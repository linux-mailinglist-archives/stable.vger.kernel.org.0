Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD792EA6D3
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbhAEJAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:00:00 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42237 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726982AbhAEI77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 03:59:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 29A5358049B;
        Tue,  5 Jan 2021 03:59:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 05 Jan 2021 03:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=K
        wHmlBlSYwHrDiz4lTbH37Kq075cZSKda6f/07inWNs=; b=lV928XRb5T4InzEV6
        QI7e1C76AIKWbduwZ0Ar2S6JI5ucUPUuZDHyKvMEfnLkyyhGVKFz6FiSmddalZNh
        t+AFrkWSdUJGxeOM7AodFLYeCpnyxg2N6hvlAGrq8htRBHJecgHAnzo87B5brL50
        yxzJKRVM3A1cViiAP4/r5DzcmHnaEqoakikE2NNoKqkxCGsIwYXapQ9YW6AKAuxK
        8QgBBkveKz2jxOd2/zlQ1gfSVlqn7Eb+Yo4zHbER5WZAavtUISCNLSPKJBBF4Ary
        tmSnBLTN0yQy52sGxSBJYMGuVrOtrerw6iQSvOe8170WCM3qosRVZghyhK4SKowX
        cM/jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=KwHmlBlSYwHrDiz4lTbH37Kq075cZSKda6f/07inW
        Ns=; b=XOm/h1GnqHc3oSkjeXx1xkn2OqdXDdXKuR9O3/BLEXhRnh6i0yAHzabm/
        7CeMoKY4BS7Ocfg2i3lOc+osz6sMHTSBgfLkrKtJqMULx/38BSClKq/u9racyJgL
        AO6CgdVwNDkzqGDmTzuf9IgVmxOgBsX3phNHwSpxJEX1GWqEVFiyX8xB40eU+CbQ
        3lTIkCjSkSfe6kiIuqfWnIOIJ9HNlsZo7fsDNdSFa2+pIyBEBPQVsfBzLQcIQrZp
        IFZIaXDvqqshAII2R4wCLtUovmmpRD5BQ742omn28fg3VAuFdiBjoBsTIYzO+D7z
        jlxbnlM2J8Nn/u692SrePewwK9XAQ==
X-ME-Sender: <xms:YCr0X9IAHI6v1p99QOqApXFazPDtaTi46vR3u42wtozZM5dbo16Y1A>
    <xme:YCr0X5IhN9DBM61Mwi6r8YYA9mNMKyiaa5EMPLLZr2f4tvAiNmWz7TZnCNcy4zUAb
    2Noti03fBbZ3Zy1_Ts>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefuvfhfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgr
    gihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqne
    cuggftrfgrthhtvghrnhephffgteehteeuuddtvdeikeduvdeuiedukeeiuddtgeevledt
    ueekteejfeevffdunecuffhomhgrihhnpehlughsrdhssgdpohhpthhiohhnshdrvghhne
    cukfhppeeghedrfeefrdehtddrvdehgeenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtoh
    hm
X-ME-Proxy: <xmx:YCr0X1vPmrUpd046QM50WwFKiSORi1m3tGPmDLOqlxyRbcwbFiB65w>
    <xmx:YCr0X-Z3_b_uv_TlP-bMKBA78TFPI1qwyfpidNU9X2GEvSS9SwdUyQ>
    <xmx:YCr0X0Z18LDcoTLppjyeUMuXoxRrz64ByO3iqnQpCQFYhzV-ovv-uA>
    <xmx:YCr0X0401DTvDt2GD25Cp1uBzB283PTpc5kkz8yw-3VsxXWVCz9kVvDjIFg>
Received: from [0.0.0.0] (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id 054A1108005B;
        Tue,  5 Jan 2021 03:59:07 -0500 (EST)
Subject: Re: [PATCH mips-next 2/4] MIPS: vmlinux.lds.S: add ".rel.dyn" to
 DISCARDS
To:     =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alex Smith <alex.smith@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210104121729.46981-1-alobakin@pm.me>
 <20210104122016.47308-1-alobakin@pm.me>
 <20210104122016.47308-2-alobakin@pm.me>
 <CAFP8O3LA87zyi8f64Sk5g+aLFdYhnZqsEbLC_uTsQk3+6Qus3A@mail.gmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <2add3f2d-ab2a-1ca3-5e04-d7b66738bfbe@flygoat.com>
Date:   Tue, 5 Jan 2021 16:59:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAFP8O3LA87zyi8f64Sk5g+aLFdYhnZqsEbLC_uTsQk3+6Qus3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021/1/5 下午3:39, Fāng-ruì Sòng 写道:
> On Mon, Jan 4, 2021 at 4:21 AM Alexander Lobakin <alobakin@pm.me> wrote:
>> GCC somehow manages to place some of the symbols from main.c into
>> .rel.dyn section:
>>
>> mips-alpine-linux-musl-ld: warning: orphan section `.rel.dyn'
>> from `init/main.o' being placed in section `.rel.dyn'
>>
>> I couldn't catch up the exact symbol, but seems like it's harmless
>> to discard it from the final vmlinux as kernel doesn't use or
>> support dynamic relocations.
>>
>> Misc: sort DISCARDS section entries alphabetically.
>>
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>   arch/mips/kernel/vmlinux.lds.S | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
>> index 83e27a181206..1c3c2e903062 100644
>> --- a/arch/mips/kernel/vmlinux.lds.S
>> +++ b/arch/mips/kernel/vmlinux.lds.S
>> @@ -221,9 +221,10 @@ SECTIONS
>>                  /* ABI crap starts here */
>>                  *(.MIPS.abiflags)
>>                  *(.MIPS.options)
>> +               *(.eh_frame)
>>                  *(.options)
>>                  *(.pdr)
>>                  *(.reginfo)
>> -               *(.eh_frame)
>> +               *(.rel.dyn)
>>          }
>>   }
>> --
>> 2.30.0
>>
>>
> (I don't know why I am on the CC list since I know little about
> mips... Anyway, I know the LLD linker's behavior in case that was the
> intention... )
>
> I think it'd be good to know the reason why these dynamic relocations
> are produced and fix the root cause.
>
> arch/x86/kernel/vmlinux.lds.S asserts no dynamic relocation:
> ASSERT(SIZEOF(.rela.dyn) == 0, "Unexpected run-time relocations
> (.rela) detected!")
Hi all,

Runtime .rela can't be avoided as MIPS kernel can't be built with fPIC.
Our relocatable kernel uses another approach, fixup dynamic relocations
at boot time.

abicalls simply gave us too much overhead on PIC code, which is unacceptable
for kernel.

In my local tests, PIC kernel reduced unix bench results for around 30%.

For MIPS Release6 and afterwards, we may utilize new pcrel instructions to
reduce overhead but for older ISA I don't have any idea.

Thanks.

- Jiaxun


