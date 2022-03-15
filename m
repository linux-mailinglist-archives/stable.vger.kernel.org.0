Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C024D91CF
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiCOAzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241142AbiCOAzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:55:20 -0400
X-Greylist: delayed 80 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 17:54:09 PDT
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.197.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771DD15A02
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:54:06 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 5B42973DF
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 19:54:06 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TvRunbcVGRnrrTvRun9WRq; Mon, 14 Mar 2022 19:54:06 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MsaWCzvxT0i+IPauM/F+iY+F4dSAozH47/qDPfN3DL4=; b=DgkufoSxrvW/aSJsOmIdJqTcp3
        C+CUwBZDQ4cKS7YUDb3/LsTjN3tVAqmn3/OtoxNOsKntHYh8gIItSjEuQX0CZUJhF2qu2E7lF42z0
        Xi4MbvgzLwfcybpZeYRqHgRWqTAuB4a4R17ajKWXkdg8RWf8X/K4bDtSDWZbeKr/PpSj/vsJRjFsw
        s/hxX4KWMLL3YgFEHBXt+D7Y/jXMbQF/08FmYNlDtm9kZyKWjAI9ehh6X5f9nowtFrQMmSEcwHsH0
        +oDMbeIJvq4KUUkQVHfRFOxqmrrQPrz7xE2H9NtVeuTn4Cz6j2K6XL/jT97PzRw0W0bkkTmrkQsCn
        euuOdghg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57478 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTvRt-003sCR-G8; Tue, 15 Mar 2022 00:54:05 +0000
Date:   Mon, 14 Mar 2022 17:54:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/121] 5.16.15-rc1 review
Message-ID: <20220315005404.GG1943350@roeck-us.net>
References: <20220314112744.120491875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nTvRt-003sCR-G8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57478
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 89
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 12:53:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
