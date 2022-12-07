Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B886450D7
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 02:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLGBO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 20:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLGBOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 20:14:25 -0500
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70F84C271
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 17:14:24 -0800 (PST)
Received: from alt-proxy28.mail.unifiedlayer.com (unknown [74.220.216.123])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id B66248033B56
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 01:14:22 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 60B37100A4372
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 01:14:00 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 2j0apNt1FLkvu2j0ap6tDE; Wed, 07 Dec 2022 01:14:00 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=GN7NrsBK c=1 sm=1 tr=0 ts=638fe8d8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Df7VXoj-bu6BeNQDfzwA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kbVUMlG8kem44gExv7WcZZiaiRDyGUBFBYwRYYgb4gY=; b=MMdXnyO8QkfIY+/6FKWpNCT8Gv
        oFDq3XYRTMtoYoKN04ZGsR9x6fiW7ByZu3NTbLbVHbbaaZAAO0bPYj+wJpzzR24bHSqzZjGsb0gJl
        turBE8+Bo71i05lBBA9UgRx70pof1UQU0OuRh27Xnb1bKFq0ED6Nba9XrCtel+WHr8P+28YozmWk0
        +nnw/mvQS2l5GEh2WA7O8s7ZW91msKi+E5U3IHZfMJf7YXnBbiqW05Q33YV60zarmBiUvT2ANLk/s
        pikf/7m14gDWNqP9L/lvV/0J670Z7xa2cer4Tpqg49ykFWKNlTB7ctN4Oi6LCuqd/UhFu4H3kUdIp
        nig8DqOQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:60452 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1p2j0Z-001nCy-I9;
        Tue, 06 Dec 2022 18:13:59 -0700
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206163439.841627689@linuxfoundation.org>
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <8c321602-1a68-d804-bc7d-94f176aa662f@w6rz.net>
Date:   Tue, 6 Dec 2022 17:13:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1p2j0Z-001nCy-I9
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:60452
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/22 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

