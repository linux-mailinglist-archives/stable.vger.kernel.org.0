Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7435002C2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 01:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiDMXtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 19:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiDMXtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 19:49:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABD9496BD
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:47:01 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w7so3320466pfu.11
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 16:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s1fZPTEFMZieTDzLJs7YEegJcaSz4nvgBDxJTDkXoHg=;
        b=ybL8E/zsWEoCM1TsFLbdwhhuMB/WPqh8lbR80T+Jwn46kRpWNLwX4y1xJxMSjGfwJ+
         4Cht/Sd40Jl4tMIsk+WTm1Vigq+YW9pKPhR7vFr6r1b5QZ7L3ztiO/qr+HhMQDJY7ZIM
         y1QTmNvMhqwXEdaCNAeJWEmAJpL+KlgW0dPG5FIF/fJmg+9zZooRxJABcObPGyqlYVGd
         MiqkmMOuUu3tqVj47/iMdH7FSt2jB0Tr1vKN1gDFh79ANUFic/x8lijXlzjhXVn/XLW3
         1mn4a7EiFfOUVTLCOZFIrKzPEIsjQZOMy7d9yiFH3GYlKiK+85LjNxAjl/ypShtkodu3
         /ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s1fZPTEFMZieTDzLJs7YEegJcaSz4nvgBDxJTDkXoHg=;
        b=TDEAIC23TTX0ucU9BYkjQrikcotxjc1gZx41SDkyfDaM7xFxmCBAilTZTvIBBkDKGY
         QWXDq+F2uWRwghW4pZj8NjLgXzhfL4oVhLyroeniorBaftNkvbO31s3JjqFeEmvPdVO0
         BJPr+U7Eh31oIKIH7+ZiDyoXJ/c7zQsreQ/sc3QgiYelU/+hFZIR6/IogBARioV6AUMv
         k4Py2yCda0lU3uN6Y+LIwN7fxxIHQF4ocVA6HO097bTQqTGmzpJrV9AIEsmCuXCiKP04
         wQcASO/dK2WmVIeKZw5rTZ/xdlnD0q2uEPNbafdD2Tq0yiKpiTQIaTd93B41FTWEnUTS
         6jDw==
X-Gm-Message-State: AOAM530vSUT7yIK9h+tciszyafyVAYbcJDB/0OsO/XmkruQ3rWTa3Mxo
        FCST/sSF0se/9FqJvN7Btwy56MldUoYoNG66
X-Google-Smtp-Source: ABdhPJwrgyaj1zAo2SYLckVibXBNlaOmb0I/sGknZMAtZSKaR5A+eMq7V1q4GP14kVuRXqaI6mX9JA==
X-Received: by 2002:a65:5286:0:b0:398:dad:c3d8 with SMTP id y6-20020a655286000000b003980dadc3d8mr51222pgp.228.1649893620643;
        Wed, 13 Apr 2022 16:47:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090aa38600b001ca2f87d271sm164102pjp.15.2022.04.13.16.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 16:47:00 -0700 (PDT)
Message-ID: <625760f4.1c69fb81.c0d37.0ae3@mx.google.com>
Date:   Wed, 13 Apr 2022 16:47:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Kernel: v5.17.3
X-Kernelci-Report-Type: test
Subject: stable/linux-5.17.y baseline: 115 runs, 1 regressions (v5.17.3)
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

stable/linux-5.17.y baseline: 115 runs, 1 regressions (v5.17.3)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.17.y/kernel=
/v5.17.3/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.17.y
  Describe: v5.17.3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      77b5472d00d158866e2e1d03c13862b428b65405 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62572d8d6848cc9057ae068f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.3/ar=
m/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.3/ar=
m/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62572d8d6848cc9057ae0=
690
        new failure (last pass: v5.17.2) =

 =20
