Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F6248F4BB
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 05:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiAOEZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 23:25:42 -0500
Received: from qproxy5-pub.mail.unifiedlayer.com ([69.89.21.30]:38680 "EHLO
        qproxy5-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231342AbiAOEZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 23:25:42 -0500
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by qproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 950AE8032AE1
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 04:25:39 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id D1FE110047AB2
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 04:25:08 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 8acmnGZ2nikTn8acmns3sl; Sat, 15 Jan 2022 04:25:08 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=CeHNWJnl c=1 sm=1 tr=0 ts=61e24ca4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=DghFqjY3_ZEA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=-Qcm0AZxhyoZnww38z8A:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2ytazBcu1/WEpQe+c3RwgbycMvD43iurYN7PpL6wsLc=; b=fb0YPheNQsk8n8tjAuXrqr/8nq
        d7f9/bFZmaSNLxsROFQ6ccY7wFIgPkQztrgC0qXfP7ljZtTA9Cn4eAAqoXFI0iS7X0wFJKRrbejC4
        aeaNtpNAGUK9QisRV+b/LRJW5;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:60982 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1n8acl-000TEm-Us; Fri, 14 Jan 2022 21:25:08 -0700
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20220114081544.849748488@linuxfoundation.org>
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <7da2da48-33a8-6448-6906-03e1661b50b4@w6rz.net>
Date:   Fri, 14 Jan 2022 20:25:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1n8acl-000TEm-Us
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:60982
X-Source-Auth: re@w6rz.net
X-Email-Count: 12
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Warnings:

fs/jffs2/xattr.c: In function ‘jffs2_build_xattr_subsystem’:
fs/jffs2/xattr.c:887:1: warning: the frame size of 1104 bytes is larger 
than 1024 bytes [-Wframe-larger-than=]
   887 | }
       | ^
lib/crypto/curve25519-hacl64.c: In function ‘ladder_cmult.constprop’:
lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of 1040 
bytes is larger than 1024 bytes [-Wframe-larger-than=]
   601 | }
       | ^
drivers/net/wireguard/allowedips.c: In function ‘root_remove_peer_lists’:
drivers/net/wireguard/allowedips.c:77:1: warning: the frame size of 1040 
bytes is larger than 1024 bytes [-Wframe-larger-than=]
    77 | }
       | ^
drivers/net/wireguard/allowedips.c: In function ‘root_free_rcu’:
drivers/net/wireguard/allowedips.c:64:1: warning: the frame size of 1040 
bytes is larger than 1024 bytes [-Wframe-larger-than=]
    64 | }
       | ^
drivers/vhost/scsi.c: In function ‘vhost_scsi_flush’:
drivers/vhost/scsi.c:1444:1: warning: the frame size of 1040 bytes is 
larger than 1024 bytes [-Wframe-larger-than=]
  1444 | }
       | ^

Tested-by: Ron Economos <re@w6rz.net>

