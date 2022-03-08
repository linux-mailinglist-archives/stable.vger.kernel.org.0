Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B7A4D1BD7
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbiCHPhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344633AbiCHPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:37:37 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E8E4E3A5;
        Tue,  8 Mar 2022 07:36:41 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id n31-20020a05600c3b9f00b003898fc06f1eso1635496wms.1;
        Tue, 08 Mar 2022 07:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=laPhZb1GwIvIq+5gAOz9hWbhVtuOoBLrm7z2JuFF6aA=;
        b=T1SixgEuD9tVWJjr6rq5qnWp0syZjQpRbdswyehuzTF7JcHTVPx7bxyTCdnvW71a2v
         gTse/eWpO/wmkS6MdfYXKL/0MexZ9MqOCvpRBKaw2uEYqc+U7xeuMO3iRoc86JzsKFzr
         1qaALvyRSrrI2nAlxtktlDL1Oz+7wkCA0ikuBw2Ojpvy3/yy4TR5LToKQ5zrNu40pZ0U
         l7pf2OY5cg/b75OYufufPZm+vIAVR6WnxgJB3WC61krYoxO8rePGTtE0z4iTKuKaRoY3
         hpbtoakhJ1YzSSZyHXRdqIXppNexyy/l4l0GWTUH+B2BDiZrrMB/1DgBTYEsCFz54rQR
         dGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=laPhZb1GwIvIq+5gAOz9hWbhVtuOoBLrm7z2JuFF6aA=;
        b=Wd+izYW769o6GcWINc8v7ICRgULFtqtG7I9Z0FVNtVTJfsejQ2lEzmhtUq281iodLK
         z7PjBXO57Tewg2VFZNbHhicv96eeOMLF/F+/REhuAn48ALTjV6aXonqmkGy+p1bcPGKf
         WnGAel7GT7kvG2z/6i6jdiFfgpobRPqjiYtPLMgMJCzCQyvTihB5US8uCi+xh9+FdLc4
         vO+T0qbCUMLi1x5WI3PuV64B6W9pxPynuEDWzejmZRMYhSaWm+VIO/kuue3wjS78ISTr
         2gV0ext0zXeLg3vywCsveNlHy1LQDRD/tc/TGUV2yo9RsI06V2ZiKbu8shMI+TTobKTO
         MF0Q==
X-Gm-Message-State: AOAM530sxJlktKtFCZa7uH6s69iqXOqJVjRCMdMMWEJ6teRdj11qtLmr
        mg399DIwgJYFLV8/T3azezc=
X-Google-Smtp-Source: ABdhPJwfXxCQcYo6qvjP5pSM4c29YqxfMnjOw01pRWnv9k1CnTApdnCkzSPYidNpZR78KgiOpsK8rw==
X-Received: by 2002:a05:600c:384a:b0:37c:2d14:a2d3 with SMTP id s10-20020a05600c384a00b0037c2d14a2d3mr4133027wmr.20.1646753799459;
        Tue, 08 Mar 2022 07:36:39 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id o22-20020a05600c4fd600b0038133076dcesm2996473wmq.16.2022.03.08.07.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:36:38 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:36:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Message-ID: <Yid4BNbLm3mStBi2@debian>
References: <20220307162207.188028559@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307162207.188028559@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.27 release.
> There are 256 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:31 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 62 configs -> 3 failures
arm (gcc version 11.2.1 20220301): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Mips failures,

allmodconfig, gpr_defconfig and mtx1_defconfig fails with:

./arch/mips/include/asm/asm.h:68: warning: "END" redefined
   68 | #define END(function)                                   \
      | 
In file included from drivers/net/slip/slip.c:88:
drivers/net/slip/slip.h:44: note: this is the location of the previous definition
   44 | #define END             0300            /* indicates end of frame       */
      | 
drivers/net/slip/slip.c: In function 'slip_esc':
drivers/net/slip/slip.c:930:18: error: 'END' undeclared (first use in this function)
  930 |         *ptr++ = END;
      |                  ^~~
drivers/net/slip/slip.c:930:18: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/slip/slip.c: In function 'slip_unesc':
drivers/net/slip/slip.c:960:14: error: 'END' undeclared (first use in this function)
  960 |         case END:
      |              ^~~
drivers/net/slip/slip.c: In function 'sl_outfill':
drivers/net/slip/slip.c:1393:75: error: 'END' undeclared (first use in this function)
 1393 |                         unsigned char s = (sl->mode & SL_MODE_SLIP6)?0x70:END;

Test was on top of 7b9aacd770fa ("Linux 5.15.27-rc2").


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/851
[2]. https://openqa.qa.codethink.co.uk/tests/855
[3]. https://openqa.qa.codethink.co.uk/tests/856

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip





./arch/mips/include/asm/asm.h:68: error: "END" redefined [-Werror]
   68 | #define END(function)                                   \
