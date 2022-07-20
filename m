Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57D57B0E3
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiGTGRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiGTGRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:17:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89233C160;
        Tue, 19 Jul 2022 23:17:21 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y141so15663198pfb.7;
        Tue, 19 Jul 2022 23:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WKiDqLNxBpiYAoeNTVy6XywnZKv63Cd6t/UmkJzR2oU=;
        b=pX7wZ2MnOgYo+T1igTNSb9oiSp+O4Y/Wm9TjecPRlpDSspSKCwGRADqEX7yK/X7jJR
         HAcxS5ZdaeuhNG0SFMxxjJSNQGVvuwLibv0gsug9hLp4rLtl9u8MfOqwtiPVY3OckU7A
         Nf8fsQXduqXk1ZGwgXOwHa4JFS8l12cFDDIvEIAiHiOKoAS0d9z7rmygwrS2Sunjz1yA
         x38/gl1PRoK0iScKuS74db04lWPAXi8dk5cLii4Kv7uRS/ifGLYLBMDPOQ/YArAJDPI7
         6lEGN79IBwKGtmzRzkhNAvWM8VzC96jRPmt7KJak/ap5B7PIxmON8C65w4kkJdWcAEYK
         dU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WKiDqLNxBpiYAoeNTVy6XywnZKv63Cd6t/UmkJzR2oU=;
        b=2Iv6W4EBa8NWjdHyUP1KI8JBRXJhxErP01/iz+fxeBEZ3E/LfctM7pEkxDqzgaK1UO
         yS9V7qhrtSxbOA7SoD+DXKDcQiimUjTnjXVBRaFQIVW/+0GN3H6ixlB+XEwupdBk/QzK
         RCr17K8odd8F3c1fPV9M9s+mLloLbyYPlhk7aZIZZWzWAOmVfW3wKKobZNQSwBTufH/f
         3E2O0s+TrkBR5KaCRnKF5AFiVqa9fE3a2zd5vBhYyKDtCzJ6yohQa9T5AxRCaRVq+6qr
         CgUno+Jf65cU7WmLZJYEgXo/UXFxmFUcvFn2Gkcwj3yfgYTcyUFHMV1loSMh1jj9oNrC
         tcbw==
X-Gm-Message-State: AJIora9+EbGcvxqTC+mV852EiODcBWyVY3ZKBYK8gg7lnthIMbOuAO6G
        EtqyslMCiRYkwv0FG/lofSI=
X-Google-Smtp-Source: AGRyM1vux97KQ7UbMDPUtbas1HX3ubvKYlPYFyjDeF30QukgbaOkCNwU2a1ePic5zyvBlMqJIGyPMA==
X-Received: by 2002:aa7:8318:0:b0:528:c331:e576 with SMTP id bk24-20020aa78318000000b00528c331e576mr37846513pfb.58.1658297841209;
        Tue, 19 Jul 2022 23:17:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r7-20020a170903020700b0016bdea07b9esm12731363plh.190.2022.07.19.23.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:17:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:17:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/28] 4.9.324-rc1 review
Message-ID: <20220720061716.GA4107175@roeck-us.net>
References: <20220719114455.701304968@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:53:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.324 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
