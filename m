Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F158E361
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 00:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiHIWon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 18:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiHIWom (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 18:44:42 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E0865822
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 15:44:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s206so12706845pgs.3
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 15:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=asrGKZedNVY4US/GQH4qVYwswFi+UAkuzsGfMI8tovA=;
        b=U7dj2cSI1R+ZhMuz61wJ/ryllWsAHupWwbiQHRzafOacQIv0TGBPt+GYxI0mz4aHpX
         2SpNNHskSnQWA3m6+r5wocguXuQJ31Ul/Vy8l/QVcRXpDhj8yQwHQjJsFes5LPX9lNlI
         vBgodkPmrd/tpMXfIH3ksnbOOyCu4DGR82FiHWOCx/xCw7QZX+bfbZp78NqdHaQp5qCP
         /keGS9hIPPrLjSJOP1HxdFXaKV4wSnNUsFOmJUBSrGOZfTOjIs17otbjNVfcr/9Nihib
         h12WnkAu+9QSLwXxXHibHIwdYO9G9rppyuaidJCb20f5fCdmsklPQgs+AF0dCFnE/YEo
         eIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=asrGKZedNVY4US/GQH4qVYwswFi+UAkuzsGfMI8tovA=;
        b=pEES5lbgEYvGwa6mQNuCLIUhzYb8x8iXeWPAL2gJQU8vzf6ES3w5mcM4gSJIQrbqDH
         8xQ3Htu60JpvfDbFX/gPD3kbLCPR3/gWOWgn3FUw1pk+8K5f2+2yk8tLY7svuJvP6mGM
         HRPB8O1MANDzY0XjaKR8+L1H8cJZpeTFtzHYzDx0kAQnhM1+kvKMgm0+yJi1X7umwxpZ
         yomhuQmHOl9FANMWEoBMEdPCg4ifjwQmNAIzvHZ3XPf6a2A51sx4PMfmLxc4hsrTHcv4
         gCGZ3Hc5d+3xbVOo3MFvSIznm3rXFESC8ct/eThweJAklp0jbyro8pP+3JFybS67RfSf
         aL5g==
X-Gm-Message-State: ACgBeo04Ijj1Tv1o3rpJi8ZULCLfLyQju8pZSAWeL13KyCPTksT1Usk+
        DpYSoQ8f4LX+aRnZFK4+MfrlV1ue18sHsvRCzS4=
X-Google-Smtp-Source: AA6agR5zf6mG+Srvj6qTl2xELC3N0FZGCdF2yKoJjtsc3Qy2d2pgo0a+0DFDRvamY6j8ZT8gpbNoRQ==
X-Received: by 2002:a05:6a00:816:b0:52f:43f9:b644 with SMTP id m22-20020a056a00081600b0052f43f9b644mr11418212pfk.57.1660085081014;
        Tue, 09 Aug 2022 15:44:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c184-20020a621cc1000000b0052d9d95bb2bsm389844pfc.180.2022.08.09.15.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 15:44:40 -0700 (PDT)
Message-ID: <62f2e358.620a0220.b238c.0dd9@mx.google.com>
Date:   Tue, 09 Aug 2022 15:44:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.16-35-g99e934b6697aa
Subject: stable-rc/queue/5.18 baseline: 143 runs,
 2 regressions (v5.18.16-35-g99e934b6697aa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 143 runs, 2 regressions (v5.18.16-35-g99e934=
b6697aa)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

odroid-xu3         | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.16-35-g99e934b6697aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.16-35-g99e934b6697aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99e934b6697aa6b51b991be24faf51c4349bbd11 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ad74bb149d8a7edaf09a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
35-g99e934b6697aa/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
35-g99e934b6697aa/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2ad74bb149d8a7edaf=
09b
        failing since 34 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
odroid-xu3         | arm  | lab-collabora   | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2b0af0f8cd6327bdaf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
35-g99e934b6697aa/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
35-g99e934b6697aa/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2b0af0f8cd6327bdaf=
062
        new failure (last pass: v5.18.16-33-g4030e25d8dd05) =

 =20
