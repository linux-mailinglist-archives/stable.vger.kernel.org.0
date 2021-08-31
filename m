Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7593FC0C6
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 04:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbhHaCPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 22:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbhHaCPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 22:15:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8973FC061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 19:14:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c6so517973pjv.1
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 19:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ashmbVL7s1GDRkb4lBCeebpFGWPy55cuE3kzKZYAOFQ=;
        b=Zh+3MxuwPu3b74HANgIe4aHZnPnBCm2Zv26zvsWBCVwRONFURrP+ZpTJNggOJNIw+k
         5W6GLBcD3MxnJIkc+r9tI3BxpKeip2cBbdS3DlvSW3srD48Gpejv5qt1liQ6hJ8aViPu
         8Oy0x3gU+Kf4SeglgxVEn519Mc4VTWsEgAMwg/JlDB5lCBUogocHM9nYk0+9iux/GwOv
         b0DE/TVOG2rTzqF5w57/vUY6rk7LjitOkUI9pdRoa9GaolvjdaiIbZnd+fm8Tsil7V2k
         KE/ieJYkxwcheWyA7nq4UiyhaYPmXoxOXm2yw9q11KzL6XCCKQP0Y6AexXXYgOET9PZp
         cylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ashmbVL7s1GDRkb4lBCeebpFGWPy55cuE3kzKZYAOFQ=;
        b=O2XTQlgd9wr4Yfma6nxJztmyaEiwlbyo7P6O1Pn9OugiCLMg//MRikMHDZbosEmS0L
         0l7EuCGnfCmukc5+qAnqQTIa5Bqf0HA0bg+T8TmQNcQeaKuhbvZbAP3xdCuienZd/W4T
         d16Il0NvY3Oag0MYOC4kG0v+ClLTMywaSQf19x0VQc9jxzUXCnMlLWIEUcgk80M4p4K6
         VSgP8z1kBS+7uKNnsMyGz8BoBvMO8eF1ONjzfHvoOosqD0bOo77+E05evJlpyYsXsgij
         ZFCagobtLMmcBSwrKQYKoS1tXp01QsJ55ycyW52A7GkTcFR2z8RxE/HPu8pQEmQP05+K
         1zDg==
X-Gm-Message-State: AOAM5306MFWejEgWDHnT6H0CQJg+2auwiUA8ucYg30KEhb9D8g7qRlw6
        5aRuFn7Xtnb2r7eJn7P/7nCHw1mkInQkci5V
X-Google-Smtp-Source: ABdhPJwW8C0q30EQVfjtj2XBoXM/yvEngaTlxn7/fBVIRCGpRJ/uQSBMndQ07Edo1+4VB8VIGpcyAQ==
X-Received: by 2002:a17:902:680e:b0:138:b98d:4f89 with SMTP id h14-20020a170902680e00b00138b98d4f89mr2409877plk.31.1630376084844;
        Mon, 30 Aug 2021 19:14:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm318043pfd.188.2021.08.30.19.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 19:14:44 -0700 (PDT)
Message-ID: <612d9094.1c69fb81.6570d.16b7@mx.google.com>
Date:   Mon, 30 Aug 2021 19:14:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.61-70-g66c70ebfc197
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 1 regressions (v5.10.61-70-g66c70ebfc197)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 1 regressions (v5.10.61-70-g66c70e=
bfc197)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-70-g66c70ebfc197/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-70-g66c70ebfc197
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66c70ebfc19785045ca1678b088433c0e09be027 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612d5eef527dd49f1f8e2c9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
70-g66c70ebfc197/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
70-g66c70ebfc197/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612d5eef527dd49f1f8e2=
ca0
        failing since 0 day (last pass: v5.10.61-22-g87253edb385b, first fa=
il: v5.10.61-53-g938272055897) =

 =20
