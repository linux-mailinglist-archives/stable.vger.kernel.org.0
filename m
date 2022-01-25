Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F15349B6FE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350587AbiAYOyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580744AbiAYOwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:52:03 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E4AC061776
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:52:03 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i17so2474166pfq.13
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rQ5XN2lu5SOc5uDZMF4NqxWl90NhdVWdjZW5E/Bdl/0=;
        b=DdzvvH7CSERWDUI6x3C8LwxRVxru69AIOpLK9sl4BW0luBXwN9e5rlsXD73uzWQnF/
         dZGaUWfh+HzLAkmRkKQXI5/AZkuaDbw64eV4mYYEtQ1irmzvkcimJjATSZpCJ0tsdBDP
         AQrMrpvpT5bqFoT+T7cbcVJc3zjhqUHXCXsbZCKz0YN5xKXNyu6Vgr1ns48+aKYkP/sR
         fwHcxiLs1yGMst6TBFpMYkOQC1impcKjY70AF8RQG2cDOuo+XnGgdoepfJKVMh79/iku
         0ue54Xdn0NZTNB3Un6vrXZykOIvIlpI0yO0Ll4FJT4wY0cMux1cQgAIXpuyBDiKiSwHQ
         XZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rQ5XN2lu5SOc5uDZMF4NqxWl90NhdVWdjZW5E/Bdl/0=;
        b=23RIjIF3ZdsQ+ic7hFyUEREaZZI+H3J92TXhzoAhPk/eg6YRSear2gEwml5H/0Ulal
         og4Lu/VSpvng30IdmeGD/LW/fvaCf+qnXoYtxSYqwBt60XPFv6o+fOXku2JlGTE9VS5Q
         MpTXPQZ0akkNibOgi+z4Rw0QMITMJSkh9XShDSGBLtovS5IxSQ8s3TM8WnysLup96G5s
         nrJ+F1RF+IL0RccpWOYNLHSD2WFmzWRmmxi3JVP5q6ALF0Fk+4qK96+nZmHyYrGglb0c
         vFPbS/x4Ya+EBiI96NQL9CTUzoFeZfRccBPCiyBuhjb+MEBZLSx38ZcSpPGL8LP63sG4
         U4Jw==
X-Gm-Message-State: AOAM531JVXGnAUXSJ87OHun2V6ZN4BmxU8uf+KX2wbLY7Q5Z0qgh2TpU
        5qTuBc+GQoQBCLjOyZTL8J4s/kW4aVCIL0F+
X-Google-Smtp-Source: ABdhPJwVXiIEUr+nYolzZUqGcyMmN8mFodXzcu6DGHPoVXziunDDr5mQWRI7kx0rAwNfzUBpBbNKqw==
X-Received: by 2002:a63:33cd:: with SMTP id z196mr15317305pgz.78.1643122322583;
        Tue, 25 Jan 2022 06:52:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a186sm14902211pgc.70.2022.01.25.06.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 06:52:02 -0800 (PST)
Message-ID: <61f00e92.1c69fb81.27aee.9333@mx.google.com>
Date:   Tue, 25 Jan 2022 06:52:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-157-g84580a31d426
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 1 regressions (v4.9.297-157-g84580a31d426)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 1 regressions (v4.9.297-157-g84580a=
31d426)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-157-g84580a31d426/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-157-g84580a31d426
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84580a31d426f2eb79afbf836bffb837686d2055 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61efd40836f41ac06cabbd3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
57-g84580a31d426/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
57-g84580a31d426/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61efd40836f41ac06cabb=
d3c
        new failure (last pass: v4.9.297-157-g670a9111c52f) =

 =20
