Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CA466A707
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 00:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjAMX0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 18:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjAMX0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 18:26:39 -0500
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD4389BC8
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 15:26:37 -0800 (PST)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id 3DEBF1004D0F2
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 23:26:37 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id GTRVpGqjDLXXpGTRVpZzvu; Fri, 13 Jan 2023 23:26:37 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=KvyIZUaN c=1 sm=1 tr=0 ts=63c1e8ad
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=uJXoyXs2SWzOjiTBKGkA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wHGbrhCQsYGBvnsMDI9Sc8XtN0LjMmgv6I4KTkqII/Q=; b=r0r4CG2TTmT9lusgtrd/RylcSx
        nnC5EraDyh1bCg83gOe5WN0dhEWAFeqFYjnaCxUB3Lx08qzDBxyvp4usO/2KDRXc5zbxHnW3j0S53
        vW1v//ItAUhUgDWAIDAtAtw0scLeEAvrtShAND7ALW0BlyXyZ/Gp2OEaVpPyvGnL3oOFiP+ZZ6GaQ
        s41FcXeCk6MhCaX2Ra3ZxFTw+Bzh5gUe1Ljhlv6F0G9Em+v0LlUdXu5pC15C/necIi6oNg8UbaZCb
        mpdSbA6wc+M3R7dSH4erc/4iYro2bL5h8HA99gXsoclutOspuzOqigIyLXRk9Iu8UR23MhQsetwW+
        2TUXk1Sw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:51374 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pGTRT-003UAp-Sf;
        Fri, 13 Jan 2023 16:26:35 -0700
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230112135524.143670746@linuxfoundation.org>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <1e9676f3-e436-3f69-ddff-abfc6ba5804d@w6rz.net>
Date:   Fri, 13 Jan 2023 15:26:29 -0800
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
X-Exim-ID: 1pGTRT-003UAp-Sf
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:51374
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/23 5:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

