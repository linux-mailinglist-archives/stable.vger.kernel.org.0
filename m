Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817712AE5FE
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 02:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgKKBr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 20:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbgKKBr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 20:47:26 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA95C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 17:47:26 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id e21so336730pgr.11
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 17:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qdgv2qiwa6hqLaPdoG6PDJhGlpujjA3JD/eEP7hM7Vs=;
        b=x5etfvNjtRuvwDr4TZVrDR/9Sm2S8lalui4MsKelXywLklsjrlO6v9bDWXPnmAkTwC
         FxL1BR1sSvPkZky4RHUoTcJM1kkULTOKUi2NOQs5ek+Gjl5hOJcdu28hGpa1XJWAFfh4
         Jb7LzGWdl+lRGmowNV+2z+ctPyJJj9g/etrH/pbyxfB0MApp8uzBKjoQ8nOG/4PAWWkq
         Ldqg30Z6BR6bnBwalt105D9EuvT4tJ+Fvj1Or8qJ/QMRcyneH1q5TQ/ehiYxTfvApB1A
         gCjjfjS5IZFBczrxUbGAlW2XgQpMmhLgOcCiwwp7Yt+7REbM8n6wpEk+Wrx2t9vJrHUH
         LaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qdgv2qiwa6hqLaPdoG6PDJhGlpujjA3JD/eEP7hM7Vs=;
        b=RUR6eK0hEa41Mxk5tck9/wvt/NbO1aq8EggJILIjDtp9eZlqUvspN3mjNsF9rhMb2v
         zDmhcICOnaJZM4gQCsU7/+yVpBAwQoRS4xXGsZxh9+aN6OENNbiZTGU+6EAAdqhxTEQG
         Z9BExelXy7Wm63haYtxbZ6P4qVM+v5rDEtVlMKjaTC0+Lb4mL3W05Y0QxfsShSeLnFPr
         5W1vTwtz022uwtu9/zdiAisHr9AIApBCDP2RX2mskMaeIWXIONZCacTMgT9cmLrO9BwW
         4kEzQWh8kz28uipifenG7mkEwcyv6XYhdNnBsnmojAe47A4ESXt/BzUuAM1pN/s+2ZrI
         eZNw==
X-Gm-Message-State: AOAM53218kA5nByx3BfsReXAq8Vhvrfvw8SehCmE+FYTRlZ92RU2ft9U
        NqtaF0NvzoTIqQd02cJWJ8xDCax2jvM+uA==
X-Google-Smtp-Source: ABdhPJzQ05WI7tveOzZdYJm7KeG+rKlhNkKUdHKxRxh3eseYqWd0EFE7y/V7gS7urgY4+67j3OlNhw==
X-Received: by 2002:a17:90a:ae17:: with SMTP id t23mr1265906pjq.51.1605059245173;
        Tue, 10 Nov 2020 17:47:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k21sm369705pfu.7.2020.11.10.17.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 17:47:24 -0800 (PST)
Message-ID: <5fab42ac.1c69fb81.f7201.1729@mx.google.com>
Date:   Tue, 10 Nov 2020 17:47:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.206-20-gbe781f4237897
Subject: stable-rc/queue/4.14 baseline: 154 runs,
 2 regressions (v4.14.206-20-gbe781f4237897)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 154 runs, 2 regressions (v4.14.206-20-gbe781=
f4237897)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64      | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 1=
          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-20-gbe781f4237897/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-20-gbe781f4237897
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be781f4237897db466061198f9fb4af07cf4345a =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64      | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5fab0df821561d9a89db885c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-20-gbe781f4237897/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qem=
u_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-20-gbe781f4237897/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qem=
u_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab0df821561d9a89db8=
85d
        new failure (last pass: v4.14.205-20-gf2fb733c4d17) =

 =



platform         | arch   | lab           | compiler | defconfig        | r=
egressions
-----------------+--------+---------------+----------+------------------+--=
----------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5fab0e364cfaac579bdb885c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-20-gbe781f4237897/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-20-gbe781f4237897/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab0e364cfaac579bdb8=
85d
        new failure (last pass: v4.14.205-20-gf2fb733c4d17) =

 =20
