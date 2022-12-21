Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87A652C54
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 06:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLUFR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 00:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLUFRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 00:17:55 -0500
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1358B1FCCA
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 21:17:53 -0800 (PST)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 3B2431004618D
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 05:17:43 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 7rU7p7xW99rmy7rU7pnzs6; Wed, 21 Dec 2022 05:17:43 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=a5L1SWeF c=1 sm=1 tr=0 ts=63a296f7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TnKrfx86Qffcr4YpYupUCLTqyu8tLQWTLm+aaRfgSMY=; b=ANsOuBG49Umw2hTrvUyGr8uZga
        Y8T1AEk/C+4/s0qkclA89sL+HUOTPzEeiIqFNE1NMYzjhMH53Q/cXNalZA/ynFF5/8bUT+1rejqdY
        xfIFHHiKE6mwBpLiJ0ESaIs8G6zI2L/PBALEiMrr4WQPJ3710Uw0glTqfd8HCjBAW0+KDlxW7VPSm
        4aj5piYBdnQo6J8nkMuWFU9Wl8X1BcOgbCkCP9Ph6JcRU7So0IGEhQWZ0mY46Rxi3vqKODUI9VmPz
        NIKLs1y/nubrnz6wB54SespNkTRhh+F2eVz5aNVhu7VC4xojf6gioDU7aHS28czos2lqmwwdBWcvK
        QjPEp8kg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:34026 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1p7rU4-001tac-Vp;
        Tue, 20 Dec 2022 22:17:41 -0700
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182940.739981110@linuxfoundation.org>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <38e9d6c4-b351-cadd-35b9-c0a1720d494f@w6rz.net>
Date:   Tue, 20 Dec 2022 21:17:34 -0800
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
X-Exim-ID: 1p7rU4-001tac-Vp
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:34026
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 11:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.85-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

