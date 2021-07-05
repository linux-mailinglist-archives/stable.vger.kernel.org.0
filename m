Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE6F3BC2E8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhGES44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 14:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhGES44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 14:56:56 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C106C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 11:54:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p17-20020a17090b0111b02901723ab8d11fso449724pjz.1
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 11:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IE+BGPcpa7xutarTZEcnm2P84zgNNSuIak827R2h4hA=;
        b=mRo81DLHv1g15Kp8eoOhxaG/QTUIXcm89EfcXoYJYEvXLvVU39lHMOhgHRUbUGXH6T
         dAlMeRYXlwI5Jpx2oTiXLKfJKPX5Ap36ZL2LW/0fOwykMI4+jNWgsegRiKu1X915wczA
         8mRwsTBx4DvrfIVAHTaD8sCiyPIKm3BzBcNBxZPv7Z7OCuk/NGT0/uMhmEQWkJoH5IUj
         ai25XIH4vOi13/pcbauuf41MWCh5rtyun4Sq1WG6NbcJ34UKTGCvm6ddjbg2Fgs1IwVq
         dm1sTD1haMJukeaVQB8gxTSu/OMK+Jgw0VJe80tWr81PKFvqoXofcQaw3+h0ZzICRHqA
         1E6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IE+BGPcpa7xutarTZEcnm2P84zgNNSuIak827R2h4hA=;
        b=Xeg7zWWmqpGclgIA5z2UQiY/aA/lCnoGJqw4PeBFv3Bb7kPygpC/uVwEx/urn0TZII
         d6yCF6LIGV4W5KmDLpS0gTocnvdEr+qqQCSdocmOJuSXAgNzNJEHb5twzJfne+q8+Vgn
         g6yr+8aREmNx2g1qRyp7AJ2DHi/Nq2e/jhh08ZXHWvqYruD9SvBJ6KDxlDxhP3xSaWtB
         kPIfMrf4A1H6wlTehOrxVDlshKMD4pDTri5OUh0NhNUBU50sCczYRJp3/p+BeufU7WN3
         PbVgzvQ0iVoK487QjfYOsibbLf/1UMixH4X27MsaoP2O+llnNfcifeSd8LGdV/iqS3T7
         qsgg==
X-Gm-Message-State: AOAM530mVB789BTLqgjNtUpaY07HdJ8dFt/yLEDRAZl/+Qa8tlj7C+/F
        iJey7+4wfjN7q3S9dn+2DXL+cnn5ysBbbheJ
X-Google-Smtp-Source: ABdhPJwF4xoEULq/VPPrbuHmOKDJLgdrtripBqQe/f+s/CqoS9JFU3Zm/9vF+97CRlzQq/l+AMdgTA==
X-Received: by 2002:a17:90a:e10a:: with SMTP id c10mr430658pjz.163.1625511258531;
        Mon, 05 Jul 2021 11:54:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm13646433pfj.220.2021.07.05.11.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:54:18 -0700 (PDT)
Message-ID: <60e3555a.1c69fb81.bea5a.8527@mx.google.com>
Date:   Mon, 05 Jul 2021 11:54:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13-2-g2bd940f771f17
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 171 runs,
 1 regressions (v5.13-2-g2bd940f771f17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 171 runs, 1 regressions (v5.13-2-g2bd940f771=
f17)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13-2-g2bd940f771f17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13-2-g2bd940f771f17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bd940f771f17441c03bdc4543fe380fb527b35a =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e3243f7a893731fa117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13-2-g=
2bd940f771f17/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul=
-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13-2-g=
2bd940f771f17/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul=
-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e3243f7a893731fa117=
973
        new failure (last pass: v5.13-1-g4005d2568040) =

 =20
