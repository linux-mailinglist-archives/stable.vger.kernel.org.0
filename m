Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B5F485C45
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 00:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245389AbiAEX3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 18:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245385AbiAEX3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 18:29:03 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC824C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 15:29:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 200so532608pgg.3
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 15:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q+2xh/+EheRw3JPkjZ2jrx30Uf1dmPnWsgkUe5frjZ8=;
        b=7JJsvOLdPeqtRD4T+5i84xt8/qVvyTntPHciyqa6w/PE8NpbU3DnsUYaYNkEvzhfcd
         rhHPgrQ/2wVFenVDNDbiW/RVM6HZZs7/lPNuXEyZThXT4jlAxWccx/onNeoXg8+5R83E
         BV1sTAU/zXElA0M/YGA3seRHtDrNAghZtDtyYBlK3exg66na/YSrJLvQqRLO5yWq3ksH
         2Bt/7M9AJpHQ0vUBUd8pkuNNMO74nW20Lr9GGQOplVqca78XETDVy9ZyfiTI37dsnUFT
         ykQJzflIyaHCR+X427bUSCmqzcABIcBaZshoGKSQTsGoiPakJ1jbp9NYYFRKEjgyP0uy
         FX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q+2xh/+EheRw3JPkjZ2jrx30Uf1dmPnWsgkUe5frjZ8=;
        b=5znapfOrUNAMDkmUwmq4KY78YMsJhd2ifBvPHFcaBx/3xu7GMkk+bxkyJS7Vf6cVbj
         tv6HprQgSGSjuvxhFgG2bjBPd0qx9TmAEl+WK4con3j8pUweOh6xbIZfJCYO4Mk9/i1j
         guQp8aqs/Xby2v5iQmAv0jVOzheMzPdBOEMsRly3AERpSI8NXldmNN2A7C7ZmDhlD7FL
         i1NGkPar9NgMwRwSIfeIquspKDdT3h300L9TRocrdljATvvANooespl9we7EnfQ4uAet
         /gcm/gV8BYVl85bNrW9WHOAclg+mrgO54lC0IjnXlUFu8YLShhrZBly9gK1zf+MZsVsT
         oM+Q==
X-Gm-Message-State: AOAM5327FDsgioGPYglpa27GlshpBPS4vwUrsakN+ZpGd6a8154YG+xw
        KX5dbqNjyJXtO9MZZt/vWZw5U8ppSn5ERwzE
X-Google-Smtp-Source: ABdhPJwlJEHF6Ex0cqKt0vyerAkuVu4k4RHELTcEVo6SZecaIcZK8tNqrtUlcPQA60eak0u9U0qfvQ==
X-Received: by 2002:a05:6a00:2349:b0:4ba:98c6:48f6 with SMTP id j9-20020a056a00234900b004ba98c648f6mr58023090pfj.42.1641425343199;
        Wed, 05 Jan 2022 15:29:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u18sm171322pfi.158.2022.01.05.15.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 15:29:03 -0800 (PST)
Message-ID: <61d629bf.1c69fb81.4db2a.0bf1@mx.google.com>
Date:   Wed, 05 Jan 2022 15:29:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.13-1-g59461093d2fa
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 154 runs,
 1 regressions (v5.15.13-1-g59461093d2fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 154 runs, 1 regressions (v5.15.13-1-g5946109=
3d2fa)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.13-1-g59461093d2fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.13-1-g59461093d2fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59461093d2fa9d7a08669d1b7cd9fa10a8c87fa5 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d5f3f7ad61cd0867ef67f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
1-g59461093d2fa/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.13-=
1-g59461093d2fa/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5f3f7ad61cd0867ef6=
7f5
        new failure (last pass: v5.15.12-72-ge906471b84ff) =

 =20
