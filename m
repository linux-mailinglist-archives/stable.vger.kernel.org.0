Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F12C562A44
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 06:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiGAERx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 00:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiGAERw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 00:17:52 -0400
Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24852220C6
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 21:17:52 -0700 (PDT)
Received: from gproxy3-pub.mail.unifiedlayer.com (gproxy3-pub.mail.unifiedlayer.com [69.89.30.42])
        by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 9A315802A73B
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 04:17:51 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id D92E910047F2F
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 04:17:50 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id 786IoAkrBrOQ9786IoEknf; Fri, 01 Jul 2022 04:17:50 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=CpF6zl0D c=1 sm=1 tr=0 ts=62be756e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=JPEYwPQDsx4A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=RyL8EgcdUj_kepXCPdEA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QrcP9l5zwhD4ru5YcYFwlVtiG8CAmCSfVKdQAdbGpwU=; b=pxrGVf5SGAMt0I0drlYJCx5fuH
        WfMOHsQSYFI0vNwYaSk6Oiy49xXc0zMjw7M0q21G4VLwSF4ZYANSKMvBpu54/JI1GstV+192cy11S
        rqPazJBj+swa0JVa/hTa5kYyXDG/+J/9RyhuZEPF88GdteOqaJNymg2vVBEH2Cv1zRyqHt0TDLL9w
        IYc1PWSSLJNaOaSnCTVES7EA1BC5d7/IbRiiiAjdPhQrr47Cdc7PXSY/Gs4M1GBacVUaT9l5Kq0XJ
        r9xBlXM7bydi7Zqe2ca/eaM8BMEWqcAiRkIZu8/GyoAkSJIsa11gyyVgnBwujGT+cl/2zCuT3Fdmi
        t4bb34Aw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:34088 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1o786H-002MOb-Ed;
        Thu, 30 Jun 2022 22:17:49 -0600
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220630133230.239507521@linuxfoundation.org>
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <37518138-2b5b-2c83-c146-e805568c1498@w6rz.net>
Date:   Thu, 30 Jun 2022 21:17:47 -0700
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
X-Exim-ID: 1o786H-002MOb-Ed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:34088
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/30/22 6:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

