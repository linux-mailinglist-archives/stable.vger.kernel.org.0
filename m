Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18B947D429
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 16:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbhLVPQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 10:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbhLVPQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 10:16:21 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8500EC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 07:16:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso2896750pjl.3
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 07:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PbP3KDLzykvR5VBAtIRIPqqNLtoWwNim1SiterXJjPo=;
        b=4AdGi10tqoHUcxnXzrd38DJ6VoMcPU9sfuRRRkg4twa3qL1IUWPD7QCbX+mqwFbBC2
         t+KXYAwOJJb8WteCvUbznjDi3azlOVBWyeEvlGcOWZLo+TUhONQYh9Pl3m3+HycWRf0F
         JWQ5lnspiqNEPe1PASIf68f2ln7JQ6SriiFdEJ8D+baiZPwRZA419nsWzfxJhfAigCRe
         zRiGAewlQ9XBMaVUL1F53kfFBFlePG8lL9mTwTJxsfefJcD+Tk05XDyWYWy7k4NLPz7x
         bhSRowZEK2X/mC3IBfFPb7vrGCMDfe+7khWomySKJkW/ecnzcbUuUycW2Y4ncCF2b9GV
         E7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PbP3KDLzykvR5VBAtIRIPqqNLtoWwNim1SiterXJjPo=;
        b=XPt530SbCCmCQBGi/G857DofmgdcWHAx/GGogdWg1sQ+feNHYuJvfOyiGV3pLTvQcS
         PgzRe0j5cE8Lw117k98Zc5MzemAp+sKPC2klQroMNDhvZ3JKtb5R1t9UutNjMEFnXWZz
         q/Wyvp30A9XMIM7ZcR5TI9Vze0Xp27RkwW/ugWTxMxTBYvGjFhAPdIFIOvhoGXRwoDPZ
         j6S3I2mozWlzcwL+xkw+DhJr5x6Nq9+UzLyPb9fNtGDshHNhXRFRzQACSl5ZGENrwGZz
         3kg1KymR3JwNtji+ookk2OpHhKSC2/06upFxe1cXpKIDw9HxYLIWgiZ1rvxirb5ArdQ5
         fNmA==
X-Gm-Message-State: AOAM532gwyuxQphmmoIakJXdotRiwbijMh1FwevKhzoVfsAGSTP5QgxJ
        EckAWNwUFLvBv2dYT8EpSk7VcU6yHGDw8uB8
X-Google-Smtp-Source: ABdhPJyfAqOpXHo8fELA3tiSUEU6IfCebjUNJRwtfLAAD3suXVUYHxuuavX8m5hJGuFvINRRJe+6yQ==
X-Received: by 2002:a17:90b:19c5:: with SMTP id nm5mr1856831pjb.194.1640186180927;
        Wed, 22 Dec 2021 07:16:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m14sm3293341pfk.3.2021.12.22.07.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 07:16:20 -0800 (PST)
Message-ID: <61c34144.1c69fb81.245a9.8367@mx.google.com>
Date:   Wed, 22 Dec 2021 07:16:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-44-ge424e12a40b3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 116 runs,
 1 regressions (v4.14.258-44-ge424e12a40b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 116 runs, 1 regressions (v4.14.258-44-ge424e=
12a40b3)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-44-ge424e12a40b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-44-ge424e12a40b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e424e12a40b3969d6968dc887e45d825b98abeed =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c30fda9729fd29c439713c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-44-ge424e12a40b3/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-44-ge424e12a40b3/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c30fda9729fd29c4397=
13d
        failing since 3 days (last pass: v4.14.258-16-g61a721b2d716, first =
fail: v4.14.258-24-g5205a2d8fc35) =

 =20
