Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1367E4D27A2
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiCIBt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 20:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiCIBt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 20:49:27 -0500
X-Greylist: delayed 3293 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 17:48:29 PST
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.146.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3D72C673
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 17:48:29 -0800 (PST)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id A75DE2C44C
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 18:53:35 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id Rka7ntkHn9AGSRka7nBLsM; Tue, 08 Mar 2022 18:53:35 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S82LfQ71+WjBONrEJUzmyZUddwy8tJcD58qdpxREMc0=; b=U5838IEnPnOKYA2dB093kbhq52
        6Jwk9mLMlXcyLPo3TS2GspleF6Kd3fvzmE10ceett6rn5xoUDep5MG5ORQkchGbacZZMvQWVKCs1A
        RVpWrdU5lB/tIdTsM2G1PkTFtw9Y7mv0TAXCky3CKfWFwKaUiGOYJRsmWtH7MshreeCAaPRasx6WU
        glKl8vTy1wt4XGnE96sQxgKTIFcA1R/cq+GlO3M429NXAfqKsFzKmHvbmkYkHkSWLHeRy7tA/kOwP
        OcjvBNc6y7Qr7V49Dw95cgZDb070bEJ+2NWEV8rASmeaDk5kEuG0AafB6PLd/MPxZSwjvX/PskA3H
        uzWH0HHg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38112)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRka6-0015kr-PK; Wed, 09 Mar 2022 00:53:34 +0000
Message-ID: <8f97b76e-fe64-ad9e-fa46-9874df61c35d@roeck-us.net>
Date:   Tue, 8 Mar 2022 16:53:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Content-Language: en-US
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
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
 <CADVatmMs_+YN3YAajL95fy98iEgoeb-7qXA_ZJ7K3QsdHGG=oA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CADVatmMs_+YN3YAajL95fy98iEgoeb-7qXA_ZJ7K3QsdHGG=oA@mail.gmail.com>
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
X-Exim-ID: 1nRka6-0015kr-PK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:38112
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 10
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/22 14:27, Sudip Mukherjee wrote:
> On Tue, Mar 8, 2022 at 9:05 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:
>>> Hi Greg,
>>>
>>> On Tue, 8 Mar 2022 at 21:40, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>>>>
>>>> On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
>>>> <sudipm.mukherjee@gmail.com> wrote:
>>>>>
>>>>> Hi Greg,
>>>>>
>>>>> On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 5.15.27 release.
>>>>>> There are 256 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>
>>>> <snip>
>>>>
>>>>>
>>>>> Mips failures,
>>>>>
>>>>> allmodconfig, gpr_defconfig and mtx1_defconfig fails with:
>>>
> 
> <snip>
> 
>>
>> Ah, I'll queue up the revert for that in the morning, thanks for finding
>> it.  Odd it doesn't trigger the same issue in 5.16.y.
> 
> ohh.. thats odd. I don't build v5.16.y, so never thought of it.
> Just checked a little now, and I was expecting it to be fixed by:
> e5b40668e930 ("slip: fix macro redefine warning")
> but it still has the build error. I will check tomorrow morning what
> is missing in v5.15.y
> Please delay the revert till tomorrow afternoon.
> 

In case you did not get my other e-mail: You also need commit
b81e0c2372e ("block: drop unused includes in <linux/genhd.h>").

Guenter
