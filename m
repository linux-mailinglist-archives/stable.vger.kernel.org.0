Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637F257B198
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 09:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiGTHU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 03:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiGTHUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 03:20:25 -0400
X-Greylist: delayed 30509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Jul 2022 00:20:24 PDT
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70913599E8
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 00:20:23 -0700 (PDT)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id 2FB691004445D
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 07:20:13 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id E40Cox9yajIMdE40CoaUAU; Wed, 20 Jul 2022 07:20:12 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=ebP4w5IH c=1 sm=1 tr=0 ts=62d7acac
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RgO8CyIxsXoA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WBlcUvTkXy1z++HuE9DeN+YXF1eS8u6kceWoGgS/K9c=; b=RBdJHEtN+UbKlz6W50g3TruZ2m
        5ou5weNxcp6yz5ZIBKbRiZjZeU0J9VkJP3kOnbWt+EDz1+F0yIGRznJjD5zDLEOQCNl4jYM9W66IN
        CVSrJjd8Pf1pjy4SQTQ2RvaaLBV2YlIBSi60Sg+dsVcjk5lIqzsY45gnD+nlM7EWwF2S5e3QgeRxn
        YxDoZ+8MFqnIgWCDvzNkV+XFhgGQlIYCgx337O/Qnx8I8mMKRLHugovyj3khyJuiINoBNScjF0aFr
        bakgfTaShX1dYt/HlXLrIVR8KZiQH2bFXkQgE2n94F7DJ5nju1wJdelViNiP0EYn1A2OGfwgkWuAU
        7HlWmu0g==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:36794 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oE40B-000Dym-GK;
        Wed, 20 Jul 2022 01:20:11 -0600
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220719114656.750574879@linuxfoundation.org>
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <f7d32794-b7f3-e7c5-7b0f-3a4f99f354bf@w6rz.net>
Date:   Wed, 20 Jul 2022 00:20:09 -0700
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
X-Exim-ID: 1oE40B-000Dym-GK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:36794
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
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

On 7/19/22 4:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

