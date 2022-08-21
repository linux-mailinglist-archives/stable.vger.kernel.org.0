Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D99D59B3A8
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 14:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiHUMD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 08:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHUMD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 08:03:57 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C32917069;
        Sun, 21 Aug 2022 05:03:54 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v4so7141956pgi.10;
        Sun, 21 Aug 2022 05:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=tT9fTOF/JPnDPf7gs+4eVJI4k6ubzr58RBsHYFh88W8=;
        b=l9zZd6t5v+I/1ZCw6Gayr1fvoXkFir/CsVD/OrOV8QiRN6vMymQYTqWRQpJ2gaPhCk
         Pfo+myYrPchTX/LtyRtzd2WPoPFZHLYmydMJHiF4hBFVE+ILTCbK9cBxdFMoFAFfOWb2
         NvEo/7It9uAB4Ox/LCLzZsTf++X/uI6o5IcNxzYBPs93D6YTyucwTyW9BtQnP6QcW8+X
         mbZHtkN3hL5RNJU0isOVQjTodTnJ34wkX3rkHCWe9Hs4OxhbvXr+RZthNbuPrkSK9ep/
         KogtyHnva1ApBzS/gqaQQAkkQqQbO00n8t2KdZhC8iGPbjK/5pqwSgTDiv17+/4Ko49l
         h5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=tT9fTOF/JPnDPf7gs+4eVJI4k6ubzr58RBsHYFh88W8=;
        b=SXGWoKcwwAY9rKhNcU0cLkxU76zZg6vaEHX3GXzTVhf6Godf8vj5K3kBdVsQY+10U3
         nfYYquiw50YhNK1fHtxcGIuIwGm1VzDGIv99wMFbDahqqcGAKqGocGhmplkN4PHC00jd
         jZ7bZUOxyob7dScur4lqTgmltSFjY8zjHlzV4YROxyU8zSzcCuw28h5PBvFnwepAR6vc
         joKgR0VX28uLObEUu9AirVcRVX0FfmE2exyHfnYmCs7ZcjqkLsYMypNCU3bsd6EEb7UM
         yb/h86hUD3NetLz8SssMFZEmuAA8WGrMjy8ys9ayt+yDoyiBiK/I3kdVbCkN3s4dwwaD
         Gsvw==
X-Gm-Message-State: ACgBeo1ZfC9XAJ+oE9Gjh7FWEm3pLZ338UlGZ1p9WiB7fp1S2OJaenmh
        YCNIghVQIeZBNkiWUjZGxo4JBzTK4kA=
X-Google-Smtp-Source: AA6agR5KNnE4NfVoTTRH0ElaCHSvpH5Pnw78EQw/fjgM056leySEwf40VXvllSr46d8+SvAGA9EjAw==
X-Received: by 2002:a63:5325:0:b0:41b:59f1:79d2 with SMTP id h37-20020a635325000000b0041b59f179d2mr13521789pgb.52.1661083433490;
        Sun, 21 Aug 2022 05:03:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cp7-20020a170902e78700b0016dc1df9bf7sm6412838plb.27.2022.08.21.05.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 05:03:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 21 Aug 2022 05:03:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/541] 5.10.137-rc2 review
Message-ID: <20220821120348.GA2332676@roeck-us.net>
References: <20220820182952.751374248@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820182952.751374248@linuxfoundation.org>
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

On Sat, Aug 20, 2022 at 08:39:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 541 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 22 Aug 2022 18:28:24 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 163 pass: 162 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 474 pass: 474 fail: 0

The build error is:

Building um:defconfig ... failed
--------------
Error log:
In file included from arch/um/include/shared/irq_user.h:10,
                 from arch/um/include/shared/os.h:12,
                 from arch/um/kernel/umid.c:9:
include/linux/stddef.h:11:9: error: expected identifier before numeric constant
   11 |         false   = 0,
      |         ^~~~~
include/linux/types.h:30:33: error: two or more data types in declaration specifiers
   30 | typedef _Bool                   bool;
      |                                 ^~~~
In file included from arch/um/include/shared/os.h:17,
                 from arch/um/kernel/umid.c:9:
include/linux/types.h:30:1: warning: useless type name in empty declaration
   30 | typedef _Bool                   bool;
      | ^~~~~~~

Bisect points to commit 6660dd43bbf ("um: seed rng using host OS rng"),
and reverting it fixes the problem.

Guenter
