Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9895A5BD0
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 08:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiH3G3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 02:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiH3G3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 02:29:07 -0400
Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE125B14D4
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 23:29:02 -0700 (PDT)
Received: from alt-proxy28.mail.unifiedlayer.com (unknown [74.220.216.123])
        by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id AA2088034F31
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:29:00 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id EA8AA1003F219
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:28:39 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id SujnoKGzRoTaxSujnoIsDI; Tue, 30 Aug 2022 06:28:39 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=PNrKRdmC c=1 sm=1 tr=0 ts=630dae17
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
        bh=mGdK1E61Nz/az3oMNW1pZ155d04/5aqM3RhgGDY14KU=; b=l1pHfrgMLmTkQBHPD+rtaf9mcl
        58Fc2dlzwnOjttcH3yMo3dBYpGvUWoS9kO+sAixlmuYwI7ER2rzclgpP8xGdB1GJwBL+WtuXL839S
        vRXm7mu6u1UcV0emg4OKUWChPfBwStIFde/GRP4tafjNJc6hZdafNj9RK/PQyqI3etXsbyK0V5Vdx
        gAJR8iURju1LTc1FpZ6uuE6RwOwYkC379XP/6FQi8UvFypkBKsbgnGwKycSO7AHCisl9ZDA/j/MQ3
        8MYe6EXA5fSObSpU52+HIHFAyn1U6ULfCzA9a6Ia1wD021QikfVUaHLWJs9/2mcgIpBmfuZ6dDw2i
        fWWpESPA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:42420 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oSujm-000MSs-Av;
        Tue, 30 Aug 2022 00:28:38 -0600
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220829105804.609007228@linuxfoundation.org>
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <611f1074-3726-3b55-50c6-fa6768f191a2@w6rz.net>
Date:   Mon, 29 Aug 2022 23:28:36 -0700
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
X-Exim-ID: 1oSujm-000MSs-Av
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:42420
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/29/22 3:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.64 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

