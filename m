Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C4954C15E
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 07:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiFOFyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 01:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiFOFyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 01:54:43 -0400
Received: from qproxy2-pub.mail.unifiedlayer.com (qproxy2-pub.mail.unifiedlayer.com [69.89.16.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6EE17E35
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 22:54:41 -0700 (PDT)
Received: from gproxy3-pub.mail.unifiedlayer.com (gproxy3-pub.mail.unifiedlayer.com [69.89.30.42])
        by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id 6F07C8029F37
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 05:54:41 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id DEBD9100563B9
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 05:54:40 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 1LzEoPyAeNVEz1LzEo2vu5; Wed, 15 Jun 2022 05:54:40 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=I5+g+Psg c=1 sm=1 tr=0 ts=62a97420
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ieWZb2X5Nz3z-Wn_6k4A:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4z81clygDyJYi9HgKWw2ndNfS4Z+orJGbop8cvsFDWE=; b=KbjSkabUr8Ppem39CGWNfLkgaY
        8UWE5QqKDVJUt5o2zT21ydNGON7a3jEe1E5SsXXHeGK5fDrfeF1raLV7WHAsKz/Qcot+W16dOXNk/
        unfzcs6mBr4YyICla+QlSmLJpvH4fvdbk7HLwKLsiguudwbDemrDLRcVl7Tz/uGtmXb4+wy3npL6B
        1D82amO7mqU5S0bKe26Stp1CWoOf31yrB+/HfxFPzUetbgesyC3lbF8KJcRgvh4+yJUaWAtXdS8uR
        DL2b8043GsbcbWJJUuysqq9JfPmwo6134tLxpocWv7f2EvGKrPwn51+7BLeO+ZaItJZxeb3nb1xzP
        y2MZc/Iw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:44380 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o1LzD-003Fm7-AZ;
        Tue, 14 Jun 2022 23:54:39 -0600
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220614183720.861582392@linuxfoundation.org>
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <827761b3-ac32-ea6e-e4ff-e08b36808736@w6rz.net>
Date:   Tue, 14 Jun 2022 22:54:37 -0700
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
X-Exim-ID: 1o1LzD-003Fm7-AZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:44380
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 11:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

