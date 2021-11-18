Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC4E4561E9
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 19:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhKRSFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 13:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhKRSFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 13:05:16 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B34C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:02:15 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r5so6099373pgi.6
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 10:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t/EXr+oMzpoBCjL0wailQ0KhKwey32csRQWIbfhW/cc=;
        b=T5CSFdL6B7uounQwsjxK1ZMr4oZBZh0b/mHcMlF32MFy1mnHHATjNMZ3nRkk0l/mnj
         eg/9h1QIz0XYDnK2a1Pby9hX9KYjePaWC38hsHaHPvopreFsFyD/8DGof2Y+EOxIGHH+
         WiVmftqcqOHEFPTRnImraCYAWa35h11DL1tevljx17mdgU38UAAtE/Cz36dHLrXhNcTa
         ygUQL4SDbHpslPOvd3cjciwcWBT6mf1BLijpQZkWieTyYxIK5AsqWjy7qOC+viiWzkQg
         3wMnw7HlQXEiFVnrx3VtdvnQw9GTSH1t+Stunw17SG1Ffr7/DHSt9lR028IFA0jslwvg
         Mk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t/EXr+oMzpoBCjL0wailQ0KhKwey32csRQWIbfhW/cc=;
        b=WqhbLQzzo0/9AJEaPRo85K9t+373JmjV0VA4WkXFiJJsfxGhxBvwPXg1mMeQO0dmCG
         MjGLFklbJa4GIad21N8r6N5TroPB2cduluynrqV88nnZhMGyHG3OD954EyTxAy8yEqSS
         E78F8wbaNtlVwKUo/FG7Xup7jSqTIR8NFFJ8bxSajUbvXL0ZbQUmkr9VwJxZPJqwPZYy
         CP5LkjZv3tuH8my3tAjEkEChj6yqpxt+c+3N7SHiNKc9hBhYYJXH9MhTA66Xh9+g0v0J
         m0bqxIpAmUCPt2tAqV9nvMwPTFwd87OaemURBCtoUvl/UuVKmA0tX403tFLWYyCteljE
         xDJg==
X-Gm-Message-State: AOAM532h/raxP0sPFN5eJzUKGW0GNk2Fh+AvOEahM7LidRAD12h/0SbD
        0vplfDTX4U6H/UOzCEU0G6CUvhXqHDdIjsKt
X-Google-Smtp-Source: ABdhPJxExlWQOr4pTHfIfkY8NK0o+x2FvNG7sP8lmaw/w91jJd79q8RqMJnbYvv67q74D2MejaFq9Q==
X-Received: by 2002:a62:15d0:0:b0:4a0:2dd5:ee4e with SMTP id 199-20020a6215d0000000b004a02dd5ee4emr58538212pfv.14.1637258534905;
        Thu, 18 Nov 2021 10:02:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co4sm9062342pjb.2.2021.11.18.10.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:02:14 -0800 (PST)
Message-ID: <61969526.1c69fb81.5fd98.a3af@mx.google.com>
Date:   Thu, 18 Nov 2021 10:02:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.160-4-g477a37096746
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 145 runs,
 1 regressions (v5.4.160-4-g477a37096746)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 145 runs, 1 regressions (v5.4.160-4-g477a3709=
6746)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.160-4-g477a37096746/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.160-4-g477a37096746
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      477a37096746b80259c66810e3af79348b057c04 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61965e4de662758960e551ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.160-4=
-g477a37096746/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d=
-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.160-4=
-g477a37096746/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d=
-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61965e4de662758960e55=
1ed
        new failure (last pass: v5.4.160-4-gb13bf6dfb5f7) =

 =20
