Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18165E91A6
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 10:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIYI25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 04:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiIYI25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 04:28:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8101962F7
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 01:28:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p14so1142176pjd.3
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 01:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=LubYNvN62tM3IRKd1+QpVCUKiYPnqOFzPuzewhFnj3Y=;
        b=TuMYTE1DcIZ8hNWmLnCMQefN0ug3/CRVGL4ol8/xklby+hdKc/3ZHsIegTw3FyWFWV
         BCXC2mr0rhZh8kFo2giRloeKhnfSlDSJBgTPoAZCJioLdpE9RR7qthMsV7qy7eJnSsjv
         UoxD53EOMvAJ5ME4Gdi7xNfH8qBC++duooRNg4t54SwaO0oTrIcILeu6RrQlb/IWwI2v
         QVQFNUa3LChX2nDOsd5QEfZdZxfsXuL7HINIzNFI8FsR1l2MF4kG3PTvJk434m1u5D9N
         Lxg4Y63Gd+MqYZ+Hk5lZuLM9YDrU63vFmlJz4mnrXkFzlj2dYt+ASp+61QDCLe1j51wE
         0f3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=LubYNvN62tM3IRKd1+QpVCUKiYPnqOFzPuzewhFnj3Y=;
        b=8JRaEyE7YT5f9b4yBeEdGiNrCenjIcOqdx4H+EA2tFIHlNQ2GnxxzZt7GwWyDkPQDF
         8VUMrxuZ0E+pFb7tQZKpKUUE82Be6ibjEJ/kdqSAfL64BP6QhUuLuDeDy/4lApZEW5mc
         BBvfe2YIkEg8RrEoaGyaKpGgd4zM1vSnDRv+MunKTUmMXGAsAWlFy6LOcDsXAYJcdKEV
         ZlmLOU+7ZXLMQ5DhJGPHzZKRpGn5VA3pwgChM45UAYfnrYK9HR2bmvzNUdhIwbkdb+If
         sBkgBwGxtbE8JE1J2tMiy4MtwKRUEWq74M6XC+f8ePucadwZQ4I0nfiL/t4d/HBf1tFJ
         s7TA==
X-Gm-Message-State: ACrzQf11YD/PfUHyuCL5CxsjCJDEyZbBDeSPHhHipWrNkGQbsyHJEV1k
        fuLhXvnJbdVu5uOQrKikbkafxLlN6pHHNpd73mQ=
X-Google-Smtp-Source: AMsMyM4WNIndeP0LrHPTzSLpBwVYcsKFYnMDKIGcNVvoNzlDXtVmCaxZxeOWrJfaxspxO7A/bEN2bw==
X-Received: by 2002:a17:902:c106:b0:178:8cb:2762 with SMTP id 6-20020a170902c10600b0017808cb2762mr16624173pli.58.1664094535846;
        Sun, 25 Sep 2022 01:28:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7-20020aa794a7000000b005385e2e86eesm9855910pfl.18.2022.09.25.01.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 01:28:55 -0700 (PDT)
Message-ID: <63301147.a70a0220.3a728.2d25@mx.google.com>
Date:   Sun, 25 Sep 2022 01:28:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-158-gc8a84e45064d0
Subject: stable-rc/queue/5.19 baseline: 161 runs,
 1 regressions (v5.19.11-158-gc8a84e45064d0)
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

stable-rc/queue/5.19 baseline: 161 runs, 1 regressions (v5.19.11-158-gc8a84=
e45064d0)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-158-gc8a84e45064d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-158-gc8a84e45064d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8a84e45064d0278f066e84580eac5ba2213ed55 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/632fde111b5c9a9d7d35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
158-gc8a84e45064d0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
158-gc8a84e45064d0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fde111b5c9a9d7d355=
65b
        failing since 2 days (last pass: v5.19.10-36-g00099e2e5131, first f=
ail: v5.19.10-39-g0c9655cc6e1a) =

 =20
