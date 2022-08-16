Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF9E5959C7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbiHPLUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiHPLTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:19:50 -0400
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6550DB077
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 02:50:20 -0700 (PDT)
Received: from gproxy4-pub.mail.unifiedlayer.com (unknown [69.89.23.142])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id BC72B802CE88
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:50:18 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
        by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id 77551100481A8
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:49:58 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id NtCvoKWkpoTaxNtCwoKp3j; Tue, 16 Aug 2022 09:49:58 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=PNrKRdmC c=1 sm=1 tr=0 ts=62fb6846
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=biHskzXt2R4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WL1xAwhUekvDaJAQgGU/uTWwJi4vjB3BzJxU5Ig6nLA=; b=bQUE55hQKeSDtQTmmJP0NJkwjK
        NsOrIC+koxLAVIZ9xJwncmznzhzXoMlp0uqGYHFUdfgKXJPuZAltxhfsDA1pzGmKZiMuG21J9fZaw
        p0KffsU1aF3pU1DyKBFihf5ey8lvCOtZ/9ur9TbMGPI1j/dkqyynCChjnDpQJh27eQfIKFUKbOF0f
        /qEciyRrTcptZmhgwLcTXpliU29Kjm33dM/+CtNg37/z1LEuAXTJ5Y9Qf7HSq8izWRSFmZh5IYbRR
        qPsdqAyhpsMwyR7MKssYr7aTmxHQqXnC8zaVyMSEtwx+UJKWUId2o/iMtS3NJoG7viqhbJzNNOy+H
        ds9j6y3g==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:40150 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oNtCt-004AMm-9f;
        Tue, 16 Aug 2022 03:49:55 -0600
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220815180439.416659447@linuxfoundation.org>
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <9f255516-7971-8ed4-5dc2-6c7ff6dbb010@w6rz.net>
Date:   Tue, 16 Aug 2022 02:49:53 -0700
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
X-Exim-ID: 1oNtCt-004AMm-9f
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:40150
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/15/22 10:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

