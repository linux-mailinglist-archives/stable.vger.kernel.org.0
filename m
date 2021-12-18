Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2CE479C36
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 19:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhLRSyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 13:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhLRSyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 13:54:18 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A012C061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 10:54:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id jw3so1920816pjb.4
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 10:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LnKb1ARANn5l3vw9v5s0KouX5Uaj/SbvBM8gtBQ07u0=;
        b=duIwRf9ROSxK+7HsvtmIZKjC2AI/dxEcT9WH0mSVN8o75lOsZt/HNklssrRXD5upF+
         CzR26oxIABJDyLVub/d3XagZFCpu3aj+30QAwFiYDceQJlWRQaox9tkrOCZNyE5hpcIg
         FKlDjmGfzmja4kaCFqhnyO+rRnHhvona19XiWpFQ0467TDQdu9XdG8t0uYiBImaU7e78
         BhV1XHaSN6SEFYS8n0miHx9xk8xfEl4dGm9KIj8V9R6E29BtBBFpWDC9C7nTSsD1aCSo
         OWt1AuVVFpYQHjpE6Jj0PbdlIAbsclz08QybyyTA0pl9Cupr2Q6W7BX/U8psX9cdSG2x
         1FlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LnKb1ARANn5l3vw9v5s0KouX5Uaj/SbvBM8gtBQ07u0=;
        b=h+1VrGU/tmG90bw9VwZVnKgB9U16czAJOSoeyade/PEnu26dS0vHgVksUdpx/vQoBK
         iKI1lAto7guj59qx53hSl76eARYnQfShnNOb6OXK3BliZ3EXkv9m01blSD9z3lu7+DoK
         DTfqei5Kr1VYj3T+IQdfHIQCe4yxbPQicNlBFxUrMcY3RbnYJwvkgmYWNO5SbTJPKS/5
         sxW2wEfKo8uxd6Z8HE5CN309wjEu03huC9S1xVE/UpHCkkCPrJXStbFi3I5L2X9G/BKG
         o0OQo9tEfBPR8ttFfTmyIRCoIt/eCj4JD/ywwu/ALK2eyImMKe9R0Jqa9EbHScjiz10F
         p3eQ==
X-Gm-Message-State: AOAM5312xvVwPiSzwCw+SF5f0HftwM34Blv///fOg+ixS0E13mS270tK
        kOZngbpJchSUtbFwGHG1fnBcLL5j278xDbJI
X-Google-Smtp-Source: ABdhPJzkb36K2eZGWWeL7ZHC5Kz2KieR1hbX/Tc9Ga2SVGsd+Qd7REWasnCM7t4pOcZlIhN3q6Dr4Q==
X-Received: by 2002:a17:902:8214:b0:148:e748:84c3 with SMTP id x20-20020a170902821400b00148e74884c3mr6609496pln.77.1639853657354;
        Sat, 18 Dec 2021 10:54:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm2152142pfc.102.2021.12.18.10.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 10:54:17 -0800 (PST)
Message-ID: <61be2e59.1c69fb81.f5fb.4c61@mx.google.com>
Date:   Sat, 18 Dec 2021 10:54:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 177 runs, 1 regressions (v4.14.258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 177 runs, 1 regressions (v4.14.258)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.258/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9dfbac0e6b8600043de8dc85ed072f5f1342dc15 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b91b42e131330536397133

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
58/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b91b42e131330536397=
134
        failing since 1 day (last pass: v4.14.257-34-g5ece874a0959, first f=
ail: v4.14.257-54-gcca31a2a7082) =

 =20
