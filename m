Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988C8504EE2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 12:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiDRKly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 06:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiDRKlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 06:41:52 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B85B15FDB
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:39:13 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q12so18137567pgj.13
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=McULvCNCH/xYx2UYsmFbIfWGMjxZcVEeWWh6es6h5so=;
        b=C10JdEb7LqIYBSHAFhyt/1TdRJEAWFstslUGz9gFN97knwZf3aOwmVhYGIsoipriBs
         G34q7HKu1lr1ng2D4dYRH/STJp1nU97iOD7nkRJMlTVqpNfETcUO3SrEFF3v8g5znuXZ
         sowMmG7IzI8JZbsZpBN3trBpulaPeJTjZLakx3ygBohjUTq8jwwq5XLCbZRzNCzMqZfo
         8aGbR4l95g2pGz6XRn62O3nlnt9Fxl37b8xmt1YarqsSVWqVRGBIlvjzuexR3MJdfbPT
         XW/pPzpOlGpL6+ZoxkfGOYmEbx2X2m9LmbK+780Fa//IhW+QILLdduhcEuzZvcpql3xM
         7Nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=McULvCNCH/xYx2UYsmFbIfWGMjxZcVEeWWh6es6h5so=;
        b=bwu4GfmVoEYme4HiNa0J0RvKYH5KBzxtrlhxMlEk+2EhgXer32KmKHwv2qLleimkVw
         kXMhrvMq4MbN5j2CrX2e03ylQ8kHt9biZJp2FQsRc4oT7ueYiGpPoLvcp0yR5Mj/Igs3
         HA1wIo12RGTriSpWjyh7r/8lp4Z3sLW/4XsTjO2dKT5TsZwTNS7RxUStpTbLipzkNsf7
         TAmU2Jdxq0U/nY+gbWF8XB2FkZpRYFbZm3YJnNGwjq4zstSsL+FDR1mgD/lTCtNMDKrV
         lghqwrZM/5vhSQXO5qpRaEdPFruoNRlfelxDM2Z1ALAwBGmUKEEQETPBX6WvfZIe3c1M
         dkxQ==
X-Gm-Message-State: AOAM532L5e221kBnZQoSYmplKYCDi+h/16+xuprbYuIKvK6M3wYx3/g7
        DISlTTv289Z9CFmOhoC9s90Uxc3u/+/71IHO
X-Google-Smtp-Source: ABdhPJwbxYb9oa/Zlwh3RB8BR+as3to0Qo0VPNvalvpdSqGqEZhPbJ8xqJYZCNK8CMvnkgED2I91bQ==
X-Received: by 2002:a05:6a00:15c4:b0:50a:7fec:c656 with SMTP id o4-20020a056a0015c400b0050a7fecc656mr1884626pfu.62.1650278352478;
        Mon, 18 Apr 2022 03:39:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6-20020a056a001a8600b004fac74c8382sm12274941pfv.47.2022.04.18.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:39:11 -0700 (PDT)
Message-ID: <625d3fcf.1c69fb81.c447b.c122@mx.google.com>
Date:   Mon, 18 Apr 2022 03:39:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.310
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 90 runs, 1 regressions (v4.9.310)
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

stable-rc/linux-4.9.y baseline: 90 runs, 1 regressions (v4.9.310)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.310/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.310
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6348ae07835a05f78ab3ada1f7293665a410a273 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6257420dc0e7700006ae0682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.310=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6257420dc0e7700006ae0=
683
        failing since 8 days (last pass: v4.9.307-12-g40127e05a1b8, first f=
ail: v4.9.307-17-g9edf1c247ba2) =

 =20
