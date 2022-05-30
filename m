Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9346C537965
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 12:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiE3Krp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 06:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiE3Krc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 06:47:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420037DE07
        for <stable@vger.kernel.org>; Mon, 30 May 2022 03:47:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso4150612pjl.3
        for <stable@vger.kernel.org>; Mon, 30 May 2022 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eqTOGINpNa5HxgJxSLVJgTDplzV4KmFui5kD3uh+XFo=;
        b=awct9MkNQEJIR5XmHGjOmFoFBkOFTGWTx/cy5E8ynIMnPt8ml0QtDst/HCXjHWd5lh
         mO7NHZ1p3fj2B08EMvJYZ6O0kgGYRJK65cqDbiVM6wiP9PhHTliPaqm4j02sjr20Eh6y
         PhnBquV0u3nQuL/moPecrxYvJp7bQFi0uz/Rhs3V0zg7uCREPV2+GCZD1Fecc/VpeSXN
         DnRMEnr5iXM6KERGO69SqrwVl+x9pU0j5BkMYefMYZUf67Qb/5bDrQn4YrHs3VyA5h//
         3NwCYM8OuxZYIHECv3A9hxPk1ytFNQHpT7RZnOXLdOg8mM1WTZiwIFGwKvDgyF6Eefsu
         QiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eqTOGINpNa5HxgJxSLVJgTDplzV4KmFui5kD3uh+XFo=;
        b=LM8kkDBHbF1kSVks1UuVR+pwxWhIfE54VucJXfWQFMDScLe+Ej2dxlk6cuLkch7pWZ
         RZIKHn4sGV79pqyOu1XgwaORcJp2zzqTczSy5SENkLkKJmFxzShnKxSf4Ri69MAtqcma
         wdMkQ5hPwSiJRQUdf+DLno4fOIeVfx5W1DWAsYB20bvmnQiWqFWMz+k2IVB9M5ZjmpmE
         QeclX0b459Co7yVfzwtG0xs31xRSd5dTDIOaz7TbumYcK0pRRykld5g9qkrOMseWX6c0
         mz1oOvFyXxdIrjSM2PAeksePTQZk6ZpbbdGgGcun/KgN8RSAibgtX9fqwdIHo8y22z1I
         avYg==
X-Gm-Message-State: AOAM5325MFnsarrRzceaw9Y5lUxXDMXRDANaddmZHh+YGcmUe/cdthz+
        HEIl0W8vBcbdi5ghDjrxUT0b+M+EDPzGNCGybM0=
X-Google-Smtp-Source: ABdhPJzmx+F1zf8urfwS5C5y/NQyoQYd/q36bRPHUj0YaMsmadTK/r1uBAVFJXEvul8M26ebU3tRPw==
X-Received: by 2002:a17:902:a9c9:b0:161:5b73:5ac9 with SMTP id b9-20020a170902a9c900b001615b735ac9mr56519195plr.14.1653907640020;
        Mon, 30 May 2022 03:47:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f6-20020aa782c6000000b00518327b7d23sm8511297pfn.46.2022.05.30.03.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 03:47:19 -0700 (PDT)
Message-ID: <6294a0b7.1c69fb81.4e7ab.2f53@mx.google.com>
Date:   Mon, 30 May 2022 03:47:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18-47-gb47941e220af
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 155 runs,
 3 regressions (v5.18-47-gb47941e220af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 155 runs, 3 regressions (v5.18-47-gb47941e22=
0af)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
asus-C436FA-Flip-hatch  | x86_64 | lab-collabora | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

jetson-tk1              | arm    | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig           | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18-47-gb47941e220af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18-47-gb47941e220af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b47941e220afb8b0c47bcc65875b400f420c5ea0 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
asus-C436FA-Flip-hatch  | x86_64 | lab-collabora | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629469b6cf6955019ba39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-47-=
gb47941e220af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/b=
aseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-47-=
gb47941e220af/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/b=
aseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629469b6cf6955019ba39=
bf1
        new failure (last pass: v5.18-47-g5fcc940824037) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
jetson-tk1              | arm    | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62946be2f2a1df180ea39bd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-47-=
gb47941e220af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-47-=
gb47941e220af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62946be2f2a1df180ea39=
bd8
        new failure (last pass: v5.18-1-g7350d3c1f391) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62946c4ccca4056301a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-47-=
gb47941e220af/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-47-=
gb47941e220af/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62946c4ccca4056301a39=
bd1
        new failure (last pass: v5.18-47-g5fcc940824037) =

 =20
