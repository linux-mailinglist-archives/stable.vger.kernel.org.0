Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270DE5967F5
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 06:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiHQEWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 00:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiHQEWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 00:22:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E685509B;
        Tue, 16 Aug 2022 21:22:11 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d20so11085345pfq.5;
        Tue, 16 Aug 2022 21:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=O6yNOAbHBLpssrKCW0NoIyJexCKifbpgBmT7LgwEDZc=;
        b=SZr+gTlO/bbqf1dbTsH4BQ9wOOs/vGE80oGhUE2I2tmA4FAfkk7Cnieg6UwrRFanbO
         Yjup/csjGk2AQICazcgAYlZmEhgaYTL9gfLK7D3QMqyY5Ba+odGC29MNgX97IbqAT+MT
         Y0sLIWC+A7E9S+mB1Nk5jl4LHoT0kwn3zrGKCtRarGOmbGL3vzZ3gevldrR56YH+lDqp
         z5rE2/83k108DOt247YcZv7jIFUCWs9/VwFDwYmOffnKUbUiMkSYg2XUrJXXliEA9hB7
         sC/mpbL9WbIHFnJ1iWNHEGXQEhb1DneE9TBly6mOID1BGmqFpUW0UWvwIIZL/F3I9Oy0
         qAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=O6yNOAbHBLpssrKCW0NoIyJexCKifbpgBmT7LgwEDZc=;
        b=cJsEQ07DpzdVdstH5mYCuBI3zbVH+vCDmgMvthDKWmVVTSwuJRud1bBCcAchNhD77z
         R4+ahvONXI0wMNDu0CZNR0cxrnoTLJ39z7xl4Al+qclQssRj0IPa/eB+Y54kiuX+K2YM
         0qPAnBom9blvlcuzxhS+7vEjCOrJ/hartheJv/DVp2IjdiQxAXyli5W//n23xrcGDeqx
         SH0L6+m6SoVT0/+KMaOecXfReZ8GKg+9jf457qrToE+fzCXHwVmwfbPD8CCKrn07WYga
         ULp/E3B7Mx4iMkvV3OZ3ro/cNAWUE+ysmSvqlmpQmIEKEkzxF9QP3ClyI7HzoM9Omb/y
         ztHw==
X-Gm-Message-State: ACgBeo2Q573q00DDXvuqutSyco2AMch4h3UyjwtRs0EL1EVuJS61WDGE
        /t+JjNAY+3pvL1CVAE2q6rc=
X-Google-Smtp-Source: AA6agR4I0pOlZA4fp4KU4G4CPAd5yDgBY8p45tpYFXbQTwK4YJdulMC/GBDG80L7ALX9f9PyR7p/TQ==
X-Received: by 2002:a63:1e10:0:b0:41d:f6f6:49cc with SMTP id e16-20020a631e10000000b0041df6f649ccmr19894063pge.223.1660710131082;
        Tue, 16 Aug 2022 21:22:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id je22-20020a170903265600b0016cd74e5f87sm229566plb.240.2022.08.16.21.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 21:22:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Aug 2022 21:22:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/778] 5.15.61-rc2 review
Message-ID: <20220817042207.GB1880847@roeck-us.net>
References: <20220816124544.577833376@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816124544.577833376@linuxfoundation.org>
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

On Tue, Aug 16, 2022 at 02:59:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.61 release.
> There are 778 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Aug 2022 12:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
