Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7DB3D79A3
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhG0PXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 11:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbhG0PX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 11:23:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9516C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:23:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e21so11658689pla.5
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 08:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WtRUp6F/rRjmVSH0XuZ+1AuYcauViF+hhi54Ey87P94=;
        b=Sl5idkNABvVqlwe50YHxmT3HkoaZXGGWOW97ZZ0Lz1NlpcCgs71gtCFV0HEf1bbBkK
         ZL/fqr9V1ZLKLt2g0Ny5Md+PwzywxXJXwvYykl9I+UpUydt/GRqBOaOOHdptAus1qFGq
         lbg0JTzit5+PmfPWP31nKAzDo8xuENfFog0DnVmwU2KjI36aXq/4KVEs/OvjFdESj/2f
         uYvAzHC+56Yj5+KbwJd8mAallMB0LDXQ9HL3kdNEA8a0IyTr26CID3kS9CKRNsBYmYLy
         QTHwbpc4GdYCkmf3/r4RO+jQ3Tzxxca/u5Dl4e+2s7l2Hw01l8Q0eZIvW7ydZ9DRJHZk
         wZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WtRUp6F/rRjmVSH0XuZ+1AuYcauViF+hhi54Ey87P94=;
        b=jAj744CKU47L87EqaNr5axpcPlRJvp7IEYRz1z2dM8bfz5i7o5VJD0Bf6/FNbSgXce
         kjXDF8fSpQpNesqkA5WcK8ZE5OIYGdSaSUTkJiZHG7kjqAV+tDbtFStKDcM2S3eFXkAh
         MESC+s2kchHoOJ85GEly4w0JkZhn3tmkhfvM47fSswI4ZyK2PIA/XNnFEJ6yoVS4lvZv
         hPPDyAfkPTaWDJ1MREYob9yggvRYJToTGgTKMHfdf+s00Ict21UIavhD2GshTaUioJgh
         dvuyVxb708i9xhtmeSi1JKnGb+glzaC2B0IZwX5ZwmDaOTXrUGyG5X+2DrGHH7h/h1CG
         hHZg==
X-Gm-Message-State: AOAM532bVH0sXPz/5fhUa1SL8p7RHYMtGVIennCGPDTxSEz9QCLuFdDP
        tqamKHuzhN5vomte5Pj+HI7D9HO6trWslOjQ
X-Google-Smtp-Source: ABdhPJzSMmLiVRoBuHYDN457tyj+5uLrnlgq2hYLzC2kjsfqza42F7wO52yg0jmIOWTuT613L/lEWg==
X-Received: by 2002:a17:903:234a:b029:12b:45b8:a773 with SMTP id c10-20020a170903234ab029012b45b8a773mr19093652plh.6.1627399396985;
        Tue, 27 Jul 2021 08:23:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2sm4278373pfp.28.2021.07.27.08.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:23:16 -0700 (PDT)
Message-ID: <610024e4.1c69fb81.78c99.ca0d@mx.google.com>
Date:   Tue, 27 Jul 2021 08:23:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.135-108-g4d79defb38a5
Subject: stable-rc/queue/5.4 baseline: 137 runs,
 2 regressions (v5.4.135-108-g4d79defb38a5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 137 runs, 2 regressions (v5.4.135-108-g4d79de=
fb38a5)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.135-108-g4d79defb38a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.135-108-g4d79defb38a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d79defb38a5d6a2b1a7ad396beee2e779ff0cd4 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/60ffefd53bd51070745018df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g4d79defb38a5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g4d79defb38a5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffefd53bd5107074501=
8e0
        failing since 15 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/60fff13eae585003a05018e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g4d79defb38a5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.135-1=
08-g4d79defb38a5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fff13eae585003a0501=
8e8
        failing since 15 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =20
