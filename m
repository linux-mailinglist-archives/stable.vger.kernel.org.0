Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD52A6E000B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 22:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDLUmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 16:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDLUmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 16:42:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C16355A6;
        Wed, 12 Apr 2023 13:41:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w11so13439953pjh.5;
        Wed, 12 Apr 2023 13:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681332118; x=1683924118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hl9sCiGfDSiyFdzk6F9ozEO0BgQb3bdfVK/ZFLs3Rec=;
        b=KW53y1eMdYXi1Ugvb5GSc4XHAUbz4MBJzeFgMXx9gYfbmlHeBzDTx7/DmAIUysi+jZ
         cn6P7kvdSHGdN/24w93MMe2Ces9uKlRNPdx3gXg0t0ZeakMXy3x0AsGc25+0Lb1BX4mu
         8+Q0y3smH/qF1gzT8Zw4gIvlVJnIFfFq6paFOSSzwReofXsx2D0XN+LwW9oPN5lSbVop
         ydrs4p0hDjYANLNT5JxPCM/vEqxl267PRoDrK6wxnfOVfz8Cls5IltWDi7T2QZxBNh3T
         2lfqzsML0i7zl+5IRbW7+qLeCcGANYmA2FjRoBTbrqJWU0VPrvW8hXHC6YmJpJUOqmp8
         ueLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332118; x=1683924118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hl9sCiGfDSiyFdzk6F9ozEO0BgQb3bdfVK/ZFLs3Rec=;
        b=RYL8luW/LiJp+sysV8dAISl8gbFZiUEemveudIcCqGrygqPwIiWkV1oANigRuxqYxb
         j+KJdHcX02guCBJ+D1FlaFhavzhVFtPjEQvxo0Kft5Dl/4iMDE1HTNGJfpnXAQJn1nX+
         r0o2l1K0MzrxPHufVZJkiR0Fm+HOo4WzhZ26M1iDjutrWfim7o2fZ2oyba4yaJuYHQhZ
         9ofjDODfNTUBXN4g9f8iLlIn95vCOyp+DcWhwP3C9tr1ugy9SHdIOpd+5CtVg4owfwWX
         u1l/gyZORR2pXZG1C7Q7HeE41JaZwT1ImMfngDJ6Fzqc7AwfPlAwUmF9AcaDhMgln/r3
         Iuyg==
X-Gm-Message-State: AAQBX9egtzyTfrR0tBaWafVFuQVDHp4bQ2l6bgO033tZF04ORSpSxBFS
        gTG/X/2gYPy2GYpb383jKlo=
X-Google-Smtp-Source: AKy350bVi5vXq6CC2Egmi3HVYVAB891DpVnGz5volM1VUtSzz82SvlVYzTk/uX4Ln5NaFx9WETF7sA==
X-Received: by 2002:a17:90b:3b8c:b0:233:e1e6:33d4 with SMTP id pc12-20020a17090b3b8c00b00233e1e633d4mr25449629pjb.47.1681332118255;
        Wed, 12 Apr 2023 13:41:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bh2-20020a17090b048200b0023acdac248dsm1507561pjb.15.2023.04.12.13.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:41:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 12 Apr 2023 13:41:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
Message-ID: <b94560ed-90d7-4d64-b15e-03478e1e75c8@roeck-us.net>
References: <20230412082823.045155996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 10:33:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
