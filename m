Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AA26B1240
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 20:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCHToG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 14:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCHTnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 14:43:55 -0500
X-Greylist: delayed 49433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Mar 2023 11:43:53 PST
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A737F008
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 11:43:43 -0800 (PST)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id 829D410048548
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 19:43:43 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id ZzhPp1QYtbQKPZzhPpvrzk; Wed, 08 Mar 2023 19:43:43 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=Jd15EWGV c=1 sm=1 tr=0 ts=6408e56f
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
        bh=NHNj9DJihJrZ9zNhZlllW5Gc176JqAfXQ0Zj8mPxPHk=; b=WVrvtQGMYomO8P2mGOGWXT/YU4
        n3qdNgra+mO9Omv7U27Hwa81lxc3m18siwsjsM2lHunLHcWhKQr+g35KvMJerNC8U5UWescq7JR0f
        oNIXUfu9Lf4C3QNhhohDq++wsZzMhs4dX6ZworX5VvyngBarW7bnq3t7QcMqUYkWj5SodAVA+2+sB
        ySURG3XY9YjpQcgACLzD170u7ppxAvJVXMjVYCFXzSak8eCMSw1FYg7sPd0ZIxmI9GlYEhGHQwrpv
        HrwHnWFc+TWYzTSp3T2M4v4SN2RW3fayHMXlR6jwZgfbsHWemZL+cLTjvmeuaznDaQHCkkBvEPnLH
        d/nnQ+1Q==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:59604 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pZzhO-001E4m-FG;
        Wed, 08 Mar 2023 12:43:42 -0700
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091912.362228731@linuxfoundation.org>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <8e9c4d95-25c9-d3a6-17a4-ceda8ec7e9ff@w6rz.net>
Date:   Wed, 8 Mar 2023 11:43:37 -0800
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
X-Exim-ID: 1pZzhO-001E4m-FG
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:59604
X-Source-Auth: re@w6rz.net
X-Email-Count: 2
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/23 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

