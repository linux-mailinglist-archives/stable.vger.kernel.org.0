Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FC14D75A3
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 14:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiCMOAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 10:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCMOAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 10:00:14 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB35E771
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 06:59:05 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q13so11466844plk.12
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 06:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/9R3zR2hgFbQnfSP65+kJVWR+rZ8gdAr8gbxJNKPmEA=;
        b=eOgw43dpXtMXwgh1WFMByTxQTkjykzj97O6eFz60MmIyR76iwWpQ4aNqJA8leJS4s5
         qQ1PArZRoO9O1urPqsmExt89fowM7xe8TA9VSlDiHgHOUaNJ8aijVCygcGyKLsLNkSVY
         xw6tndmO7BOyV9W0X48GmR7u1k4jv8TSULy35Pml//AGQ9hIVnmxohPVnJHx+jAAEv+T
         4iUiazroMF+w0DUd/ILayCx5VnRN0aSWpI8vkuTEdGV0Z9DVRhwkLzqRMonhTGNZ+DhQ
         KydIPPghQFT42Er5X7jrJU7QS/sVZur0v31AevAWwW1II/xaCWXho+sXSmU3isG+OoE4
         HfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/9R3zR2hgFbQnfSP65+kJVWR+rZ8gdAr8gbxJNKPmEA=;
        b=yF1dNabjPVE6alVseplDf9Po00FZpMs9L7aqnYLvOlGzI/fbyh8rfJnDEPZRRffyI3
         6Zz1Nbdd+9JEf/tudQ5PIXh+/7d8LmPD7Gzxcr0NDzQaaDIFeeNqFiasC0YzPpzEVGJY
         dPF35cGLC2khefW1sJfIi7KTGD/cE2zFTouvFC1OpkPNqYGpGQyeuvCBp4VI9o31Q/3D
         uBAEDhdKiV3r6kNkLFHv1NPJp8qeNjARp4qMjvRJl6JIyVJWZWGPBoDG6L4M4kWd2ae8
         Ix8fo3wwFQ6fG499Tk9vnImg+flcFnuB2+bgsNjcNYJQuhQrPIe9AbqtHsP4TFtn7kia
         U4/w==
X-Gm-Message-State: AOAM533TYnSdGIT3Uz9fvt0J4TT+orn9FvMe3O5DIrZWLIVh8BIaSvAS
        nJ9HEdj7EfVfb0pjzyjW0uzhca1ED9EY72iHQEA=
X-Google-Smtp-Source: ABdhPJyLW1gmSAOaLX3On5UAr8yizpgI3d+3vgOPlrgNVfOy98d/yqFk4QoKD9rQ5Hme9LAEMutRJA==
X-Received: by 2002:a17:902:b094:b0:151:be02:8e27 with SMTP id p20-20020a170902b09400b00151be028e27mr19746308plr.50.1647179944569;
        Sun, 13 Mar 2022 06:59:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k12-20020a635a4c000000b0037852b86236sm13369538pgm.75.2022.03.13.06.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 06:59:04 -0700 (PDT)
Message-ID: <622df8a8.1c69fb81.cff32.1e11@mx.google.com>
Date:   Sun, 13 Mar 2022 06:59:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.271
Subject: stable/linux-4.14.y baseline: 51 runs, 1 regressions (v4.14.271)
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

stable/linux-4.14.y baseline: 51 runs, 1 regressions (v4.14.271)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.271/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.271
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      af48f51cb5934738a3ee97e951d7dededf029488 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622dc24a26905a6f16c62983

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622dc24a26905a6f16c62=
984
        failing since 24 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
