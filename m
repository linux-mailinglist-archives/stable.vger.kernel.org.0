Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E067A570C38
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 22:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiGKUzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 16:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiGKUzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 16:55:51 -0400
Received: from gproxy4-pub.mail.unifiedlayer.com (gproxy4-pub.mail.unifiedlayer.com [69.89.23.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231206D2DF
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 13:55:50 -0700 (PDT)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id 83CB51003FB93
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 20:55:39 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id B0ROoWbPqgTLJB0RPoKtER; Mon, 11 Jul 2022 20:55:39 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=XKL19StE c=1 sm=1 tr=0 ts=62cc8e4b
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
        bh=MSGIUdp/JK+F8en/Gx0sEvmg4Ih1bisJEdEy5ufJK0Y=; b=iHGLiz4jmWzYQulVs3WrkflGZy
        Ton9Tu063I0wY0AzdHODPTfiAuwAc2cF5OliC8suwEMyiUGmYc0cZtaOSBCk/XGdCdqxTsRqg3X10
        wbIq3lgeCEojdMmErbsCUkFJQGpllInqOTN+1QP+FTPeeYJN19TMiKJlAUe02TC1YK4JaWNVbGCq1
        S1toWhhgV+yxY1sEoCu7LhkK7wjHGaDipXZsI/URRznn2MwLKna74eaLwLiM2jJ8t7Mx7zCLJv+9L
        jvSIJgtSqJmiuOxTs8JK0bDLlxuVyXVuhcLaetMXmqbZZeIL18umHtai5I5IsuxrYr4Ft+6pmAkxZ
        qM3qJzWA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:35444 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oB0RN-003TGO-Ts;
        Mon, 11 Jul 2022 14:55:37 -0600
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220711090549.543317027@linuxfoundation.org>
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <46d44d6b-4230-2c01-0a38-1a8f3a89c819@w6rz.net>
Date:   Mon, 11 Jul 2022 13:55:35 -0700
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
X-Exim-ID: 1oB0RN-003TGO-Ts
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:35444
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

On 7/11/22 2:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

