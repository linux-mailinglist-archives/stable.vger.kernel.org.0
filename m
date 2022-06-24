Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B6E55A459
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 00:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiFXW0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 18:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiFXW0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 18:26:39 -0400
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC0B885A3
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 15:26:34 -0700 (PDT)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 1CCB21004818B
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 22:26:34 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 4rl3o6fdRPDOm4rl3oEE96; Fri, 24 Jun 2022 22:26:34 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=GLDNrsBK c=1 sm=1 tr=0 ts=62b63a1a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BDCG8O_D2SPVAq3EX74A:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zEUVMjd6At/VaVcDdqGUbnb9HMrynB1KutbZgP3N6a0=; b=vyTiJrLyojw4tN3o/kOyb6enhj
        6mKy76Uki/sZc5NF2O+2xGgmTPUHBlCg11Op61uCvSk1SH4ck/C7gXiuGrj5x124mRKl+K1Haxscw
        EjkV1KNXkP6ZIbZeoAXVDBcckkjt2QzDiykyX253g39R1cSCYyGhYMkijO1/iT9cejxepEk8bROhR
        Xe0N75/M/NQdyA0yBAnwe1CPEZe8TDEqDAVia/fQEZFr03UdJ5I1CPSHiAi0371MIIAxFu02uKNt/
        uEwv+yjVq5tXkiFwZ7wd6cQBkgp/F+2uoN9J8El52qNC4ujChG2Qm9rQpk4bponZz1A8aWdHE0FUA
        sgfuZ+Yg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:45616 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o4rl2-00434m-JM;
        Fri, 24 Jun 2022 16:26:32 -0600
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220623164322.288837280@linuxfoundation.org>
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <8c1b80b5-b01e-e3e7-8a2f-5b8ba799d28c@w6rz.net>
Date:   Fri, 24 Jun 2022 15:26:30 -0700
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
X-Exim-ID: 1o4rl2-00434m-JM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:45616
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

On 6/23/22 9:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

