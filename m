Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E5C48F6DC
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 13:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiAOMcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 07:32:48 -0500
Received: from qproxy4-pub.mail.unifiedlayer.com ([66.147.248.250]:42108 "EHLO
        qproxy4-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231397AbiAOMcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 07:32:47 -0500
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 29280803889D
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 12:32:47 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id D471710048EBF
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 12:31:46 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 8iDing7xtnAlU8iDinXFA3; Sat, 15 Jan 2022 12:31:46 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=QIOt+iHL c=1 sm=1 tr=0 ts=61e2beb2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=DghFqjY3_ZEA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=EiS2R4b7cH6gAcqD88AA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ljzcytYZwH/UWJRlNXc9+FEdgCIqtEZd042mwlrIzNo=; b=P5nzavBzFeZo069fN25nsxOkW6
        HRaSMldSFdlaxBpr28lt2jkElViMbtXBhtfsO/sxf/XK9OBSjpAtEWDv/4TgvTJyoP05cJi4dRBDf
        C7nNndSTHdQ0CYPPO/DW40rmM;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:32786 helo=[10.0.1.23])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1n8iDi-003gEg-41; Sat, 15 Jan 2022 05:31:46 -0700
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
References: <20220114081545.158363487@linuxfoundation.org>
 <b94bd7bd-0c8b-1697-f4af-27e99ca9e62f@w6rz.net> <YeKCeIOd8v7vOpdE@kroah.com>
 <6aa09e6a-9537-72d0-caf0-347038fe37b5@w6rz.net> <YeK69MTpuiz0wqrU@kroah.com>
In-Reply-To: <YeK69MTpuiz0wqrU@kroah.com>
From:   Ron Economos <re@w6rz.net>
Message-ID: <78cae1c8-9a2b-b0a4-d9a1-efeb03290f58@w6rz.net>
Date:   Sat, 15 Jan 2022 04:31:44 -0800
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
X-Exim-ID: 1n8iDi-003gEg-41
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.23]) [73.162.232.9]:32786
X-Source-Auth: re@w6rz.net
X-Email-Count: 12
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/15/22 4:15 AM, Greg Kroah-Hartman wrote:
> On Sat, Jan 15, 2022 at 03:52:34AM -0800, Ron Economos wrote:
>> On 1/15/22 12:14 AM, Greg Kroah-Hartman wrote:
>>> On Fri, Jan 14, 2022 at 11:59:57AM -0800, Ron Economos wrote:
>>>> On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.15.15 release.
>>>>> There are 41 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
>>>>> or in the git tree and branch at:
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>> Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
>>>>
>>>> Warnings:
>>>>
>>>> fs/jffs2/xattr.c: In function 'jffs2_build_xattr_subsystem':
>>>> fs/jffs2/xattr.c:887:1: warning: the frame size of 1104 bytes is larger than
>>>> 1024 bytes [-Wframe-larger-than=]
>>>>     887 | }
>>>>         | ^
>>>> lib/crypto/curve25519-hacl64.c: In function 'ladder_cmult.constprop':
>>>> lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of 1040 bytes
>>>> is larger than 1024 bytes [-Wframe-larger-than=]
>>>>     601 | }
>>>>         | ^
>>>> drivers/net/wireguard/allowedips.c: In function 'root_remove_peer_lists':
>>>> drivers/net/wireguard/allowedips.c:77:1: warning: the frame size of 1040
>>>> bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>      77 | }
>>>>         | ^
>>>> drivers/net/wireguard/allowedips.c: In function 'root_free_rcu':
>>>> drivers/net/wireguard/allowedips.c:64:1: warning: the frame size of 1040
>>>> bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>      64 | }
>>>>         | ^
>>>> drivers/vhost/scsi.c: In function 'vhost_scsi_flush':
>>>> drivers/vhost/scsi.c:1444:1: warning: the frame size of 1040 bytes is larger
>>>> than 1024 bytes [-Wframe-larger-than=]
>>>>    1444 | }
>>>>         | ^
>>> Are these new warnings with this release, or old ones?
>>>
>>> thanks,
>>>
>>> greg k-h
>> They are old ones.
> Ok, that's good.  Are they fixed in 5.16?  Anyone planning on fixing
> them given that -Werror is now allowed to be set?
>
> thanks,
>
> greg k-h

They are also in 5.16. I'm using the Ubuntu 21.10 config (which includes 
the kitchen sink), so they're probably not showing up for others.

Ron

