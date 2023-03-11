Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807B96B5B97
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCKMYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCKMYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:24:52 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E094120866;
        Sat, 11 Mar 2023 04:24:39 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso5043942wms.5;
        Sat, 11 Mar 2023 04:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ktDtq6F5mYK2om1OkmlupbObQARt7GGBfAckHwwPD5s=;
        b=SJmbpgMg1wWeZlpCieTj0YgVoj6N0l3ju7FpvmBybLKjaMMXTS+HFZDJIcGooFODJs
         WaE+YlV3Xd+3AucPMZ31HT6n2ImvFxaChorJEhb4ZfNE3Zw7Bx/MpwHXbSEW3c1IzECp
         qCZkW4tbof5nXEqko3jKaa1nhkY+k1RLgce5njC05FE9K5d4rcpQlyHHVHqic7JOdKEL
         O8zhLGO2zv7O618oBuDwtQPjZ07OU+ffmmAAwAI+T9yyEyPBVj11HG+U0c+SofnPCsdN
         E+V5E+++mhzjcZJSJE4JAcAyEhT1+UFsgLMB+b995XWkHzIWCgjFaxAY7HgpjUdE9WMj
         qBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktDtq6F5mYK2om1OkmlupbObQARt7GGBfAckHwwPD5s=;
        b=p3xgUQJAkWsIlts3GSMeJ9v7+fxqNvyj4RWZ2GEw5WlSiCU4XMkoEFA5mu7SchWtMA
         +Ps9A3DENUturEDdjcXULkmm5Yb+Skh+JYgy3T+o29FlUaKCeIY6SWAHu+8rsk0xyA6L
         36O51ESgUhPKaLP0zAa+nDG0kUkV/IlSK2du/qPr/T+QteWACcfhFE7vRokRM0EMjk4f
         SL15qiOQoKa4ly3kMiYJHmSh9rKI0kKMEO9fENKl/enbyg1diH/yNTs9TOAJUaWPYM6s
         x8bWUbDqYVKekvxrMTsaOcb0Xg+ZF4K7W2RNWVdUmbeXenGnxz3KxsvY5klM2TpR7kKr
         /nkg==
X-Gm-Message-State: AO0yUKUC0UIsOPShDczGApTdeYxQQNgf0o7QkCA3lDQ2RKGmCZ/CFmDb
        NtempJI0U2LZ1edXT/1Z6rddpv3exqw=
X-Google-Smtp-Source: AK7set96yaiaJ5hySs218YQKWsYE12lJazGBg2QQx4xHtBYi2y4qn1VzdHW+JeV8PI88QTgVwJLjHA==
X-Received: by 2002:a05:600c:19cf:b0:3eb:3cc9:9f85 with SMTP id u15-20020a05600c19cf00b003eb3cc99f85mr5798593wmq.26.1678537477544;
        Sat, 11 Mar 2023 04:24:37 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d44d1000000b002c5691f13eesm2339151wrr.50.2023.03.11.04.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:24:37 -0800 (PST)
Date:   Sat, 11 Mar 2023 12:24:35 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
Message-ID: <ZAxzAxJWBUDX1F4N@debian>
References: <20230310133733.973883071@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Mar 10, 2023 at 02:34:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 65 configs -> 1 failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> failed
xtensa allmodconfig -> no failure

Note:
mips build failed with the error:

arch/mips/lasat/picvue_proc.c:42:44: error: expected ')' before '&' token
   42 | static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
      |                                            ^~
      |                                            )
arch/mips/lasat/picvue_proc.c: In function 'pvc_line_proc_write':
arch/mips/lasat/picvue_proc.c:87:27: error: 'pvc_display_tasklet' undeclared (first use in this function)
   87 |         tasklet_schedule(&pvc_display_tasklet);
      |                           ^~~~~~~~~~~~~~~~~~~
arch/mips/lasat/picvue_proc.c:87:27: note: each undeclared identifier is reported only once for each function it appears in
At top level:
arch/mips/lasat/picvue_proc.c:33:13: error: 'pvc_display' defined but not used [-Werror=unused-function]
   33 | static void pvc_display(unsigned long data)
      |             ^~~~~~~~~~~


s390 build failed with:

drivers/s390/block/dasd_diag.c:658:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
  658 |         .pe_handler = dasd_diag_pe_handler,
      |                       ^~~~~~~~~~~~~~~~~~~~
drivers/s390/block/dasd_diag.c:658:23: note: (near initialization for 'dasd_diag_discipline.pe_handler')

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/3081


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
