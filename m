Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA7257B380
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 11:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiGTJJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 05:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiGTJJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 05:09:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE3B4C60C;
        Wed, 20 Jul 2022 02:09:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso1557256pjq.1;
        Wed, 20 Jul 2022 02:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qN4tE7QTzfrPXoxH5P2c1WhvXRBfHKET+E8uhAqveWY=;
        b=SENmYs2q0MTMRtBAB4+FKUW3DeUGBQjEl9MMYOAP6ahQgsDxDixpqgdVfH/KEgztfI
         PdwPGzFTujACvnNnhOXO7l2O5nt80grM+3jUQsUzaCqa1AyrykyuhKLjNdE8I0d1KPuV
         y0KCUB1W8KwvC+Z4wAK+LHXckmZnHZMO6LbwLIKTeiq8IMWDlS+r2vfFXkdxVd10LaVp
         wdq9MH+G4Ff5VdEPvOd6GHtKmH8XOBPXswNcqeuW/ac/qvRMj/E6PnheZhv1wopqxobI
         vKkT/eJ6MtoEeuyv5e7OImbmb774HxoddLfGDAbLh7Qpg3qcd8WYfnF2+18OWoXepffr
         XhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qN4tE7QTzfrPXoxH5P2c1WhvXRBfHKET+E8uhAqveWY=;
        b=cmNQsuMQD2w4HNDEdeQs7T9Cdy0haHpCICKyZTJMzeAsGyf1CfPvRG+mGFXzh5Nu79
         Tl58TW6aNNJ7vS5BpyL08Qlk1J2Ptt80+4mlJnNE+8VCYszwExoeHXC0nMMgsfRb/N1F
         tDegpv9vvtlgio+uOhxXuzjylZHHbDutyI8OpN0JlYa7xKSQGKP/2cZIcM+twZeiYZ45
         hn7vRukdP9f+T7ofUJV2ImnbY4FTVdAAbVj7ASAZRdIvN8iQTL+Cxp3vhwbY9Fornx/4
         4YHVAHhVG8/qh8pYkDz/DhDJAO1BDhELqoR/B9X7IhdsSdEmdSmHi/QwFlqfPChooCA5
         PpXQ==
X-Gm-Message-State: AJIora/wPIeUihWqtZQjlxe14lpgr0aSwOpaBJYdNzaO3+OM9krKM8WX
        0pLPLoGfaaJBt8x5FK/xup4=
X-Google-Smtp-Source: AGRyM1slhJoQagciG1MhdK0FKcQPdwkhZYYiwoZF0ulRnQ1ztbel48Ifa+lO2VBOlIFQSoKDjGks/A==
X-Received: by 2002:a17:90b:4c10:b0:1ef:eb4a:fbb with SMTP id na16-20020a17090b4c1000b001efeb4a0fbbmr4144438pjb.121.1658308182683;
        Wed, 20 Jul 2022 02:09:42 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id y5-20020aa793c5000000b0052ab7144de8sm13483171pff.10.2022.07.20.02.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:09:42 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 141F0103AE9; Wed, 20 Jul 2022 16:09:38 +0700 (WIB)
Date:   Wed, 20 Jul 2022 16:09:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
Message-ID: <YtfGUj5D34KHdv2f@debian.me>
References: <20220719114656.750574879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:52:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
