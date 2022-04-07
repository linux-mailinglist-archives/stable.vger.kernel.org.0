Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4604F6F46
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 02:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiDGAjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 20:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiDGAjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 20:39:31 -0400
Received: from qproxy3-pub.mail.unifiedlayer.com (qproxy3-pub.mail.unifiedlayer.com [67.222.38.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF45C749A
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 17:37:31 -0700 (PDT)
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by qproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id A364D8029A20
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:37:30 +0000 (UTC)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id F33A010049E2C
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:37:29 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id cG9Rn0YkPb2WGcG9RnKCNh; Thu, 07 Apr 2022 00:37:29 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=JN7+D+Gb c=1 sm=1 tr=0 ts=624e3249
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=z0gMJWrwH1QA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bIMdmTHLG61J0YS6dT9sK3YQTcBnNvHeOEKkHWlWK0M=; b=q54460fYLglenLQOYaEqHriTiF
        NPDhmSkIgcECsE5Gu0JICE7FKpniFajRpV4/d0gy7dmp3sMns4rjhHjZoumC7jTmCqwquHH08exOL
        9NrEqsrU44jKxzH+BHQHoWhVTRddi9qwR9gsMQ2zDNllrZEKR9IeoytOrB7VMaX8qrN/NFmcA/2Yc
        Iv6TsonBYxtqkf6eYiMHJBQURl7Oo84uphgHtd6zReXDZWc9KasWpANQnshXSnpggNxEYcJVcmEOd
        pdPyEDQh4GmWeWxd2ayIB8TIEjyXrV2wdQmwSe6hySMlGT/8LJCeHXdzimMtxsSAcV2QApQMOqFN7
        bsNN00uA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:36326 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <re@w6rz.net>)
        id 1ncG9Q-000nIg-Lv; Wed, 06 Apr 2022 18:37:28 -0600
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133122.897434068@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
Message-ID: <ced2db7f-e71f-74f1-0de1-bf1d4b3a379f@w6rz.net>
Date:   Wed, 6 Apr 2022 17:37:26 -0700
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
X-Exim-ID: 1ncG9Q-000nIg-Lv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:36326
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 6:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

