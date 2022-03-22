Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4E4E3664
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiCVCC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiCVCC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:02:59 -0400
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.145.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CCA1E3C1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:01:19 -0700 (PDT)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id AE7682B726
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 21:01:18 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WTpmn4SG19AGSWTpmn1tjc; Mon, 21 Mar 2022 21:01:18 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hWnTey+FyR6LRXe2f6A+JT0pvBHxARNd7bnunBkTFKg=; b=B9EMsC13eWVCJpEolcuFFV+J/z
        EpwwtVGZ9BDQW4zU/93JnqBPtuKIufu2mPhxizzzoAqBzAlCx4ErsAdoXkqPIWzNayOYzAF1T549J
        E0CTTeYZ6ht6MAFJEcuW/ktFKcAtS+FZNIZztFJ5romiinPqg4f6YzbtcErhWL54MUWAkyZUoVaXU
        /7M2iWYCUh6nZg9N3+P2PRyAHWK3FjcAQi193Jo15uAEhLZJ5+brzBGgOt6IMqy1TjI17iZa1DILX
        QSmj6q1IIAgPqqEk5PwYikb0Kfgpb02MTRL5moHFxA2xT+Tt0GM5gChCnusMONIr58BiJZMa6G136
        vcmk8mYA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57594 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWTpl-0027BO-Rp; Tue, 22 Mar 2022 02:01:17 +0000
Date:   Mon, 21 Mar 2022 19:01:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
Message-ID: <20220322020116.GG4126967@roeck-us.net>
References: <20220321133221.290173884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWTpl-0027BO-Rp
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57594
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 37
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 02:52:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
