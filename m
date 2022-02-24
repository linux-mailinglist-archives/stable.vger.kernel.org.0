Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50A14C20B7
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiBXAkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 19:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBXAks (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 19:40:48 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36988B6D14
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:40:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c9so330408pll.0
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yc6FBzdCClHOB+pgJCcDcKVotcYQrX5B2z2RdP0kadg=;
        b=INL0UKvaGQebIeDkW6WnW4q9QLNuE4k2Ow7glAtfYcjPviZqgk5Ww2qAggipOAq+Hf
         mucit6ddoGpIvjzheUc2Gg5WGhxUkx5jnrPCtsi8ixK9ShwHjeNYSzCbVHCRQXIX5CA5
         qkC/NAE5FaRpiHIftr2nd7lzIdHs+syU8CFj6SoZQQzl3dl+kKndi/1MIncjfSP4w6YD
         STeB5L/kYDVNAPK8mpWQFTzIuQa7eqAHEz9jBeuofDieRDKXyLDt40D3Xzp7H9/Ly4F4
         81BJDRJz4jnTr8EdmTReBiSrfTKL6XC5ipnU2xhE1ivhzqlmXeYUZr6nwmFmbNdkJB8m
         HI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yc6FBzdCClHOB+pgJCcDcKVotcYQrX5B2z2RdP0kadg=;
        b=O3YaRFdhvr/Zx3LW/7uj3l+zbdT365oeR4GElc1356aHGsu2YZk5klP21NZqTeahTN
         5pFHBcYIRKvfOV7vw3DtQ4N/LjNp6hamiOthkpUIwCxOBMuNTs9ZQgWeTk2yCkdm+79f
         ewR14dkyc+4VND+xjWCtgL/DH4FZ8X5O2oShSd54NAPW+dDcIV5s3acIjWx35GJRWHon
         CpPyUfwK+1b7BSXT5FMFdFPctX20ZsL+kgyQ1s1sV+MKT14/ItM+IioB/bOFgQvnCfji
         fVYLteEwN8aFXZrbNocCCCjCxn4TZ2hZeCV9WdMUYDS9dL1/6U3sLmOlWykqXoZRej6h
         0Wjg==
X-Gm-Message-State: AOAM53108VWkfFKD8Ue4/u6hM6BAlWBM6rYL//uXJxdkbokuiD6+t5Rk
        zmdmxXTO4lg1NO1mvhZeT9IPEEsq1KZ9RqFSBvE=
X-Google-Smtp-Source: ABdhPJyIw2Scg4gtOsaDqroFdOpRXNGwqyE3QNLG3l8lqY1H3qbXyw56/u2NJl4cKKGXNIhp7Gqicw==
X-Received: by 2002:a17:902:d101:b0:14f:b339:de9c with SMTP id w1-20020a170902d10100b0014fb339de9cmr57953plw.37.1645663215564;
        Wed, 23 Feb 2022 16:40:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090a5d0300b001bc2b469051sm3985177pji.29.2022.02.23.16.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 16:40:15 -0800 (PST)
Message-ID: <6216d3ef.1c69fb81.b9c08.aa9f@mx.google.com>
Date:   Wed, 23 Feb 2022 16:40:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.268
Subject: stable/linux-4.14.y baseline: 70 runs, 1 regressions (v4.14.268)
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

stable/linux-4.14.y baseline: 70 runs, 1 regressions (v4.14.268)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.268/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.268
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fa33f9094f36943ea32f7fbe323293b62e96151d =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62169dbdef5b10f06bc62984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.268/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.268/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62169dbdef5b10f06bc62=
985
        failing since 7 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
