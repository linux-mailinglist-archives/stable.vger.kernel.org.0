Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514AD3F13E4
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 08:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhHSG6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 02:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhHSG6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 02:58:18 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F373C061575
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 23:57:42 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t42so2030468pfg.12
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 23:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=njxP42abE+dtIuGy9xNIAtgdMgp8kRNrgbW00jI8wj8=;
        b=ZcqnHK15MGCpUyzrjqyQeWraNvKNHWgb4EKJXJh0+HnvP23kHWR56GL6KAXLsIAkhB
         rXOS3whTKl7bHqiQwtMZ8rwnFea/hfFwJ17Fq59zehfrfHMbMB2b7kVrT7lzx9K0aSQF
         wDVbUR4xgZyW01EozTeO1vcIJR73+atp6naXil0AYxEcdVKLvWCVLrtYMQ3IiNQeLVxX
         VOt2+eaxidTyY0qVHDeHO5i2MiYyCh9khqLHDcMz8ktbgxcnj74M6x+G39aYWWWE2J71
         eWTJPDUwEZ3PzjQWMIRqB/R6ilA99Gq0zdSGP6g6bA7bCi4V5f49nwU68Lnxw34Uk4JK
         TlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=njxP42abE+dtIuGy9xNIAtgdMgp8kRNrgbW00jI8wj8=;
        b=QsAjCmnG1d9kuLOybWj4yipjYHOe07T9b03zB4AULpzLgjwFsHz5hfXUkt8L3NV0n/
         zknd2/fLPHD39dQlfuSGjd1bGg+2VWvwjLntZZmD1AXuEpFI4odqy4WKFMxuOvz4zOFe
         E6A+WTmCO4CSSjYuwlNTR6SjeBgX5Zi59kt+I2+UtrD1VZjcF1WZaVmOol4du+WpEYV4
         Zy8EGYFJWSCYlQW2G7QhdosRisJrcup0u0PFZVMkmZw11OIlO1K1ozPt8T7lhj1B3naQ
         EJJziZyUcVHRYp33CvDf+cxDlUbW+iC7ubj/dotRFsSa6XGnAtFFhFdR0bjNNihdLdTC
         GlUg==
X-Gm-Message-State: AOAM531mP/+gJUz7ui+dIXXQ8ezdSDXSis9JflEene2Uw4nnjbgSMKa0
        rRSqX888560sWnujh+xcD/eqYiF6sS6gf8UM
X-Google-Smtp-Source: ABdhPJzosaGdOsJrglqR8pUNAu5TDIB/3/IkQIyMEKe3833/Sj7ZKweEJmnFALb9OOvCHseIZzsgxg==
X-Received: by 2002:a05:6a00:2444:b029:3cd:5af9:821e with SMTP id d4-20020a056a002444b02903cd5af9821emr13379519pfj.40.1629356261904;
        Wed, 18 Aug 2021 23:57:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y19sm1076857pfr.137.2021.08.18.23.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 23:57:41 -0700 (PDT)
Message-ID: <611e00e5.1c69fb81.7eeb1.2da1@mx.google.com>
Date:   Wed, 18 Aug 2021 23:57:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.12-4-g543923f53902
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 129 runs,
 1 regressions (v5.13.12-4-g543923f53902)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 129 runs, 1 regressions (v5.13.12-4-g543923f=
53902)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-4-g543923f53902/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-4-g543923f53902
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      543923f539027441e45195677c8c378fb815cb7b =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/611dcbad966facbc6db1369d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
4-g543923f53902/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
4-g543923f53902/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dcbad966facbc6db13=
69e
        failing since 0 day (last pass: v5.13.11-151-g712b967cfd54, first f=
ail: v5.13.12-1-g3b7bb0adff56) =

 =20
