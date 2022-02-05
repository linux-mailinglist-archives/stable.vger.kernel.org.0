Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD8A4AAC94
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 21:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352676AbiBEU7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 15:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241545AbiBEU7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 15:59:22 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58022C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 12:59:21 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c194so8169656pfb.12
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 12:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4piMMq0JtbcL70se/qgNwQJn4uYrRo9hxWhvQdMKH5A=;
        b=cXvnLr6VM+AUmbM/6hxrdiAmAnz9FGEKSqVn4bvRwNyomOdnygCs/gemq4tAFmClQl
         yc5GS1KHyC9OUaK2sgi+WIelMDXb6OCI0TAZzQjdeWdsZ9m7W46sQ0vsYzZuerzwTa7+
         qcjsoaN3mLieCpKuNdvqiwCuyaY2YF7dx6+zSC9ZdiL8x79ls6Vq+hNv58VZE+yHyQUW
         90yZh6DaLtL4Ws37DB/76jcsVhmw3W7MjO627NRiv68KOl1U6lpYM0ODPvFXhrd9YZn4
         OfQFsLpZTk7phmEqaVEhh2T0KlGwhQecvz3h2TKQXzttoma8BlxUtZAqNCPyJYwXkd42
         Rr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4piMMq0JtbcL70se/qgNwQJn4uYrRo9hxWhvQdMKH5A=;
        b=leMlehtmqd0eb9HHinja7eQzPGZ3vdldOv/7IKHg9SPTr1N9k48y9oYAyKhzre9OSC
         OggRDM69bHsiybZEVFd1S5nykpMIalfyVWbWYADFG9VPiwpxHDhDZwL2xm7kzw15kxJM
         AClLeBX7IPCZZwDTFDRZqlAaqQZ500jeudXX6nLKNPtwUjSMs2KdydX5IvZT04Ai8pGt
         bLLJpxDbnXjaDHzn9YtDZokQc+dc5nrT4OWy6wMmrFSOLILDNyuVSaT846045aaenCd8
         9ry78cVKpxDSq/nZyqKZXWpNO/CNFiUgX2iUP5azzQGJRNJeJP6GvMRGGkHH7WTSAeDt
         TBpA==
X-Gm-Message-State: AOAM533E18I8fDOnuDC5emcc5yDyS40RCgcbFzvREmP5s6SM8L8k33Wd
        cyPsJP4hBzbMh3FOrG45BCsZTXC729NyaO64
X-Google-Smtp-Source: ABdhPJyIxX9Fm4qJmjKyoO9kCnacij+ckWn5zoxFVz3EBXUMl+5uHfSe2TJveV9fcvqIj5zLZFwY9g==
X-Received: by 2002:a63:6b43:: with SMTP id g64mr4025659pgc.396.1644094760624;
        Sat, 05 Feb 2022 12:59:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g20sm7165813pfj.196.2022.02.05.12.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 12:59:20 -0800 (PST)
Message-ID: <61fee528.1c69fb81.6959f.247a@mx.google.com>
Date:   Sat, 05 Feb 2022 12:59:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-62-gcd8bdac92abc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 130 runs,
 1 regressions (v4.19.227-62-gcd8bdac92abc)
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

stable-rc/queue/4.19 baseline: 130 runs, 1 regressions (v4.19.227-62-gcd8bd=
ac92abc)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-62-gcd8bdac92abc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-62-gcd8bdac92abc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd8bdac92abc1b0852935e242a8714ac5537d012 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61feaa977661ebb4bf5d6ef7

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-62-gcd8bdac92abc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-62-gcd8bdac92abc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61feaa977661ebb=
4bf5d6efd
        failing since 3 days (last pass: v4.19.227-45-g1749fce68f74, first =
fail: v4.19.227-45-g388e07a2599d)
        2 lines

    2022-02-05T16:49:02.881136  <8>[   21.151885] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-05T16:49:02.926563  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-02-05T16:49:02.935614  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
