Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318B553D866
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 21:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbiFDTeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 15:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240898AbiFDTdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 15:33:43 -0400
Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA2024BF6
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 12:32:35 -0700 (PDT)
Received: from gproxy1-pub.mail.unifiedlayer.com (gproxy1-pub.mail.unifiedlayer.com [69.89.25.95])
        by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 831A08026912
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 19:32:27 +0000 (UTC)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 37470100480DF
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 19:32:08 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id xZVHnkzNsY8ycxZVInHXDx; Sat, 04 Jun 2022 19:32:08 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=Y649DjSN c=1 sm=1 tr=0 ts=629bb338
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QstPAZKlEbBmq2pGECc+/oY9sfbsVlCgJreiQ0bWwe4=; b=Oy2w1yWnxTNuzynzqDECPU57fw
        ZA294237zfxHl73jmdZixmzKd0ua5oZPhm86ENce4P3Ffu0tGqLPqZVsm243Ec7pZQHOjv/g6Bhv1
        F2J/fdOd7V6+mMBXE16ZX2SYJO16ELyOvFMgSIvZxh0KmiBZ5di3SJX0F7cxpEXq5cLiPQlA0GRMF
        KqeZDt21IhD8+bWR+dw7A8ca/rLHYj+DDHrCrWW/oWTqUttvuZ4DRBRRaU4TA0jCMmKiPUv0jECmp
        Jt6641QX4XVsRdQUn5O0w0kJiA8kCr4X5grInaGrOhEmQe8Fp848SJdu6jrXdAdCcahzHX/qIRYtn
        Sl5OdQww==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53404 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1nxZVG-0045YX-Vc;
        Sat, 04 Jun 2022 13:32:07 -0600
Subject: Re: [PATCH 5.17 00/75] 5.17.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220603173821.749019262@linuxfoundation.org>
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <cc2dcb8e-acbe-2bd2-f778-fdc59f8cc790@w6rz.net>
Date:   Sat, 4 Jun 2022 12:32:04 -0700
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
X-Exim-ID: 1nxZVG-0045YX-Vc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:53404
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/22 10:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.13 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

