Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E935B91CD
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 02:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiIOAhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 20:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiIOAhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 20:37:33 -0400
Received: from gateway34.websitewelcome.com (gateway34.websitewelcome.com [192.185.148.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC43B39F
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 17:37:32 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 804A347205
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 19:13:32 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YcVYo5xXPgeGqYcVYo5bgV; Wed, 14 Sep 2022 19:13:32 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I36WnZ63D/mULay/sD5tEqwT2kxeAhKIhlJbB7iRBjs=; b=1aiq33rXIKxS9LBqxz2DPkOmbo
        xS7F0ek5DBB8RY0ulFNJ9WIGXDfT2xzIQuXsmhgzwv/EvgXl5njQ2h0zZRglDPrfG5ME71hB/4MPW
        xpmNm0o9nRSbNyJLoxCpR7QBp8+ooZRTDNY+tGV6coJfKBSs7Fsx27xeyZO93vg9gijCIChyC3u3L
        eQk9Id+2NHL5XIaaz3sqLZUyyJIdnW8SoOQWjuH75gQw75b0vgQ4tsruSybo+DlQjQOJrW2K1katH
        aH6HIbTyiWAsoNAfRaCpF+T9EoiOXtP8ly/xVGM0JW3gPoTpALw5hvRb/BU1IjuHTwTTs4FATM59C
        KOxArnoA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:39608 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oYcVX-003KS6-C1;
        Thu, 15 Sep 2022 00:13:31 +0000
Date:   Wed, 14 Sep 2022 17:13:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/79] 5.10.143-rc1 review
Message-ID: <20220915001327.GC603793@roeck-us.net>
References: <20220913140350.291927556@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oYcVX-003KS6-C1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:39608
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

On Tue, Sep 13, 2022 at 04:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.143 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

As with 5.15.y and 5.19.y, new runtime warning:

BUG: sleeping function called from invalid context at drivers/clk/imx/clk-pllv3.c:68

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
