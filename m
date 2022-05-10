Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8226D52250D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 21:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiEJTzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 15:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiEJTzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 15:55:17 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654D3297418
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:55:16 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c9so17003582plh.2
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w5bPOBjg+XRObu2BJPNrDgddV/hrrDh0xEWf+6ECRp4=;
        b=KFLxG1ixwzbkkRXgCDlzu8bMy5f8gB3S6LF101zZNNbMKzJgydkvsotBKZgdMUt7wL
         YdJS+hlR3sTcn5rTO+6TA6BPPOsVDjJDk9i3c+5A/pHiPCgYGfmPyHrieedFJMxNNl5K
         kGLZxISUb2X/Ymfl4bimrONd6W5lu/7Aa9lyda/D0vHDYVZme8ZuYQZwBs6Bedd46Bfx
         ZFLMhh1hVJzCoeiqg0yhr6vCM6sMM18xKXVM0YDSFrqP9ympJyK80Yql3WWvCIoUGzRD
         CL8b+KAZnIgzl89lGIIVocIBhJyXAFfnR671IUXDBcxPZoMqgQVBHLJiqyPA4ghk3pCn
         PdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w5bPOBjg+XRObu2BJPNrDgddV/hrrDh0xEWf+6ECRp4=;
        b=gwk/Kb9qbgRawnjPBNWUYYQx8R5nLMjVfM8xeeBvsN+kqHvpRa0nOtvpLXuhVEpzpL
         a8yg/4HhvGC56lVPEEo1mSrDuPmiGNbii8DzBsbsMZBTQ9hEeS1sQerQE4jn++METvg6
         +6ckzXpATaUCLA7wF0F510DtWv/uSv3djLDtz7YbdO4FZiGRfsVagDrrab3CKq/R1pCW
         D+ZxfpPbnyaRbsz/549wuBjE6FKUc+h7gg1DHNfvpxzGgUdIa+pJN5T3p092vk/EcExU
         J46+lQvVH+u7x+ZsDGrzGp0PVd3DTwe9Aq7thbYL6j1oHgkWwv/kwyBeDShnCjEsh6wM
         FvPQ==
X-Gm-Message-State: AOAM5319+84qcLzSS2Ufc+vj9oy5cM5sQ89orOon4gcbNIAjDZRFVtto
        /nwYczJXVbWdcJOPN1+FAdFmQN/1q+VsdWYyseE=
X-Google-Smtp-Source: ABdhPJxBjuR6Y5NrZu8AK8VHTTLDd7T3dt0BZo8L6jJ9Bkf5OQodWND72BsKQc40Uo8vTDMN2Qcq5A==
X-Received: by 2002:a17:902:f28b:b0:15c:5c21:dc15 with SMTP id k11-20020a170902f28b00b0015c5c21dc15mr22221027plc.16.1652212512608;
        Tue, 10 May 2022 12:55:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16-20020a63d550000000b003c14af505fdsm125350pgi.21.2022.05.10.12.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 12:55:11 -0700 (PDT)
Message-ID: <627ac31f.1c69fb81.a155d.07a4@mx.google.com>
Date:   Tue, 10 May 2022 12:55:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.37-313-gf15ef1d11d7a
Subject: stable-rc/queue/5.15 baseline: 118 runs,
 2 regressions (v5.15.37-313-gf15ef1d11d7a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 118 runs, 2 regressions (v5.15.37-313-gf15ef=
1d11d7a)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-313-gf15ef1d11d7a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-313-gf15ef1d11d7a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f15ef1d11d7ace650672a79f870d3d277b9f1a0a =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/627a91ba5c871ef0488f5719

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
313-gf15ef1d11d7a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
313-gf15ef1d11d7a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a91ba5c871ef0488f5=
71a
        failing since 40 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/627a92ab09e4758a128f5719

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
313-gf15ef1d11d7a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
313-gf15ef1d11d7a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a92ab09e4758a128f5=
71a
        new failure (last pass: v5.15.37-280-gbc585cada83d) =

 =20
