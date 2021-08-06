Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1173E2C55
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhHFOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhHFOQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 10:16:51 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16808C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 07:16:36 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id z24so6530571qtn.8
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 07:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b0wyf8QKF4VeHeZpXBJeQu9Mm0fDhZAUf6y7t7GyJ2c=;
        b=IxDwDKTnn2AbDY6kDah/p7oXNgSWXLc6F4gHz524lgjObryUHnkP+9d53xTaXwgFkr
         T/SPoqfpI1T8uKKAQujSprCmRswCeCWeSJ9rVii99xbK7Z8eTm2p7/OUSzHgKwhXn0aw
         c4v1OLShzSU+wZyLxPSsOzXc7T3m8K54ZOjvk++uYVs46FmqFN4Wi/SFBCUWBIN4J6r3
         aPxt98bsdobrpChusXudPZB1j0x/CZJ+ziu1oD1gzxD5WdkrLiCLer0Q5QY5yd4xwCI2
         nNTLrj9TlD4H6Hopvw4osHIo6r3jM4l1UYIdsJsltnq3DsV40QMJyYJHP/MbPSkblsIT
         PPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b0wyf8QKF4VeHeZpXBJeQu9Mm0fDhZAUf6y7t7GyJ2c=;
        b=pUa8OZwVvLdYcpApiikCrE6ApDLxY78tWJx/XKbHNUA3FBy4Fo8zkNTssCY0Xc0GQe
         mbymWmm4AqHVGjf8HPGfcV3Wbd0BCok5vhEVGCrYwYYIsUr3CYMHpgqqm/x3YTbAKFYh
         IRfvcQMxO/g0aC8Nl8o4+jNtEsJLh259j/MOXN1vmRkBp9mWpVtKkOg2qSyjiv/OL5gJ
         zUkg4B+TuOruKdTwRHX5uqG3NwnwFdO02+amNI7QxV3Ew9qRhaVSflDfQQKVC7EJ6nfD
         PlowslkhsPdVzjsofyGFNaWLUnHl6K5aLdX0cTHhZKTjSqo++8O0OOV0sm429lgBz4mG
         r3tA==
X-Gm-Message-State: AOAM533HIM7v3HzX4pfp/d1QWQIssp0HptGdQ3ygPwYZ+bxez49DzAmO
        wZHXY+j1fjpTQGsFmxu27ig=
X-Google-Smtp-Source: ABdhPJziqbyVSLSL4fDsj1dEMaWAwlm0QdiDM6tLPLtQVI61enPmdpAIJWH9WPLCMm8I8zpf4yChvQ==
X-Received: by 2002:a05:622a:549:: with SMTP id m9mr9328092qtx.248.1628259395245;
        Fri, 06 Aug 2021 07:16:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z21sm3491947qti.73.2021.08.06.07.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 07:16:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <efee3a58-a4d2-af22-0931-e81b877ab539@roeck-us.net>
 <20210805164254.GG17808@1wt.eu> <20210805172949.GA3691426@roeck-us.net>
 <20210805183055.GA21961@1wt.eu>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: Regressions in stable releases
Message-ID: <dcb1a1ad-fb1a-8b4a-44c9-c47ed0164355@roeck-us.net>
Date:   Fri, 6 Aug 2021 07:16:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805183055.GA21961@1wt.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/21 11:30 AM, Willy Tarreau wrote:
> On Thu, Aug 05, 2021 at 10:29:49AM -0700, Guenter Roeck wrote:
>>> It looks like a typical "works for me" regression. The best thing that
>>> could possibly be done to limit such occurrences would be to wait "long
>>> enough" before backporting them, in hope to catch breakage reports before
>>> the backport, but here there were already 3 weeks between the patch was
>>> submitted and it was backported.
>>
>> No. The patch is wrong. It just _looks_ correct at first glance.
> 
> So that's the core of the problem. Stable maintainers cannot be tasked
> to try to analyse each patch in its finest details to figure whether a
> maintainer that's expected to be more knowledgeable than them on their
> driver did something wrong.
> 
> Then in my opinion we should encourage *not* to use "Fixes:" on untested
> patches (untested patches will always happen due to hardware availability
> or lack of a reliable reproducer).
> 
> What about this to try to improve the situation in this specific case ?
> 
> Willy
> 
> 
>>From ef646bae2139ba005de78940064c464126c430e6 Mon Sep 17 00:00:00 2001
> From: Willy Tarreau <w@1wt.eu>
> Date: Thu, 5 Aug 2021 20:24:30 +0200
> Subject: docs: process: submitting-patches.rst: recommend against 'Fixes:' if
>   untested
> 
> 'Fixes:' usually is taken as authority and often results in a backport. If
> a patch couldn't be tested although it looks perfectly valid, better not
> add this tag to leave a final chance for backporters to ask about the
> relevance of the backport or to check for future tests.
> 
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>   Documentation/process/submitting-patches.rst | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
> index 0852bcf73630..54782b0e2f4c 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -140,6 +140,15 @@ An example call::
>   	$ git log -1 --pretty=fixes 54a4f0239f2e
>   	Fixes: 54a4f0239f2e ("KVM: MMU: make kvm_mmu_zap_page() return the number of pages it actually freed")
>   
> +Please note that a 'Fixes:' tag will most often result in your patch being
> +automatically backported to stable branches. If for any reason you could not
> +test that it really fixes the problem (for example, because the bug is not
> +reproducible, or because you did not have access to the required hardware
> +at the time of writing the patch to verify it does not cause regressions),
> +even if you are absolutely certain of your patch's validity, do not include
> +a 'Fixes:' tag and instead explain the situation in the commit message in
> +plain English.
> +

I don't think that would be a good idea, First, it would discourage people
from using Fixes: tags, and second it would not really solve the problem either.

While I am sure that the patch in question wasn't really tested (after all,
it broke EC communication on all Mediatek Chromebooks using SPI to communicate
with the EC), we don't know what the author tested. It may well be (and is quite
likely) that the author _did_ test the patch, only not the affected code path.
That means the author may still have added a Fixes: tag in the wrong belief
to have tested the fix, even with the above restrictions in place.

The same is true for the Bluetooth patch: This patch was for sure tested
and works on many Bluetooth devices, except for those with a specific
Mediatek controller and driver. Again, the Fixes: tag would be there
(and it would be completely unreasonable to expect that infrastructure
patches are tested on all affected hardware).

No, I think all we can do is to improve test coverage.

Thanks,
Guenter
