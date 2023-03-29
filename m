Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CD86CD3D0
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 09:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjC2H4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 03:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjC2H4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 03:56:43 -0400
Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6761D211B
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 00:56:40 -0700 (PDT)
Received: from gproxy1-pub.mail.unifiedlayer.com (unknown [69.89.25.95])
        by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 7EBBB80308D7
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 07:56:38 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 3136410048EAB
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 07:56:37 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id hQfdpDAibaaYZhQfdpnGnX; Wed, 29 Mar 2023 07:56:37 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=b813XvKx c=1 sm=1 tr=0 ts=6423ef35
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=k__wU0fu6RkA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=d+eF+E8ANnCURjnXP9gSySb7ilKifBaKExn2Bht4pd8=; b=jePc/srXmC13ZHfYuXwqfejDDS
        npwz9U9tgf3tzbv9BKuEFYLwgZsPq7I+GvDOkH3hqy6Ihq1YVsDFTVKCUYsM8TVsnDydXelU6vet9
        kX+7SM/supZZVKwwrygoIsBrrp8pb18qqngHNrFzvDWYcOBF87vIcitbp0slB+IBknLI2xiKaH6W0
        Tdk0MWkEO0qRHq4YicYrxGllZyfA1JZslog4IdOf7S0F1XmVUBNERliFUDF9DaoDcX8+t88TGzMBS
        IDQZMUHmaL1icSoImho+3Bmv0JkoFH8vJsJXz3npIiTPrKmM5rWhDMLCkQKWdRKwo82U42SNB5umx
        ytibA0rQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:33594 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1phQfb-0006TM-Lo;
        Wed, 29 Mar 2023 01:56:35 -0600
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230328142619.643313678@linuxfoundation.org>
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <4e0400e1-08cc-ef8e-5386-6ce5900945f4@w6rz.net>
Date:   Wed, 29 Mar 2023 00:56:32 -0700
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
X-Exim-ID: 1phQfb-0006TM-Lo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:33594
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/23 7:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

