Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3104484494
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiADPbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiADPbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:31:01 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C92C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 07:31:01 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id y9so4499187pgr.11
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 07:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Npm8dN3irugNGBKK8WLuq6yMGMxHYzfyDN/ghP6nl2M=;
        b=FQpfna8bSUYNlZyKX/3qcD7bOAxxnbaoztzcOCh0zZmF/9jpuigwzydGAEz4YARTk3
         HjSYIf4Qkx6neQwXkPgynk1+fpujrhQ7/DbKwUUBQg30gAXKgtRFGmPs/zDqBcvC/dec
         2O94QrolGAfOKu3AKhOjKCpj2LBhUMYS7VMXIkNd53nqdbkOPl4UDEyOk2dv3lYfwJjc
         vCaLpwz91vuRvk8PMKq3H7fvpOELVjzOpOIVrAR8/R0JcjUzXcPjWLYQZTxpfJqQNZqq
         UReDiktwAPdGhtL9x1wfM/s/OTR66Klw7dD/HVidgSUwYmi17tbvaGFsfTK0e2w7vKQ3
         Kqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Npm8dN3irugNGBKK8WLuq6yMGMxHYzfyDN/ghP6nl2M=;
        b=i51Sk91N0JHLsfE3DsBDs9EbvmRpnopRUBuCd+rwqnkndLjL95i2J6cegvBYC+CFcE
         yBfKoNLOqV1JcCl+Mjf7wdr5nlKXhR8h4rKXqOYxI/WDC3/JRoRSlJphTtoxicRZbR40
         jwm4ly9wDGwLdUyPX6i1ZFUE5pTQcQRD4yhUfhLj4Ymhn8CfIQGXIdjeHIcFElP6lb+T
         Y3HFVXysQKIOLRBvzBkXcnF/AZQz/wPga6HRGhzrL7l+feWoVa3Baasx0bjZawVYex9t
         aIyexsQLGJY2ZK4OwOFRBDn/xahWuw0sf3iCUOrxipmKJVMbUfx3u5nf4BgyO60FP5Vd
         ufQg==
X-Gm-Message-State: AOAM532FzFNqtdtNT75yQR3KuDvv+dhK1yMU9y42wruPaiewwGGP6q4G
        Sk324I070vIIAHPUStps2CTQUCOcUWWDHw7K
X-Google-Smtp-Source: ABdhPJw+0gImMc/lIRukOXFQiGr2nroLZi5pmqMPHmB5deHYxdyDJm6VuHJSFq7nttEh4W84oCAxXQ==
X-Received: by 2002:aa7:938d:0:b0:4ba:c445:8761 with SMTP id t13-20020aa7938d000000b004bac4458761mr51712978pfe.12.1641310260617;
        Tue, 04 Jan 2022 07:31:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw5sm42502001pjb.13.2022.01.04.07.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:31:00 -0800 (PST)
Message-ID: <61d46834.1c69fb81.7cddf.ec59@mx.google.com>
Date:   Tue, 04 Jan 2022 07:31:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-14-gf0356246206e
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 95 runs,
 2 regressions (v4.9.295-14-gf0356246206e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 95 runs, 2 regressions (v4.9.295-14-gf03562=
46206e)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
i945gsex-qs     | i386  | lab-clabbe   | gcc-10   | i386_defconfig | 1     =
     =

meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig      | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.295-14-gf0356246206e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.295-14-gf0356246206e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0356246206e02f32675fd81017b5159b3eb9799 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
i945gsex-qs     | i386  | lab-clabbe   | gcc-10   | i386_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61d435c332594b2558ef6755

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-gf0356246206e/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-gf0356246206e/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d435c432594b2=
558ef675a
        new failure (last pass: v4.9.295-14-gc154c6cb3efd)
        1 lines

    2022-01-04T11:55:27.322201  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-01-04T11:55:27.331165  [   13.120893] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform        | arch  | lab          | compiler | defconfig      | regres=
sions
----------------+-------+--------------+----------+----------------+-------=
-----
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig      | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61d4347200f30aed2fef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-gf0356246206e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.295=
-14-gf0356246206e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d4347200f30aed2fef6=
763
        new failure (last pass: v4.9.295-14-gc154c6cb3efd) =

 =20
