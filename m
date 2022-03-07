Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277E44D048C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 17:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiCGQwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 11:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCGQwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 11:52:10 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7051066FB4
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 08:51:16 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e15so12829248pfv.11
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 08:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=22jr83ksN+0ptUH+iJwPMNkt4Mg7rjUCgFK7Ro1mRv8=;
        b=eNhWMy7N5BxvSEIsPWkocoYyzCpnx9ImlcrlQukeNT7MvfxCps5MoVnh1cT65g5BKf
         NA2Jmkhjp8QpWgeaoEzaQFlumj1m7t1YExgfz4hPo/XboHSfXbBr3Z+R9Pj7zzskH8kR
         fRQuKobsgjMx3BKynakkyE1kk5Py7u9ycO+XYrTSAqSCDKJ2fKKNp6X/SHAX4ZxZbopT
         PZmt3dbDlhCeAtWYXtI+xHOv1xIGrsG7hGOXKiVoXtKraifY2XOLN3wIlvkG/9W7WIeQ
         Quao5mvIB6NgVeP0hpszI2iUFe3c2rN1tC/tq9BqfC/6epyo5JNO1/grNdHj7d3KH6wA
         Y0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=22jr83ksN+0ptUH+iJwPMNkt4Mg7rjUCgFK7Ro1mRv8=;
        b=NDegIOuaZ2nc30r/vw7xZv5XGbMTJQsjBoalsykhB5dJYLeh10ZTrPeydmwLaATDEp
         IAc/AWTJA9Iw5DiLmMwA9j3smrx7Pk+9K4Zprobt8Bw84SweUWrzkOcywgCCQdEqF+V8
         Kc7bwyKOSKS3dvB6NSNLrjzidNDeI/hHpaunOEOSo4VDlWMIAn3XMYPbG/l7W2HPSm/y
         +IvFCXheITPw9Fd7v0LpItwVzdtOT/z8tSg8PQs5sCh8GrOfo6o+oksW+1trHsnSh9On
         atO4oy+1cG/QSCAeJq40lGfoZX0mXBDoJu+dKm6ekbpKNxgHf5ZfSOnNX664Ay02V3sj
         Qzxg==
X-Gm-Message-State: AOAM531huR0fjtl6nUYecCoXdjJLMCa4FFIQQRDxbBUrLqg6FOhoNmxO
        uR12fo0Z4WLH8RdJlFpS3Oybh+HwD0JaYjBbDMw=
X-Google-Smtp-Source: ABdhPJx2dj+qbbW09QFGJdpdpQoW7yjqbwdQ5n7uYY8Iu17wqdjUarUgNgr1gDqyTZV3HStCjx0NWA==
X-Received: by 2002:a63:6cca:0:b0:37c:7cd8:e53d with SMTP id h193-20020a636cca000000b0037c7cd8e53dmr10748950pgc.600.1646671875848;
        Mon, 07 Mar 2022 08:51:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090a551500b001b90ef40301sm14207447pji.22.2022.03.07.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 08:51:15 -0800 (PST)
Message-ID: <62263803.1c69fb81.3b5bd.4042@mx.google.com>
Date:   Mon, 07 Mar 2022 08:51:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.269
Subject: stable/linux-4.14.y baseline: 67 runs, 1 regressions (v4.14.269)
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

stable/linux-4.14.y baseline: 67 runs, 1 regressions (v4.14.269)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.269/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.269
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e853993d29aa42ac4b3c2912db975a0a66d7a5b0 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/621fccf6367bbb1e44c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.269/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.269/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621fccf6367bbb1e44c62=
969
        failing since 14 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
