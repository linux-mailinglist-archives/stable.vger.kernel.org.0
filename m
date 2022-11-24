Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6A763708D
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKXCjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKXCje (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:39:34 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A94B65873;
        Wed, 23 Nov 2022 18:39:34 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s206so339782oie.3;
        Wed, 23 Nov 2022 18:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INRI4j7u0ywb8VN6ROU8d4+uuUvfHheBW0Fak5UKexc=;
        b=Ifoa+gBezHayJ8L1oRtUoB3+5WzF0EvHQk5wN+6ezTKexHiJjELDyGAxvkP1YiaTyY
         2uyzbMuzBurx/5i0cStZsgKHs6rkRjI9deZfC8Dxi882MYHO3mpVMs0BqNwELNQUYDx6
         JcaycZsTst0S0J8AOIgeAdBcPciigpl9OHpd1E4rVYbslgbD3oEzfgGFBtATWIWMu9eW
         lbCtZ3Z1wwlIrgXJkpzKU40mPsAa0lUoe4l/VVi8D3kNceW0AggZHdx52N8THv8gAnwl
         DpLfSAmH3sRFnCOezu8J6LtPOEX6+WyUM/D4UxJJk6KQqr8lWsUTexz9LsNfYnvGYjNK
         oP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=INRI4j7u0ywb8VN6ROU8d4+uuUvfHheBW0Fak5UKexc=;
        b=QdgtBuOnHBuI8ipgbYEZxwRfAF/kQMsxgxEPKi2XzJjPduBZFqfan2eavQpiH1/jeR
         maSqQT3fQ3lLq4wVNw2me4I+IRc/aj0+8edZGuCUiYMWrpK/zdtUgHMheorcQ37P5W9a
         ohWg3NvsXl+5xSHs6QuCvANnbTnLRnkEJiv3PU+4rBpIK7qJP19bT8jpqr5s1FC8m4tL
         7dx6XYfF5s5ENyDj1Z1lJ4JabXbU8Vk2Yy4rvsjA67h4sGtUgA8UE0VeI6fm0AocWqJl
         i6NF4fG9ukxqpLHmrBGzWb6c08HKbcATRS854xGbPuJRkhCFvnS+LYR52sDcPbIvDSWY
         /1Tg==
X-Gm-Message-State: ANoB5pknJwd8oigR3RpwUDg1mhQrmfGC0JcRS3NFG1kUYHS4dbuuTBUR
        Np8Dl0BVrjww93tMC6uP1Qg=
X-Google-Smtp-Source: AA0mqf5rxKdUPlF/w5S0LSfmz4QOv3bm1rR4PokvvsrEZx8F00GhpZatCGnnb26bI519OMyP0iqkCQ==
X-Received: by 2002:aca:3dd4:0:b0:354:7326:8b07 with SMTP id k203-20020aca3dd4000000b0035473268b07mr5824182oia.43.1669257573489;
        Wed, 23 Nov 2022 18:39:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5-20020a4a8505000000b0049ee88e86f9sm11789ooh.10.2022.11.23.18.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:39:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 18:39:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <20221124023932.GG2576375@roeck-us.net>
References: <20221123084625.457073469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
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

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 147 fail: 5
Failed builds:
	arm:allmodconfig
	mips:allmodconfig
	powerpc:allmodconfig
	powerpc:ppc32_allmodconfig
	sparc64:allmodconfig
Qemu test results:
	total: 500 pass: 500 fail: 0

Error log:
drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1347 | static void rtc_wake_setup(struct device *dev)

Guenter
