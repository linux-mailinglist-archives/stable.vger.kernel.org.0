Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCCE6A2138
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 19:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBXSLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 13:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBXSLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 13:11:39 -0500
Received: from alt-proxy28.mail.unifiedlayer.com (alt-proxy28.mail.unifiedlayer.com [74.220.216.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910F6695B
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 10:11:37 -0800 (PST)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 9CD041003BDFC
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 18:11:36 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id VcXgpnpK1PH6mVcXgp1KHD; Fri, 24 Feb 2023 18:11:36 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=evcacqlX c=1 sm=1 tr=0 ts=63f8fdd8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=m04uMKEZRckA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EUGO2zo5A5LgyGuTJ4tMddLToPMG74kYrvdy7mNDB4I=; b=HaKWocC8o3X0JluyjpKSe2PGpj
        vOhuoLu7tyPBWOwp3lqk1DovY8rXhUbwid6G4MPCAx/K/guvZl9zDu4KrOkV0+a/uD0Vy2iWWZri7
        VR0BroxyudpKM2IHWgte3Xqn2vKa4VxqezC3xBmKVhGAX+wB9pIJvB8UQvOpNG1ch8XGyyfmeBH1w
        VKVBe/cNtLe2BfTdgVtBqYKsnB8YsGsBa/Svw/NuazeT6qm3uupAuU2aaaaZPXA7vbFOd3UtDJENd
        f4VAVRpoaDltw8ATl72E85ZHzrr39z3pQR4qubPr/xOHnz+kIYTyye7wp3BxnMH4wZ9yIM8sTP+B6
        pzL5qNDw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:58270 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pVcXf-001VAs-0U;
        Fri, 24 Feb 2023 11:11:35 -0700
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230224102235.663354088@linuxfoundation.org>
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <a395cb5a-d54a-d52e-8a44-0287358ae002@w6rz.net>
Date:   Fri, 24 Feb 2023 10:11:29 -0800
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
X-Exim-ID: 1pVcXf-001VAs-0U
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:58270
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

On 2/24/23 2:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

