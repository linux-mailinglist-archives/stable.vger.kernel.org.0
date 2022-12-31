Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC2565A5A9
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 17:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiLaQNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 11:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLaQNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 11:13:35 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E5726C6
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 08:13:34 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m4so24801221pls.4
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 08:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FSdrvvWdauOCQ4E7zfOTmSXwKyWZfKh8Z+MFx/aJ4a4=;
        b=GmZEQUBaJ3Aq0CLHYp2dY6nbd3mzVUqammyrnT54KcDeJB3jwdddVtE6bJBJ7Juvi9
         1Uw/v3lfOLUTWs4tdjacwi2DDq+6q3zY6MxIpit8mJ5ACMMdq/VGlcLJ3fa6VnjLjEAH
         HgkxRZue/fTz/wKwgM4vr8fAeRj1cVeg0WtEH/eg8q6mif+zgKzJHQduaq+NB1Yw4FD7
         aSA+7MXbanYWngopfVQbAU760MV2A5gJp5MGp4KLPn2KeyDxM4p+U2lTogkPPsZKHRL6
         cht1nlP0aUMdaWtZ67aAoBSzpir19IGmHeQeFEtgWtnVZh3irGiTaenGXS5oKtpUmL0j
         2dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FSdrvvWdauOCQ4E7zfOTmSXwKyWZfKh8Z+MFx/aJ4a4=;
        b=QQCYM1naNNL2WllapOPrxs8HQbLFnTRIiFBaBL/5SRVEpovdpzIv06hvBZ+QZL1+/Y
         uu5fJhIJViA0RJmay475IIfO9oiA5HaNPDZuh5cUN+YYdUekzmdQAgois6TGUtdFh2Hy
         OIX1Khz77BO0j3RFXURQ88xUDBAaWAAaXAk1bUJ9Gvse6B2jlP98T66ulIcBpin8Zvuy
         MkqO8JrlHXqI9EAgeqS8X8cgRdleE1ueSo367Q04xBJfNBr2C221Vf/L1tvTDxWx0cmS
         KCkO0WXiNolb1fKy2dvGhx+w1bI8B9xNBZjJ5lVt39J47XWw5YO/0PYse/J/LGzj2+9D
         KgYQ==
X-Gm-Message-State: AFqh2kp4U8po8+UybWaAZJ5kmYITexK6Y7BiorSYVOvpMIe62wgJwKUh
        pLghsqbvc9Jh7k+TVnFDi4GHiS0gml3tsZQn
X-Google-Smtp-Source: AMrXdXt71A3nYIpUO8BIis+5KQvaOQBrvVRoniiq5UWjTt7PdXf0EjojGsB0wkSrJwz0JhJxvL/WJw==
X-Received: by 2002:a17:902:e0c9:b0:192:61ed:a887 with SMTP id e9-20020a170902e0c900b0019261eda887mr25335013pla.57.1672503213702;
        Sat, 31 Dec 2022 08:13:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18-20020a170902d51200b00188f6cbd950sm16968368plg.226.2022.12.31.08.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 08:13:33 -0800 (PST)
Message-ID: <63b05fad.170a0220.b3854.c0ed@mx.google.com>
Date:   Sat, 31 Dec 2022 08:13:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.85-729-g91ac771029b8f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 151 runs,
 1 regressions (v5.15.85-729-g91ac771029b8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 151 runs, 1 regressions (v5.15.85-729-g91ac7=
71029b8f)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.85-729-g91ac771029b8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.85-729-g91ac771029b8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91ac771029b8f30d444e4ff185cb712623f1e767 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63b026bec5cb88b8b74eee2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.85-=
729-g91ac771029b8f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.85-=
729-g91ac771029b8f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b026bec5cb88b8b74ee=
e2c
        new failure (last pass: v5.15.85-731-ge1259934211e6) =

 =20
