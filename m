Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A241526F49
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiENDgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 23:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiENDgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 23:36:07 -0400
X-Greylist: delayed 1306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 May 2022 20:36:06 PDT
Received: from qproxy5-pub.mail.unifiedlayer.com (qproxy5-pub.mail.unifiedlayer.com [69.89.21.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CA7D8081
        for <stable@vger.kernel.org>; Fri, 13 May 2022 20:36:04 -0700 (PDT)
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by qproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 8178E8035FFB
        for <stable@vger.kernel.org>; Sat, 14 May 2022 03:14:18 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id 6E180100418F1
        for <stable@vger.kernel.org>; Sat, 14 May 2022 03:14:17 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id piETnZIVohWk0piETnF2Bz; Sat, 14 May 2022 03:14:17 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=IrfbzJzg c=1 sm=1 tr=0 ts=627f1e89
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=oZkIemNP1mAA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EULY3veXiEl90Efzf2o4YpOjDlsmuqpcgC1+YFnsQBI=; b=m9M+n7aVex49Xy5cXs+gbikaCf
        OfHu4St07SeMzCBDgFdgwwtuvmTRmk//NLSxvc88r9WM3FeF5h3qMRwom+J2c8qr5uLJhpblPKI/K
        AlOT3CurelvRN61yaE4l5n4rDyb4L5RxTPKQYWgxkcbVoj54LbtIwMWyGGi5x3E2tAJC3naZ9BoJa
        BWnrxB6FgU00fpiFN6Epi/CSp8vvmOjBD5FHeq7Jx2VKC2dR+vLiCbzycF4OKAYEvJzzkjuaEjXgn
        O1YfTNK+e6Uo2z2nxRs+6sMql/HpJQTO1Rx0OhHOHJGCekbMHzkqL1X6JXynFM5GwH09qRsUnAKUp
        Ceii+c6Q==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:50868 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1npiES-002ADB-6J; Fri, 13 May 2022 21:14:16 -0600
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220513142228.651822943@linuxfoundation.org>
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <75b14b6e-788e-2698-d2be-3340327b6e89@w6rz.net>
Date:   Fri, 13 May 2022 20:14:14 -0700
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
X-Exim-ID: 1npiES-002ADB-6J
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:50868
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 7:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.8 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

