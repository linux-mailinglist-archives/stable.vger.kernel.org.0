Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1861B33A006
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 19:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhCMSmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 13:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbhCMSmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 13:42:21 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C95C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 10:42:21 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q12so2951735plr.1
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 10:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wTXxRZ1NPG3wTe5oSNXPox9U1OeQFyuRh6Nik9fCBRs=;
        b=TnbxvmCflEG7n1bcsNAlejlfnVYKujwINSHVOKIuCEhFBS+fhu4VHuTKPq2oX6+W9d
         442mYb5qzPM8R5kKRR0BAu/HdEMRGVdQvI8zvb8Z0H5y07HslFuFtZWhzh+M4Ep5R0ng
         yk/kyClD+QciWAYqHR19/JBs5BUAQmpPhdWKHqLH72pkVf5EwE1T3vnNb1s4KVGSme3A
         EPav5mPBut2Ar5icoDXdoXmSrUkbqFURJ6SWVg9XgsIN52vSVrXV0k7u2PL2GbCiQoFP
         vVRJnixKERN3ziaWTFGZapkISHBhWqxricG6bDrSB94LxGC5Rsc1xL2Bw6IdoAExzSm0
         7WDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wTXxRZ1NPG3wTe5oSNXPox9U1OeQFyuRh6Nik9fCBRs=;
        b=XJxvbfX0gCm2lnHhv83QKxkUAhL33xtlWXW5gep8/6u+qZ916HXX2jYwu4Ts/EL0wP
         a3B29b1T2FJMwz4x/B74FgkNyrOZxkEhWcIByDAAT5J8KMAslwQwKPtAleF1+UJfnz7b
         80a4rdJzzxszx47cHIGWJrwmy8y8nzUY70kIazHEHK7Ql4D3q2VHTlPdXX80h/OuTP0Z
         bf2dR25hjLzDR4jQf9jNllT2RgQV18pGeGBFlJmjOqwCeiT/X8V3IxUHqC7a9DP8E7C0
         h+e3H7e79CYPhVuuEblpPtFNElQYKIw78nsJayLoNFR2JbpooPBX/TuJew6G4vqtWth4
         YxQg==
X-Gm-Message-State: AOAM530tVu26b4apntN+9eTlb9xV11675n7rpGRhUybIrvwXnYp3uRh4
        tfsT/caKDb7tzK1+BzwzTyH8t9g3qmNJag==
X-Google-Smtp-Source: ABdhPJwW4LQhinVfk2Mb/nhP3NrFOYaAstBl+wNQG3EcT4is3IUa/LJhyyKEigF9c8wKPsngFWoaaQ==
X-Received: by 2002:a17:90a:5284:: with SMTP id w4mr4684567pjh.29.1615660940330;
        Sat, 13 Mar 2021 10:42:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fs9sm5516465pjb.40.2021.03.13.10.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 10:42:20 -0800 (PST)
Message-ID: <604d078c.1c69fb81.58b2f.ce94@mx.google.com>
Date:   Sat, 13 Mar 2021 10:42:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-198-g7496dbd02b273
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 183 runs,
 2 regressions (v5.10.23-198-g7496dbd02b273)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 183 runs, 2 regressions (v5.10.23-198-g749=
6dbd02b273)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.23-198-g7496dbd02b273/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.23-198-g7496dbd02b273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7496dbd02b27316275e097a4e52cebcd2ca5a5c0 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/604cd24ce6856c8c90addcc6

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
3-198-g7496dbd02b273/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
3-198-g7496dbd02b273/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/604cd24ce6856c8=
c90addcca
        new failure (last pass: v5.10.22-48-g93276f11b3afe)
        11 lines =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604cd24ce6856c8=
c90addccb
        new failure (last pass: v5.10.22-48-g93276f11b3afe)
        2 lines

    2021-03-13 14:54:45.353000+00:00  x00000006
    2021-03-13 14:54:45.353000+00:00  kern  :a<8>[   16.833385] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 799422_1.5.2.4.1>
    2021-03-13 14:54:45.354000+00:00  lert :   CM =3D 0, WnR =3D 0
    2021-03-13 14:54:45.354000+00:00  kern  :alert : user pgtable: 4k pages=
, 48-bit VAs, pgdp=3D0000000007fe2000
    2021-03-13 14:54:45.354000+00:00  kern  :alert : [0000000000000000] pgd=
=3D0000000007fe3003, p4d=3D0000000007fe3003, pud=3D0000000008438003, pmd=3D=
0000000000000000   =

 =20
