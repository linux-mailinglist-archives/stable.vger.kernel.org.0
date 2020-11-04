Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F4B2A6C89
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 19:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgKDSPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 13:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKDSPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 13:15:33 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B765DC0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 10:15:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 13so17969403pfy.4
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 10:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=adI2tFY3zMTiVIqz1QgrnysGSbGRO2tZmh4DMQNkx5g=;
        b=UM6l4tCkUILb2R2BPZ3+MpU2PBdsyLSjXQJTQZgl2Ce9EhhvUP8YNLXt+eOtSUcnW1
         DwWd26Tkl+gVfzDrAfvvGoLSrg0eywU+XnPEEdzR2hpUpYDoPUt6m+4+xJ6NDCbH0plC
         BHxyT27494hh7NSMJruawP0udme2YaL/8sktXVKpgsGa17XqLew58S6c4sDej2DlkoyD
         SAkqgOuT/Ybft+zLI2vPaXEXdh3EUGX8tHDpDzsns4lDjNMKwDucDHsGUg12OxM4dUj3
         8sviVabd8OF9mGEd53yVJl5T/x9hWSCmoh8NjNfTCfkIb984ptV711z0YjGi9d8SACcp
         epng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=adI2tFY3zMTiVIqz1QgrnysGSbGRO2tZmh4DMQNkx5g=;
        b=fENHJTf2+T7zMkrUdZ1BTa4qq6O4Fzn7htCPY9dhXccAED6HZCPYBm+PiKpXOvx8OQ
         zB87wetpoZKbkfVVl7nkPIoaSWae1j/sdgolMxosCs5llSaJj4XtQOGDnuTQ/StN2rM8
         4Flovtlpk8iKuIF2CQnpAv8OCpD6p/EJicshkuRybUKHWlAHhkOAqaUIQQJspSf4Sjdx
         sDGOhEa8JPEBhph4re/XZfznJ94A1wtlDJLn3G9MiuukMs8C3vYg2jH2tGTptwQvKyTM
         0i4wVRYzwFXFbZMEHVr/vLHl/TIfc+1GubEh+3Ht73IoGSP2wRtaBi8x0I/1CpSThmfc
         2ASg==
X-Gm-Message-State: AOAM530A7m4v40/MatpNLnyefxQHptIohYDOMb46S1QgR7V4pCaXMmSG
        TUl6lUGmCcqn/uybNQBvdZ/FQ7svKEQDbw==
X-Google-Smtp-Source: ABdhPJxy5DIEcOKox50wPSoMomHLbWW/2fKEZ3AOe8tQPCVWShCzwi982g6o6Oz0CI7EB9ki3pUVfA==
X-Received: by 2002:a17:90a:ce8c:: with SMTP id g12mr1848481pju.181.1604513732929;
        Wed, 04 Nov 2020 10:15:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm3310561pfc.165.2020.11.04.10.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 10:15:32 -0800 (PST)
Message-ID: <5fa2efc4.1c69fb81.7be53.7930@mx.google.com>
Date:   Wed, 04 Nov 2020 10:15:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-124-g6aeefdbd6063
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 143 runs,
 2 regressions (v4.14.203-124-g6aeefdbd6063)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 143 runs, 2 regressions (v4.14.203-124-g6aee=
fdbd6063)

Regressions Summary
-------------------

platform        | arch  | lab             | compiler | defconfig           =
| regressions
----------------+-------+-----------------+----------+---------------------=
+------------
fsl-ls2088a-rdb | arm64 | lab-nxp         | gcc-8    | defconfig           =
| 1          =

imx53-qsrb      | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-124-g6aeefdbd6063/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-124-g6aeefdbd6063
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6aeefdbd6063e85ed6e56eb786e6bcbfb6868998 =



Test Regressions
---------------- =



platform        | arch  | lab             | compiler | defconfig           =
| regressions
----------------+-------+-----------------+----------+---------------------=
+------------
fsl-ls2088a-rdb | arm64 | lab-nxp         | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2b8083e2e5e106afb5315

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-124-g6aeefdbd6063/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-124-g6aeefdbd6063/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2b8083e2e5e106afb5=
316
        failing since 0 day (last pass: v4.14.203-125-g68bd10b5f0a3, first =
fail: v4.14.203-124-gb8668b06092c) =

 =



platform        | arch  | lab             | compiler | defconfig           =
| regressions
----------------+-------+-----------------+----------+---------------------=
+------------
imx53-qsrb      | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5fa2bde2e9778b0cb5fb5341

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-124-g6aeefdbd6063/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-124-g6aeefdbd6063/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2bde3e9778b0cb5fb5=
342
        new failure (last pass: v4.14.203-124-gb8668b06092c) =

 =20
