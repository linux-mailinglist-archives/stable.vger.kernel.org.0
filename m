Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A6C533FF8
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiEYPLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 11:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242474AbiEYPL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 11:11:27 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC0DAFB13
        for <stable@vger.kernel.org>; Wed, 25 May 2022 08:11:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v5-20020a17090a7c0500b001df84fa82f8so5367074pjf.5
        for <stable@vger.kernel.org>; Wed, 25 May 2022 08:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DbCyV7WAtKcRcsVyv+WVe8xIy/DDQmSfByN8zWFa/fI=;
        b=5W+N3IMVAumHUDktF4xHLXn0VgFGSpnP5VqxWYYYLBZi4KNLOuV2Pp+6gVPNak74aV
         9HzeRaf0xWWGoJSrzdmrJA5rUC16FShHhE7JODAwHkdZUkUkU2kZt9yL0fiIzhlghi9J
         Iv54PoQCO77baajDEqQaaOdvDUFq7adaYAqsbMwnC7NIgQ10RRHJomtjX9px1kDpnvul
         04b1z7LRP+R/l0+LDE1GCuyqyeLetBUjXL+lSJ4SoHzh8rGlMw917fQ+kLsJ90YoUAjs
         +JRp2hQGNO5M0E5cKe2CV6u4bAeAvUG51W9KuP13OGni9idkFwdOa/IJDGD1SVeJc3Xw
         +sEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DbCyV7WAtKcRcsVyv+WVe8xIy/DDQmSfByN8zWFa/fI=;
        b=ueAKq2NfYxqJbFsKdSS5LyBGMQM+QQhzAROeJebfkoilKzl30SoM0OVLIYXx8U0U5J
         dHZaAOU9jQlM5vVL/4nyE0xX3wlg1pegmxujulsBVKBUbc/ZfGLQxJpOxE2faon9mD6f
         p1QSy+bs+0vhX7jV+IMCkZiQkgz0pNSBGrOLyK2Yuko/aohggZknns1SFI3IuqYaoTzh
         JAMv6OXqr9ZYoK+4EZ+TfbuQAqdj16I9nzgPC2rmCBwWT/Q5qbd8LCJQuw79mh57Flas
         eOpP9jFTC+vvv9Qgwf3P0GDE6mokKgNDUMrAUUq8nxfip2GVGkdNcTC+UuxfmseFDrNA
         uRNQ==
X-Gm-Message-State: AOAM533vv6zdj9QPZetlchui0aPl2u3TLtQF5trvbr+/rM+2+eOm16q+
        VX5LswQodybHapUIqdIoS2W9v9naF33Q/8HUWHQ=
X-Google-Smtp-Source: ABdhPJyzYEef/KqGqkOotvp8zKtgR5hRdeUb+aSGMsHIENPiWWDg59/Iyu9ei4ZqYfxGH3ZlzKt/fQ==
X-Received: by 2002:a17:903:2305:b0:162:1023:b88a with SMTP id d5-20020a170903230500b001621023b88amr19700767plh.48.1653491482496;
        Wed, 25 May 2022 08:11:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u5-20020a62d445000000b0050dc762815asm11570974pfl.52.2022.05.25.08.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 08:11:22 -0700 (PDT)
Message-ID: <628e471a.1c69fb81.187f2.bc4f@mx.google.com>
Date:   Wed, 25 May 2022 08:11:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.42
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 115 runs, 2 regressions (v5.15.42)
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

stable/linux-5.15.y baseline: 115 runs, 2 regressions (v5.15.42)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.42/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c5871dddc145ac70916dac7c3f8366aba55ed9f3 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628e18f4ea50749d8fa39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.42/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.42/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e18f4ea50749d8fa39=
bd2
        new failure (last pass: v5.15.39) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628e157bdf21649a30a39c06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.42/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.42/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e157bdf21649a30a39=
c07
        new failure (last pass: v5.15.39) =

 =20
