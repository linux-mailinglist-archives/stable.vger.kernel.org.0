Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBDD5FE801
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 06:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJNEeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 00:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJNEeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 00:34:09 -0400
Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF912AF182
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 21:34:07 -0700 (PDT)
Received: from alt-proxy28.mail.unifiedlayer.com (unknown [74.220.216.123])
        by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id 58F6B802CD2A
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:34:05 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 58ED310040222
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:33:42 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id jCODoKCjp76pjjCOEo6dQU; Fri, 14 Oct 2022 04:33:42 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=TL6A93pa c=1 sm=1 tr=0 ts=6348e6a6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=Qawa6l4ZSaYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=OLmlkwXjvnPPfp-jv6YA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S20gLhLfqA3t6QFp79HC+ZRf0CIiK8ILqvNiNUtkAFQ=; b=gKV3AXHg7mLDgOQ0jCZeKa5ozX
        USx6ZMLulXGgberDdR8v37JN68NygvKASVU4s73ehX3NH3iiryxf5ZaSVnKz5E84ivT7Bfb+95Obj
        tkGpCPzC829AcC+PzEXcGusnTNklop/r3KKAKCDrl17qDlf4mVAqpB7IqO8cQCMW0Nw2NEonrpIrl
        SPZxb73PRmTfAyDOzrNE6xJCQqIzGVjBatcM+AERbcjcnliSQo8sLm8AqJhDFrF7zNYCH7zI0qJs+
        d3ZpF11H7pGurnkIxor67+xig/eKZvq/HFJSXgnCgp8t/BBxiJ9TH5x0zCnbuO5bqSMPz5seb8T/m
        Eei4JrnA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53774 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1ojCOB-004HVq-Jy;
        Thu, 13 Oct 2022 22:33:39 -0600
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221013175146.507746257@linuxfoundation.org>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <988efb2a-1be0-b809-781c-099804ef96b9@w6rz.net>
Date:   Thu, 13 Oct 2022 21:33:32 -0700
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
X-Exim-ID: 1ojCOB-004HVq-Jy
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:53774
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/22 10:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

