Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D7C2AA7CF
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 20:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKGT6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 14:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgKGT6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 14:58:12 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEFBC0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 11:58:10 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id x13so3672017pgp.7
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 11:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vu16G3dE/y+vc7ws+dwpRZ0fTiBJkKbYl8w5afmem5o=;
        b=OoWt9CdLFM3agCqMyLLIOkRf/H9xv+wTPpmfy5WaRruZCIXQ2e6X91Ug5F7QA1SEaV
         P95mM539jzRodnweDgn0HzwdgJ1QWbW5SkHvLB1ld1+RDk516VdeujLAaNaX/GJMaAmN
         m0MFxuncqA2baHQcF640bOfJt/z9UysNFKyx+KaWLkuTVK3cCxVHr334j/adalb77e16
         vChx5H4Gb7j5SwUY2bABRm7eX1oa0X2Mh430lfaYZNRyf+JljPv4lvfXMHNFbHyNs6FH
         hM8QL+RxXkSMxKi0LVFnsDkTUj5MVyrdNY6y6bOkBn/2sa58s/HI5nUdYW912bJAXTLA
         Yzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vu16G3dE/y+vc7ws+dwpRZ0fTiBJkKbYl8w5afmem5o=;
        b=LKOa4XZ+0KQmq4ZwKjH8zwmIa2QpK4NpIDsAf2g0ULtER7wd+GYEkq7aw91KIpUEEN
         Og0JVytJZR4A3OsF4G6HMMixX54YtqUZlfbuhx+fmKn8h+xfvePtj1kVISuUsb6+jNzv
         xWBwhfAn5vD6emKA91rQuDJRrdBFtHNKZimuK1oqw5j/MD9epzgmJlqETItJqo8m6P8F
         o2nzABpSHJysajfcyiWaJFZiFy7cgQls5HO7iSIChzlcpmOXAvLduU10nNnDXMYe5OhY
         OQgonrFoD7TLT/UR2S3PH8F3eQrdBvUvVZZGg9ucbIJAy9s56qFkseMmwfC2uROsWA66
         Lx3A==
X-Gm-Message-State: AOAM533u3L+NwLsezUD9Xt5OWbGhZ7hVdG+6IufWdFdlxWLzp25uya/z
        +srIpRFsDakxgxtcVlAYUIy+3ZQIz8ozKA==
X-Google-Smtp-Source: ABdhPJwfDmn0FG8IV3QhyxJogQ+U8dthcPH8hg8AXFPuq+awZcyh33O4l9uF9AfCsuoOu4TgTwqyOA==
X-Received: by 2002:a63:b548:: with SMTP id u8mr6672588pgo.356.1604779089881;
        Sat, 07 Nov 2020 11:58:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y24sm2894499pfn.176.2020.11.07.11.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:58:09 -0800 (PST)
Message-ID: <5fa6fc51.1c69fb81.b6a66.59af@mx.google.com>
Date:   Sat, 07 Nov 2020 11:58:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-21-g8d63aa09568c
Subject: stable-rc/queue/5.4 baseline: 209 runs,
 2 regressions (v5.4.75-21-g8d63aa09568c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 209 runs, 2 regressions (v5.4.75-21-g8d63aa09=
568c)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-21-g8d63aa09568c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-21-g8d63aa09568c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d63aa09568cb7aedf5fe34a07e90891025d8d60 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fa6c91a136aa2f39ddb885e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-21=
-g8d63aa09568c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-21=
-g8d63aa09568c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6c91a136aa2f39ddb8=
85f
        failing since 9 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5fa6c8c1cfb8be461cdb8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-21=
-g8d63aa09568c/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-21=
-g8d63aa09568c/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6c8c1cfb8be461cdb8=
854
        new failure (last pass: v5.4.75-21-g2198a177d7438) =

 =20
