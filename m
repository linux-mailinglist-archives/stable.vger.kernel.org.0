Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284DA4D022B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiCGO7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 09:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCGO7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 09:59:51 -0500
X-Greylist: delayed 1350 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Mar 2022 06:58:56 PST
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF30333A2D
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 06:58:56 -0800 (PST)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 2B9751973FC
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 08:36:25 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id RETInW3kvb6UBRETJn9sgB; Mon, 07 Mar 2022 08:36:25 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0YOcud4UjX4A8vuagXWQbi+Ry040RmgGU/96BuLodnE=; b=wEHFIGtbFv4cR4lDRsaaCBWccL
        4x5Uj447m1ND5lrJ4hWhvrj6/D//Ph8QO1IBn/1t/bZw36c0NOBReP5SFDpBpgIfX6ifYwul712Bx
        Kz7GhsvmxnzoBH9qBWi9vBpv1RVjJpiSwv2nIagH8HT+YaNkm+k2DqV/F0Q8wk6wXLKlbL32/SW/M
        4AafZKKjGeKEhIky7wh6PvnCzkPZNu2TWcwyaZTg8QofsOW1c1a8Aog0EpBY827Zng9CIGBjVlm66
        389MLK32/X2g0eZHKlsGm8yVjyv8VnqQ4oqkq/0WZB25OuS0EaOLQDCH5VJHED/ZFVIa4qDfg+tA4
        Vlu3X9aQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38092)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRETI-002Cmu-Dd; Mon, 07 Mar 2022 14:36:24 +0000
Message-ID: <24c54a05-bb80-a128-d0ba-a78c6d5d101c@roeck-us.net>
Date:   Mon, 7 Mar 2022 06:36:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091702.378509770@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nRETI-002Cmu-Dd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:38092
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 26
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/7/22 01:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 

In addition to other reported build errors:

Building mips:allmodconfig ... failed
--------------
Error log:
drivers/net/hamradio/mkiss.c:35: error: "END" redefined

Guenter
