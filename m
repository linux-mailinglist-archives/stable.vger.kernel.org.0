Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60FF59EDE7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiHWVBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiHWVBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:01:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CE17DF77;
        Tue, 23 Aug 2022 14:01:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f4so11454840pgc.12;
        Tue, 23 Aug 2022 14:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=ntOZuNJFNelgT/pkIxDQ8M2IKR1yIkb4TRuBWRbP3hQ=;
        b=IRhzWO1pc+SnCmzeT8APuBZpSO1H711ZFWShgoG114cPTF7w99SFwZT/UST0C5Gmwk
         esxw3gzjn8tem0G6TrDSk3IUHkBaRK3zmHoe48GU9TEdjnMcPnB07doS0stoY5Rp996P
         UxRuje+PFkfq0TIGDMPi2IzIDtkO12z4MlWW/y9JTHTN0W/qzH4HeYih90SGTQv9LnD3
         ZpANem9L1nMSztsE4r3zbUIGFuCOTzC9BGDQ8em54CaukZocy67dmk+WYcr1CJL/tzw9
         xxE89fNQczyaOMlLHDbpi1H/sZPLKhx19EsL9+6wVDMWxSmfQvLLpG3WOWpauA6C2TYZ
         GLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=ntOZuNJFNelgT/pkIxDQ8M2IKR1yIkb4TRuBWRbP3hQ=;
        b=KxBm1rQ1ujr7jbmpozv0w0mKlftDeLl02SQqxfnXwZMHLrEOBO9v+/eLyY4I2KDl4G
         vAw6sjQGXXzPGD+WAY6HwMsTAbnDr5HkY2zNwI9ws/7tuF77fKXvXBiZmV34pKxEDWRZ
         yTrFZUaCM5F/uo7h5Hj6hPKX7cNuMbTRyWB6d8bw6C5i1yO0az/uvbuOeiFH6W1uHZZs
         KOTyDX/fpFPOKEQG5A3LccX89yKoDTH5OEw3LDAwFcm3qXnf07Ii3JI4JJZKqzzSUU+Z
         k2GEQcur/JzmXMcE3KwMOSXgvxdiLcMW4hfMpVL4puuwoyrx/5ndvSMls1c1xnG4IQEH
         9HMA==
X-Gm-Message-State: ACgBeo2wdDWG94LUQvwbqTiJkJlQPWGImgPB32wvO9Z2Id5d+vcert1z
        bYwC2p+6p7m8JcQAEdDZqMA=
X-Google-Smtp-Source: AA6agR7TmlIpqJqz1tUUZ1eHB3FN0ipdEHpGdI4XMicTl5POBQ31CGMGtl/lEzYMUeMkKROMeVkh4A==
X-Received: by 2002:a65:6e46:0:b0:42a:2c7e:4232 with SMTP id be6-20020a656e46000000b0042a2c7e4232mr19892993pgb.611.1661288496326;
        Tue, 23 Aug 2022 14:01:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902f68900b0016be96e07d1sm10851201plg.121.2022.08.23.14.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:01:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:01:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/287] 4.19.256-rc1 review
Message-ID: <20220823210134.GB2371231@roeck-us.net>
References: <20220823080100.268827165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:22:49AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.256 release.
> There are 287 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
