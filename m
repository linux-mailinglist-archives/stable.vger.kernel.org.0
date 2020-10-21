Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD87294BA5
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 13:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441898AbgJULMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 07:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441897AbgJULMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 07:12:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0F5C0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 04:12:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lw2so973443pjb.3
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 04:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LnFU2+xtUqyV0l27KN+Q3ikSelGVSiUBZcqMrkFDJh0=;
        b=H8cXhcbuZBSbueeiG6mn90TUICpVTMpT2/j5GdJS4tdK3iAIVzTE2RnGJFHQ3quchk
         Txhl4Yg0AkNuCS+AB6jjjV+LrU9eDjdSd3mGc56syjPKdVoVbI01LmIWDpbnoEfLuP41
         CXQwzevvWu+KIs3FtcDSE944r+HLOylnu/iOcf58gHF8snWscWXPFihZI1NaNEIR2ZKy
         kiSVA/Y1CqZhCoGNBmwfF0vyWJ1p8+c6+T4e9X9+GxMf0fbp3hK+J8qbfDpYCABx59fK
         3yGIdjD1TqpclJaMe+RW3DMB6x2ZNYHkPOOCy+Hj/i1LftkpzyNOOw6UBZbw1NXNPVz/
         XsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LnFU2+xtUqyV0l27KN+Q3ikSelGVSiUBZcqMrkFDJh0=;
        b=VHaG+j+SSe2bnswRDK+2sNAuQwt4FdN30cyqmtdws5fXomuimraW7c1LBDZ0n/51Jv
         C1WKMI5zRWMkrqx09M1S1oPDFJQ9ZLpvOGzn5LNy9e2MsOHGoD4BL/mPa1oc86+3RU5m
         DKA5SOfYlM5LpXIEzNe42175Nh8nnMY6HSTyMT+oHrKDnndjBq6IGtUaZBURXcpVQCWL
         AR4ZYdMY+ksWJ534OQg+duYrE7V9tl66EgXgg5EPaPtGii1G1ITT3hiiuqUnYgJU4WwU
         shQxBJw7twOWsDgyfPeWnu7u+PAUoLKyOiZ6YeU3rWR0/4e3567/6IFVtbwwPWznZBTA
         DT+A==
X-Gm-Message-State: AOAM530jhC3VcPXA5L2M34N4HXQmc+Hxbdpq3oWojqpfPej7mmLH90he
        lPFjsuCfc2mCKBpnw9/8MXWYR6NfPY9sXw==
X-Google-Smtp-Source: ABdhPJzos+W9j6UrHi05b7x6z7cVTPeIkD27dLaACLjVKwD6rJVr2D37GHu9ZKUykuBH0UikMjhskw==
X-Received: by 2002:a17:902:8541:b029:d5:b4f3:314e with SMTP id d1-20020a1709028541b02900d5b4f3314emr3085070plo.31.1603278769892;
        Wed, 21 Oct 2020 04:12:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q123sm2076984pfq.56.2020.10.21.04.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 04:12:49 -0700 (PDT)
Message-ID: <5f9017b1.1c69fb81.ce5ca.4f92@mx.google.com>
Date:   Wed, 21 Oct 2020 04:12:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.16-29-g94b8033e99d8
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 152 runs,
 1 regressions (v5.8.16-29-g94b8033e99d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 152 runs, 1 regressions (v5.8.16-29-g94b8033e=
99d8)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-29-g94b8033e99d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-29-g94b8033e99d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94b8033e99d836087990be2c86f090c4f8a86f2b =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8fdc149d0f92bee44ff429

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-29=
-g94b8033e99d8/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-29=
-g94b8033e99d8/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8fdc149d0f92be=
e44ff42d
      new failure (last pass: v5.8.16-29-g970dd0292df8)
      1 lines

    2020-10-21 06:56:16.744000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-21 06:56:16.744000  (user:khilman) is already connected
    2020-10-21 06:56:32.502000  =00
    2020-10-21 06:56:32.502000  =

    2020-10-21 06:56:32.502000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-21 06:56:32.502000  =

    2020-10-21 06:56:32.503000  DRAM:  948 MiB
    2020-10-21 06:56:32.517000  RPI 3 Model B (0xa02082)
    2020-10-21 06:56:32.604000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-21 06:56:32.636000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (382 line(s) more)
      =20
