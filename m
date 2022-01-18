Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4F492B85
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346299AbiARQuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiARQuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:50:39 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AFFC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:50:39 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o14-20020a17090ac08e00b001b4b55792aeso3111306pjs.3
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gtuufH0a8PBXmWdmoYQBTCb4S3MumRkctpBg2fnUOZY=;
        b=LoQaNDBv9UK3SOBFpru+wLV+ArFcCnVyhOsvAzjEuwzS4Am+HZM+PNcVIh0S0cCBXm
         jRNnAa3Te9No9Pk4+VzT6ATduc9eXY6qr1h6oLhPu3CpFzz+6pTdrdteCAjwdJ7Vpt6+
         a6zhWdKpakfXh/DcyQIyf0csav8GWolZuKzSEjZNuoC6Y8hSLYsyco1mJy8jnYwmiVey
         ODy5FaAH93GtgwCvWGc253ycpkwsY0T9r/9Bupd6QSv/Xz/GwfUt3/UXoeenyndgGoZs
         U4ZqCgyPpdeejo4+DCpZkTPovyM3UAP/LXTdkHPC7b8B4pwhkYC3LAHh9iISRxirAXkk
         DWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gtuufH0a8PBXmWdmoYQBTCb4S3MumRkctpBg2fnUOZY=;
        b=gBd99DzBJsF3iN3ozbXZFRK1L6ZwHIc4IODg5phZNKpdaPoujyGwx/AQSKBLtt2yLb
         a5oTfvIorX+RzBmyXzv0eaD7tpOTuqX5lSBB+nYlHDyJezQ1qwl3t5EvqTnElVe6KrUB
         mgjzUcq8ZDOmt/7ycVAFMfXRqjOUKqTnDaj+9+czmjZHdGCGbto/nbEgoDPAbccfq/lA
         qJ4ktHPZbIcPPp7WkI51UM6S+XNULmcSceq1PMssf8W+xFNfSEb5teNBs5LfbrIRp28t
         d5qNYu2nAsQrgVTnjwKnGJHq0uK/0JOWsfkri9IGp3xDqTbmzK0RtbapTF6sxVEFRMbA
         dOJQ==
X-Gm-Message-State: AOAM532hvlC7zYT2KA3rlbfTxjEBkCBXi6bmuTPV58Eab1xNWu2wIDDy
        fCGBd2oG7dDZkyR7aSMHpzVJr3yMsffo/yEM
X-Google-Smtp-Source: ABdhPJzFZxEIWPGRbs2qbx5K8yXitQuCcjwWKnEkjPqWkKw0Ii8arX30SZC8qkyZJdZF15MlAM6QlA==
X-Received: by 2002:a17:90b:1906:: with SMTP id mp6mr33682820pjb.221.1642524638643;
        Tue, 18 Jan 2022 08:50:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6sm15435695pge.50.2022.01.18.08.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:50:38 -0800 (PST)
Message-ID: <61e6efde.1c69fb81.f716c.95f4@mx.google.com>
Date:   Tue, 18 Jan 2022 08:50:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-47-g6c855c89aa97
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 1 regressions (v5.10.91-47-g6c855c89aa97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 1 regressions (v5.10.91-47-g6c855c=
89aa97)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-47-g6c855c89aa97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-47-g6c855c89aa97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c855c89aa9771901e052c048920ad3a326c03b8 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61e6bd48ec55e27d6bef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
47-g6c855c89aa97/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
47-g6c855c89aa97/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6bd48ec55e27d6bef6=
753
        new failure (last pass: v5.10.91-28-g5f88f205517e) =

 =20
