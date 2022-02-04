Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE8A4AA101
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 21:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiBDUOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiBDUOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 15:14:52 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284FCC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 12:14:51 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id h125so5915453pgc.3
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 12:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bys/3rcx1XsQGlvnyM99l6vwa4+A7o/QAJygXl8E4JI=;
        b=hUJBZL8rMApSP3kbMgb/ijGKFksyKMKAcWpsE3mm5i/sIenTHNoCV1Xu1y7bGZSCUK
         5YrGy6Z7ycPrapgsi3lQOTaEixCDPR/vYv+c2RXXedOTgBQEjyZK3M7hkvTyKBcmLJ7U
         A9rgduicf84Zljy9onTmtF6zlzuEOFbpxqVjarrP5Kowal8QEc5GCMII+KRzEqJUO6Ig
         RYU2mpiqGzdMAMymzXs3KJRSvOINWVPNsuzmyys6z2KBKjIOXohR21PFNUszGXuwMW4b
         11uZc8KjIAtB5HLE4Nrd+GOV5YFWKepX2g/TCXnQO43Dzna2AG88RKPgp1zylHktlh0p
         0lgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bys/3rcx1XsQGlvnyM99l6vwa4+A7o/QAJygXl8E4JI=;
        b=WKxhrAfY+Co8Dx4H33Ik4J4aQttWB1t2PtexGjCWm3KiKv7yuNo9s3VZTWWaZr+hma
         iAiFPdI+3BSkcFR3LeFOMzDJbOq9dR5Z6HppvKj+BFciz2+55lZj+6+JJa0EIw91mVDU
         0JRwvSkmKkynoZMxYOG7IJ20v5GybHFl2FUGANN/l7J2wO5OuZh721VDPrLDdIb8yk8z
         QgvPrGRHNgS7rVp9WzArLtwxXDdbkko8R6Ow2B46fDBGPEZ/8NC5zPEPRUzSU6U+m/MI
         X/J7mscWenJmxlJjj4yMam2kcJ550cXxDtWOwoeRRqU3jwaiu+Dz5M21TP01XbMGo+r9
         fxXA==
X-Gm-Message-State: AOAM531kd7zCPZc4vW0Ww8rBrtc9HoFiPUdQt95B3zx0vm2ZAcEsMN8o
        mWVQZNI0lR5TsepGur+X0Vh3adRGOzt4MM/f
X-Google-Smtp-Source: ABdhPJzqF9FXFh6Ynam6szp5Ua9DdRvdCd0WwY+Yu0dCd9y7db2QaZ+er+ahCU3p5sMdIL5mGKpcVw==
X-Received: by 2002:a63:618d:: with SMTP id v135mr558078pgb.214.1644005690519;
        Fri, 04 Feb 2022 12:14:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3sm3160024pfu.84.2022.02.04.12.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:14:50 -0800 (PST)
Message-ID: <61fd893a.1c69fb81.dc3a4.8a47@mx.google.com>
Date:   Fri, 04 Feb 2022 12:14:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.16.5-45-gf58321948b36
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.16.y
Subject: stable-rc/linux-5.16.y baseline: 92 runs,
 1 regressions (v5.16.5-45-gf58321948b36)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 92 runs, 1 regressions (v5.16.5-45-gf58321=
948b36)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.5-45-gf58321948b36/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.5-45-gf58321948b36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f58321948b36b3589e2af9c3fc5718862597e364 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd7c01cd73d7d01a5d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.5=
-45-gf58321948b36/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.5=
-45-gf58321948b36/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd7c01cd73d7d01a5d6=
ee9
        new failure (last pass: v5.16.4) =

 =20
