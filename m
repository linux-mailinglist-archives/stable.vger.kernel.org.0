Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385F159F621
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 11:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiHXJY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 05:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiHXJY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 05:24:57 -0400
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D727CC7
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 02:24:55 -0700 (PDT)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 766A410046CC6
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 09:24:43 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id Qmcsop2E9mB5LQmctobp22; Wed, 24 Aug 2022 09:24:43 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=MaSpB7zf c=1 sm=1 tr=0 ts=6305ee5b
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
        bh=NEB7zk9S/UrcHKcsoG4dsO4AhOSULEbS7qIvDAgAkF0=; b=SDe9t48lw6TFxQzVzQNtqUrMCb
        Xh6usf8x2o9wiVssUpsutAYy2LM1aezYMIJ3AgrOlQTYy9K3aHf5DQm9//1hOP3yRcdVWXBvnDETa
        8R70l+zyuJaa7/YWq2gabe5lEmG1FOOGiVF1/dCZta+Erpf8ZYUYNOS2RLuE3FqW8uHCoeipesiEu
        9R7BI7Aqx2/PQXBphLe5Qv2RuuXtXZAMyc70o9egLp+n+eYs5TU/iSPsvzNnuTbOS+mvI7LoPvMhA
        v6OKfNNsr2koXH03hM8NRVBUorqrjccBcvh6cqeei3VnYYDqqDlNdPyq3rDRMadGT/3gE3V9gLHMa
        7GfKlaVQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:41550 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oQmcr-000i6v-Ja;
        Wed, 24 Aug 2022 03:24:41 -0600
Subject: Re: [PATCH 5.19 000/362] 5.19.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220824065936.861377531@linuxfoundation.org>
In-Reply-To: <20220824065936.861377531@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <6994e85a-3081-693c-d865-4021562937df@w6rz.net>
Date:   Wed, 24 Aug 2022 02:24:39 -0700
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
X-Exim-ID: 1oQmcr-000i6v-Ja
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:41550
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/22 12:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 362 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Aug 2022 06:58:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

