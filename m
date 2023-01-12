Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019C7666FE3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 11:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbjALKkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 05:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbjALKjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 05:39:46 -0500
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859C565BD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 02:34:24 -0800 (PST)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id E2DDD10047C1E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 10:34:23 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id Fuudp7oy6FxgHFuudpGydK; Thu, 12 Jan 2023 10:34:23 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=ePfWMFl1 c=1 sm=1 tr=0 ts=63bfe22f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Hb3yA03KV983punxqLMA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DCc3XlxNqADuGnNawjyPGM382LoIqxxCBJw5HrzyTIk=; b=1qW4FU5hU8KRXtbF2ENFm15qQ9
        t4ZBjV6hapbf2AvpOIm9arnJINGZmtbsM7XK1k0oMg3/pah5URRFPHeLCjeHEcvPwujBAkUxRgyuw
        yDL1qJasZ8/CadbsPlVWPsMdeuVMP90c/wrhD28WNp739XhRr+P0+gN4NLO+iwJGifhhBQq8iDb4M
        jRXySSfk5nksMg4+4lT+ea7iGQyishEs1loB9mG62DgLJhUIuTAoNWH3KVfOBm+UY8c0oZdonIlDm
        6SLUToc4tH8N4UPSPRaK34wsgyGsWrO+OT/WBDpU50WFOdN8i2xBbX5IReFW8pRY18dqcy7BuKy0n
        Z4giGmDA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:51236 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pFuuc-002AnF-DW;
        Thu, 12 Jan 2023 03:34:22 -0700
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230110180031.620810905@linuxfoundation.org>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <0a23518a-fa75-52d0-81b9-b6528ca8d7b4@w6rz.net>
Date:   Thu, 12 Jan 2023 02:34:16 -0800
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
X-Exim-ID: 1pFuuc-002AnF-DW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:51236
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

On 1/10/23 10:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

