Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8053466A723
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 00:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjAMXeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 18:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjAMXe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 18:34:29 -0500
X-Greylist: delayed 50005 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 Jan 2023 15:34:28 PST
Received: from alt-proxy28.mail.unifiedlayer.com (alt-proxy28.mail.unifiedlayer.com [74.220.216.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96AC8A211
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 15:34:28 -0800 (PST)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
        by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 748091003F450
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 23:34:28 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id GTZ6pYeOrFxgHGTZ6phb1U; Fri, 13 Jan 2023 23:34:28 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=ePfWMFl1 c=1 sm=1 tr=0 ts=63c1ea84
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=8j9jZ_j0GnAf7xrnhSYA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:
        Date:Message-ID:References:Cc:To:From:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MHojs0DFvTXiisLyglEjgNm/wZzZNyybHYAwQfBA/oM=; b=fLyeFWSsWz5EooXcUQqTtTkVRu
        zYUADgnogOJy2Xj7B+CuSIVL/BxDC1Lmn1Bn2XhJlBugpE5nmQ3ES0jJiDrP0vnN3uSp4+OTBrg/j
        G64GsSQ7FzBGT5GQDhAUCrTA/f2XjCYGNOab5Ngf9NtvmYwOYaA9/1uQItnlNd3wxTaHRnc0MwkMy
        x956rmarE3ENCH6Ekg1JPBPlJ3m8g7h9h8QEIfmFwzQDZ2n5VUlVd/IUN6mJH0fOHXUNLUootf9HM
        svdTRpXhOtDyaRacd4UiDsTNEMAJj+ZOKCU1dFrqvSG2r5ZsiZ/uK5Yf2mF7fOlHKdGdsqSkw7r7m
        Z5lpSV6w==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:51382 helo=[10.0.1.47])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1pGTZ5-003XXH-1I;
        Fri, 13 Jan 2023 16:34:27 -0700
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
From:   Ron Economos <re@w6rz.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230112135524.143670746@linuxfoundation.org>
 <1e9676f3-e436-3f69-ddff-abfc6ba5804d@w6rz.net>
Message-ID: <7fe35e67-66c4-edc4-8e08-10acabf7df95@w6rz.net>
Date:   Fri, 13 Jan 2023 15:34:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1e9676f3-e436-3f69-ddff-abfc6ba5804d@w6rz.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1pGTZ5-003XXH-1I
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:51382
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/13/23 3:26 PM, Ron Economos wrote:
> On 1/12/23 5:45 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.163 release.
>> There are 783 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
>
> Tested-by: Ron Economos <re@w6rz.net>
>
Oops, replied to the wrong e-mail. Please ignore.

