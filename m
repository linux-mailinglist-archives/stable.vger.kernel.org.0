Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BEB470542
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbhLJQJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 11:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239918AbhLJQJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 11:09:24 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B901AC0617A1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:05:49 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gt5so7162720pjb.1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hrX/2kYaZulygZR0342iBMpSB0x41ET+fZtiUScwxoE=;
        b=T1107Gqo0D7/btE2jw7moeqUopxj7N+/RVCSh/x15jAKtxDiPf+ypv8DrKEBYsc19K
         8oU84R+IZnWWZFyesv4og3bgNyQ9XCs6is06OgcmNSEee6OVBLDpeCC812z2pYWF2TZb
         1l5h0TsSOBy7q4iyWXSyaGD8ROZdnNd6a12dbHhRUUsuzTNJuOeO+QSAzgdOycZQslTw
         0j/DLFaHOfYDyEesortT+Z1jaINsKvNBAcpvygaCfwd9BUjV9PMHRYtj+0vRIxfhKtn5
         0d2WAxhB1nXPQcpD6qdio0OimPo8UbYKZZu3Cxg5hhXHdjHlM+KYPqpFvbpkRidN2Vcr
         UNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hrX/2kYaZulygZR0342iBMpSB0x41ET+fZtiUScwxoE=;
        b=CbQKZNpiY+i2x9BPUJThfWbjz18ZWnxfNp+g6HeAFNMK/umoivNRRN1IHpWeAyojzM
         Pz0kwVgCYwuWuF444ud4+hC5jhIZ4Q+bru6QLatRrafGbFOsw+Lyqk2bheIUffNnHhLL
         Mjc7wxNOq5yFd30EGZPlkeqArGL2A0PEi9lPhLipoIKOKGdR0iQLdB8EimfbLYHanpuH
         wnxgQ+tRBvRGtsiuqsEqeyUEUz37d505bVSpSdb27WsxGWgs3heI9XEPpAWGBtEB8TI6
         2d3D1oH4rwxqZAODWgp3v1Nte6bg6Lt8kipDX9z+r99a/JhQVRVTgAlSuMfOHrhnBV7i
         L0sA==
X-Gm-Message-State: AOAM53389DfWh0vYP+ISpVk7IXmWcYoy7zPoLPkrLK1AbX9521SiyWxu
        nMA9jAZXmFSqQk/fBCOAM4hdebHd/TkAwXh1
X-Google-Smtp-Source: ABdhPJzd4YgKFcGty0NyqJvPrsp5Nh7RNGZEksVFlenIUubAbkJAp/vUx/Dxtfi2zzocBJmtSa6Rbw==
X-Received: by 2002:a17:90b:3908:: with SMTP id ob8mr25028439pjb.57.1639152349159;
        Fri, 10 Dec 2021 08:05:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm4222854pfl.201.2021.12.10.08.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:05:48 -0800 (PST)
Message-ID: <61b37adc.1c69fb81.d35ed.bbe1@mx.google.com>
Date:   Fri, 10 Dec 2021 08:05:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 126 runs, 1 regressions (v4.9.292)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 126 runs, 1 regressions (v4.9.292)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.292/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.292
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      575a0d95491df8cb6d0f566562c8edda4fcc5bb1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b342b672ac3dab0f397129

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.292=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.292=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b342b672ac3da=
b0f39712c
        failing since 26 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-12-10T12:05:57.326494  [   20.252197] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T12:05:57.374775  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-12-10T12:05:57.384421  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
