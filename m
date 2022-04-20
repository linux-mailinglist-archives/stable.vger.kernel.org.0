Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D251508B27
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243561AbiDTOx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 10:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiDTOx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 10:53:26 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2035192B4
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:50:39 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q12so1796153pgj.13
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 07:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H5J9Rk4iFuKfxNo3A/+Fm/rCn1rt4GIRvWXJcx3BB8M=;
        b=2da97x/bTsmeS7ZHMujxX/qvdZlyvBbGmlpUSMn8MjnB/EJhVUhvR3kBkS4pIjouHz
         QQIb4rImOkiqeFc8PbOfU2Yb5lOwWrIZZQ2zyMSkXt3+yQCygku/fW566jHKhyn9Fwjx
         R6K3KX0uZn+mPX9TJPSrjoqgg4q7H0UmAhLp9cte7GOeG/l5PutfTQy4Hw/IDKIB2On6
         j49RhFUoUYEf5LhidCW2UabVD2+olD2+DiPPNXZBSWr/ssnPi7H/W3+WaJSOjLV+MenS
         75wuEM+YQ/W9JlGF8+EBwz20AJU5OnyqCXR76ZLaNF9A+cDPYJY0eFrTjM68F4WuVteG
         TGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H5J9Rk4iFuKfxNo3A/+Fm/rCn1rt4GIRvWXJcx3BB8M=;
        b=5V+ItAzw46scneLuJfxO22bLO98QnwOSr6LqzJr+UPcBA29z/RoxVLG6ccmHSHp4mV
         a/o1PPYxDDPQl9pdW7K9oP1SJL2lAoAdhzrMs2j/pnVHBB8hBhQi2J4wFqJPZTyJBRPw
         dkl13r/Dh3NnN6QoQsPTC6j5R4saYu+hvhrL7r4RzBAW+DEqARICWaXLICJf+cNjEQEt
         ihRAK/0vjV5IZi9EDxPTEdI4eYTM7NuvHLRTKDulG8hTw/icUcLDRlpSUo3tm+GRc5mP
         pmkrpkJ+mOuXgzOWjoWVDI5KNaAgeKovW/kTvwy7shn/9CiRkoR/x5john9RCi7Vykf9
         gv3Q==
X-Gm-Message-State: AOAM5305QIPNNrB9GVv9SXAmvMAXH0rQT7E+8MBI8uJAmeWuk7Tsp7w1
        y0mHKqLpJZ7uQROJq2Xvvh+cz60Kyy/kIdkxn5o=
X-Google-Smtp-Source: ABdhPJwdbKkft8d2KYK+eSWWu7m/BA0pe1wR+OdCHzqagGVD+M+CLmTmyARfernV/3SL2biCT+L28g==
X-Received: by 2002:a63:40c6:0:b0:39d:9463:94ac with SMTP id n189-20020a6340c6000000b0039d946394acmr19301709pga.289.1650466239186;
        Wed, 20 Apr 2022 07:50:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 204-20020a6302d5000000b00385f29b02b2sm20097446pgc.50.2022.04.20.07.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:50:38 -0700 (PDT)
Message-ID: <62601dbe.1c69fb81.72131.f555@mx.google.com>
Date:   Wed, 20 Apr 2022 07:50:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Kernel: v5.17.4
X-Kernelci-Report-Type: test
Subject: stable/linux-5.17.y baseline: 137 runs, 1 regressions (v5.17.4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.17.y baseline: 137 runs, 1 regressions (v5.17.4)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.17.y/kernel=
/v5.17.4/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.17.y
  Describe: v5.17.4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7ec6d8ae728e2f3b91a4cfac5e664ca32eb213da =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625fed6f01fc12c0c6ae06c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.4/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.4/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fed6f01fc12c0c6ae0=
6c1
        new failure (last pass: v5.17.3) =

 =20
