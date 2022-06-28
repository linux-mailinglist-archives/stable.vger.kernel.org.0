Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D538255DAB4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbiF1HZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 03:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242439AbiF1HZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 03:25:28 -0400
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173B72CE20
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 00:25:26 -0700 (PDT)
Received: from cmgw13.mail.unifiedlayer.com (unknown [10.0.90.128])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 2D96410049CD1
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 07:25:26 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 65bBozbOcxkuL65bCoeqi6; Tue, 28 Jun 2022 07:25:26 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=euAacqlX c=1 sm=1 tr=0 ts=62baace6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dd/8kKGy/GabW7UsEIjWRKKLrTv0hBDPvgFYx7vygeg=; b=rcfsxP0KZ7fal3DofKKFfwmLwi
        kUySICuZ/XQQfEJNA282CCyAZTJ19VpOoD+cmX05BOOmF1PYi+rM5NZcN6QTi4fBPvIXxXpQyRRAd
        pIYhNk453QlMUXr+4l1lUvbk8KHIpeJlSawnkFqkrEtOS1aNpxYv3NzXEVv5sapiKvqdcot6rKcmf
        IAMBzKz1SS8dBWG5HLFKgtN0X/INmthhA6lhqlxZ6DOr6lUIDpde1UJTxjbvMTga9LIIEVBCmlUYx
        nvfjSSWoF7+ic0Vl6Tl6hVG0ZX1zGkJgbNHkyUlJkJc9xMZlVv0+KXoXaoqJ7Xhodvs3rnUxCnsn5
        GC152orw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:46160 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o65bA-0040hQ-N8;
        Tue, 28 Jun 2022 01:25:24 -0600
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220627111938.151743692@linuxfoundation.org>
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <84fd3bd2-4934-cabd-acff-0d2e2ab2f6a5@w6rz.net>
Date:   Tue, 28 Jun 2022 00:25:22 -0700
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
X-Exim-ID: 1o65bA-0040hQ-N8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:46160
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 4:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

