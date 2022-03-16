Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF34DB7A4
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344237AbiCPR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 13:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353411AbiCPR4F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 13:56:05 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA696D95E
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 10:54:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so3201719pju.2
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LKIB1htNB6TWkH2XlGgClgOPl6Ljpo/2f1tY6E5A8os=;
        b=xc65cIHmTH+zxC8ulCVilB+ZvB0sh05yo7Uv6bEbwVsjKQM4hyzO1QgI2jJIbH5rJZ
         dJzSqLhGHsFITLEhmFd67kjhuQBULdCnnvJtrrHApdIlbyAl1TmnfBFz9GapgcCnEV3s
         Ba30sbV8MmExRImExSmPo/gBjPshYLpHZhzXZDhFNwH0TCVcyQ/kPduy0z+DbDrzlVbv
         LiHALlrDiReR9UwdQ+2LxLu+qWUbESfC21h6rk8FVzfKKR4/kdC/DG+NzHo+6mSlRFur
         DpEeczGOM8BMe5wOwX9MJNnb0XY5yS8g2RSDRZ1/+Pygvf91qh9psiQF7DflZblaIVDD
         9Wiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LKIB1htNB6TWkH2XlGgClgOPl6Ljpo/2f1tY6E5A8os=;
        b=LRhvaO40kCLWDscEtcX6eK0LMi5YbpbXI9LZb6fWOFfImLEcjEN3v/2E/wqDtoYG/2
         AAnhDjNWLRRaZ+B+qnir17oi3cZGWWl0lDUTPFlIAPZyCemnZyWDtikI6sW3mIBi0mm+
         EIgd/4djoveons3XXoEs5ZAD34qgM6X5DSEfmP823nt7J4WB874U228GA4+vmpFFZ/nM
         P3pBs/BJtLQtjmDTkxK5FiMwAPNwxiFP2zv6gYsZgELczv+Csfc6jHbknBaIPKqhghWH
         NtWK7IeJt2z/rHHIG3jHkRj1LoRLqHmFUVHnYZOKv4SAv8aLtqfDvz1DOSMJtpqUaFOv
         L0vQ==
X-Gm-Message-State: AOAM5306bqPBO36VjPrzxnG3wbilT3WXsk08q6H0X9wtWU0QpSGCWYQH
        flEgLnYvgu87M5yyhQPFGviMgiyjteoCe4TPUAE=
X-Google-Smtp-Source: ABdhPJw7VVptZQcldx1ONWBdXkxSzErcRrd387sS9YSBA862nL/pQzxOf3rb2r8Hi3VlaP5Ol1nORw==
X-Received: by 2002:a17:90b:3a86:b0:1c6:5971:5980 with SMTP id om6-20020a17090b3a8600b001c659715980mr4835518pjb.68.1647453288579;
        Wed, 16 Mar 2022 10:54:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a056a00241000b004f3a647ae89sm4098174pfh.174.2022.03.16.10.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 10:54:48 -0700 (PDT)
Message-ID: <62322468.1c69fb81.2e834.9ba5@mx.google.com>
Date:   Wed, 16 Mar 2022 10:54:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.272
Subject: stable/linux-4.14.y baseline: 59 runs, 1 regressions (v4.14.272)
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

stable/linux-4.14.y baseline: 59 runs, 1 regressions (v4.14.272)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.272/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.272
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      eb045674aab31aa55a4f9aec27cce36e3d946a21 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6231ec623b6d061ab8c62980

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6231ec623b6d061ab8c62=
981
        failing since 27 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
