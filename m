Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909ED5ABB23
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 01:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiIBX2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 19:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiIBX1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 19:27:46 -0400
Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4DAFC131
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 16:27:38 -0700 (PDT)
Received: from gproxy4-pub.mail.unifiedlayer.com (unknown [69.89.23.142])
        by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 8A20A802971E
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 23:27:36 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id 977BB10043443
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 23:26:08 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id UG35oib20pnCyUG36oy0lT; Fri, 02 Sep 2022 23:26:08 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=d5kwdTvE c=1 sm=1 tr=0 ts=63129110
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=xOM3xZuef0cA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7ctZbvHOl7zGXHzbAHP06xpfYEwJG2UzkD+Xm7teGkg=; b=ZwV2nrk2UJ/VixJo9GcWSy4+Sf
        1WxkXpRhWh66HfbeHxekhW+iAW8awVBeJLPjRvtpQNHBMql4w8GV8/pocC6Ta3BOBXNfvK+SIlzdF
        oa6a3Xz96nOFWiYvT8tqvVdmy6x8o4jdpWa/ebS0wJOKzf7sGNrvwudtl4Potvqf4TZ9uVRLMA0xp
        FgS3ZDBhoDi77fbmhBjVwa49Wm1Eim0XXalNvonkZdU0FSjEagrWkUkrPsBhQlhfqeYua84BsEing
        e90thDZ8BVJE9r9ItJn8hdszMjYIlA+po0UEPvkAGDwgRCdabr8M/7b/d5g2aXWe8vaW6LD/tikg4
        Wjww4Emw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:42978 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oUG34-001Ye4-HT;
        Fri, 02 Sep 2022 17:26:06 -0600
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220902121404.772492078@linuxfoundation.org>
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <159f3c3e-70ba-b736-1b0a-c9ec6d4aac66@w6rz.net>
Date:   Fri, 2 Sep 2022 16:26:04 -0700
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
X-Exim-ID: 1oUG34-001Ye4-HT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:42978
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 5:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.7 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

