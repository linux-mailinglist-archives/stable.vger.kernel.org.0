Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574C73A1315
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 13:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhFILoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 07:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhFILoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 07:44:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2135BC061574
        for <stable@vger.kernel.org>; Wed,  9 Jun 2021 04:42:38 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q25so18189476pfh.7
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 04:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g9LBhdmb+e3J1PSYZL+EoIb20C4KaPdYaRsMqfdp0nQ=;
        b=YF0y6O3D3C7XJo2w8Q7r3UB0oh46ObYCINQOCIBrkTBWhSkwlnVnGlQyMfsOm34tz2
         vJCrD83Zyp1EH4S2oaADFfPBxOIPAYsPeO8Bdq4yJPiQIuggGrhXxLtlnO0FQRf0NmH4
         VzvKCIayOvLmmDzGlR5s/rzQS/hQ3aPoUlcHEWYp6nBYpPEqAZ1IxaqUFBJAJbeNkyNm
         J0r/NjDRvqDaPVcEc8hLOC8Ppbo1P9TyJvO4elWUK/2i5BX8yurLaSpKwZzP2KoSb/IN
         EVy5DbOlUDdEOdncyx0qwZPcpFRjLTu/qFA07oxIARJAKQsCqOx6BQKlddLp0I+a7RKt
         PCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g9LBhdmb+e3J1PSYZL+EoIb20C4KaPdYaRsMqfdp0nQ=;
        b=r/eQ7tFs8NnPSW8MzgU3UyYLPJCTVYuxHY9sT1iZDa4qVmDHEVBHnZwT2xFWiXLE0y
         c12n8oULi6txoWJGZsML8K3wTeOCx1BbvPfFVl6nRDNSEJrQShiapX1JTXcfDA7IBiHD
         c96vADBQtUgh/ge4JJ1mUTtLNb35mgfxUK0jciT2eJcTgtyo2ubOJ1AoPgn+Kvg6McRZ
         zqddcjnwhTxfGd/u0wyXAFu2MHYYjzniikYlmNjPbfoobQQWJwPUNFFoaYSBctayJ8s1
         7Z2Sfd1ol0TcSUGo2B1u/HAWt9ZLhSmk79+Vn1QUePtbbqpd49BWg2yTxkbRR6lN6XCn
         dOVA==
X-Gm-Message-State: AOAM532ZqMhR3VyeRqxngnMo/zYdPEkQK0UlCrIJ23xIuCdy+tt7xROV
        C1/SpGNKfdKO6XqVWdJ7Lt9bdIZipe0sBDwI
X-Google-Smtp-Source: ABdhPJzj2n0NF0av+E9Q9yHHGxilzjbXQQ7CKmifvTWkm+g6t+x48svbZrDEDMyjqKGKMFud1ydQxA==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr3443785pgh.382.1623238957301;
        Wed, 09 Jun 2021 04:42:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a65sm13635145pfb.177.2021.06.09.04.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 04:42:36 -0700 (PDT)
Message-ID: <60c0a92c.1c69fb81.01c7.a145@mx.google.com>
Date:   Wed, 09 Jun 2021 04:42:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.9-160-g00e5df628293
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 165 runs,
 2 regressions (v5.12.9-160-g00e5df628293)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 165 runs, 2 regressions (v5.12.9-160-g00e5df=
628293)

Regressions Summary
-------------------

platform         | arch  | lab     | compiler | defconfig           | regre=
ssions
-----------------+-------+---------+----------+---------------------+------=
------
beaglebone-black | arm   | lab-cip | gcc-8    | omap2plus_defconfig | 1    =
      =

imx8mp-evk       | arm64 | lab-nxp | gcc-8    | defconfig           | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.9-160-g00e5df628293/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.9-160-g00e5df628293
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00e5df6282932074ed10a564a4be0a5924076276 =



Test Regressions
---------------- =



platform         | arch  | lab     | compiler | defconfig           | regre=
ssions
-----------------+-------+---------+----------+---------------------+------=
------
beaglebone-black | arm   | lab-cip | gcc-8    | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/60c07929512cff3a2a0c0e2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
60-g00e5df628293/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
60-g00e5df628293/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c07929512cff3a2a0c0=
e2e
        new failure (last pass: v5.12.9-160-g06ca62e1f692) =

 =



platform         | arch  | lab     | compiler | defconfig           | regre=
ssions
-----------------+-------+---------+----------+---------------------+------=
------
imx8mp-evk       | arm64 | lab-nxp | gcc-8    | defconfig           | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/60c079f259b01a08e20c0dfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
60-g00e5df628293/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-1=
60-g00e5df628293/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c079f259b01a08e20c0=
dfb
        failing since 0 day (last pass: v5.12.9-153-g7a4b632f5146, first fa=
il: v5.12.9-161-ge6befd55293b) =

 =20
