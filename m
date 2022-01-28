Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06049FB71
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348976AbiA1ORW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:17:22 -0500
Received: from qproxy2-pub.mail.unifiedlayer.com ([69.89.16.161]:46050 "EHLO
        qproxy2-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348069AbiA1ORV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:17:21 -0500
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2022 09:17:21 EST
Received: from gproxy2-pub.mail.unifiedlayer.com (gproxy2-pub.mail.unifiedlayer.com [69.89.18.3])
        by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id DFC2880308B1
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 13:55:01 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway4.mail.pro1.eigbox.com (Postfix) with ESMTP id 33A811003F1B1
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 13:54:31 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id DRhunVqRcwm8iDRhunVTKr; Fri, 28 Jan 2022 13:54:31 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=DpSTREz+ c=1 sm=1 tr=0 ts=61f3f597
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=DghFqjY3_ZEA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=U4_wLaSDwdVF22gBXvgA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ox6JJNhG9ib98sEZW2gK85YbeDqfQLKuvNf4lK7WR9E=; b=BhEyABq7JEUtUIBJld1GUl/UM4
        ucL65b1uevgSzaxE4goEDZkC+bIfRexwGYtcD6e8zQEgOvQMNTVd2na7tiibvCJM988Jd5WyizwF9
        IbU88zv0sNDRdRd2jBCcM0vPe;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:52012 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1nDRhu-0037UC-99; Fri, 28 Jan 2022 06:54:30 -0700
Message-ID: <1feb90c2-58c7-8a8d-e9ef-4f2f687d76a1@w6rz.net>
Date:   Fri, 28 Jan 2022 05:54:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20220127180258.892788582@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1nDRhu-0037UC-99
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:52012
X-Source-Auth: re@w6rz.net
X-Email-Count: 11
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/22 10:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

