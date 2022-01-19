Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E08493303
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 03:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350771AbiASCik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 21:38:40 -0500
Received: from qproxy1-pub.mail.unifiedlayer.com ([173.254.64.10]:36790 "EHLO
        qproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350974AbiASCik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 21:38:40 -0500
X-Greylist: delayed 1299 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 21:38:40 EST
Received: from progateway7-pub.mail.pro1.eigbox.com (unknown [67.222.38.55])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 989A2802E8BB
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 02:16:58 +0000 (UTC)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id EB1EF10047C09
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 02:16:57 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id A0WvnZcDvEaNCA0WvnSxUX; Wed, 19 Jan 2022 02:16:57 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=dJtjJMVb c=1 sm=1 tr=0 ts=61e77499
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=DghFqjY3_ZEA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hjfydMHF/MmMGRnNHBs9sxyXrEERNM5+XgoEui7sFIA=; b=OxzJmFjy5JK7BVgsjV1M+6eSQW
        sM649t3LWY+oXdaOXz7JYKWe9b3eU0s03qqBNPt4UQxJoVVR8e5LFGiS/WoVz6ZT9BmDlZ3gFD9Gj
        A+7hFBgR7d5kFe/gv+0K9FfEy;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:33320 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1nA0Wv-002z0P-1c; Tue, 18 Jan 2022 19:16:57 -0700
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20220118160451.879092022@linuxfoundation.org>
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <ff258d00-12cd-5919-af39-ad07e914580b@w6rz.net>
Date:   Tue, 18 Jan 2022 18:16:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
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
X-Exim-ID: 1nA0Wv-002z0P-1c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:33320
X-Source-Auth: re@w6rz.net
X-Email-Count: 12
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 8:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

