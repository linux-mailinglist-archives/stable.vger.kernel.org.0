Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5B5B864F
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 12:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiINKZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 06:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiINKZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 06:25:31 -0400
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640A47CA89
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 03:25:29 -0700 (PDT)
Received: from cmgw12.mail.unifiedlayer.com (unknown [10.0.90.127])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 5C31810047AF2
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 10:25:18 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
        by cmsmtp with ESMTP
        id YPa1oe2ko9QuVYPa2omW2c; Wed, 14 Sep 2022 10:25:18 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=eIrWMFl1 c=1 sm=1 tr=0 ts=6321ac0e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=xOM3xZuef0cA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=m3B_eOHTikhj6PlMeNoA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lch9f7nRNSaxR8ZTH3Gya7AO/BKlFBXxTtcb2dgBa8Y=; b=wl/gbnfQPZx6PTJqHLnajfdH3L
        lpQ8ODQsX63a2HCSVGsvGAqtm7ZGDdCkNgwgiJ18Bo0EB5b3w2g4UqEEXwzIAPaHx2hnRPI7NpQHz
        8jptdIrygF5838gcJ9+27wiFW1+FxDYMGl3UOtnWWAQ/dOAvy0dxcWp++Q+r+fE1GhTiUxGhMNsCK
        RDHNxpCzelOATqm9W7dzElpeE4NfqkZHZPY3QMx0OdSBcbwpijkojWF3y/lVGtm3l/VxOyH8HACwg
        st2TFKbtZAE5vZ9vmw6w6uBUz8zvQDkoZ5qzgJ7PxLYzOcwhp/I4hR/0zjwfGryEPnmfTwZADgU2G
        pPmMGXUQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:44396 helo=[10.0.1.48])
        by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <re@w6rz.net>)
        id 1oYPa0-001o9R-DE;
        Wed, 14 Sep 2022 04:25:16 -0600
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220913140410.043243217@linuxfoundation.org>
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
From:   Ron Economos <re@w6rz.net>
Message-ID: <ce98b3c6-109e-0d87-5412-3bdd4813e4ea@w6rz.net>
Date:   Wed, 14 Sep 2022 03:25:13 -0700
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
X-Exim-ID: 1oYPa0-001o9R-DE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:44396
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/22 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

