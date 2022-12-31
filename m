Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A347E65A3A0
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 11:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiLaK5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 05:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLaK5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 05:57:16 -0500
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB8A631D
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 02:57:15 -0800 (PST)
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 7425880289BE
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 10:57:15 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id CDF17100479C6
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 10:56:54 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id BZXqpTEVWZJgEBZXqpHYZ5; Sat, 31 Dec 2022 10:56:54 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=d7QwdTvE c=1 sm=1 tr=0 ts=63b01576
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
        bh=VK/x6/mOJ8Gy51bBhgt4cVHFBsX3+Ebfh8gsGc0NBsc=; b=jGv101HzvCYHaG4Q9OdVyee7If
        axYQmXDR3fkReFme3aDTVbdPFCgdLKT+1RzCiyvoddATNrPz62fN9j61PxKxWj3U93nTDXMcL3gy7
        gJmNVCwKO3QhvZv57Ih18LbeFHcuEVIUs+2CN90kw9A8nGo5tCB8qMMPtgHCj+KOnwPWWeXRjavuc
        awEe53OlzTqkskAygG195h5MqVGx90AtmWOgmJuTsMdj2wuz+VleiiA9D3p+8xsE1pEfFD7PPSPdm
        TDMQSI5W3qK/P99/2jb8C2gRA0ZeykyQeD/y1aZ9Bo/KfsMH2orU+9BHTWPSib1rubI6c2yUN82dE
        umu17yTw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:38946 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pBZXp-001Zau-3M;
        Sat, 31 Dec 2022 03:56:53 -0700
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221230094107.317705320@linuxfoundation.org>
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <237e4a88-21c9-2569-fd9d-45d5e967e671@w6rz.net>
Date:   Sat, 31 Dec 2022 02:56:46 -0800
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
X-Exim-ID: 1pBZXp-001Zau-3M
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:38946
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

On 12/30/22 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

