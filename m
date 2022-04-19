Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591A9507D5F
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 01:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358540AbiDSXws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 19:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358536AbiDSXws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 19:52:48 -0400
Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C861FDF63
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 16:50:02 -0700 (PDT)
Received: from gproxy3-pub.mail.unifiedlayer.com (unknown [69.89.30.42])
        by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 6D28880438D1
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 23:50:02 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id CB0EB100474C9
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 23:50:00 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id gxbcnrEa8Qs3CgxbcnwrOP; Tue, 19 Apr 2022 23:50:00 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=A+Opg4aG c=1 sm=1 tr=0 ts=625f4aa8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=z0gMJWrwH1QA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1Tpk2UOmd7KVafY+HBBYYPKu51iJiccL4hNj5lxOwtM=; b=IeUDOFNmbD+TUj+rw8vVQW9ygb
        8yPCLnVGhFiBCG3lYd+dLg29K/3/EZQ+bvtNrS4adYXkk2W+yYw6fZ13EWgq/CdpNJTFsVVHbFrnr
        6hSQ0vI+sJUCBqdE4sSYEDUE7Zg/H/yg56N4lprKrgpjI2ntCNIJ2zRPAgKTEjkkkRaFm8C8JH54t
        aye6iZ1QffjbxP3jJFlHLAe3kSOYB1WKhEpW4Tylh7lDBOvxmcTWxGZVYFhnVjRTFHShtaunsIj8R
        xAoMI10fEWgde11wWMA0Z2BQSJQ5w04OwieJyC3Ap2o+5C0X9uQy2wo6MULeszN8PBoxxJWSMLpHP
        rqUNlrvQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:60242 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1ngxbb-0005M9-ES; Tue, 19 Apr 2022 17:49:59 -0600
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220419073048.315594917@linuxfoundation.org>
In-Reply-To: <20220419073048.315594917@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <e0606719-087b-3149-7a9e-0b37590bebca@w6rz.net>
Date:   Tue, 19 Apr 2022 16:49:57 -0700
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
X-Exim-ID: 1ngxbb-0005M9-ES
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:60242
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/19/22 12:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.35-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

