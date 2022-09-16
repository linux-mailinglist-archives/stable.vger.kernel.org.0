Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED1F5BB44A
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 00:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiIPWJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 18:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiIPWJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 18:09:21 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 15:09:20 PDT
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com [192.185.46.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CAD81B2A
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 15:09:20 -0700 (PDT)
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 185C82CEBD
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 16:48:37 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZJCOoRikb3RgQZJCOolFpK; Fri, 16 Sep 2022 16:48:37 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EHbKZA6yjT46Rojb/IT9uZWTBgxFKvwIyvYchmr8B+s=; b=2677euBBI9uG7btjPtpr2APOvd
        DWjM8EM83PwH7UFvLZAAhyjzr2p6WzBYb/app+GJd2LIsSc6slYXTforLVsOlM4iotzrEDhLgxd3U
        icUodSib4QO5yxEdgcfxD0JbfzMM8BIQn6H94oi/dXFxxPzBRz27YOmuVuueVFFIHyqs+30OgqUUl
        Nz2qfuM4RASTDg9MEpOzS8RqEYCHtCxrdFa0G7JcndoE5Ma8aBM3qf2Qi8UlCvpRe3zvh7XWoctxD
        2oqkKMQ2JU4vSp2tnIkl9s1NlEFK+Gm8jWWpv+vwwHsq1Bl37q0PJkB/0tHy41zitnKNbFm9hd+b6
        6T2m0n7A==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38854 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oZJCN-002eZr-VO;
        Fri, 16 Sep 2022 21:48:36 +0000
Date:   Fri, 16 Sep 2022 14:48:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/35] 5.15.69-rc1 review
Message-ID: <20220916214831.GF3350231@roeck-us.net>
References: <20220916100446.916515275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oZJCN-002eZr-VO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:38854
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 76
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 12:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.69 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 486 pass: 486 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
