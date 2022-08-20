Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B9B59ACF2
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 11:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344262AbiHTJfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 05:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245125AbiHTJfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 05:35:10 -0400
Received: from gproxy1-pub.mail.unifiedlayer.com (gproxy1-pub.mail.unifiedlayer.com [69.89.25.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C3821830
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 02:35:09 -0700 (PDT)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 7EF2F10041FA3
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 09:34:58 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id PKscolYLhpnCyPKsco2fIS; Sat, 20 Aug 2022 09:34:58 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=d5kwdTvE c=1 sm=1 tr=0 ts=6300aac2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=biHskzXt2R4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=P_Ggkjto_qLeQm38W8AA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pfUh0OkdD9ECtf/Ulbr9qrfSPNo3aES6azkpvwDTpsY=; b=UIpbHoa864y7Aafq/VALhprIth
        RjPm+iR41cwYusjlbfyyUDOc2t0d+TINQBhkhZro2m0SAn4Jb2uWun6dne1GvLM/0rLctj5fTKapr
        7Bg9ZmTN5FxaAY2XZDE2hgD844auCjuX2R+jYvlVnBmvOWMeX3yt47eYTA9eZssCbbDcD2XiFfcGU
        NHAqO9jOwpb95NYIbqDdCyni0jBBNRKE/hjz7jmekdiNO6zTw78QVR7oEh3JP0+QJKbu9XflNh9SN
        2RmCz5B3AcOP04gSNY4BKTTH7uI9YCeibzm2VR44Dkycuk2Zo+19G5g/PEFuPJQltEvH1ttvt4Zpc
        okHAeR4A==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:41002 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oPKsa-003W0a-S6;
        Sat, 20 Aug 2022 03:34:56 -0600
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220819153710.430046927@linuxfoundation.org>
In-Reply-To: <20220819153710.430046927@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <63b7a770-fc9d-e001-f303-431c77895b61@w6rz.net>
Date:   Sat, 20 Aug 2022 02:34:54 -0700
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
X-Exim-ID: 1oPKsa-003W0a-S6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:41002
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

On 8/19/22 8:40 AM, Greg Kroah-Hartman wrote:
> -------------------
> NOTE, this is the LAST 5.18.y stable release.  This tree will be
> end-of-life after this one.  Please move to 5.19.y at this point in time
> or let us know why that is not possible.
> -------------------
>
> This is the start of the stable review cycle for the 5.18.19 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

