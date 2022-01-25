Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0D49B6EB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1580655AbiAYOvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:51:33 -0500
Received: from qproxy5-pub.mail.unifiedlayer.com ([69.89.21.30]:55415 "EHLO
        qproxy5-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1580412AbiAYOt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:49:29 -0500
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by qproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 8CB2280312B0
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:49:18 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 5E0251004E50C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:49:11 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id CN8Anty4mikTnCN8BnWVJW; Tue, 25 Jan 2022 14:49:11 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=CeHNWJnl c=1 sm=1 tr=0 ts=61f00de7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=DghFqjY3_ZEA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aQAIBmicJCSxrmNyH3iv9LFB+3idbl+44IkGVHzPsZQ=; b=Jx4qh/VKtn/MFl0Ep7ecOLLtGJ
        cyPjOsoxdZL4ygKDRuJ3Afqak+u+Qp/IsQ7s7uz3Apw+KkURTn4sxBftgwwcR4SoOuOmCTeD6kk3t
        p0gWR1TqOcyeJQEfmauEEFLj8;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:51644 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1nCN8A-000lzi-Ew; Tue, 25 Jan 2022 07:49:10 -0700
Message-ID: <0ea51623-2455-4860-cca7-7e9765e3ae6f@w6rz.net>
Date:   Tue, 25 Jan 2022 06:49:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0000/1039] 5.16.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220124184125.121143506@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
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
X-Exim-ID: 1nCN8A-000lzi-Ew
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:51644
X-Source-Auth: re@w6rz.net
X-Email-Count: 1
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 10:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1039 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

