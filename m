Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898845838A2
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 08:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiG1GSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 02:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiG1GSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 02:18:04 -0400
Received: from qproxy3-pub.mail.unifiedlayer.com (qproxy3-pub.mail.unifiedlayer.com [67.222.38.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF15C946
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 23:18:03 -0700 (PDT)
Received: from gproxy1-pub.mail.unifiedlayer.com (gproxy1-pub.mail.unifiedlayer.com [69.89.25.95])
        by qproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id 4B9CB8033FDE
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 06:17:54 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 8F496100478AD
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 06:17:33 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id GwpwofgokCokGGwpxoOFvZ; Thu, 28 Jul 2022 06:17:33 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=d+QwdTvE c=1 sm=1 tr=0 ts=62e229fd
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RgO8CyIxsXoA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=04ThL/Ir5WfZnXDToLT1mrxeXlTnqbRk4yrjXl8e34g=; b=YraBbNA/JCdPobNB/H5C0GcpDy
        4gKCEaNb+hrbNT5XuYc+K+WLykpYr5unyFofRNBtyhuUbDXVBzbEUR/IX9x5WHtDbqRuj5Y8nJR6d
        841lXfx6aNQ+sj/PIlw/uOuoP6gsiAqNR5JmB/MDCx9WLG/wu0SWg+SEmXHuF6H8mV+S+jVwQaGXU
        HRqs5V7IyttkCOcalhERSV9342KQ2NCs8tJM/JiAQT37yGGgIUUvTLZBtC0ru8KJ4Z3grQFQhhWZ/
        73312BdcMwc8fmDDYn5+P/6j3HZO5UJJg9/JR2+nvdG+PGbsMdH3Da+T4jBqPhbpX96aV2tS2IjXH
        ryI1LXJQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:37750 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oGwpv-003yHc-NP;
        Thu, 28 Jul 2022 00:17:31 -0600
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220727161021.428340041@linuxfoundation.org>
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <774a6b89-b83e-3f97-f42f-467e810863e9@w6rz.net>
Date:   Wed, 27 Jul 2022 23:17:29 -0700
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
X-Exim-ID: 1oGwpv-003yHc-NP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:37750
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 9:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

