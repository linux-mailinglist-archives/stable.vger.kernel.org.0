Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFF43A34AD
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 22:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFJUSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 16:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhFJUSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 16:18:43 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD1EC061574;
        Thu, 10 Jun 2021 13:16:47 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4G1FcW6f71zQk2T;
        Thu, 10 Jun 2021 22:16:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:date:date:message-id:from
        :from:references:subject:subject:received; s=mail20150812; t=
        1623356199; bh=dQSPfn5OIBDPRmFUxtISYE1NBjZOgDsFrLoyXmTkxEw=; b=U
        mboHjcDk0XW7Wt8/aHoi1zB1OzRc5hqmjWVm2/n/5t5eeRmuvPTHIMioCsZhVGra
        D7kMPyob/piq3f07YgEpE7JxTOHcbGHXUTUj+lhAN0FNx4mD72NCGBE264QPEnh/
        tPtz1g8OsdfaTd8l00BbHNQaojlWLT1GWNqOcbMOard5sg+uGMTtmYTbZ/YKId7X
        zLwLuhMZOt6RmYKEPwQMN6gYz3WEcos7qjaMrxBKmsBBmP/u47tHEHJIJqfzHAQp
        g//gPxZ3ViYIU/DwM3uCSG2HztIutzhR3DimU3czvpoJ1EBfDzXCcExnFYCGnLXw
        1CVHj6vNzxmXq3F24T9Ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1623356201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MXpqMDwXkXCnsvAQ3PZgKlt0z04GrXO8gPeprqPtTw=;
        b=k1Z0W5I+0D8ThdLsE/evBqUgZXzu2jdezq+3K9wYdz86OGkRdPQR55TTU5bW3foOdmPiFW
        wFXJMtflo+rCO/OhRNf5jg3DyPScXbLSHGKW5Nog/tuKp+A68zWYXL5Ri1XNwfyPCeo/yt
        H2JJXMZJjdRtNMTbHhmaWdf2gfh4Ru/sOEls/GCu3twTbRppVR67YoKO+iuwjgKl0CTEFX
        GILoHEymZnRH2WSeutSF0wG6WRwPDvaUm6T2BWOL7/mOnpu9yySg/B06m9f6QDqnNSKX79
        Fqr4kiHW15v2WMoogz7X9Gb676UWjupf30gdu4AnJpdQdL5Pi+UqcDIlQHkrlA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id S8nOqlyuYKyU; Thu, 10 Jun 2021 22:16:39 +0200 (CEST)
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <214134496.67043.1623317284090@office.mailbox.org>
 <CAKwvOdmU9TUiZ6AatJja=ksneRKP5saNCkx0qodLMOi_BshSSg@mail.gmail.com>
From:   Tor Vic <torvic9@mailbox.org>
Message-ID: <156d8beb-2644-8c2b-789b-104cf9268c8a@mailbox.org>
Date:   Thu, 10 Jun 2021 20:16:38 +0000
MIME-Version: 1.0
In-Reply-To: <CAKwvOdmU9TUiZ6AatJja=ksneRKP5saNCkx0qodLMOi_BshSSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: 84FC5181E
X-Rspamd-UID: fd5769
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10.06.21 19:20, Nick Desaulniers wrote:
> On Thu, Jun 10, 2021 at 2:28 AM <torvic9@mailbox.org> wrote:
>>
>> Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped [1],
>> leading to the following error message when building a LTO kernel with
>> Clang-13 and LLD-13:
>>
>>     ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
>>     '-stack-alignment=8'.  Try 'ld.lld --help'
>>     ld.lld: Did you mean '--stackrealign=8'?
>>
>> It also appears that the '-code-model' flag is not necessary anymore starting
>> with LLVM-9 [2].
>>
>> Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.
> 
> Please include this additional context in v2:
> ```
> These flags were necessary because these flags were not encoded in the
> IR properly, so the link would restart optimizations without them. Now
> there are properly encoded in the IR, and these flags exposing
> implementation details are no longer necessary.
> ```
> That way it doesn't sound like we're not using an 8B stack alignment
> on x86; we very much are so; AMDGPU GPFs without it!
> 

Will do so.
Does this have to be a v2 (with a "changes from v1" info) or just a
resend? It is based on mainline now and the line numbers have changed.

> Cut the below paragraph out on v2.  Thanks for the patch and keep up
> the good work!
> 
>>
>> This is for linux-stable 5.12.
>> Another patch will be submitted for 5.13 shortly (unless there are objections).
>>
>> Discussion: https://github.com/ClangBuiltLinux/linux/issues/1377
>> [1]: https://reviews.llvm.org/D103048
>> [2]: https://reviews.llvm.org/D52322
>>
>> Signed-off-by: Tor Vic <torvic9@mailbox.org>
>> ---
>>  arch/x86/Makefile | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>> index 1f2e5bf..2855a1a 100644
>> --- a/arch/x86/Makefile
>> +++ b/arch/x86/Makefile
>> @@ -192,8 +192,9 @@ endif
>>  KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
>>
>>  ifdef CONFIG_LTO_CLANG
>> -KBUILD_LDFLAGS += -plugin-opt=-code-model=kernel \
>> -                  -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
>> +ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
>> +KBUILD_LDFLAGS += -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
>> +endif
>>  endif
>>
>>  ifdef CONFIG_X86_NEED_RELOCS
>> --
>> 2.32.0
> 
> 
> 
