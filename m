Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE428EEC9
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgJOIuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 04:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgJOIuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 04:50:25 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB72C061755
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 01:50:25 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g29so1498791pgl.2
        for <stable@vger.kernel.org>; Thu, 15 Oct 2020 01:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FCIS0WxWFBeom1ooABJmtTXa6XoIEuDyxirGGVCbVe8=;
        b=pIBFsmqnYBg9DyipQgM/LXai/gBJMLS+vTm0K9vp9hBVDW1qump7JrLsuZOSGzNvPa
         OeLcuXRtWSOIif7sbIYOFd3f78JlEzQniKel3yDbWy4U0Imkdo4IhmWx14yhGRxJkDvq
         qvNs9l+64jB1z6zMu3V23Q34V1xIJ+5HEqpEtrqnIbepw7yHg60svBq3Izy+tDfpXgOq
         9NjhUmsun35VxnXTuy/fbygEznb5CTntF6p6glTTGc6bTsckRJkC/6OfE0G8eV/e6+I/
         y5WdHbfrKub74P1+eOUwVd11DF1fPRuxK6AMotALhwcGTILb04i6Ok+cwuwpLGOUnA8N
         orCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FCIS0WxWFBeom1ooABJmtTXa6XoIEuDyxirGGVCbVe8=;
        b=Wt0pmXzFD5VQTmGgPFYmHgdAVyubsQfixL8q4LTmhz8Fak7hFytRYbA3jBpVswfOmS
         jbeQ3mRTNyoKaG5fKedOi1m9qnvmWXHry0+VQHXX/1esuuEpnFOSk/bSUJaOW2ObSklb
         o9oCAJ7wAFzwhkiJmKO42CTCN6x+dRsaDu1OMueOR9jKDnZ92u4ZVCSVXXBWpBVoZHCu
         Y2CjN3Cjh4allO4xnEIDAjnfR5fzqxKESwrjFW9PQftsMEJvn58ifAlt4R514SuhTxSS
         R35XXTpyxyudxgj3NQbrHKyEfeszmlvvf6xvETst2Q63iUKdyAtjGiNwQ9XqTViOpS+K
         E2fg==
X-Gm-Message-State: AOAM531QVBEzT+iXXtZCSec+HH2T01FlFk7amLxPlZ8nJrCK1jwxgdP/
        VdMCROX6wN2oEp6nKnjlcKf2HVe55mBdEg==
X-Google-Smtp-Source: ABdhPJzfp/8CnMdU1Q8VQXjTuaZk2fJUgpGszzUY+y8yoCWfiCsQFKihtEngen7/CXekhs0prD5oFw==
X-Received: by 2002:a65:5a81:: with SMTP id c1mr2464939pgt.448.1602751824404;
        Thu, 15 Oct 2020 01:50:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 38sm2343149pgx.43.2020.10.15.01.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 01:50:23 -0700 (PDT)
Message-ID: <5f880d4f.1c69fb81.38df5.4fde@mx.google.com>
Date:   Thu, 15 Oct 2020 01:50:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-90-gf1c1692bd009
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 199 runs,
 3 regressions (v5.4.70-90-gf1c1692bd009)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 199 runs, 3 regressions (v5.4.70-90-gf1c1692b=
d009)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-90-gf1c1692bd009/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-90-gf1c1692bd009
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1c1692bd009fe4086a5b201d74ddb1c29fb2c01 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f87d268df000c4fd34ff3f4

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-90=
-gf1c1692bd009/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-90=
-gf1c1692bd009/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f87d268df000c4fd34ff408
      failing since 15 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-accel1-pro=
bed: https://kernelci.org/test/case/id/5f87d268df000c4fd34ff409
      failing since 15 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-15 04:38:56.791000  /lava-2721790/1/../bin/lava-test-case
    2020-10-15 04:38:56.800000  <8>[   23.910465] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f87d268df000c4fd34ff40a
      failing since 15 days (last pass: v5.4.68-384-g856fa448539c, first fa=
il: v5.4.68-388-gcf92ab7a7853)

    2020-10-15 04:38:57.822000  <8>[   24.931773] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
