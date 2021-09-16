Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3061240D84A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 13:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbhIPLTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 07:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbhIPLSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 07:18:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164E8C061766
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 04:17:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso7273644pji.4
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y67DPWz0nmUV/gSAS5ByoO1iO11C43ceTgyf9rt2vRM=;
        b=EoxgvWkIl5FuZnacnc7Z+CW7rTEYebjCyWFXCSXrLNkFASOwabauwaqQpoEv6KdXkC
         va4k5wKNtob4u/u6VSy5ShYsa8fYNC12VgGl5MjieircxleyNvIZ5QP3htYB58ZHInzE
         SOsWJ6VRBZcaIEZ3QdOB+JQ3+RSpd9u7yap6PE7Lxl8SMw10U12UuIFSI5J8JJSceK0L
         4uKDvPkYoFBz4OZ8bPx3GRQnx8OsJm6+r7nPcbxysGuDWdGiBcCOHHDQ91b7hsyhODOM
         qnug6G1SSJ/5ND/mEBNAv/xoiB+9xLtXFFvry36/5qYM3IlBpOwCLlD1DtKbo5r8fJX7
         P89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y67DPWz0nmUV/gSAS5ByoO1iO11C43ceTgyf9rt2vRM=;
        b=RVFJU/6bXhlHgN7lKr49isA7ze6V9294UvyfKZ2T9IONesg0o9ANsyEYBrwtj78Peu
         Q+aHb65ZqlHOhYm3dmNK3AqLztw+1StlwrfFq+i10npbs+HDQMsSisE5XKQO1K/Ccaxn
         RO9HtW6FA4xZCtaMuUcjp9Fwh3X7jm9YS+JTrl8fVsQBuHRkq6lh4DOPeeaGafbQseia
         5l5vtDzy2bj9sx1DC2q96jRy015Mdk8ioeouMEU+2C+pjy1pcdOeNdYDguzRohrSsBK2
         YyQ0e3QBaMQ3Qm4zSHVP0kuiv6ALILrXjgTHtlZt+UhdHC1SR+x5i5lR6SAuD70SutAv
         4mYw==
X-Gm-Message-State: AOAM530ByV6ezCQ9ql7t4Ulz1zwSvLingqBEUgAqpSlbgUTOQhB8e0Iz
        taky5wAAw7uBrAhe3kOHP2xCI5ipXNyJQSZuRvk=
X-Google-Smtp-Source: ABdhPJz/LlGNgNuEh7NKfiaH5BOyEmh4fleft7yCAL+qo6zw8n01HKa7k8dfU/G94+FonPCISb8Aaw==
X-Received: by 2002:a17:90a:bd08:: with SMTP id y8mr5448002pjr.123.1631791046221;
        Thu, 16 Sep 2021 04:17:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm3057648pgl.90.2021.09.16.04.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 04:17:25 -0700 (PDT)
Message-ID: <614327c5.1c69fb81.eef8f.b51a@mx.google.com>
Date:   Thu, 16 Sep 2021 04:17:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-150-gf26597d59c72
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 84 runs,
 3 regressions (v4.9.282-150-gf26597d59c72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 84 runs, 3 regressions (v4.9.282-150-gf26597d=
59c72)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-150-gf26597d59c72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-150-gf26597d59c72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f26597d59c723cffceb5cc280641555b0461be8b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6142f36263cb3cabfb99a2f3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
50-gf26597d59c72/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
50-gf26597d59c72/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6142f36263cb3ca=
bfb99a2fb
        new failure (last pass: v4.9.282-102-g588ed610887d)
        1 lines

    2021-09-16T07:33:37.482279  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-09-16T07:33:37.491416  [   13.752617] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6142f26e935158bf5e99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
50-gf26597d59c72/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
50-gf26597d59c72/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142f26e935158bf5e99a=
2e8
        failing since 306 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61430a5d260c81981a99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
50-gf26597d59c72/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
50-gf26597d59c72/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61430a5d260c81981a99a=
2e7
        failing since 306 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
