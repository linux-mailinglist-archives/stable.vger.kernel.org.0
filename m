Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3F845CB56
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 18:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243479AbhKXRqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 12:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243881AbhKXRqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 12:46:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B877C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 09:42:53 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so3381935pjb.4
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 09:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cHw5pAhcJ9Eu9u7mZ4EomXuMzgiAc74G6iZ0OtCFPMw=;
        b=EG82sVDZW/m0KrhbHvoN8lfpOP5/sIUOfZO4I/hBGJOGYxt7/a5cSrUBtFp2w228be
         0zf7C6TZeahW6MK3TtZx56HXHZAOMBl4IXlW9Le0y4jKd5vLLuPG43gkKL6Pdgf17XEd
         fe9KLsx65xwjKqjGeWAnoHt0Lpwi0p1cTJqInTAXoCN0ffn+NiiplOBbbd6xTJ8gJJaK
         1nfnlZbPiQlUxCIMgcgIHUlJ7z3gwCg/lpqaqwq1oJeckH3/ncD4nbrdfUc4mj+i52Wk
         t4DU3bAr7A7DeTWHD1Iev5jDDs4Yg6Dxi5O0O9jvlz19L4LtYfPOIMAo4sfC9T0LqYaA
         9cCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cHw5pAhcJ9Eu9u7mZ4EomXuMzgiAc74G6iZ0OtCFPMw=;
        b=xXxahAk+VBtb8UcH0eNccjM9Sg/anjh2pbVblZ8rkKuhbq1c6aOwwgIXXtNIj/hyCz
         l01kUtgigh7qZI3J8kh0twqIj63YaV7IxGx1YPX7u2CHGE+T1L2+0Fl74J3HSgehHlcl
         CCTWYguWkXat7CELc74+GNNr6vjZYXCZ4xgRL1O5sqLafZsg24y9nFtVmhGpcG3qRC3g
         +JlAPVysH9UFGrWpXlV+vTPn54Kq78GyudnXBmNm9HlzdKMo8N6TnXoAXI6AQRPq/+qR
         LJZtpa9Tu+nSLSOHJHvs+g+qu4TbhGPBPxW6qP1EH2MGdJK69KfpAHOL1KKWThhgxKzP
         LZlQ==
X-Gm-Message-State: AOAM530uMTg8hRJ7P2mEyReDvtHbo89+kw8RoZ1/99hlylFktR+tfyKE
        SWeDAuVoLuGt5c8T/PqDxa0j4h9nX4kAYu/CIbY=
X-Google-Smtp-Source: ABdhPJxFJWVOpL7LWMdHworI7cqcZwtEUel/3mXLACmntIj7xsjkqWe0r+qz7e8/3qpEkWQgzMO/hg==
X-Received: by 2002:a17:903:1c7:b0:141:e630:130c with SMTP id e7-20020a17090301c700b00141e630130cmr21178411plh.80.1637775772871;
        Wed, 24 Nov 2021 09:42:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q17sm388940pfu.117.2021.11.24.09.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 09:42:52 -0800 (PST)
Message-ID: <619e799c.1c69fb81.91c2d.15b1@mx.google.com>
Date:   Wed, 24 Nov 2021 09:42:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-251-g4fe6ab089e81
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 117 runs,
 1 regressions (v4.14.255-251-g4fe6ab089e81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 117 runs, 1 regressions (v4.14.255-251-g4fe6=
ab089e81)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-251-g4fe6ab089e81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-251-g4fe6ab089e81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4fe6ab089e81a5212e307da3987200d614f2071e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e3fd1bc06eee0e7f2efcd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-251-g4fe6ab089e81/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-251-g4fe6ab089e81/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e3fd1bc06eee=
0e7f2efd0
        failing since 5 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-24T13:35:59.333707  [   19.950408] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T13:35:59.376586  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-11-24T13:35:59.385606  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
