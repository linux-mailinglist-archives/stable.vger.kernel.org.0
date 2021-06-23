Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F853B115D
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 03:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFWBfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 21:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWBfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 21:35:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A79C061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 18:33:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g24so510669pji.4
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 18:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eBaDvkL0+Wfkgn1i7YG9mv2nzWG7wKmzKiGX9x1Y3Y8=;
        b=ISq7q/3vPXhQ/Ko9HTFTM425JVVGds/gQNTkyHNUvlhraaVVI8cOqubWyVN+erDeAy
         zDAJiy4KeCqlfddJEHDuEc56VZXlqzRBV6sYGtgU2ihIwV5TjoIL3jiOd7wX7oy5aMlY
         nzQ+4XS+1qLxCb3x3uVIH+WYsey7NFl0psfCHe/8zmRQnn1baGuoC98UWREFKfc2RPOs
         WxgGTiqSg2OXh+Eh/IRRy6ksMRdqcblEctk1+mMsagKrPlstIMzURNEIb5SDVRzoHv7K
         7bcVCgrql5FYH7dhHo2vyad1UsORyMlgPXAgeWKUFq59aVuAsHI4sgR1fDKH6Rhl0+xx
         iNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eBaDvkL0+Wfkgn1i7YG9mv2nzWG7wKmzKiGX9x1Y3Y8=;
        b=l0lvPpvCUj+f0939QW39UnU5FnWzz77hQuXYyHvRZYpK8RAkKv7h5Ui2yuGV4K9IBm
         zcQsufvD/n1GJvuWx9ZyZj+7S6BRE2qMT1t526YEDHLLPtwkXTK4pX96Gji4aC1Wfb7J
         wA3P15+McUpmV5dOAV5YsNQCLj2pbaHH6KDpO1UTsKGRAZyjN0Q2yX9e0U3nfM9jW+vW
         Sq3bTe7NOkJSX2Ev778ZlAEPpLcgwqQD5cHMfyUJ5vu1kias7I+XfFMZEQYDM5wWu4pH
         +xJ5Oa5q5WoMb5+jBcNc9qAPSyjb04OD6JHfM1fySn6MqAfg+wmLh8ijMZkEXoObNYtf
         Ns3g==
X-Gm-Message-State: AOAM530YglKXtT/ASx0x2rx0OYCvJEIpMuO6lJPLzDXJcQptzUa39Y8h
        O72LjCByQ5b0MS/EL+XZyhYW8phx3sbHyg==
X-Google-Smtp-Source: ABdhPJwAyfgtad3KuIrQUC79RSYmdzz9QzqGxFL5gEschIsOZRvhCOngK8sbYpB2uLRPMRb2lh6UQA==
X-Received: by 2002:a17:90a:5795:: with SMTP id g21mr6669438pji.235.1624412014792;
        Tue, 22 Jun 2021 18:33:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18sm21001120pgl.87.2021.06.22.18.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 18:33:34 -0700 (PDT)
Message-ID: <60d28f6e.1c69fb81.02a1.a34e@mx.google.com>
Date:   Tue, 22 Jun 2021 18:33:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.127-89-g137361f31bc6
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 163 runs,
 1 regressions (v5.4.127-89-g137361f31bc6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 163 runs, 1 regressions (v5.4.127-89-g137361f=
31bc6)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.127-89-g137361f31bc6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.127-89-g137361f31bc6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      137361f31bc69ff173de2af89eb3f00e1d7ec92e =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60d25acc08a6f6c8cc4132a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-8=
9-g137361f31bc6/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-bl=
ack.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-8=
9-g137361f31bc6/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-bl=
ack.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d25acc08a6f6c8cc413=
2a8
        new failure (last pass: v5.4.127-90-g27c44e52794f) =

 =20
