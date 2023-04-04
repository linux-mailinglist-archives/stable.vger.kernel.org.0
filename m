Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34E86D5AB0
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 10:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbjDDIXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 04:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjDDIXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 04:23:53 -0400
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6CB1B7
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 01:23:51 -0700 (PDT)
Received: from gproxy3-pub.mail.unifiedlayer.com (unknown [69.89.30.42])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 7B3238028A10
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 08:23:51 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id 0969D1003F0D6
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 08:23:50 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id jbxGpWgvPuftbjbxGpcxTD; Tue, 04 Apr 2023 08:23:50 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=cPYlDnSN c=1 sm=1 tr=0 ts=642bde96
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
        bh=+IoIfCnNuLKHzmztRu0VTFAP/IUIGC9ln/Qu+p+X6Bg=; b=GOa+GZDpukXkhne6SCdzEdSbvA
        l8+tjYHZ0wkTInmop2PYZaJln6alxJ5D2cOVN6pRNM38hjFjiUv83f0xCXa4ePmQ2B3FPGJXnUOpx
        3CqovkSVRp2Kwub1jt454RuE8FEWcw82m1Mvoij+wqgz6VSOpZwMMCMVcslTQ51gm+ECHkodsLcNU
        37aVnHXhmOa9AxUm3vI7gogKHDmV0SiV1nBdM92fOhAORGXfuvrDF98iLe3Kdk72AGGGBLZWFOa+J
        3+pmPsevKsoQFKMbuaAS2k2Plc+mcf1viTRq8TU+RgJUcT88UlPiS/euNv5VvSfzc2xpa6BRT3S8J
        Ou0qVM0Q==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:34080 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pjbxF-000m1y-Q6;
        Tue, 04 Apr 2023 02:23:49 -0600
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140416.015323160@linuxfoundation.org>
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <a1adee63-bbcb-3221-1a6e-910508d3515e@w6rz.net>
Date:   Tue, 4 Apr 2023 01:23:45 -0700
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
X-Exim-ID: 1pjbxF-000m1y-Q6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:34080
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

