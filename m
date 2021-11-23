Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0619F45AEC8
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 22:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhKWV7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 16:59:43 -0500
Received: from meesny.iki.fi ([195.140.195.201]:55698 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhKWV7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 16:59:42 -0500
Received: from [172.16.24.131] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb@iki.fi)
        by meesny.iki.fi (Postfix) with ESMTPSA id 27B22202B7;
        Tue, 23 Nov 2021 23:56:32 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1637704592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvSp1quBF/r2X8h0rUNOPMDy349fc4EAE8LATnyMxIc=;
        b=dVhbsWek4w/Eba27xnladZGMIVnBl8SB9UZjzCJe4bvfGwgF0fgY8h7ccBtuW39IIeukT4
        les4mQP2OGCQ7eSrNFfliHOHXctgXiRGayrQ7yFRYF2B6ZMq3arp2n5Y6XEMkpp3s0U0zP
        qocbg9we1g9+bweWSZ5jbdBdhJTNna4=
Message-ID: <2406f6cc-3c24-4b0c-20db-194da63640c7@iki.fi>
Date:   Tue, 23 Nov 2021 23:56:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     ebiederm@xmission.com, Thomas Backlund <tmb@iki.fi>
Cc:     Greg KH <gregkh@linuxfoundation.org>, keescook@chromium.org,
        khuey@kylehuey.com, me@kylehuey.com, oliver.sang@intel.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
References: <163758427225348@kroah.com>
 <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi> <YZ0vAK6QJJFP3jY5@kroah.com>
 <aGPtF092eTtTol3Vfasn4-kVySgX_vBRkK7e4jX97omisSwgyJR7vHltUrS1bwNE9pYuB2N2nSas1HWLQxUBNg==@protonmail.internalid>
 <877dcyllom.fsf@email.froward.int.ebiederm.org>
 <d0eca47c-73f8-3d7f-3eb8-4ee7722022f8@iki.fi>
 <zxGERJOml4ibU0qisIO6vgdvT07lGQscimGWqAgInuK30--ddobSRfYhUSr1Ez9n4Dc_SRpEKCYvA_2QAeQrKQ==@protonmail.internalid>
 <87k0gyim6z.fsf@email.froward.int.ebiederm.org>
From:   Thomas Backlund <tmb@iki.fi>
In-Reply-To: <87k0gyim6z.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb@iki.fi smtp.mailfrom=tmb@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1637704592; a=rsa-sha256; cv=none;
        b=B4A+vWF0dQp4rAnx/zfnCaUkydTvRmEdKO04gONsbOe9Y1D0Nsj0Gy1g0nzgCYJLMBXZZ8
        y2tIOdmzweE4T8o01tFGsgBcbb8SYwWXOmR39h1QODzxmiAXIZ4R81w/BqYAOE+TQ2i3eD
        EktZcayroJXSTpV9wbt3OLaBkeXD8VE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1637704592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvSp1quBF/r2X8h0rUNOPMDy349fc4EAE8LATnyMxIc=;
        b=uYllrCPX1791OiQfv70+/MTez5Lq/7rOrKSmuFSplFNCZEtHUSfzj7Nzy65AYVz3FlOWD6
        l0HYdPs+VhWeLaxTCNed4Jc2mgseYcWr1+1632G2pfQe9MBtW3ftEwYHXxyoVq7fdadNIY
        zbOShjO35macWCfKQNs7ZDuCN+WjGXQ=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2021-11-23 kl. 23:41, skrev ebiederm@xmission.com:
> Thomas Backlund <tmb@iki.fi> writes:
>
>> Den 2021-11-23 kl. 21:24, skrev ebiederm@xmission.com:

>>> Maybe I am wrong but I think "Don't always set SA_IMMUTABLE for forced
>>> signals" will apply if you drop the hunk modifying force_fatal_sig.
>>> Then you don't need to backport all of the cleanups just the fix.
>>>
>>> I will take a quick look and verify that.
>>
>> that's why i wrote: "if the other patch for signal that has similar
>> description should land"
> Apologies for not responding to that bit, I was reading quickly
> and I missed that bit.


No worries :)

> The second patch does not need to land in 5.15.
>> (meaning "signal: Replace force_fatal_sig with force_exit_sig when in
>> doubt")
>>
>> as thats the one needing the whole patch series...
>>
>>
>> since going by patch descriptions for:
>>
>> "signal: Don't always set SA_IMMUTABLE for forced signals"
>>
>> "signal: Replace force_fatal_sig with force_exit_sig when in doubt"
>>
>>
>> both has the info:
>>
>> "Unfortunately this broke debuggers[1][2] which reasonably expect
>> to be able to trap synchronous SIGTRAP and SIGSEGV even when
>> the target process is not configured to handle those signals."
>>
>> and the second even has:
>> "This avoids userspace regressions as older kernels exited with do_exit
>> which debuggers also can not intercept."
>>
>>
>> or is the patch description on the second patch somewhat misleading ?
> It is the same problem.  But it only applies to code that was merged
> post 5.15.
>
> For 5.15 on force_sig_seccomp is really affected.
>
> For 5.16 there were many calls to do_exit that I turned into signals.
> Some of the properly should be oridinary signals and some of them
> for correctness purposes can't allow debuggers or userspace to intercept
> them.
>
> The second patch went through and modified everything that was
> non-interceptible before 5.16 to be non-interceptible in 5.16.  Where
> that is not necessary we can relax things later.
>
> But for 5.15 only the one patch needs to be applied.
>
> Eric


Thanks for the explanation.

--

Thomas


