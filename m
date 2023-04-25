Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706556EDF1E
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 11:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjDYJXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 05:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjDYJXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 05:23:34 -0400
Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B885A3C0D
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 02:23:32 -0700 (PDT)
Received: from gproxy1-pub.mail.unifiedlayer.com (unknown [69.89.25.95])
        by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 60857802EF22
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 09:23:32 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 119CD10047D99
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 09:23:32 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id rEtYpMLnI0Q2KrEtYpzgj8; Tue, 25 Apr 2023 09:23:32 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=KqWIZUaN c=1 sm=1 tr=0 ts=64479c14
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=dKHAf1wccvYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rFkmwY6uSYR8HWHNRn13pMEFGkE7KOyC12GBmOo7yX8=; b=DjbzAJ0rjPmCiOTaVCGXh9rymM
        AQ5OnqAgr8VLhQihCXY9CgTTsROV3SIMnNaS6KGceNUXZPyNGuqpMHqu+Mk/jezHMVxE0+OM2V0r2
        CToVOFcLSKCfCnvqp6aA6ot6fcur20tkrrbUs0gPUoXE1Jng7W+vYnRX3G9Xls4xDy5Lxcb7UHCWD
        oNLYsYAcxXPRsfzrmR02e6ZBE3um4RT0xnp0j1mdn6UuW3FRLR8Iln84UyVVV6YNiCPE2801QoGLp
        W/OH7lgif07YkQKDRxbfIWS5yr/vVp9oOGT4sO8J3By59l/+HPBNpsaSystObpkA73EwFgq9ZB4GW
        +zXPaP3g==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:36068 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1prEtX-003CoZ-E4;
        Tue, 25 Apr 2023 03:23:31 -0600
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131133.829259077@linuxfoundation.org>
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <8aaba2c4-2147-9010-16e1-b0e42b5a879a@w6rz.net>
Date:   Tue, 25 Apr 2023 02:23:29 -0700
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
X-Exim-ID: 1prEtX-003CoZ-E4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:36068
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/23 6:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

