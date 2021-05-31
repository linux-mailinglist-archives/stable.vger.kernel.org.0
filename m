Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA7C395848
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 11:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhEaJmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 05:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhEaJmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 05:42:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7FEC061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 02:41:14 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id j12so7952039pgh.7
        for <stable@vger.kernel.org>; Mon, 31 May 2021 02:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uR6ItW4pJwKdwBUafqfsXV2Iw3BxddbLWAXOTd/A/FE=;
        b=fbPNZzee69atZeL6FF5s0uBSM14wA0DwJKhdIJUbGtgtmtO6GuT7AVy2I/tWnNuP/1
         swirKAP7ABMzd2rGjufsVXT8K/K9adVTGOZ7L0MqzBkRvqFNYJUweIj0ve+qFDpEmSll
         BEqsq97VQ9XkQMB7Yt5VzWXGvnNjr7eaBZG6/zrYdc/Fdvaj9kiWdXhyLtNh6CuHsFIj
         yfQ+bxepk33G3c2k6vkC1fP1C6QqxrwVq3GrfVO7VdLHmPB7Znub+XEXiz9tmMaY/Qdc
         uHGTwtKbomI7njcJDqe8ixJ6JYn1XsNYtPPJ1A9ZELzFJrgpgqA4sbumNlf8jV9Y+n4g
         COmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uR6ItW4pJwKdwBUafqfsXV2Iw3BxddbLWAXOTd/A/FE=;
        b=NxRLuGIxedQzP845bGVxw7hdbrAYnpMjMCC3bMTcJXn1NXvSYre215CVt4DlMYC7Ew
         QnY/+wtoPsuG4F0sUpHm0MK+vM14c9rTiiauTfOLHfbAMSCz6js6+n/CX2Z9REJJ2Rwp
         AzQPO/oHfv7vwajEiFpEsn9yX6hKPoLRY16F0H1zjfknmVw323AqVkZW5/tgnlVvkx/A
         bdWFGccnYLdT0k3IA97P1MQ0gCoBGpi+S/UTzel4k2HjxRr4/dxZMTcMq3AshELHJVjH
         tRqVowAKlv1639QgE5n9t8/4sP9z9ZKpRKfDukdJUEown3BIte/CFzkGcqXE4jT3Rtos
         /mRA==
X-Gm-Message-State: AOAM531xdSquNAe5O4S+yX/Y5fpJegrqS00iIyRC+eya9yxfRYrZl0Xv
        tTi4lTq4n77JFulOwOPD3bbSqsmyh5kXOUri
X-Google-Smtp-Source: ABdhPJzc7D+X70fulfuisnHByjWFfNpmvpciu4DcAFybhLtpDC4csz0JavmOna2GIpiNVPnzzXTBhg==
X-Received: by 2002:a62:7587:0:b029:2e9:a997:1449 with SMTP id q129-20020a6275870000b02902e9a9971449mr10383561pfc.57.1622454073976;
        Mon, 31 May 2021 02:41:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id md24sm821184pjb.43.2021.05.31.02.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 02:41:13 -0700 (PDT)
Message-ID: <60b4af39.1c69fb81.7ed70.1d02@mx.google.com>
Date:   Mon, 31 May 2021 02:41:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-252-gefa4dae380d8
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 138 runs,
 1 regressions (v5.10.40-252-gefa4dae380d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 138 runs, 1 regressions (v5.10.40-252-gefa4d=
ae380d8)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-252-gefa4dae380d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-252-gefa4dae380d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efa4dae380d8d46373a8f5017d2f0c1c6fe4e670 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b47606143e63d790b3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
252-gefa4dae380d8/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
252-gefa4dae380d8/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b47606143e63d790b3a=
fb7
        failing since 0 day (last pass: v5.10.40-139-gf93ddb6581f8, first f=
ail: v5.10.40-198-gc51a6e59c823) =

 =20
