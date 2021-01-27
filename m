Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CD0306193
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 18:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbhA0RHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 12:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbhA0RHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 12:07:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA88C061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 09:06:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u4so1747086pjn.4
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 09:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k8zqTyk/OHLpLotLzhRT5RvxQ0sSm5TJhiVFPRcSBgs=;
        b=mq7sRLvZDbTeoBYAziY7ed6XXwm9DxRCQYCxklaNqT6NNb6sab7NTVLWQ0K21TApD/
         yB8sf42Ielb+KKKhJGVsjpCkmdPxppeIb4UUBmF71JgWf5QBROSkRVw7w2zDRHMfAlun
         +Ww57mypmV0Ih5fhg9Q7bJDQNTvmOTbta+GZrcnrj82gw9tJtvtqaQYiqv/i5lTr5B5u
         c6WbmG7VjBHCjuj3o/GYVafgFQ5ujGtcY8eYzejHWnOdH8eq7QDktS0UVp7HRojdW0O/
         /U4HDe6eNJPUJ7Ug+MYQhSOXVrD9391rXlCq4kfYJ34NsFkh9ZkJHKIV/wE+B6aI/lpw
         wUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k8zqTyk/OHLpLotLzhRT5RvxQ0sSm5TJhiVFPRcSBgs=;
        b=tT51t9BwrraoeBhacZYkW7lXMtQOcEowGKK9gRScZefg6M8QND6fZCnhiCTX7EnpXG
         L4MtY9v34D1aa5JZ9zhtWj54QYz7fe36gZg2fn1dTidVAO57Hx0WsGW9FZ6mmAg5HTCV
         EZN5bCM/u7J6GlXNqdpmG+pV2s0+28HXxg6GJuuJpbav6x89xtqaol5rdYLBMfm6BZ+s
         OZPQy3WoIGE5/1Sw1vG5gUXvbEOJ1Y31ohj3vdCEjTLwFS8b/8gzIABGmRjQdhs/bJ0V
         qsGnH6CVACFfl83pWdCSvTTcvLdnEl0zWz7+8myJ7joGSb2GAtMRPw1lng18csuEzeWR
         jpZA==
X-Gm-Message-State: AOAM5324Mg5NljuKrGEWzJCpWaVFniAuO5eNMYyC5nA+OtqR1vfc/rYi
        mp2LwbErd3KQwInLM6RlPWapY3BQ1Yxi8KlK
X-Google-Smtp-Source: ABdhPJxwDdWyZPALU5kbaj3/YmgVB97VPqtiPAzr+0Wz58tNI5IQT/n6Bb34NymTuh21HwiVnn87Nw==
X-Received: by 2002:a17:902:16b:b029:dc:4ca1:f5fc with SMTP id 98-20020a170902016bb02900dc4ca1f5fcmr12266533plb.26.1611767179984;
        Wed, 27 Jan 2021 09:06:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm2643467pjv.3.2021.01.27.09.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:06:19 -0800 (PST)
Message-ID: <60119d8b.1c69fb81.7c207.5b36@mx.google.com>
Date:   Wed, 27 Jan 2021 09:06:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.10-204-g57ecd9fe6812
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 177 runs,
 2 regressions (v5.10.10-204-g57ecd9fe6812)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 177 runs, 2 regressions (v5.10.10-204-g57ecd=
9fe6812)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
imx8mp-evk                 | arm64 | lab-nxp     | gcc-8    | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-8    | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.10-204-g57ecd9fe6812/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.10-204-g57ecd9fe6812
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57ecd9fe6812ccb941cd390a7d109a7907cbf83b =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
imx8mp-evk                 | arm64 | lab-nxp     | gcc-8    | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60116dcbd9e41e29d4d3dfe6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
204-g57ecd9fe6812/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
204-g57ecd9fe6812/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116dcbd9e41e29d4d3d=
fe7
        failing since 0 day (last pass: v5.10.10-199-g7697e1eb59f82, first =
fail: v5.10.10-203-g7b2d1845e2139) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-8    | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60116ccd663fe35709d3e00a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
204-g57ecd9fe6812/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
204-g57ecd9fe6812/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116ccd663fe35709d3e=
00b
        new failure (last pass: v5.10.10-203-g7b2d1845e2139) =

 =20
