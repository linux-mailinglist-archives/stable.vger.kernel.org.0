Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6602A99A7
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgKFQlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFQlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 11:41:36 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59639C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 08:41:36 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z3so1826609pfz.6
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 08:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YHxk/hDb9Gavoiujhaoh2EXMyLwq4ZHPrF9EGVHlZVg=;
        b=JwkNzKpxxcnM1nY6tArC/+KPhBUK/KhxhP5ftel/hf1I5yeIcjtetGOqQIi7aML5NH
         3jlfPkzvCsrW6FuFA85eBr4Aoa6hzHG3IYQTkMaKMJbn8rFjP5C7hwHaz2mTt8iRJGAv
         /MseQ+cZG0rPnDTMhu3XGtthQ+4WwkWLRz1G1mIM7G7drzc4zYqCBzw3+stxQua53Cp5
         42t4KIRdDiKpUTADA41s08/6pClZh+ijoGa54df4FvCMaXx/5XKVB6dTmgrL1fwu0LIt
         uJK0I9CefzDKvrLeV4TP4gMhSd0uih9lVkr8CKeuKSUjbLCO1PdJC75HnIB3GMIPj9pN
         Rd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YHxk/hDb9Gavoiujhaoh2EXMyLwq4ZHPrF9EGVHlZVg=;
        b=P5uMEIHFAsNOEj4Ld22xG2UuKAueYrjTr5QJEo09K6WQPBePplA+vv+4BbJKbz1hF8
         2IJskog3o5OQatz2FRtzVJraHIONxMee1uVU4WibYFakW4etDiIbTE69/8ylI8kQ21Ke
         nGaYlqo8U8/75wobS36ohuCVHOr42OZfHbgF7zcEpIIfLt9TRXArhLMfFf5U9yMUKxw9
         N5PzCkZrk7kqBterlR5ixe2uD9toVxgOJ73ueQH8om94rceSltTSbCRIjjkZkP0ffuOK
         le2G+/Ijh1PDCZtqNV5AaOzNhXJcSy7/Bj3Z+wQ6cEymBD7rbSMPnsJhzLqboUdnfQMw
         r6Dg==
X-Gm-Message-State: AOAM532+45V5CYAdN6Dt1WIEWqm0D5ZIFy4ghCjatl2XNG2ncg6fuN4Y
        UuRiryAO2Vc2siuhsDlhAXI4fdBmqxLYQA==
X-Google-Smtp-Source: ABdhPJypdpr5MQa+NYGkMYkqvtpDDpn0yIZRzJLrrO1GJu/C2ezee5qFaA3LolLPQtlI+mBgiCEJyg==
X-Received: by 2002:a63:1d12:: with SMTP id d18mr2471726pgd.314.1604680895633;
        Fri, 06 Nov 2020 08:41:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm2696082pfn.173.2020.11.06.08.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 08:41:34 -0800 (PST)
Message-ID: <5fa57cbe.1c69fb81.52c2e.462a@mx.google.com>
Date:   Fri, 06 Nov 2020 08:41:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.204-3-g260838f69ee7e
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 3 regressions (v4.14.204-3-g260838f69ee7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 3 regressions (v4.14.204-3-g260838=
f69ee7e)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.204-3-g260838f69ee7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.204-3-g260838f69ee7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      260838f69ee7e908d8e885748336a3c45803d023 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa5479245b76698d7db8859

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-3-g260838f69ee7e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-3-g260838f69ee7e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa5479245b76698d7db8=
85a
        new failure (last pass: v4.14.204-2-g7fda2804efba) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa54a0b5a4938684bdb887a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-3-g260838f69ee7e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-3-g260838f69ee7e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa54a0b5a4938684bdb8=
87b
        new failure (last pass: v4.14.204-2-g7fda2804efba) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa54a0c5a4938684bdb8882

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-3-g260838f69ee7e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-3-g260838f69ee7e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa54a0c5a4938684bdb8=
883
        new failure (last pass: v4.14.204-2-g7fda2804efba) =

 =20
