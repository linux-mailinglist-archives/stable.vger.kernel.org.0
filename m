Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A6864EA0D
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiLPLPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiLPLPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:15:15 -0500
Received: from qproxy5-pub.mail.unifiedlayer.com (qproxy5-pub.mail.unifiedlayer.com [69.89.21.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254713720D
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:15:14 -0800 (PST)
Received: from gproxy1-pub.mail.unifiedlayer.com (gproxy1-pub.mail.unifiedlayer.com [69.89.25.95])
        by qproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 23C2680312A3
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 11:14:54 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id DA23410048C33
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 11:13:53 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 68f3pV0u68FgT68f3pbiSO; Fri, 16 Dec 2022 11:13:53 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=AYt0o1bG c=1 sm=1 tr=0 ts=639c52f1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ID0sHYrF0ttGq9hImI0A:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C1Gk3WR60xBx5j7TMCCl3jFFITCLtmd00+7RqlkeWK0=; b=Wbk4UBbRK1A2iOrztTv4n6Wrbv
        yeAvIx9G+OWfHJLD4uWyz3sMClDN3fLF23j53OxM17QtMYbPVPO/ZYNxQ1/zkHmafDJmIf4C498Wt
        6DndCvZoc+HcyayXDKxiXo2ErcXTd8tqn1tkJnSpbIXHNn1yL24JSn4Mpmz6n8tev5tzgblHrOO0K
        NgJrnKklKuHry1W5TaKOw/qFoC61nTcXEeJw6aRvH+mwqOqmHI/OHq+MFLFHfgmU3xbPk1jrAKqqb
        MjEtGnf3xpncGJkYOtlFlYMexet0TXRPyJijF0DawVOA7s2kO2BMLOK1I0JjrneTqPQfqWqAJJhlD
        VPCdRfxQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:33370 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1p68f2-003WsH-G7;
        Fri, 16 Dec 2022 04:13:52 -0700
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172908.162858817@linuxfoundation.org>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <0b3e5d0c-d9da-0fa5-b5bb-e21c255cd883@w6rz.net>
Date:   Fri, 16 Dec 2022 03:13:47 -0800
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
X-Exim-ID: 1p68f2-003WsH-G7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:33370
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/22 10:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

