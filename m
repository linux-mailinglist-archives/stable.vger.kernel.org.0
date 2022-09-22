Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677AF5E66A4
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiIVPRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiIVPRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:17:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54B5EA5BA
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 08:17:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fv3so10143473pjb.0
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 08:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=BMz0BKp/ofXzHhaKAIYC7lC7i5FtaSrVvAiGEC6+DUA=;
        b=YnuA5JSPNtnFSY9YW69Nq5V4etdDuVh98ahSU48p4LYtB1akwnGajQhVGOMVLF4+1+
         xkmg4c9Y+gGLxOPdobpIrkvYqmj5vLHeGq3fhZWjirCEEmp2VVrQ8hcO12QuBWaVDCM7
         olDpxB/4tYn4B4PXx395Ophzcmhc2vq6LmFfjEW2RgRe2ollfrSWcSHC5tHmL7TRoc4m
         85PBDbanFOGbJW5/Onm5HW8oERmO3YRdst/NpDcsYKmQL4FP3PTsWdOScEo+TsfPf9w0
         DyUUuG9pTbVaYev/A1in9SWGEzFxKcQGOYRR5RyNBgnqmfkRaewX5nywasva7V7AYWsM
         LsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=BMz0BKp/ofXzHhaKAIYC7lC7i5FtaSrVvAiGEC6+DUA=;
        b=s7klP9oaSZZfWovLhuiDbB8U2R+8nmn+2RK+LtOf0N8FCno1EH4X/B3UUY0iviAD4L
         6LvVhUTx9CIUzcgHWj7eNvRF46JP7hd6Iae6gXfoGxcRjzpUNX2VHrfd1UqPrB8MDCbX
         RYipePmKvqDn/bxYVf/fipEN13AmhUueIhGmpW/gxcpATnCCfDOauppyvtph6DtY1m2i
         2n7Z123eH9hBWBuqwl0pcO4VzVF9LKpGv2KC5yu3oiaeTfZKLLlANHZf4pG4ncojuzii
         4H78wMlUCX0tIT5M4FyNsJpHTlaF0PjpWibkLepX300nxlv5Jzey+txucRgeyZYbrPsy
         UWFQ==
X-Gm-Message-State: ACrzQf09b/v5Q97OJWdr+L1FngYjcOStpNL6kLAbG78EEy0zkaTYay5/
        EAE7M3mF/1FDmnRhSlIJ1JNXsj1Q3DU5Xs3cgaA=
X-Google-Smtp-Source: AMsMyM6QkW/ROqJrRzfsKgJDdxWg1j1NCQvpN/56f+S3gRbeITygbazST/DAPLyyyCzzHSTqqY+9pg==
X-Received: by 2002:a17:902:8215:b0:178:6946:a282 with SMTP id x21-20020a170902821500b001786946a282mr3895068pln.162.1663859827277;
        Thu, 22 Sep 2022 08:17:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902bb8c00b0016d9b101413sm4119437pls.200.2022.09.22.08.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:17:06 -0700 (PDT)
Message-ID: <632c7c72.170a0220.82ef5.8b92@mx.google.com>
Date:   Thu, 22 Sep 2022 08:17:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.10-39-g0c9655cc6e1a
Subject: stable-rc/queue/5.19 baseline: 118 runs,
 1 regressions (v5.19.10-39-g0c9655cc6e1a)
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

stable-rc/queue/5.19 baseline: 118 runs, 1 regressions (v5.19.10-39-g0c9655=
cc6e1a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.10-39-g0c9655cc6e1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.10-39-g0c9655cc6e1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c9655cc6e1ae5641a5ae4d217db859d9def59ae =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/632c43639bdc571adb355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g0c9655cc6e1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g0c9655cc6e1a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c43639bdc571adb355=
648
        new failure (last pass: v5.19.10-36-g00099e2e5131) =

 =20
