Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E4B374B41
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 00:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhEEWbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 18:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhEEWbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 18:31:16 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5D9C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 15:30:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v191so3353065pfc.8
        for <stable@vger.kernel.org>; Wed, 05 May 2021 15:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bGptJaR7sCLVnKhGYOrW8DsxlFR9l1XbIG/UoIP0so0=;
        b=r2aAI3x0mRbzGW35yvrVyiSLYhZDkQszq8pTZEXri7OAhN5Q3b3lt4h/jTijeJyOHl
         blLr5NIUlMHjdUw9s8UAoyINilQDlyalqPoPTm+bxCiWfxEvX0/GHAvlSzmTLBve0VRQ
         YiOMHabZ1PMC5ENjsODnbHXGFeGUYqcwZORyISuP7OEJ4UJuvDOyQdMEepCos2F4Zh9g
         rI5l0W8xeqphU2zzp+Jzg2nyp5UN1PNjCXmxHYAiCrZiX9DJbAvAR9YGFdCCk2aCBkBL
         DLhZetM3KtJlE5l1w3wH4CqslyK461a2tH/jAp/i+HCQKEB/INA3UsXxxFyi1Y5lMQAc
         4Wxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bGptJaR7sCLVnKhGYOrW8DsxlFR9l1XbIG/UoIP0so0=;
        b=Vc3OdG3QYUz9vzbB/wHb+zzuz+uB1DFyo2/EmSqKVpDtVnZEiy8C8SHEaTK0K6ORb6
         5kbnKs5x6NOnVf1idRxC6na+HIKEHHsvEuDjexOB0LDJYtbHsljkzJ8X+7E9jmL33mLY
         SX+PyzznX1kQ0tP4aHqmQcARHW1w5rptQqu7aITJHNWtesii/Id6t5foEnRpBqWRrWGI
         zS7AyQXqgNK4sAW1cyJGKMIZSX7eQtFhYSMgkAknIvoi223Bdd0VHMgCq0owVG1407+h
         5vHqplKIWuSBkQDjm53lKiXvE99dWzvggJc7BsU11cyvOpzX55HvP/Tv0C15+6tHSk6s
         x/WQ==
X-Gm-Message-State: AOAM5315gcAQAqihWrBv43sfrA+MstNOjrpXFKTucQ92Ue2q7+st9Ham
        wIkflH1h+T+waZAKnlo9pSEJ2B+28nEzsCCe
X-Google-Smtp-Source: ABdhPJy1ftKZJgw0zvNS+ptr6LHIapfqqt6ofCH9QpMVr2SA5dww8Lc0XgOAn4qhSays1UH0MSTS8A==
X-Received: by 2002:aa7:8750:0:b029:28e:d3b9:cdec with SMTP id g16-20020aa787500000b029028ed3b9cdecmr1193596pfo.20.1620253818329;
        Wed, 05 May 2021 15:30:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm205876pfn.166.2021.05.05.15.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 15:30:18 -0700 (PDT)
Message-ID: <60931c7a.1c69fb81.4722.107a@mx.google.com>
Date:   Wed, 05 May 2021 15:30:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.1-18-g77358801e46cf
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 82 runs,
 1 regressions (v5.12.1-18-g77358801e46cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 82 runs, 1 regressions (v5.12.1-18-g773588=
01e46cf)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.1-18-g77358801e46cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.1-18-g77358801e46cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      77358801e46cfaa306e7b1bcf5d8cf99a21b40d2 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6092eee2e446ddc2476f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
-18-g77358801e46cf/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
-18-g77358801e46cf/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092eee2e446ddc2476f5=
46b
        new failure (last pass: v5.12.1-17-gb3226f805af4) =

 =20
