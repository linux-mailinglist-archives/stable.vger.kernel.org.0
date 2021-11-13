Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB2944F0C2
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 03:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhKMCXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 21:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhKMCXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 21:23:24 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8058C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 18:20:32 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v23so8186575pjr.5
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 18:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2/B6gX3HKpyR83SZEI3H9I0LM2Bbm/0VmvNHOoD5nfg=;
        b=Ahn/PBLpTNKy390AfyCB/emDg9voR4V+BL8RFharS/S9+HTvJkNd/tQkYCmITw3TRz
         kAsQngw+XonQ7KvkYK/XupdRXyGAbtygi1J112KZBhv3h5wKGVmmQjR5VH1SkVXI9mWT
         /SCdWw9jvf8if2chE6nIWC3mNJqvCw0PCLCpc/KJT9dYhUUvli+NMGgIBQrl7HEXAivi
         +GMAsF86qCWcnNsiSJ+FXC85lJytDUFfmhZ768iF37TtWy0GiguCMsgYfd1N2F8TkACU
         fpg+sKDNGkOBS281HuqsYcNSQcw8xwM9iwPTogr3xSgljSUG9aNNbz22vzOeGyxpitD2
         uBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2/B6gX3HKpyR83SZEI3H9I0LM2Bbm/0VmvNHOoD5nfg=;
        b=MRpCquBFdUC1sFFiGZWEpbsc7lJ4Um25eu+JryNryWGwKZAiuamQBjUCkbRLFejE/e
         1CgNUC2yb2vPgxY9iaAp6f+hQZp60HyyE6wkglPA1qrgC4kCSNZdkeq1bB+WUl45MtvL
         zmH3o2QH1/0Vc4Uu7j7x+2GNOhBoT0brlcyCdBcz7jS1S7b6TNQRtrD90hEY7XOJu6uO
         pGazfbFou56J4u/lFKL+XQSRbBkmrQJFxlUcQa1gt9kV7Pnf0XqZCF3nEAFLOp8uqe9L
         Fr4ZjLoby5ElfC8Gq92xtVR1Z//mbi7XflDU0xYMnulBFjhzoKpm1Jq4T73JbRahxcvi
         IN6Q==
X-Gm-Message-State: AOAM531MfZu2/d+DnquJXvL76ixC/DVnXSIMfQeXl/9Kw0/K7gHeBz7F
        6qHik7ZnsDhDKzCfgxPwhtABg4R64zyWV+7G
X-Google-Smtp-Source: ABdhPJyZeVKr8VJde4X2+pqyXnphvspK5mly6DhzknGB+Bj9df96Cj3gYNwgLAqF4INuOsF0huo8TQ==
X-Received: by 2002:a17:90b:350c:: with SMTP id ls12mr23687945pjb.197.1636770032097;
        Fri, 12 Nov 2021 18:20:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm8212133pfv.176.2021.11.12.18.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 18:20:31 -0800 (PST)
Message-ID: <618f20ef.1c69fb81.db693.7d96@mx.google.com>
Date:   Fri, 12 Nov 2021 18:20:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-26-gc7ff976017bd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 163 runs,
 2 regressions (v4.14.254-26-gc7ff976017bd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 163 runs, 2 regressions (v4.14.254-26-gc7ff9=
76017bd)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-26-gc7ff976017bd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-26-gc7ff976017bd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c7ff976017bd00296c3dc30d9613a9dfa0da7bea =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/618eea3b42a68e806633590f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-26-gc7ff976017bd/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-26-gc7ff976017bd/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618eea3b42a68e8066335=
910
        new failure (last pass: v4.14.254-22-ge72515f84fc1) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/618ee8cd6bbd28f252335928

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-26-gc7ff976017bd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-26-gc7ff976017bd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618ee8ce6bbd28f=
25233592b
        failing since 3 days (last pass: v4.14.254-12-gd0fa8635586f, first =
fail: v4.14.254-13-gf0ce35059c8b)
        2 lines

    2021-11-12T22:20:42.155258  [   20.229278] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-12T22:20:42.198807  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-11-12T22:20:42.207729  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-12T22:20:42.224383  [   20.300567] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
