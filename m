Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AFD4895E5
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 11:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbiAJKBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 05:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243540AbiAJKBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 05:01:21 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B02FC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 02:01:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z3so11354402plg.8
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 02:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CdF6DjGgBF3/uAxI6i6FZtc6+qO9owboo4qasTYodTs=;
        b=7VPuJs0Sl61dL+3moAwwwgoM6lWrPsOgu9gCf6JE4OaHRvHMbTKEqO8Ir4gED+fPrB
         kDCnjevAo9ITCaziWTwuoXG5i4bTaRytTP49Rro/sWQXHxPPxGFLm5fYFO6F2vqQkJ82
         KuNtyzjk/De6IoGAjVO63XP+bb4x8kCzSAdEnWsjBFrKKI+sYTJHRhPWplb++7IC/Pmj
         UhaBjdGOhLLqXQujFTzF5JPTLXl+A0dW1aj3td7YibO75Ll394g8qiUxwsYTO+sjlyCJ
         mJWzqtOpZkniozUAjm8FcIeHhI3/Ou65e0dBLrbGdA60AlFcKlyuD4TpNWjcPFMSKjwu
         0FPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CdF6DjGgBF3/uAxI6i6FZtc6+qO9owboo4qasTYodTs=;
        b=7f14eLqnJPLqgc+ugieV2A+YgKWCDVqtEQBEjN0nlLQDdQQMPIzh+TJJXGCM3l5rfS
         q5kzd/oYBSsI9R9yPcMedAHQZWFGJgVIaIVwEBbjp9Phdr4sghN935uhHFBbcbzA2vLB
         FY1/CT1sucjNHXvDuvURhRDYcQ1v8gjfddu03+gXxHeXEEwO7ri4V6O/GOHrjsqrv5us
         deAGduD4xZaxYXreM03JPLsPosYYFfEp6jXK2WSfWDCxbPW0jHiYUcX0EFLm+zOVm5GL
         LRWReX/vmR4/gGUJl7+4wXdtQ9RJLyNcUvWhyWYRvZlBXvBbeJ6Rv+M78Kme6+hTww4I
         PFxQ==
X-Gm-Message-State: AOAM531yQRoXH+NjSt1APrAdkze0mT7HHUtFz1xrxzbid+OS5JSxo6UP
        3ZSoIcQv2koWGNcuaaeVlwzg3CfMOFyir/fA
X-Google-Smtp-Source: ABdhPJzEOr83FmOxF+YhqQDbUyqP8wn0nPLUJoKIq4xMD4qjOggUeO2bxMQuImW4kv0xw9PQs0f7Iw==
X-Received: by 2002:a17:902:b201:b0:149:4b25:332d with SMTP id t1-20020a170902b20100b001494b25332dmr76336156plr.17.1641808880382;
        Mon, 10 Jan 2022 02:01:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id om3sm8726648pjb.49.2022.01.10.02.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 02:01:20 -0800 (PST)
Message-ID: <61dc03f0.1c69fb81.1b3f4.6769@mx.google.com>
Date:   Mon, 10 Jan 2022 02:01:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.13-70-g916d1894bcce
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 163 runs,
 1 regressions (v5.15.13-70-g916d1894bcce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 163 runs, 1 regressions (v5.15.13-70-g916d18=
94bcce)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | regressions
---------+------+--------------+----------+----------------+------------
hsdk     | arc  | lab-baylibre | gcc-10   | hsdk_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.13-70-g916d1894bcce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.13-70-g916d1894bcce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      916d1894bcced3b7f2e191f03b5456ce9a86026c =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | regressions
---------+------+--------------+----------+----------------+------------
hsdk     | arc  | lab-baylibre | gcc-10   | hsdk_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dbce467dc74663a1ef674a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-10 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain -=
 build 581) 10.2.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
70-g916d1894bcce/arc/hsdk_defconfig/gcc-10/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
70-g916d1894bcce/arc/hsdk_defconfig/gcc-10/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arc/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dbce467dc74663a1ef6=
74b
        new failure (last pass: v5.15.13-50-g3941bf6c6d13) =

 =20
