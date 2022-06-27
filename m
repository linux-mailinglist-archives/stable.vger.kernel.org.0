Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7F55C4E1
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbiF0Xqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 19:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239342AbiF0Xqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 19:46:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF2816585
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 16:46:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so14064194pjm.4
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 16:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W6N9shmwFdrQCUdnVmKEv8HgK20R0xABKw/hXJwKlyQ=;
        b=g061sVom92CRPlXUMsdXUA8+L/sDWCG4GMXhIXncYMt3bX5P8fFpxWgybPy1WYTn/c
         sqtTuT48tYWBC48uMKYh7t6jG1h4KR2nesxZ7wYa3jEf8cAsYLzPkhWQ5VqKd6a/lX4i
         T/Ddsat8vD7VmJGMQQA5oTCgC8aoJJN3uAE5n5dDAwdRQFBOvGrnWnz0gXT3Ms4QIy1/
         ke+WkcZgJYQtxXCSKsqCG3xr0uADx0LGQl6OJwirbWFZ8AgHSYhA9jyCL5wWAC4q/7b/
         ih/FnMtxEroGmGFwb/mZNHJFWi7uHSOjXsMvewjnBPW+SYkW1aa7WKMusP2uYGdi1cya
         7jCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W6N9shmwFdrQCUdnVmKEv8HgK20R0xABKw/hXJwKlyQ=;
        b=IZj9W/V9tEy+hBnhf7VnmWw43Z4Zuj+BCEB5hwjuYRqb2Mek/HPrTqRDPusojlt2zo
         XfuJFdhQwmk2sHP2REHZJxD40bAjBOZ1jOf37Cv1/yRRi9XtyLzXsgB/HQoAwFzGFYHj
         rFtYvl1vgaqiuJOUK3kB51mezpTeH6Ek1VXuORmKiGPZ6Fer/NoI2oo2HSyPJ3ZGGxtw
         G3aEqT8L9xpM/rmmFd9uZsfqEYoO3UpkwKSvOKABYWf0slctRyAPBQ06OAW3OMP6YE7j
         u3xbS6/Qy4Tkwjm3oVuL76Khkki+RVPQTjMXlSY3gq5SNkZ/FL3IwYo4kj6PiCQ5kYen
         oyCw==
X-Gm-Message-State: AJIora9OzpuANDTepT588K0aM0W2dhML5LDxbRm3mUvi7951vz3AOBOi
        uk/qkvFcjsAnLzJYClTINGYQdVThZrj6CeUB
X-Google-Smtp-Source: AGRyM1tKC2t4RKB+AnBeRIzhe7xORfA89c7105o61cBLMgHNllxMFBS2I46tDkV0z2LFA6t9qEPMxw==
X-Received: by 2002:a17:902:d145:b0:16a:25e:d4ef with SMTP id t5-20020a170902d14500b0016a025ed4efmr2045578plt.162.1656373608047;
        Mon, 27 Jun 2022 16:46:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12-20020aa79e0c000000b005184031963bsm7923300pfq.85.2022.06.27.16.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 16:46:47 -0700 (PDT)
Message-ID: <62ba4167.1c69fb81.7b6d.abb9@mx.google.com>
Date:   Mon, 27 Jun 2022 16:46:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.50-135-g7ebec9568872
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 140 runs,
 5 regressions (v5.15.50-135-g7ebec9568872)
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

stable-rc/queue/5.15 baseline: 140 runs, 5 regressions (v5.15.50-135-g7ebec=
9568872)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig |=
 1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  |=
 1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig     |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.50-135-g7ebec9568872/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.50-135-g7ebec9568872
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ebec9568872a151f8f0cc82d9245052ce2b554e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62ba0b7b5ba247467da39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba0b7b5ba247467da39=
bdf
        failing since 89 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62ba0ba60974499af6a39c1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba0ba60974499af6a39=
c1f
        failing since 16 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62ba0ff2521f6ae77ea39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba0ff2521f6ae77ea39=
bdb
        failing since 14 days (last pass: v5.15.45-833-g04983d84c84ee, firs=
t fail: v5.15.45-880-g694575c32c9b2) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62ba1229f3bf71bacea39c12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba1229f3bf71bacea39=
c13
        failing since 19 days (last pass: v5.15.45-652-g938d073d082af, firs=
t fail: v5.15.45-667-g6f48aa0f6b54d) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig     |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62ba1dd7ad4c5ac611a39bd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.50-=
135-g7ebec9568872/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ba1dd7ad4c5ac611a39=
bd8
        failing since 9 days (last pass: v5.15.45-915-gfe83bcae3c626, first=
 fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
