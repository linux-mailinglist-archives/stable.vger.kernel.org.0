Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7546551F62
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240916AbiFTOwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240318AbiFTOwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:52:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C114522F1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 07:11:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f16so8958524pjj.1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 07:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IEF3ugwOJmGM8uxyDr8uU+dCBFoV4/3gSSoXJmKYI+Y=;
        b=bRdpTJLCUGP/oT81/WwoWWeNpY/aHekMVlGpVc7k2KXGxVXhnAkX/cjUn4LUq6I5a+
         Z+P2ySkL5T8e0ycwhhEzpXelyZOMOnBCdjtUQuTDwrK5GGnB5js77fw+eMUtCQtecsGv
         UXaRr7pODroC4DqcYhzaBlABCgiVmbRJKg5esCW0s01X18vFEgV5z1BE/06VHnZtJa4d
         lWKq4H6ZJeKqX42khjvTiMBXUkNN0YkiQvK+rDh1zYaMA/7mqBi+sobhJjYspv7+WvxK
         qp3iS3HQMbJqzQ3NddO5dybBFWjK6kQGVRIHNwfSbpU7ISDWltDm6HoZLHTb7qSdsT4k
         q+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IEF3ugwOJmGM8uxyDr8uU+dCBFoV4/3gSSoXJmKYI+Y=;
        b=r22otTLdXfJZoMYXq+Ntw26damNQ27Nnxil4gpA9vEtRyIwD4hyT6NirxE5jWS0zWf
         Hmb0sopYXJQZepHRfifmCDqzxA4kjjf8yXWAU5LGi2gplr6eNELjesCMr0Q7q0aHCNo+
         xb6qZo9bxmh/9zM0f7ERSuSSHH4CUGy4OlEQiWAEtN+O60/7EGismYJa1WvLzp+bRrYb
         Lb4a+TW2U4LC6WE4WaZlhha0MEtJBINl807zr2xyDYryj+7Lwcnep7Om96eSCz3kSE1u
         XO7++y0Xl1ZsfmMWGaXPe+Ng35ceyu5v8J2/OT7sDN5Vzdw/q0UBxgSnexZ6hVHIjgvX
         KvFw==
X-Gm-Message-State: AJIora8bUkLHAfBaZSSVaJU1VQ7dXD1yJGIJah3LWI4TRRR/8ErwrRTj
        n0cxsKOGjzUjNR0BEv5Zigi2S/h1lnc8GiJGxHM=
X-Google-Smtp-Source: AGRyM1ust8cMBRVR/Qg7IV2eSDGoWDSuwJM7a6uU0MrQj1tXIY6HoM9fLmEHFhhAzboa1H1C2NH/ZQ==
X-Received: by 2002:a17:902:7102:b0:168:dcbe:7c50 with SMTP id a2-20020a170902710200b00168dcbe7c50mr24290339pll.116.1655734260440;
        Mon, 20 Jun 2022 07:11:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l4-20020a170903120400b001620eb3a2d6sm8777584plh.203.2022.06.20.07.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 07:11:00 -0700 (PDT)
Message-ID: <62b07ff4.1c69fb81.7e4fe.c053@mx.google.com>
Date:   Mon, 20 Jun 2022 07:11:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-115-g6f49e54498800
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 197 runs,
 2 regressions (v5.18.5-115-g6f49e54498800)
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

stable-rc/queue/5.18 baseline: 197 runs, 2 regressions (v5.18.5-115-g6f49e5=
4498800)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.5-115-g6f49e54498800/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.5-115-g6f49e54498800
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6f49e54498800429eb78ee9b5db5b68462dafe0d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b065edbbd091c8a0a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-1=
15-g6f49e54498800/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-1=
15-g6f49e54498800/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b065edbbd091c8a0a39=
be9
        failing since 2 days (last pass: v5.18.2-1057-gd2f82031e36a5, first=
 fail: v5.18.5-4-g941f74bf03b86) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62b066921c10d78e58a39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-1=
15-g6f49e54498800/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-1=
15-g6f49e54498800/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b066921c10d78e58a39=
bd7
        failing since 0 day (last pass: v5.18.5-51-g1c79ce42b8e0f, first fa=
il: v5.18.5-99-gcf0cf9cc98a11) =

 =20
