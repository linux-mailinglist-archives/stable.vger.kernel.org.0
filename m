Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02E66162AA
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 13:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKBM0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 08:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKBM0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 08:26:17 -0400
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23E224945
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 05:26:16 -0700 (PDT)
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id EC0F180380DF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:26:15 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 63F2410048902
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 12:25:55 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id qCocoZS7ZtENmqCodo41sZ; Wed, 02 Nov 2022 12:25:55 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=R4rGpfdX c=1 sm=1 tr=0 ts=636261d3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=9xFQ1JgjjksA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CSFKPktmnMtZzj74Sde0RaSXpz44odT6IJGcn0daLl0=; b=EKvvegnihbuqmRnfe5LeduRd17
        +n3bn6d4FVMlZUF1U4wuey+jO4FA9IrXqLh2X7IUF58FHQXPkfe26dcYTzKyqt+Vtf/sn7LrghWwZ
        kjR7VkngroKsM1DZLpFb9ziu5d7BaBCL49TqjbgN+RYmdsLHX6xRMkVZcK8uHdF0rAXtuTeyemX7M
        I0TrDnj6xzHps7lrYF7SwHOnxNic3LuRxiS4yekRGQ0xVyI3QHOaNo+kFGCR/L/JF13IFbqKinojo
        jso/Ig8A/LEOsy5Ysk6OuUj0D/uELA1N+SV1QyAOkX6K1WuyIsvJYXwb8/zljptyIhQvw8GzrE4jV
        RQIRlsIQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:56258 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oqCoa-003ByE-Bd;
        Wed, 02 Nov 2022 06:25:52 -0600
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221102022111.398283374@linuxfoundation.org>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <2ebfdb20-b1f4-b982-c480-bf667b601b2b@w6rz.net>
Date:   Wed, 2 Nov 2022 05:25:47 -0700
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
X-Exim-ID: 1oqCoa-003ByE-Bd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:56258
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

On 11/1/22 7:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

