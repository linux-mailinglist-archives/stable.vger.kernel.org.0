Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5530316F64
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhBJS7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhBJS5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 13:57:38 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE9DC06174A
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:56:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id b145so1877064pfb.4
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uMmrxNFTDORqpF5V5oPyx1H5bmvs0/+e/42h3EVID58=;
        b=O29vxzw58GSreWUjQPBNtrY2oWUMvXeo6ZzGMvAQLJDSHlAfJTSndM+B0EPLAjCMDw
         ZwsZWbko9By40dMNVo+vHhm8MM8k2aJScywfHGOwuDkjiIKK6LirASFLfn7uJ/51fLSd
         NYJYBKUHOQq06Qb5QXvoPIS37yHQTShmhUyAVMHHr5ENbDXuML4ojOx8r60xOQkzKg+u
         /v7Bu15yCS0Bh8Qihz/+7RfsgdIUDWQmtJLxKCZA4og5kVPI07rdGPtA+4oCF82OiqgM
         liPy0rpeg2LSK5e4NRmVoc+GB8KvmAvGBZTxlui4STgbydq7RkaNAeREGdJ9na+KHR8W
         bEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uMmrxNFTDORqpF5V5oPyx1H5bmvs0/+e/42h3EVID58=;
        b=St2wQ2owf6m1ZAIKpCwVrpMnDt22ysADBgDJFn55LGgFIZxd2antV+0mfFZsBy98P5
         mNyikS+gu0l1fQ+tFSNZN3hsbfzdvKNqxZ8ZrpxNk0gArd+vCAZDHKqMyeDCF2/G6Hop
         Ppv4XtDLKtMu+KOcZKTZyHRVyIs3wmolC2qlzzkaek6ZvN5uAtlcPSMjabGVd+DZCcj6
         wCyNnWpXYiF2wmt+DwlErt+nJvp+KaEFluiUy9IGgbdPhlIOWiPo0q9gXncZYS03o5bd
         rC6R4P9qlGueBt+jwnDUd4PfD6JBCoJawRc4Oc8vDUimyFtGOgUEs2CFAdU116oYP+Kx
         rbqQ==
X-Gm-Message-State: AOAM533rQBezbSJoUK0oy+GTftqxjctGfSb5ywYKR4KC5NSOfcSTgZbO
        MADErTJlRmb4AQzhOnVAtQ6U6Vh9ELfIPg==
X-Google-Smtp-Source: ABdhPJwAs7B8yCBUc1Z31JRzySDlpgyGqhU6si+JDBuPEEl9Hd/3OqJS7Shhl7Sszntdk/id36s6FA==
X-Received: by 2002:a63:1524:: with SMTP id v36mr4383516pgl.383.1612983417203;
        Wed, 10 Feb 2021 10:56:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q139sm3215268pfc.2.2021.02.10.10.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 10:56:56 -0800 (PST)
Message-ID: <60242c78.1c69fb81.50257.708e@mx.google.com>
Date:   Wed, 10 Feb 2021 10:56:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.256-47-g343972be0e1d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 45 runs,
 1 regressions (v4.9.256-47-g343972be0e1d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 45 runs, 1 regressions (v4.9.256-47-g343972be=
0e1d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.256-47-g343972be0e1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.256-47-g343972be0e1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      343972be0e1d61810a687ce0690edb076009e09d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6023f9c0d8af0e2c3e3abe80

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-4=
7-g343972be0e1d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-4=
7-g343972be0e1d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6023f9c0d8af0e2=
c3e3abe87
        new failure (last pass: v4.9.256-43-g76bcadc3cd1c)
        2 lines

    2021-02-10 15:20:27.325000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/121
    2021-02-10 15:20:27.334000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-10 15:20:27.354000+00:00  [   20.867462] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
