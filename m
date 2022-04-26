Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D253510C4A
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 00:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiDZW5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 18:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiDZW5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 18:57:08 -0400
X-Greylist: delayed 1486 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 15:53:59 PDT
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258A949F85
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 15:53:58 -0700 (PDT)
Received: from gproxy1-pub.mail.unifiedlayer.com (unknown [69.89.25.95])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 20C50803197F
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 22:29:12 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 7181C10048149
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 22:29:11 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id jTgCnrQpykku4jTgCn8Pwh; Tue, 26 Apr 2022 22:29:08 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=WPC64lgR c=1 sm=1 tr=0 ts=62687234
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=z0gMJWrwH1QA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=SVN_c6MdWGthp28QxcgA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/Rp5JcowqbercpMnejn0KXXZ7Dd61U1MssBPSMRyV+g=; b=Kl63dDgR3urjsU27Ldi1WayfM+
        Ap2/OhcjXsdeoRheS8zZG43gKm0u1E2I6/vGNtJHItheVjgKoutHCzPV1xGkPKb2xL0v0VritCb6i
        ELhQCZiA1pMaz74o/l4ODQP4zrifTIB71fMgcLc9h76roqux0am8vzPlOTUWcmrzb4vFxkoxyEPyB
        LQDFdUYRJnEavhBnvNEbWCVw0mwHIyFK/mu5dLs1O0Jr/8nGsKUxCLOKId4Cc6UMlbMUWEbmsRBiJ
        2mZ78vktTFN/z8IaZClBO1SkIGOrS1PIOQJjZPr2jIsgSZ88DyDAvhdMRkMzLoklLxZslDA2OnB5p
        Mjf35AHA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:48778 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1njTgB-002ry4-Ig; Tue, 26 Apr 2022 16:29:07 -0600
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220426081750.051179617@linuxfoundation.org>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <18b0792e-642f-0435-1f22-e693de7ccfea@w6rz.net>
Date:   Tue, 26 Apr 2022 15:29:05 -0700
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
X-Exim-ID: 1njTgB-002ry4-Ig
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:48778
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 1:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

