Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4E5F9ECD
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 14:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJJMiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 08:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJJMiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 08:38:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291BA43175
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 05:38:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so12976172pjq.3
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 05:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Wrv/U+G1a8qeEtsgCibukStHmUzbnjV38GnxUfKUg6w=;
        b=rSWvyOaaXE1tsGD4XugsTTbDTQU+1D5SzGo1FVxJAq4S4oJfY4jdMS2D+Y7h6rPMxk
         tVdye7J5L/mhhPZEWNi7pVvcLFsVWHNpuCKIYSOuvObue8uiFBSxezJ/PkSTTIbvV8Wz
         1rgPV9WKCr/1em7C5UwJGMGHhu3+UwR3cRUXOlWlFrwW6NNjYI1GIg3ok1ifVvnKkqDh
         su6OiZFPYg1ixlm/WNxblrk5J5UvfnhGKsciPX3OqNilwGH68qMHVczzETFJShAjorwi
         fXclOL7IPYrTf6mC+Xxs0BLs/JjWT1AWG7XjbJQm39Mz9DwA4sc9dMZqusu5igOBXrUJ
         Amgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wrv/U+G1a8qeEtsgCibukStHmUzbnjV38GnxUfKUg6w=;
        b=EdBhF6ADz31MXV5wfW1ur/+CJyJcq1VghomhLclz443YZS3zlKEuPTudzdI01cxAKC
         2V3UrTIU8qK0nUe7MCOrIqN/+orM74SA8xnAFX8XbI5U3Cm3VaL/lX+GiQnGYOJaAK8H
         H7suakdTcSyUwTpnDiFVQVczK1HleiepNycE0+sY0axQ/x2kS7P94hxKstvltG7lwX08
         YrB21602p9CgF+04uyUhRzGg1CZzkfwlHzxG66LOPjxmz98aaGmICUFcHBcNpPVx0f8F
         MapHm3YLA4VBNFmH3iICnOP3NTm2l6yaQz2JCQHDl1IUu0eWBhF+ikqmkPztONTu1Oaz
         YLag==
X-Gm-Message-State: ACrzQf1faILTT09gugIQ/RQFmjR9Sarz09ivPX9qBwcO3AXiG5l3jyjH
        UpYIQXbxVXfIggzRn5nmwl9bYVnkaau5quNb7Ao=
X-Google-Smtp-Source: AMsMyM4VGyFuz124wjv2A4l+O5B2HyH6COrRq2Iw9MB4TDiXwJS3UuqPOLmrJ4P9AqTdYCN3Hp/l3Q==
X-Received: by 2002:a17:90a:c250:b0:20a:e484:63aa with SMTP id d16-20020a17090ac25000b0020ae48463aamr20878008pjx.0.1665405487460;
        Mon, 10 Oct 2022 05:38:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902a40200b001750792f20asm6470655plq.238.2022.10.10.05.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 05:38:07 -0700 (PDT)
Message-ID: <6344122f.170a0220.fd1db.aec2@mx.google.com>
Date:   Mon, 10 Oct 2022 05:38:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-37-g16538c20c2add
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 188 runs,
 6 regressions (v5.15.72-37-g16538c20c2add)
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

stable-rc/queue/5.15 baseline: 188 runs, 6 regressions (v5.15.72-37-g16538c=
20c2add)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
beagle-xm                | arm  | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig | 1          =

imx7ulp-evk              | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defc=
onfig | 1          =

imx7ulp-evk              | arm  | lab-nxp       | gcc-10   | multi_v7_defco=
nfig  | 1          =

panda                    | arm  | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig  | 1          =

panda                    | arm  | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-collabora | gcc-10   | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.72-37-g16538c20c2add/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.72-37-g16538c20c2add
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16538c20c2add1fb4057cbc743b3243a1778a051 =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
beagle-xm                | arm  | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6343dfa0a0c414d9b7cab626

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343dfa0a0c414d9b7cab=
627
        failing since 18 days (last pass: v5.15.69-17-g7d846e6eef7f, first =
fail: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
imx7ulp-evk              | arm  | lab-nxp       | gcc-10   | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6343e0c3b8243d7e7ecab5f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e0c3b8243d7e7ecab=
5f8
        failing since 14 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
imx7ulp-evk              | arm  | lab-nxp       | gcc-10   | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6343e2506208560328cab602

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e2506208560328cab=
603
        failing since 14 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
panda                    | arm  | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6343e17a7d934800cecab602

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e17a7d934800cecab=
603
        failing since 55 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
panda                    | arm  | lab-baylibre  | gcc-10   | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6343dfea8682685348cab614

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343dfea8682685348cab=
615
        failing since 48 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =



platform                 | arch | lab           | compiler | defconfig     =
      | regressions
-------------------------+------+---------------+----------+---------------=
------+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-collabora | gcc-10   | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6343dfea8682685348cab617

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
37-g16538c20c2add/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343dfea8682685348cab=
618
        new failure (last pass: v5.15.72-36-g65c395d4451cf) =

 =20
