Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E8359B3AB
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 14:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiHUMJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 08:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHUMJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 08:09:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55DB1EEDB;
        Sun, 21 Aug 2022 05:09:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so11450327pjj.4;
        Sun, 21 Aug 2022 05:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=jSWPHPF0WUdeKO3v95owYqCqD0J91vuibFdMuHLrsek=;
        b=EYAPmf7bOEyu89iB0FgnBiKG5BFcStMrfDXSq/CQmRFCxE2tsDSKDeKCreMRxCimui
         7dyEbF195Dv846GFIPX7b0qe4HD64LJ71QzuGCF7wdSSeex90khuVQKt6RozX0COue3A
         akaW9jkN2MfNQm5ImMK7ESoW/KNXOZL0oc8QVqJlVbsvZ1WRYYOmHmGGlEwLJviQfYwN
         Qm1PpcRqFvqZXOlXniuJkf/9CnEdv94Jm4Pnj/HSHfkrOaiAypmwJKVZvRYlCq2CHZAy
         lAijEYCq8Iheh4Ka5cHtTN1L75UssDxepwXOn3soMKizoB/CzLfGqVYBQ6KaG2M9H2ij
         jA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=jSWPHPF0WUdeKO3v95owYqCqD0J91vuibFdMuHLrsek=;
        b=4eGJaPa4J1e1aaoMQsWlSx9V8I0goK09lAZrsbf2QT10AI2z0+ex2o/ip4PSGBssX1
         1CQ91eolbLh1sd5uNX7c9gER6CkJG7Of3Q/4y00OoBvDeugaE/M9DV8we0TGSK+aWO7+
         4SSsfuVCIYPyA1T6TFdirAoK0sRlHtT2mFKfnzJDcmeza1jRse7xzPmiBD5fLqZ+INyR
         gb87OHJlwxGl9McRBg21DFwBeRehMbDyELAsKln6Dl9pQhdsgLLJ5AIASwfpKP3TshiJ
         nkQzdWyYyyrPVBatKt+6RnTAO3JKCN/+tI1HsGS9kE1R8hFT9KpzxPcDfcEfPDJOu2EA
         cYig==
X-Gm-Message-State: ACgBeo1/R5ynQaL5VVsaUytgzopVnQWCt/QmxCTU5aTl6uHdmHU8JQku
        aB+io9Nfy99o1iUu3EEM+zE=
X-Google-Smtp-Source: AA6agR5UGB4GaXL5bJB8KoPmRQYVO9SRORthSgOKQrSpfVzlhCALipiPsoUdy1q2p2fd/emJkcouhQ==
X-Received: by 2002:a17:902:c945:b0:16d:d425:324a with SMTP id i5-20020a170902c94500b0016dd425324amr15317916pla.7.1661083745330;
        Sun, 21 Aug 2022 05:09:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12-20020a633f0c000000b0041c49af8156sm5591265pga.6.2022.08.21.05.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 05:09:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 21 Aug 2022 05:09:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/10] 5.15.62-rc2 review
Message-ID: <20220821120903.GB2332676@roeck-us.net>
References: <20220820182309.607584465@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820182309.607584465@linuxfoundation.org>
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

On Sat, Aug 20, 2022 at 08:23:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 22 Aug 2022 18:23:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 485 pass: 484 fail: 1
Failed tests:
	openrisc:or1ksim_defconfig

The openrisc failure is a soft lockup during restart. I only recently
enabled the soft lockup detector, so this is probably either a false
positive or not a new problem. I'll try to track it down, but it is
not a concern for now.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
