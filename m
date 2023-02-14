Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406616957ED
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 05:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjBNEfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 23:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBNEfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 23:35:08 -0500
Received: from qproxy2-pub.mail.unifiedlayer.com (qproxy2-pub.mail.unifiedlayer.com [69.89.16.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DAA193E9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 20:35:06 -0800 (PST)
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id B9EEC802EB00
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 04:35:05 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 5C3A0100478A6
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 04:35:04 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id Rn20pZGo1jkdRRn20pT1Pe; Tue, 14 Feb 2023 04:35:04 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=LPqj/La9 c=1 sm=1 tr=0 ts=63eb0f78
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
        bh=Ycx7yKhb6BHF5jh1v4RxAby3S01VdNj1GD911429xQ4=; b=NBGY7KVJE4UyBnWheIM1/Ih+hy
        prqGo3Dd0rVnTNB5m/iijxPfINOEnl6GHlPIAAVqM3zTsbCSFHUAmtwDpdCIx8pcKRR3fWhzJLLw9
        2acHX24ugLHTJO+NfI5llbpYX+T/D/4Km8yVIssTEj0d4YYwmRzGWiegga72jClD5h068P/bf6naW
        Mwv4MjqcZNmyWk76jYjONDI34oLnNn+xG4XBrO7nsNEnzJX9WP2y1NjIwqSvyL5YJZ2AjlvnwXwtG
        lTpqesJc19ZX3WkMe2wcMBrjD5XtXPNHdjefITd+CTK0K//D/V6auRhZANjGhfQQNqPKs7t5/6qJi
        s/m56vyA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:54266 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pRn1z-004ORN-CE;
        Mon, 13 Feb 2023 21:35:03 -0700
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144742.219399167@linuxfoundation.org>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <3269b73f-7198-4da5-3cc5-5c33cf7ed0d2@w6rz.net>
Date:   Mon, 13 Feb 2023 20:34:58 -0800
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
X-Exim-ID: 1pRn1z-004ORN-CE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:54266
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/23 6:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

