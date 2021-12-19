Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7769547A26D
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 22:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbhLSVv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 16:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhLSVv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 16:51:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA753C061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 13:51:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gj24so7556424pjb.0
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 13:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wAIGXs/JaB3MzBlX2Mqf8XLxiQu3i8fEopmQoj4YcJc=;
        b=JOnP1MID5jT6FeSbb+HHRdxJruKURpBVlUv9wfeAaIQRamNewuSVabzl155EtIu8RE
         kZ/K/aOUOtuwdvD8opfKKgta3UDQnjeivTm0MbHlNWFVeKYT6EBnvh30HwCcT8FQ+ws3
         y6NosmoZazu2zlqbhSA79PKuGiCuoaQy42/8wvv0ndgrt6T9/gEsQZaBIzRFrDnh6ciX
         CYcY1BWLA8YfF4zfeVj5m+/Cc5N+sSoQrVQMI0RrvuJ4vzWOBuapN+numsX9HOHnnjPA
         kc2vrbHWiCRNP+y0VIdpKoYhRKwh2v8CK8SG+xdSf7g6EtvfCn0sMFVv4qUBSm1LpD+d
         NsdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wAIGXs/JaB3MzBlX2Mqf8XLxiQu3i8fEopmQoj4YcJc=;
        b=OjenikzBNTHuPEKq+mrRXoEyTP4Av9cySG64WDG3BzpBz+Dxe66naXEpABCeb0hrYw
         LfUe2rCkP8bRqmkVOzyGUpkCSfoIgozbMcamneQEEpbTGP/vI3qySNQ+hAXD6IDdJOqd
         VSRcdkitXmiWFdhC2wLcsfMIq3qkEr9htCrFFHn9ndyDFXFyLFUekPsy+HZ9L9YSnamT
         FlqSH0hlif49h4etgvnt9rBcDZih72x1v/92n4KGxVq3PslEdsdY12AHjFLNoHaXG5tq
         x5hREATstpAgXDSBhDxsh2oP3yCV378tvOL742gzQZhSq8lypWXNKrbRYInzbAoLIEWf
         dudA==
X-Gm-Message-State: AOAM532Gr/tG3pbcefzyBHFCWhsWeRYr8sGBnJlmPjtbwmd65GNs6xgI
        b1ncCEV6BnvpY9/V6qYFZge3l3Zi3fpUJuBU
X-Google-Smtp-Source: ABdhPJy6028aOb2ANNi0iY/tVwhde3Mp147LWfXpHIPvL/yiZYrIuVp3qiy6A3fu+FNhO2EVsezVlQ==
X-Received: by 2002:a17:90b:360e:: with SMTP id ml14mr7375706pjb.135.1639950687266;
        Sun, 19 Dec 2021 13:51:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h22sm5725539pfv.184.2021.12.19.13.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 13:51:27 -0800 (PST)
Message-ID: <61bfa95f.1c69fb81.f044.05ac@mx.google.com>
Date:   Sun, 19 Dec 2021 13:51:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.87-62-gec26c797e6cc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 187 runs,
 1 regressions (v5.10.87-62-gec26c797e6cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 187 runs, 1 regressions (v5.10.87-62-gec26c7=
97e6cc)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.87-62-gec26c797e6cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.87-62-gec26c797e6cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec26c797e6ccde58aeb28f59676a20e40985303b =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61bf714bd39d38bd0239711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
62-gec26c797e6cc/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
62-gec26c797e6cc/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bf714bd39d38bd02397=
11f
        new failure (last pass: v5.10.87-63-g1b969379182f) =

 =20
