Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7710D6BD91D
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCPT1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPT1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:27:48 -0400
X-Greylist: delayed 158 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Mar 2023 12:27:47 PDT
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EEADCA6D
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 12:27:47 -0700 (PDT)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 5FD2F100410C7
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:27:47 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id ctGNp1nQIUEmJctGNpozH5; Thu, 16 Mar 2023 19:27:47 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=TLSA93pa c=1 sm=1 tr=0 ts=64136db3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=k__wU0fu6RkA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=JJyvPXDEJU0IjC6tU9kA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TOPigHHk+IoINLgiEflG7CkIoyJpvZQVcBqj2W+Z6gE=; b=OYNAs+3URbBWjgzVHsxWYP0aAN
        xXGY53OKdsq+PAHqOJegQMvsptjmwpK0YXfdhFwQQw4Afgj8sQuugB+T3tSgCxI3360dVrPh/1tAN
        DAl3Zxe6To+gSPVmuodKkmdJze6Wth4eYoJx7aFopmROHdgr5tsqXSX8T4fKYC2wJVPF/AbQuoT/Y
        o6kuSttqZu0gARNJ4bMMB7/naKYPTbkpgo16wVwoolln2hT875l9xOXFxBQXT+bY0GOCATLBkZjUd
        FbIfnyMMgiHg2/8eCtozj9rb3zjjAAKLeMzFLJnPjmjwZ8lckVhsXSBFJeq7f7xi3UEaUXywutl97
        aoYm6y1Q==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:60506 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pctGM-000F1N-6Y;
        Thu, 16 Mar 2023 13:27:46 -0600
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083444.336870717@linuxfoundation.org>
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <4d70ca88-f39e-d6a6-2c02-5a484f5044a3@w6rz.net>
Date:   Thu, 16 Mar 2023 12:27:41 -0700
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
X-Exim-ID: 1pctGM-000F1N-6Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:60506
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
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

On 3/16/23 1:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

