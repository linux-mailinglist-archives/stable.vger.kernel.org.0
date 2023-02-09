Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FC268FC72
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 02:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjBIBLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 20:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjBIBLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 20:11:06 -0500
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643DB24114
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 17:10:52 -0800 (PST)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id E503D1003FCEE
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 01:10:51 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id PvSdp5CGhNX2aPvSdpqIW6; Thu, 09 Feb 2023 01:10:51 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=NMAQR22g c=1 sm=1 tr=0 ts=63e4481b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=m04uMKEZRckA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ts_C7CwfbZPzB7fMd6YA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MikMOipJ2uoVhe9ZVYyY4wVdZII+lEy/vF539YRUOJE=; b=H7X0S5dMlqkSCf5BruuJp15IW0
        lSsCF322nHlWb5AG6a51GshnXNgiq14jSpdEYWdt2rozAcyTiwx4hb2atMAyxJXw2GxkMZdHgDPZE
        xDbkSSKYsLFoDY4rfAr8r0lyw6Ub2QOKp7eR+L9QahOsBNqfhOUlUKu9vL7SOUtQ+79To2JAU8jbH
        rja3lIIbUsoVMXumNME8FtGbPBJQt0baZMIcpd9nI3pZpf1ewB9EjIE9/lX+QGQ8QrNcLCC8XwX5U
        dV5VFCdcbB2QHWnECphb8HqmNmxDYmL14MRTJOq1LsvCHD6chUGrXW1vvK1aAXoRJWn5t0CVPDymo
        WXwNiiFg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53846 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pPvSd-001ul4-4U;
        Wed, 08 Feb 2023 18:10:51 -0700
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230207125618.699726054@linuxfoundation.org>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <038d4c39-f15b-6784-8cec-26257f5c98a3@w6rz.net>
Date:   Wed, 8 Feb 2023 17:10:47 -0800
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
X-Exim-ID: 1pPvSd-001ul4-4U
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53846
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/23 4:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

