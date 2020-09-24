Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6D22765D5
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 03:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725208AbgIXB2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 21:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgIXB2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 21:28:30 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18468C0613D2
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 18:20:16 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x22so805474pfo.12
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 18:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=23cGNeLeYmktazIiNttLwgm1ra2PuqueF3B56gqYzuM=;
        b=iLyNJdiOP/NNzjINlUsm/Z9Wo8VNtU9ahwlMPn5UlQSdzet2gQfeoBfIyjYYS583h+
         iqsuqXKywsSMdetyePNt19mo3dntgNYY1AJbPCbsys4snOsUNaeK7kAMuPoHyBT69gbi
         AiHJBTF+ZWE7tZ4dlJnEfzH7Wt5RZMuA/7UIdKWzWZdXKgFHi+eDUmqNhhrvfyFCSZ+9
         v8bW+9Q2Hx2q46WyZcf8/8+vc8HdoP1KQwFw3tGMSUrzejSvdnpwyu7JZs+/LGiZN1n/
         0RBeQzs1m2msYrlVegGSfP6UAwxcLXPAddqhFC4cCwT7q0m4IStLs1L5UfF+HtFR+TVy
         IJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=23cGNeLeYmktazIiNttLwgm1ra2PuqueF3B56gqYzuM=;
        b=A7vGI4gVR6BJllZyP3MonnLaGMfdXKvRw9i2QrZSaBdhvGMDrUdZ7b5sRllY2N3ffs
         NNpEC6/5sIJlfyaYXARAXBiFHFa/XUwyrl19nyFxoSZUbSx8JBL1Jou52gOR6PVXlU/8
         OmLPj4POdeiikMHERhHGH7HmYguB8KMs9jWACDoAU95o2TW1gKqdDNArKqVroKu3P4mH
         Byay1+1Q62EuyCWLKV/S1bZ323eTg1x90PVzYFY/FbD+DwtvHawyTGMSNqQYUttKcOe6
         myXFXjS0U9dY1pgehuX8nf0J4SiishJ/jIWIRcp3pOPjTs/Clt7hAiIn7InII0NEz6Qy
         ZnFQ==
X-Gm-Message-State: AOAM532yDjnEYZDE88/DOvEJ3rlyeBIWBFM450TAUJSnMCd8VI6oFeUp
        Tt/jMwBBMnt7cce1sCYRZ9j5hOwql+JG7g==
X-Google-Smtp-Source: ABdhPJwstGV8mfykkL2uIlyI5Ew9J9Kq15wOd5yBYatGIgfsGS73HmEaKGKxF1Q7M8w73aNkPVNsqw==
X-Received: by 2002:a62:16cd:0:b029:13e:d13d:a13f with SMTP id 196-20020a6216cd0000b029013ed13da13fmr2341749pfw.39.1600910415288;
        Wed, 23 Sep 2020 18:20:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm762243pfu.163.2020.09.23.18.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 18:20:14 -0700 (PDT)
Message-ID: <5f6bf44e.1c69fb81.e05cc.3098@mx.google.com>
Date:   Wed, 23 Sep 2020 18:20:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.67
Subject: stable-rc/linux-5.4.y baseline: 170 runs, 1 regressions (v5.4.67)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 170 runs, 1 regressions (v5.4.67)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.67/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.67
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4bea6a4f1e0e5132fdedb5c0a74cbba696342fd =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f6bc0e0fb5bb52d9dbf9dda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.67/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.67/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f6bc0e0fb5bb52d9dbf9=
ddb
      failing since 165 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
