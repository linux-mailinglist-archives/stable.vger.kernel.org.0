Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AAA6525B7
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 18:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiLTRpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 12:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiLTRpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 12:45:30 -0500
Received: from qproxy2-pub.mail.unifiedlayer.com (qproxy2-pub.mail.unifiedlayer.com [69.89.16.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B41C1AF36
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 09:45:29 -0800 (PST)
Received: from gproxy4-pub.mail.unifiedlayer.com (gproxy4-pub.mail.unifiedlayer.com [69.89.23.142])
        by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id BE0DA803C8E6
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:45:08 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id F0F0D10048554
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:44:35 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 7gfLp0vmO9rmy7gfLph1l6; Tue, 20 Dec 2022 17:44:35 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=a5L1SWeF c=1 sm=1 tr=0 ts=63a1f483
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Mr7br2G1yL84+ZgN3ql83w2Wlq+KgqVo7AJXmT9xhpc=; b=w0+W4I8UFcqrIJ9mtKiomHXem1
        tryp2h3/yhndw8d8foYOr3d4IUCtU201gQ4O2ngVGXUBbnsEOcwS/wmVrVmbp0F1gbAbrreZceiEJ
        /mjmgvGlCEuOamA8LUhOZ1ZUQPMzvXWpucTPJfe32ZBgk2uB08+zvqFPF4shPHCz1Wq3xmKhCk14R
        Cg/P+BCGVmeTIqb6Bk6hnBVVLz5Gdn/XFAtEnyK4vzKTt2idbiwXs9hvF6NEjNUhNX4e8l1X1MHC1
        Y4y9vne0pWE34EwCk397Ib9wQcb4+s42My3ScvePnDDlRd5laYf8B+S47ym/cyw8zTt7Cl8HUSB42
        plly4TuQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:33968 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1p7gfJ-001qHU-VD;
        Tue, 20 Dec 2022 10:44:34 -0700
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182944.179389009@linuxfoundation.org>
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <3a6341b7-5f00-59ce-efe1-36e888a4d3ca@w6rz.net>
Date:   Tue, 20 Dec 2022 09:44:29 -0800
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
X-Exim-ID: 1p7gfJ-001qHU-VD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:33968
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 11:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

