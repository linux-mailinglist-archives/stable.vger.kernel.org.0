Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6458D5678FC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 22:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiGEU6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiGEU5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 16:57:53 -0400
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36BB1A80A
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 13:57:51 -0700 (PDT)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 603CC10047AEF
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 20:57:51 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 8pcEoVwKxNVEz8pcFo6Di9; Tue, 05 Jul 2022 20:57:51 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=I5+g+Psg c=1 sm=1 tr=0 ts=62c4a5cf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RgO8CyIxsXoA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=vhpX749HnvCW0mh33ykA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/nxWS6cBZLbcqxA+5kMlrVWt16ff2+E/pEwSLhb3+GY=; b=sHVqsex7lsCzHnU/Pp8p9h49dJ
        o16exNNkqOFkvkb2lytUT0cv/y8xYKbrs6gdtTFsQfjzEgzGyJ5K8JsLPZlY69qjrvGidVdGVwRBT
        NGu8PABhfwyAKzaMcMsYRUfq3sWL6/sUR9iLFR+6jRnkafuLTVsuM0BoB6zGFPhs3Rj7n0wrmp0MQ
        D/AHs+xCDNfYHkME2oC1S+zohzmQv28uJN+2cYvD02liTw1zHeN1NpArcTgVHrMZuRdfDkSd2nPKi
        8H9vmCkS40F2EYKP8pzt2lxNMvxaqgSb6+tX9BPDe9jyl7bwPaxKleOfgrXON1AtzbcAo02zwR/KH
        kiuP1Jwg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:34686 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o8pcD-004OBE-Mn;
        Tue, 05 Jul 2022 14:57:49 -0600
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220705115618.410217782@linuxfoundation.org>
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <0313a6a1-aaf4-fed3-6e00-8dd4869eb85e@w6rz.net>
Date:   Tue, 5 Jul 2022 13:57:44 -0700
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
X-Exim-ID: 1o8pcD-004OBE-Mn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:34686
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

On 7/5/22 4:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

