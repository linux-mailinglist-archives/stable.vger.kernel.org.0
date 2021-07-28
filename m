Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0C3D90BB
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 16:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhG1OdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 10:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbhG1OdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 10:33:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE570C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 07:33:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l19so5502729pjz.0
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oG+3ZQyy3F1dnDEsbE6T23AkYpgyYveEkoHbvmODhL4=;
        b=ocq9ocamXjxpsb788OwFOwNGUK7KdgU7j0YGpeWi/lRS55vIhGcvBMCNQAFbtdNC7u
         8oDd9FyqHZBeHx6qx/r9YegvTBJ8LQQS58Vts7mDc8GMfr0Kh7EwSsF8JLHP28Dqj7ho
         YekDkJiuU72ypMh5bHE1MIQsnIN0KQH5nV8HKxOfbeSlgRsKkzb6RNQ4PjI7na/30sAm
         KfzcgD89bV+xSeyMTu/FlbAcCPfKTAeExHy32ZtKzqNwCQVV32r5EDkz8T4c7iJh8cin
         vE0vmPh/8ReD1xxcKejtHg7XsyTbAtR9nsE9Pw+qPErq8vKf6XV0e0uzTGya9kDP+xS3
         5TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oG+3ZQyy3F1dnDEsbE6T23AkYpgyYveEkoHbvmODhL4=;
        b=ICbWhomVNKvQZdgwR2EumdjDNSJd249o66uijP9xWF1Ezyf0czGlV35W946xWLJy/B
         IkBIumMcxG8aszjh/hIWx66qYGT8n7Rr7RTJGBrKgfei8BQ05beYIoGSdfcmWQgDVrP5
         oztQmgHdnj3lDB5UXK9ivYtrfXlJDYrHfJhPuMFVUgg1tg6RHgUwiCW9PqLPvQZSm7Tj
         aOYPG8bnI6ckU4BFbL0BCoYPwje9CMLZ5CghYPL9vSOoaPTG1aLLapt7oMjWgz5kGVqC
         MGvmj/m37NkjTOB26BdkG8/YND88GJw0ix7hJPnEqaPbY871F4KFzxgL+y1If/lR1n2G
         JTRA==
X-Gm-Message-State: AOAM530CqUCxzcYuwq/Yxc1ezRzBs5nSxOkPH0+4Kt4p8A+L28DmQ2Fq
        8q+j7KM/7G1vYD3yHtEFybVKDBrTfvkrARrd
X-Google-Smtp-Source: ABdhPJyj2EvzW/310XGdXw/lsyBdFFBaFP/rOwm3fWEBv4TMSOX0m0fDdF1rcVoBL14ZQTLuZNfgwQ==
X-Received: by 2002:a65:6408:: with SMTP id a8mr131363pgv.242.1627482800102;
        Wed, 28 Jul 2021 07:33:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t30sm8732020pgl.47.2021.07.28.07.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:33:19 -0700 (PDT)
Message-ID: <61016aaf.1c69fb81.34267.ab5f@mx.google.com>
Date:   Wed, 28 Jul 2021 07:33:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.53-167-g7fbcbc1a9534
Subject: stable-rc/queue/5.10 baseline: 125 runs,
 2 regressions (v5.10.53-167-g7fbcbc1a9534)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 125 runs, 2 regressions (v5.10.53-167-g7fbcb=
c1a9534)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.53-167-g7fbcbc1a9534/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.53-167-g7fbcbc1a9534
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fbcbc1a9534cadb5533d0ae623988c375eb750c =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/610132786346a9fc24501910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g7fbcbc1a9534/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g7fbcbc1a9534/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610132786346a9fc24501=
911
        failing since 16 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/6101359a3f25b69ff15018d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g7fbcbc1a9534/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g7fbcbc1a9534/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101359a3f25b69ff1501=
8da
        failing since 16 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =20
