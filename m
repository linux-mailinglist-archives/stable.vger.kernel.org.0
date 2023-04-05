Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7076D7291
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 04:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbjDECpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 22:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbjDECpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 22:45:31 -0400
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBC53A9F
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 19:45:30 -0700 (PDT)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id C15331004853E
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 02:45:29 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id jt9Np3co4zLqsjt9Np9qpr; Wed, 05 Apr 2023 02:45:29 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=M+SIlw8s c=1 sm=1 tr=0 ts=642ce0c9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=dKHAf1wccvYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=rwde2vLGyBdoTMciaJAA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UG42hj4qw0tNhibK7lyPhkULm/Re9q2sW9cwapeprqM=; b=FfuZwz12qWNbqIhNxvQMmf72pk
        RDU1/wQ0lDUuPmo/T3RdQ/DS+EOI2uCWRu4HokstfhkALeRH4KTjB9Q/flqePAHN0O4/wxMeWaeCJ
        7627pVQl6hI160M3kn3FKKyHvmBQfarABVKQPp7IOJG7QCt2is9dcnroi0kzzcuYxxgFYy/xrK0qd
        3rxM6/Ma+zSqB+ZlgLC1fBe78Z2v2U51XAf0hUGWuSKSRTWoAze9cLJi1IZBwPrfLqVHGMYso1vst
        iFrOV77ziB2lt2N8inGJVDP5NNZMjraTCmAU4IY5+4RPLe54lce6Z6heV5q+Hfbe01qm0ygghumLE
        ATekmBZA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:34158 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pjt9M-003b37-K1;
        Tue, 04 Apr 2023 20:45:28 -0600
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230404183150.381314754@linuxfoundation.org>
In-Reply-To: <20230404183150.381314754@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <5ebc4141-dfd2-af04-ec46-343de0052d44@w6rz.net>
Date:   Tue, 4 Apr 2023 19:45:23 -0700
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
X-Exim-ID: 1pjt9M-003b37-K1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:34158
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/4/23 11:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Apr 2023 18:31:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

