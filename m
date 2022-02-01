Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBDB4A574B
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 07:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiBAGfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 01:35:08 -0500
Received: from gproxy5-pub.mail.unifiedlayer.com ([67.222.38.55]:37216 "EHLO
        progateway7-pub.mail.pro1.eigbox.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234248AbiBAGfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 01:35:07 -0500
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id E07D810044914
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 06:35:06 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id EmksnG9IAnAlUEmksn8lXq; Tue, 01 Feb 2022 06:35:06 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=QIOt+iHL c=1 sm=1 tr=0 ts=61f8d49a
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
        bh=UupU1YHbf5NBbBAYFb3ldml5kuHdAQyQHnkHeLNQrCw=; b=AFO06xvShKOgBLNEaLOXtwMWFh
        DgLwmprylKJBO3SP2B3AhRdI2CcKCmhxSrQdFxx2lVqwLINyx7mUA0N/RQJrfoxd4RIB2ASGY11/L
        LKgnMz2JZfJ9uAm2FGVGRvGYi;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:33724 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1nEmks-001VXb-1h; Mon, 31 Jan 2022 23:35:06 -0700
Message-ID: <70bb3dc0-c54b-d617-a5ed-5ff31e2ac126@w6rz.net>
Date:   Mon, 31 Jan 2022 22:35:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
References: <20220131105233.561926043@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
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
X-Exim-ID: 1nEmks-001VXb-1h
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:33724
X-Source-Auth: re@w6rz.net
X-Email-Count: 11
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/22 02:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

