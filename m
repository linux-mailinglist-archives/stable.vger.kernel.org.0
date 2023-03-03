Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A867B6A9101
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 07:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCCGaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 01:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCCGaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 01:30:10 -0500
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D5576A2
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 22:30:09 -0800 (PST)
Received: from gproxy3-pub.mail.unifiedlayer.com (unknown [69.89.30.42])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 06FE8802BE7B
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 06:30:09 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id 8683A10047D68
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 06:30:08 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id XyvgpDTQhuVTuXyvgpGhGG; Fri, 03 Mar 2023 06:30:08 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=UcqU9IeN c=1 sm=1 tr=0 ts=640193f0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=k__wU0fu6RkA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O3hNsnRcHcmrHKJ81Ype8MvM9VzJLv3jdg6F3Aeoh8E=; b=Z7zrzcrJmDEs7oJaDnc8FiPiDR
        AhIx4IGaXPBSp7HALzHTU4BiOrq8uywW65FBFZZ9O6I6fZWyjz/RNxJpgULlgLWNmM3zunWejd+r1
        5ZLlc5bHj/SO/OrE0xVqE992iC8URILpYbirkaHtESLWnBJQcxMC9jDXIVrNU+bAmlD7iZgLwR/W/
        +N4bh1iiCi/aeRvLXXKIFLh5e1+EyxeP5DpX/6GOk0FO4Z3IdnvG1oBmLw6jbJjg5ZP3tvQqHeWJ1
        eCfoSaacwCzleoM3NXvwmUPXrrk6cYTgNgZjfnPVzFlGaIQDkR9GcjSz/fXcGAkwCsb7d25KjClnx
        O2WlylvQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:58872 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pXyvf-002nvr-Jk;
        Thu, 02 Mar 2023 23:30:07 -0700
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180652.658125575@linuxfoundation.org>
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <781059bd-45f0-e300-c01c-7978a8ded5ef@w6rz.net>
Date:   Thu, 2 Mar 2023 22:30:04 -0800
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
X-Exim-ID: 1pXyvf-002nvr-Jk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:58872
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

