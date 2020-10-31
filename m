Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D9F2A181F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 15:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgJaOZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 10:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgJaOZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 10:25:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B02C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 07:25:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j18so7521656pfa.0
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 07:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0BEO0oz7a1ib7rPiz840fpHXTww/4H5jdSfZ6Xg0db4=;
        b=kNLzS0Rg5kfkoG1SSYi4vNrDqS/TznJzxgJ8NdJ269bAZaPZeP0brG7d376SN+rZsU
         vRasWprUM+62CAY+dbeuEe9pxSpIEEKHQSnP9vOooahGX4PClPA7HGivWxp7OwCMSwhw
         UQt6vgHw9bGhNE+NH/ofU45+ByYYlSwBScLPkYPEbTpEPftCd1gQ1DT6A3KYXAxW69mk
         6nOjmkCgvlKG74v/1VFxLNu8zeMSjxtXRzxPLWMO+XmqcRdrmQcjqI76rj7M4rA8qY6s
         KKjLNb6iCt9Jd4S5zDzywFUp4mNNk6Yh9/KIwqKjFllEIz7jyxKx0YxlctoAGJPiIDRN
         KAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0BEO0oz7a1ib7rPiz840fpHXTww/4H5jdSfZ6Xg0db4=;
        b=mMpRHByBhKtH7lMoBIC7NVfLiPWapsz0DAWkigRjIcM5EqgAvbpXVP8YmDUoy+iL19
         O6zcxkc1Ic4DeAq2RyAZmQO1CCDZrEhD/bpaNTgCMrSiSJPgvUtBoQOXhF8jME3lzq6S
         6tn/to/KEzERovbiCmCJWJ6w4nxBAclPlwRdLS0rScRP3AXkQA3HlwpYAlw6zpyTkZSu
         6E/8hEMbJPYRxnlU5whdpYQAC+HgsXOSI85gtB62PmPGX0d05DQ/1HKvHalmFLFShuUP
         ALI/uZUVo3PXWHRW8LbZxWeZOt9Ui17Ue2gGfFjuRG7KYc83Fq4Pt39Q9B6+yfFhBVq+
         3BwQ==
X-Gm-Message-State: AOAM530MyRVKLA6LWWwfOzEy/Ra3ISrEyWwpDgIE5tR5ZBrFidELl38D
        0bSc3HDJQYWgrkrbSC37XiPH5EFOUhmliw==
X-Google-Smtp-Source: ABdhPJzE3Yv4CdPhB2sdif/3NtclJ+pimuL3TyQnvcw+cphTVxyNvgl0PVBtwXaPHtaZ7yWEm/WQCA==
X-Received: by 2002:a63:1325:: with SMTP id i37mr6268966pgl.98.1604154345926;
        Sat, 31 Oct 2020 07:25:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g85sm8913488pfb.4.2020.10.31.07.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 07:25:45 -0700 (PDT)
Message-ID: <5f9d73e9.1c69fb81.56a70.5cb0@mx.google.com>
Date:   Sat, 31 Oct 2020 07:25:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.17-49-g114a0c1f9474
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 177 runs,
 1 regressions (v5.8.17-49-g114a0c1f9474)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 177 runs, 1 regressions (v5.8.17-49-g114a0c1f=
9474)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.17-49-g114a0c1f9474/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.17-49-g114a0c1f9474
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      114a0c1f94741d495f7539c0579149ee0f7be424 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9d439b87b21d16b93fe7ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-49=
-g114a0c1f9474/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.17-49=
-g114a0c1f9474/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d439b87b21d16b93fe=
7ee
        failing since 5 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
