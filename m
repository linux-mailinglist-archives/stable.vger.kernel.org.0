Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1439A3F8
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhFCPI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhFCPIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 11:08:55 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E54C06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 08:07:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 27so5376933pgy.3
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 08:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w2LRg1949KvAriZz4TdP7TxDcJOuzcVK+jYesAkhoPw=;
        b=D7g00I6HvbmE/yyvhf+jkktUwRV1J3L4kvA6dbICOawxKS2bSI9iu5GS6Yr6UmqF0d
         6V3fXfr6HCRpNom3Spdi0E/1fwMmZ9glMzRq/21/1yBG2B7FGxzGHbudeEK8qIGrLLlq
         CJP8e8ViX5v8EojuebismZyVKFnjq95HKRKBirwhCFhD+RlblR42kSgEovLfj70LqO9j
         0eLdGMc85fLk2oeHSZ3BQ+r61MLVM90+/0h+3mP0CV4iPjbngMCx8g11UBzHHSmbVsC1
         wQ4962s1WxiIRkYoYznFfaJ67ruaAXD9UrSLFQGFvm4XOUmQheFxDkshIh4dgl7dd/jj
         rUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w2LRg1949KvAriZz4TdP7TxDcJOuzcVK+jYesAkhoPw=;
        b=RDN6bRn2uouSgkPMyzLRg5x/n5HTUf5Z+Cs1nFbV6BRHl7/dQ9LEN8+wtQN9tUJg5i
         81CrvmKlZdGePTWCvMFNVdg9e0OED1PyBd4j/+qsfHV9X3us/k96CPwR9CHPtqf9Dm0+
         QdvaIbLHbCzeNtBp5p52hzIr2T4Q60X8d7/NwAWnEMdNgyZ17Lhlje8Y9HYRlhZVvsHy
         clIPCmCxxTjmFqiL0dMzW/4i9/jEbFSOcNDW6LOF1hXwGQWtG6ObdvLL740bomRLTO/x
         ESpoStzM0vjq+DZ6Dni+0arOZ7nIlawr8CiunOAq3bMDeC0aZUTwypQo77viwRLyfBES
         H6Sg==
X-Gm-Message-State: AOAM532U7oc7meLi50d9JiTEOOt/SZQ7lTsC5nPCIBCpGtq1cJ1Y71vJ
        3xLmfEc1SUCRi950UxVyAk90UnINLl9WNA==
X-Google-Smtp-Source: ABdhPJzPn9xymsEwa5IPS61fL5cjDomoiKtZOQhNEQp0xS1TYXjYd63FXzQE5XuOtOXUXD95IjAbtw==
X-Received: by 2002:aa7:820f:0:b029:2e9:c89a:5cdb with SMTP id k15-20020aa7820f0000b02902e9c89a5cdbmr202560pfi.41.1622732830327;
        Thu, 03 Jun 2021 08:07:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm2656977pfq.83.2021.06.03.08.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:07:09 -0700 (PDT)
Message-ID: <60b8f01d.1c69fb81.62525.8014@mx.google.com>
Date:   Thu, 03 Jun 2021 08:07:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.12.9
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.12.y baseline: 120 runs, 1 regressions (v5.12.9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 120 runs, 1 regressions (v5.12.9)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.9/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5a973f1903850a6257856e72959354eb856085ae =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60b8b6920b93f5d351b3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.9/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.9/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b6920b93f5d351b3a=
fb5
        failing since 5 days (last pass: v5.12.7, first fail: v5.12.8) =

 =20
