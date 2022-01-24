Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7A74976E4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 02:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240715AbiAXBVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 20:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbiAXBVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 20:21:41 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BC7C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:21:41 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id j10so1634674pgc.6
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+sKD7W1Wc6cfpCMIAUUNhpkbsuku/J5iV/orSebIbDA=;
        b=aQ190EFA0lKi05aQxoaNj+d84bvw/Jn77MLLbZWxOXH4I9fd4RgNC/oYH/RgEUs3J6
         QSB8/XRMF0V/mbEIJDuejz8HTmkEibYJRza18/LvyahEiA8TtlYnAEbyEeCT7Sr3RJ0e
         1E2gssaw1etAObpppxJ4Gz8PdZdzOtLOEEHq9VOjcq1VXf/JVUQjryXylGgr5mPZ0VI6
         j5z/BrVZsXdYlb/MLchWRKyJ482DaefNLAV9Mi6vO8QHn1Jy1nq4yXl0/6mvOdIrXWJh
         tZhUT+UkIVjkc2pCId7eRdTeZEb3fQHA3PJFy0C38JwWc0522GV1Kv9zar+jduLZ/C71
         YSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+sKD7W1Wc6cfpCMIAUUNhpkbsuku/J5iV/orSebIbDA=;
        b=dahsw+ZZAgS5WzeXJlH3btuVnXE/YHZfI9zIqGmF4wRopNqdbMC59/+MGWvrhCzENp
         Kc62tRUDXRKg8yB8pfR+acp4CZMzTOu/wf99tuMHWY6WePOd0vfey1jF7wCrqKPeQFWc
         54de3LEvSWqtIy6rKcABe8idGMN0BW6QVpxqOQplrCXCc55Kv32HxN4x5uQ01xCmbvhR
         /LOod5VmRVsjAx+G9jhqvM2p3R8blrWkxBaYFtV4FLJ1gYOWg3PVhQZH7BJgoOiiQEcg
         wdcIJndCsD/nG5V/GmQugLm8SLBzwLc+WaTj0cJe9N84S2VPURSlb3VRRQQSDsdawnr8
         NB6A==
X-Gm-Message-State: AOAM532Kk9ykLb1AJnYXbuV046CWBgL2ekS4HXikjoU4K1R2XSRTsHlv
        Ofj3j8GUjJy7L99SYY/yHM8sNTcSbNZA3t3m
X-Google-Smtp-Source: ABdhPJyawI4EMtL9Pr2+5QZEob3yrjfhYkxaRuiM8x0KLZzRv+36blE5B/PdORoOgX2/MR9hizAhMg==
X-Received: by 2002:a63:2ccd:: with SMTP id s196mr10092460pgs.555.1642987300915;
        Sun, 23 Jan 2022 17:21:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r12sm6963148pgn.6.2022.01.23.17.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 17:21:40 -0800 (PST)
Message-ID: <61edff24.1c69fb81.90d4.22d6@mx.google.com>
Date:   Sun, 23 Jan 2022 17:21:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-893-g3f6db3f99b11
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 116 runs,
 1 regressions (v5.16.2-893-g3f6db3f99b11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 116 runs, 1 regressions (v5.16.2-893-g3f6db3=
f99b11)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-893-g3f6db3f99b11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-893-g3f6db3f99b11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f6db3f99b115aa93ceaeb7deedde8398b17792f =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61edc73f169bd574a6abbd12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-8=
93-g3f6db3f99b11/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-8=
93-g3f6db3f99b11/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61edc73f169bd574a6abb=
d13
        failing since 0 day (last pass: v5.16-66-ge6abef275919, first fail:=
 v5.16.2-847-g4e4ea5113e47) =

 =20
