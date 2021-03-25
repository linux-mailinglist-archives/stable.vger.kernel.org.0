Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207B6349646
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 17:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhCYQCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCYQCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 12:02:11 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5E1C06174A
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 09:02:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so2516072pfn.6
        for <stable@vger.kernel.org>; Thu, 25 Mar 2021 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=08bRxnhYhs+ZttJI92DU8qyDMy34sPvqzHB2pSNtcm0=;
        b=XYzTXQ61GK1jgZ8p/vAMzG05K7Tzt/qyhcEqFyrYQnkVJbCw6pxzWthnbq1TQehbDZ
         KFmWcwVbccNnLBQn5vSX7pvk4p+y7e7bGVhtq2r4OBRwo6t+YdLcOXOivt3ymYuTv9It
         1cjYLNmHTuaaW44uY/wx+zmledSPSWTN8RC4XmeIie6oxrqL3lXf7Jo+2FxzfUW79TZg
         N5WFWs5WrdRJpIbywa1cLKNXCcuU2R5acC0z6clpdJ8YOLXtxKKmIiEYmWDhFUoFi9hO
         cXeGYfy7mvQaIAYVrWTqGr7cr5fO7qADOeY8w4jCtYyT9oipoXXwgpe6hsz6zPqJDKPI
         Rh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=08bRxnhYhs+ZttJI92DU8qyDMy34sPvqzHB2pSNtcm0=;
        b=QN/Cl5GfK+i0cp6LcfWEEhQ9QgbRav7VWxV5oufVXNAC4Dg2FueX+gwSmYAhLe7mCr
         XNdi1zLMQNuLa3h+pWNlfu/HMpsEfaTrum8W+xpl4K3ekhcq1Mbqvf6hzloKf4ahszrx
         p0GkeAfkHfJjKQ/gIcq3c4Js6LgQz2E5fBdnYExskJzzgx1xvLVrIg4pZphwV8LnbZyG
         9Znn1FhepanPpt0ob92aJPdwscbFIRpfe+fTdGNMVhC5cJ1GozvXfkr5JPmvG/jF2ati
         pkNGI3mudSyDeOMl9KrVhvbyXmuHj7CQCEs8YCdUINtr9PBXUfQBevu0pWXl5CXX69gO
         YAGQ==
X-Gm-Message-State: AOAM533juDC/Mqld9EbPoCnstlihXsz/KLSwoHrGApFVjPSW6IsWMmyL
        uCwqFAx/cdgCwgPjoU3WHw9x5s3DigzfTQ==
X-Google-Smtp-Source: ABdhPJz1bpL4c0ES0h1xlK+vCOkUhjhQ44NEPpC0toQlSIIn3rM5hcVorj72zdV/PKqwt1ojNdI7Xw==
X-Received: by 2002:a17:902:aa0c:b029:e5:da5f:5f66 with SMTP id be12-20020a170902aa0cb02900e5da5f5f66mr10292862plb.81.1616688130103;
        Thu, 25 Mar 2021 09:02:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a144sm6556757pfd.200.2021.03.25.09.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:02:09 -0700 (PDT)
Message-ID: <605cb401.1c69fb81.9edac.fc60@mx.google.com>
Date:   Thu, 25 Mar 2021 09:02:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.108-1-g214e806feaf8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 141 runs,
 1 regressions (v5.4.108-1-g214e806feaf8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 141 runs, 1 regressions (v5.4.108-1-g214e806f=
eaf8)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.108-1-g214e806feaf8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.108-1-g214e806feaf8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      214e806feaf83ee0a00982396b9d2b0c5cb8c75a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/605c7953fd126c10adaf02ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.108-1=
-g214e806feaf8/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.108-1=
-g214e806feaf8/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605c7953fd126c10adaf0=
2ee
        failing since 125 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
