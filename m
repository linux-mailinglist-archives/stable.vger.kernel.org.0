Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C197137BC11
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhELLx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhELLx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 07:53:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A05C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 04:52:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so3149423pjv.1
        for <stable@vger.kernel.org>; Wed, 12 May 2021 04:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U6wKTlDHZS45NlVDO5pqYTnVgTamHM8gEXVcoQLmumo=;
        b=l4zudctcPipfpq/Ru7h3l7ddwc1mo9D24EH2BrIW9UaNclgcaHwTzEmtGl0RHjS4Tb
         F6r5CL9B8XKxO70//P3PWTzR1SntkyVsEgQSInDQUSg6nH6fu8lNyufUkmQKqbaE9OCt
         DuWzeq3An9aUfCbYUQBFDyICrMVAhmBml+TZBzaohIy3l8ofEGGayhbk1f8Mhd+sQuwI
         ju4mcmGV4X0VmHHvITJgXL4sAM4dGRnulWD42TeMBxLebq8wmZj4Ch6rLBUAuXd+MWAO
         aH3J9ClXpKRGB6cv1LkUYDWX2TgvRYxKg5+JnNaJIW6DPER2lDlScje2KGZ8V3htYTGu
         9xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U6wKTlDHZS45NlVDO5pqYTnVgTamHM8gEXVcoQLmumo=;
        b=ceaklEt+xT7GrFrcoL0HOH71JCQAcsp4FBz+2wEl3xOslY4mSh+gLaZr1B1X/9Jo31
         RUTaaLUwzQ4899g7RwfcGEAjoivlGBnTXUd5glM0XObPOl7XKvlAwcCfYHjs2zRMeAQt
         CYb4JRXq4nfroddXlSR9ijo6K9bAlAlSy1wT4r32x73wSiK8+4wcE2VstA+Q/dw+0zwu
         VfFqZXgPpQQPZMyAdctDSA6z9XZ3N4bbKkTkl4J4Pqyc9mF32cOg3+Pg+Hfvfz3fbiwD
         vCDiAgCg5NSaVur+5GdYHndxUISopZbG95SUj0/U9K3mUiUda9o1BNlAKk5Y4UC4Vaga
         mE/A==
X-Gm-Message-State: AOAM530FakHp2BCrONajVomZEGfS/NC5mHMTyUgYns76Rb2rZB3kVt7b
        KOjHhgOM3+y0iqhZAfADcRzW4swGgM3xvewG
X-Google-Smtp-Source: ABdhPJwkDL8Osv8pt9O4W2VHnY1ZfBnI32FyCOl6VbAHkD1E6C7Vnn9vudSMxMrTI0MVN+xD/o41sg==
X-Received: by 2002:a17:902:7c85:b029:ed:893d:ec7c with SMTP id y5-20020a1709027c85b02900ed893dec7cmr34111251pll.82.1620820339998;
        Wed, 12 May 2021 04:52:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a129sm16806040pfa.36.2021.05.12.04.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 04:52:19 -0700 (PDT)
Message-ID: <609bc173.1c69fb81.a305c.3901@mx.google.com>
Date:   Wed, 12 May 2021 04:52:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.3
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.12.y baseline: 171 runs, 3 regressions (v5.12.3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 171 runs, 3 regressions (v5.12.3)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
beaglebone-black             | arm   | lab-cip       | gcc-8    | multi_v7_=
defconfig | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-8    | defconfig=
          | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.3/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d795d7b5846cb98eaa66abeb2b0927499ede2af5 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
beaglebone-black             | arm   | lab-cip       | gcc-8    | multi_v7_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609b8f438b70fea30cd08f1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.3/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.3/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609b8f438b70fea30cd08=
f1c
        new failure (last pass: v5.12.2) =

 =



platform                     | arch  | lab           | compiler | defconfig=
          | regressions
-----------------------------+-------+---------------+----------+----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-8    | defconfig=
          | 2          =


  Details:     https://kernelci.org/test/plan/id/609b909ca4699af9dfd08f3e

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.3/ar=
m64/defconfig/gcc-8/lab-collabora/baseline-meson-g12b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.3/ar=
m64/defconfig/gcc-8/lab-collabora/baseline-meson-g12b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/609b909ca4699af=
9dfd08f44
        new failure (last pass: v5.12.2)
        8 lines

    2021-05-12 08:23:47.840000+00:00  kern  :alert : Mem abort info:
    2021-05-12 08:23:47.840000+00:00  kern  :alert :   ESR =3D 0x86000007
    2021-05-12 08:23:47.840000+00:00  kern  :alert :   EC =3D 0x21: IABT (c=
urrent EL), IL =3D 32 bits
    2021-05-12 08:23:47.840000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-05-12 08:23:47.840000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-05-12 08:23:47.841000+00:00  kern  :alert : swapper pgtable: 4k pa=
ges, 48-bit VAs, pgdp=3D0000000002635000
    2021-05-12 08:23:47.841000+00:00  kern  :alert : [ffff8000128268a0] pgd=
=3D00000000dd7ff003, p4d=3D00000000dd7ff003, pud=3D00000000dd7fe003, pmd=3D=
00000000074ce003, pte=3D0000000000000000
    2021-05-12 08:23:47.967000+00:00  <8>[   49.761186] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/609b909ca4699af=
9dfd08f45
        new failure (last pass: v5.12.2)
        2 lines

    2021-05-12 08:23:48.286000+00:00  kern  :emerg : Code: bad PC value
    2021-05-12 08:23:48.450000+00:00  <8>[   50.243236] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
