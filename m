Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47AB664E8B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 23:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjAJWMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 17:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjAJWMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 17:12:36 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5950AF5A4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 14:12:35 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso17962933pjp.4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 14:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ptfag1LFAR0qzt0xrxGwFhqN8rtHCfocexRXhmL0nHo=;
        b=3fFUBpBaH7tYd7kvG5iZv3Hert9SPwdS0fMpveWw1Il8ulvMac5/Na6uXZ1uUXC/I2
         8MXVAd+p89sKolWjmNuLjsumfPnspABRVXiAdGFHYlIVM6UTtsqUcuXQjZ9wWQmODsQG
         zHFJR/hbc7SRrSSJl/Qq13w5aljz7XNr6+6nlouHhCSOg7TWANmFPsGY6hY1uBBq/Juy
         LcXdYoHHuwExfJj4Gt+VWxk9iLnFh8033BWbCC4TOwi1s4q13zXtuayLB5qDLZpxbmtA
         ANBfbs3+4MUughwQP69lh5RX2PxhM+KsONeTtO7a7lo6B89gSpcUMk6Hn/hZUs9swvQU
         tB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ptfag1LFAR0qzt0xrxGwFhqN8rtHCfocexRXhmL0nHo=;
        b=u8jf1RMIv4TCqv9loXYERIfn9Mtej1O76VOSyoiCLuvTX4GyQeCaYBsspvTC5rKOhJ
         d2lJn1D7biRuLAXJuV07ql2X93YTywzMSP3BOTx48w+UOmdrbjPKJBeBAVYYR6REoeWt
         tsrnORMdbDw7spbXuBXNmeOx8zFrxQu2pyTm138K+WpREGXrkbx05f3oglMuZeM3fqJ0
         l5aQZlGJ/1dr1ALYHo1yT/4trNt1id8vrx0iA4Em4b+sMJAlR/MvDNOFa6QY4uv3txnn
         561Xso6LQfdF20HRYfQwKHqZ5lVKZZ0Uih9tc/BQpzTqbz9/E/2rNj9ajouMkvBK/fj2
         q6ow==
X-Gm-Message-State: AFqh2koNFqi1RPMzby2aZU707wme1O0UPoCTUUgGzi0fnkdjVANqPlT6
        U38k6FHkL6QGA91tgSshC9mJIYUYLNsKNmBsN9WoLw==
X-Google-Smtp-Source: AMrXdXuLCFhd3Yz7/jkwd9ufhGt5s6BBV7C59iyrEkeu+b5q78JB+XReECogt2xD91pxvxmdvn/LDw==
X-Received: by 2002:a17:90b:394b:b0:226:d73d:12f4 with SMTP id oe11-20020a17090b394b00b00226d73d12f4mr17695617pjb.28.1673388754642;
        Tue, 10 Jan 2023 14:12:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090b010c00b002267e2ba88bsm7662873pjz.46.2023.01.10.14.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 14:12:34 -0800 (PST)
Message-ID: <63bde2d2.170a0220.a0fab.c482@mx.google.com>
Date:   Tue, 10 Jan 2023 14:12:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.269-462-gf31084f8c6b1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 46 runs,
 6 regressions (v4.19.269-462-gf31084f8c6b1)
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

stable-rc/queue/4.19 baseline: 46 runs, 6 regressions (v4.19.269-462-gf3108=
4f8c6b1)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.269-462-gf31084f8c6b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.269-462-gf31084f8c6b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f31084f8c6b17d4d4fcaf572041ec7d75acf05b4 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63bdae6c6e2819d4da1d39d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdae6c6e2819d4da1d3=
9d8
        failing since 168 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63bdabbd0df3180ee81d39ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdabbd0df3180ee81d3=
9ed
        failing since 168 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63bdae58bdb7ded9251d39d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdae58bdb7ded9251d3=
9d7
        failing since 245 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63bdae94ff0dc1cd711d39ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdae94ff0dc1cd711d3=
9cb
        failing since 245 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63bdae807a85ef8ac41d39d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdae807a85ef8ac41d3=
9d1
        failing since 168 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/63bdabbe627eda555b1d39cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.269=
-462-gf31084f8c6b1/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bdabbe627eda555b1d3=
9ce
        failing since 168 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =20
