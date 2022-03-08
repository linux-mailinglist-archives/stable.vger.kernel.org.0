Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7694D24B1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 00:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCHXKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 18:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCHXKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 18:10:48 -0500
X-Greylist: delayed 1432 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 15:09:47 PST
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.50.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137846E7B6
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 15:09:46 -0800 (PST)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id D8C4B4F03
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 16:45:53 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id RiaXnaxMAXvvJRiaXnxw2g; Tue, 08 Mar 2022 16:45:53 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RZMiZ7ROUmJLlPppAwRoBUqTifoIUpfa1vCZOri7D3s=; b=DGm0f2OIHgjMnBB2LLOuDtu32k
        2SVRJpPyUcz4n2Tfrz8+RIjOdUkz3C0Z6lVGgzv9vDsBhZ8uDeXyeuYaIMNu1hqNdT5s5RiPOmkdz
        VgyOVRHQPVK01Sby4nuom7l7EDBJ7L7SoYUMAb5Dn6Lw+mHYwqbWMmip9rMyANacA9ilEWwm+FcvK
        TKbG4/6BwTEpDxyeTi/4T6nmUKDby647fPUQVsTpqrpbwvrh6U/gRZFQbqL2fmOFmUZN0lKvqVhEM
        KqGz4ITkMfdRljgzNKCVNu2fxkCr3zNsUEWQK8htnsZXN+mSnPltDcOUqFT8LpjPAq0KOLm76yvkV
        0tIVoLhw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38110)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRiaX-0042Fl-1M; Tue, 08 Mar 2022 22:45:53 +0000
Message-ID: <ab0b668c-e321-e1d9-3cc3-a609111b828d@roeck-us.net>
Date:   Tue, 8 Mar 2022 14:45:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
References: <20220307162207.188028559@linuxfoundation.org>
 <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
 <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
 <YifFMPFMp9gPnjPc@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <YifFMPFMp9gPnjPc@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nRiaX-0042Fl-1M
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:38110
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 10
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/22 13:05, Greg Kroah-Hartman wrote:
> On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:


[ ... ]

>>>
>>> Reverting 4778338032b3 ("MIPS: fix local_{add,sub}_return on MIPS64")
>>> has fixed all the 3 build failures.
>>
>> MIPS: fix local_{add,sub}_return on MIPS64
>> [ Upstream commit 277c8cb3e8ac199f075bf9576ad286687ed17173 ]
>>
>> Use "daddu/dsubu" for long int on MIPS64 instead of "addu/subu"
>>
>> Fixes: 7232311ef14c ("local_t: mips extension")
>> Signed-off-by: Huang Pei <huangpei@loongson.cn>
>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Ah, I'll queue up the revert for that in the morning, thanks for finding
> it.  Odd it doesn't trigger the same issue in 5.16.y.
> 

If you don't want to revert: the fix needs the following two patches:

e5b40668e93 ("slip: fix macro redefine warning")
b81e0c2372e ("block: drop unused includes in <linux/genhd.h>")

Both are in v5.16, so you won't see the problem there.

Guenter
