Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568E42A8845
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 21:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKEUnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 15:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKEUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 15:43:50 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA9AC0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 12:43:49 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u2so1351492pls.10
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 12:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hPkwayGyzvOeTzXSXbuRWJEhJIwhyp9eefBdG8GNLNM=;
        b=QtmqlThPl9+WzO5J9SVyP3zKOMpbsUNfNK93w+rty8zJPbnGll0Vu8gLpt7D/tJY6R
         Y8n5WofgahbQbvJPtBzXH07hm6DpVK/md2LvXB9ozoyBJsX91MnJEz6PxdmlYbiOU/+d
         ASbv11RdG0cHuZ87a90bFHLyLfI5WS4s8rXLcViarO/Z8qfAx7IA3l7t5oGX3HTyBgFn
         QqxcgRNpVqzcCaiHy3gVGjvJNUV4PhDzh3Id6frQALs2UEEVmp9yTf+VMHW7qncHBA1w
         56i7iD7iMkAJS/pYxFZORy8LzVApI6h1UoNPFlIi/kBLAYuvCuoG6UZt6eeD3wlnvmwX
         IVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hPkwayGyzvOeTzXSXbuRWJEhJIwhyp9eefBdG8GNLNM=;
        b=giOpoZ0hMFpuHYB0lO9DmMRfAx9jKVnX21DChbZOt3S98eD9RgPQ86iWtdOv9POpQd
         /LH1bukBEQAXCSv5oibDv85EC6OwPKi94gr0AcPPCpaimqvkWRKlisklnPwI144jPIQH
         Oa7yEx6ezQhFmxtCqe3AbzyBtS2xThfhC/8WkwhPtRy4qMpzTzg3x/hSQMQfkEgTZn/8
         SPzjiRarkxqUkbwln12US7rP6hQAwAbPIjjM02RFQXoRn7mfQCgZEVLoo9Yqw7RRirC0
         tyNBa+cO/0LaOlpPh35B5/zSJGa9n5IDqJhg7C2HHkoIAUSZQGTx6w23Wocq/Foo4KyO
         VBGg==
X-Gm-Message-State: AOAM530pmGzYoy73NqN3CwFChZsciFE6c/2nWPpCsSks+is/s8Il3q9/
        RsKareIVuX6oERrfjyVhTD1tDvbvaSLKjQ==
X-Google-Smtp-Source: ABdhPJzi0Y6v6L+q+qlhx6Db+9hu4arw5MltcDc0NuPSDF6rZAOTnM0ibBIItxIsHZGj0Liox41YrQ==
X-Received: by 2002:a17:902:848e:b029:d6:d2c9:1d4c with SMTP id c14-20020a170902848eb02900d6d2c91d4cmr4014016plo.40.1604609028948;
        Thu, 05 Nov 2020 12:43:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm3258597pjc.41.2020.11.05.12.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 12:43:47 -0800 (PST)
Message-ID: <5fa46403.1c69fb81.7eb83.5c81@mx.google.com>
Date:   Thu, 05 Nov 2020 12:43:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.155
Subject: stable/linux-4.19.y baseline: 193 runs, 2 regressions (v4.19.155)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 193 runs, 2 regressions (v4.19.155)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
hsdk     | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig      | 1       =
   =

panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.155/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.155
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b94de4d19498b454645b72d08a05d32fa9074fb5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
hsdk     | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig      | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa42fa4c49b35b909db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.155/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.155/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arc/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa42fa4c49b35b909db8=
854
        failing since 112 days (last pass: v4.19.124, first fail: v4.19.133=
) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa43121bb038e826bdb8853

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.155/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.155/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa43121bb038e8=
26bdb8858
        failing since 21 days (last pass: v4.19.150, first fail: v4.19.151)
        2 lines =

 =20
