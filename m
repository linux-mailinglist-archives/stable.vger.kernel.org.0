Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC5D2CA34E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 14:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgLAM7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 07:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbgLAM7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 07:59:06 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82BC0613D4
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 04:58:25 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 131so1051772pfb.9
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 04:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FBVLLDN6JoKT0mrZEqVPmF84306EXDWkwDhmceFZiEE=;
        b=o10pmFbGKiEy8RmPY44HBzGs4W57nK4e6VtuhsFIecdlt7aCO2YeUqbP6g/PSJbFjV
         r844gz5cXiiMhqAL2ihkkHHGhZa3CCKRD96OSSokipy2tAZCt4paw/yiw2dXtX5CFODM
         SKf3pMr/uM5+w1ixFayH4dduTidsfsd3i3o719XCZoAerzUfvAiPVRHM4ElS2lv+cJ5j
         wTE+CAUzaFmgCY5Bf6+oWUXvVoXO0snPqvaDLBzKrdaEizUmHLcd55UnZH2y93zuy5b4
         Flw/IxMXYk2arEd/8cSl7shNy2YIiLOMZF10XcTu4diA1YKxJCx7q6r/JUuIJlfscNJW
         aPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FBVLLDN6JoKT0mrZEqVPmF84306EXDWkwDhmceFZiEE=;
        b=Ra8oJa6X2lrnPXeReT11LpgqqbJaYRxMAUrNELEYh242IzivhGAUsIsgVUOWA/Dn+v
         i44xp3+JPwGj3NTPVrvKWYFDe8YruBwfhr+P+oiG4RgxNvYNASj0Rc8ptU8x1sQ5b4KX
         PugAcs3hu0ID8p0Mr8zcY4l0gcf6VW0StqbNc4rya/1JNPb4NYhl0faMZFMGNwjXSLSY
         iGEjLo6P0fTZh8Fn8fd0PRXpo0mvYYluM8Y74OLGzv7Hsr/XA3CNpJhWDOBnnUh0/8wL
         mvvyMwtI2jGuaR9reKuI0a9h/T7FgJRkrggTceoxrXTRoRRUjIEPmhmjgNLpODMvCqMb
         xtuA==
X-Gm-Message-State: AOAM531fv5++CJ8Iamr/xZr5sL0Ph1vfF4CE5eFdYugEbJHe+STWxg5r
        nF+mYFC/0+QDeTNOi1ACLGcPlRyDKuDHyA==
X-Google-Smtp-Source: ABdhPJxLEj7Kg6bUshwyniNUy8Oc1Hv9oRLcAIfvMpceO97H7V4WSDv/b6dD5VVFW+jUHquml7AeAg==
X-Received: by 2002:a62:d10c:0:b029:199:cf94:f33a with SMTP id z12-20020a62d10c0000b0290199cf94f33amr2408461pfg.16.1606827505131;
        Tue, 01 Dec 2020 04:58:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm2781961pfe.65.2020.12.01.04.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 04:58:24 -0800 (PST)
Message-ID: <5fc63df0.1c69fb81.fc3bb.5714@mx.google.com>
Date:   Tue, 01 Dec 2020 04:58:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.246-22-g7a10548606fc5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 33 runs,
 1 regressions (v4.4.246-22-g7a10548606fc5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 33 runs, 1 regressions (v4.4.246-22-g7a105486=
06fc5)

Regressions Summary
-------------------

platform       | arch | lab          | compiler | defconfig      | regressi=
ons
---------------+------+--------------+----------+----------------+---------=
---
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.246-22-g7a10548606fc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.246-22-g7a10548606fc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a10548606fc5e71ff947b2594df31fb45bcb5b1 =



Test Regressions
---------------- =



platform       | arch | lab          | compiler | defconfig      | regressi=
ons
---------------+------+--------------+----------+----------------+---------=
---
qemu_i386-uefi | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fc56f1f303d1e391bc94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.246-2=
2-g7a10548606fc5/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.246-2=
2-g7a10548606fc5/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc56f1f303d1e391bc94=
cd5
        new failure (last pass: v4.4.246-20-g079da72c36509) =

 =20
