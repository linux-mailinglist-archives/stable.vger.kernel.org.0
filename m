Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC26754CC53
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245501AbiFOPN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 11:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348160AbiFOPNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 11:13:37 -0400
Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AC824952
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 08:13:36 -0700 (PDT)
Received: from alt-proxy28.mail.unifiedlayer.com (alt-proxy28.mail.unifiedlayer.com [74.220.216.123])
        by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 0B610802E079
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 15:13:36 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 9448B1003C221
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 15:13:34 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 1Ui6oVNsANVEz1Ui6o8JN2; Wed, 15 Jun 2022 15:13:34 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=I5+g+Psg c=1 sm=1 tr=0 ts=62a9f71e
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
        bh=Z4nPqYG2TqBqwwPo2qCf6x7FPw6Tk77VRbXS8wdJFmc=; b=T28ShSbhcU6PdtJGIJkAvMHO0q
        38PI6Qsn97PQhDk3+lK9uSpwOmYyZ6L+dk+h5QWL2Lu3ng0jMiNW9T6wQLzpmil2Vme7gn+W2X6af
        CY86PVJ4mVmny6jLgv5DlPEmrPpgpfDw3r4/qEMPyIWhHBhVR/YZHAFhYN90ocB17BtLlDxqbXHlH
        PttyQu3aWIBeR+ytwSxi3hoLMuoErnfaPbAPG5MACK1TgVRliAzdhMNQEOdOmEaL+7h96dyFQSdjw
        nzrcMHC+493nIQkNEEwjVq+8bYgPv9IavCvhvlZ0ufXj9QGlkzIVzZpHZQXOO60GOpWGEI6U+Plqt
        OVbiUYLw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:44454 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o1Ui5-002CBC-4X;
        Wed, 15 Jun 2022 09:13:33 -0600
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220614183720.512073672@linuxfoundation.org>
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <1b8232d8-ec31-f192-0ba8-a1481c64fd8a@w6rz.net>
Date:   Wed, 15 Jun 2022 08:13:31 -0700
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
X-Exim-ID: 1o1Ui5-002CBC-4X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:44454
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 11:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

