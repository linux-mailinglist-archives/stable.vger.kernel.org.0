Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F00538805
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 22:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiE3UGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 16:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242107AbiE3UGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 16:06:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063D61EAE5
        for <stable@vger.kernel.org>; Mon, 30 May 2022 13:06:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s68so10913552pgs.10
        for <stable@vger.kernel.org>; Mon, 30 May 2022 13:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b6X8SZuwvprX/bM21qipZ5UEkMeyxwV/5ipS9zyXV3k=;
        b=ea+polUIx46nLNrEPjH1v3MTY0BtrDkw0WHnTQCTZRGH0Wk41Tiu8l1IJPPKgYnQf8
         X/rlsCmpkbuWTQ1c06CA40HW9A7cJjnTBBJmUqQatjfXC1gqUqgUfccJRFbbDMxVf7MK
         /wroo9nyBGN4n9+aFT+D6gkfwEcSlXZfoTY/UP28oUw58MmTY1VYEs17fxzpQFPW6cgO
         ovlR16Ycex+YqVyxJtSUeTG3kPdh04hwcO2zDZ37JU4Ap2tpRXNc9qb7puEAL9EiCE9T
         NmodXQiwAsntf0mzCzvs2h398I8jF1zflKghgzBqO8p5Vj8HqJfqfOXguKWKFpB9eqDR
         16hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b6X8SZuwvprX/bM21qipZ5UEkMeyxwV/5ipS9zyXV3k=;
        b=Sny3MB116u2iNtig+/FSI1twQFskVGrHEAn3sS0N3PWmXfsHBUiKKitziOWhASMUjQ
         bJBw8z8ePX5vqweHH1gEULhZ4iu4xNeskBK0Rw6DH9BOTdqu0BRuFBZDaahLxwGzv4jE
         /BjmK8xna3ETrmMVsxcPo9npI/P/CfiYHMYosIfDajR9arLajxtrAi+7vR7Mkeg9apQp
         3tmBawn2s7ftJ6VrA41X2TcdqI/cud+UvqcLZ38LuK7Yu5BYnDg3KhLZCHL6H1WKvH86
         UvaFxi0JLEKCPPS859HOtdouiWyj+uPfgTktkPA1NzrK7vTLizXcc/MR/KIzHjWyTj0R
         /WdQ==
X-Gm-Message-State: AOAM5339JZ4L0ezZjROk9XZ4pIJApIrHkC6pdFduymBO9M4D45z3tOFe
        kx1pFqWlev6U6ofxddrK2JCT5e5G1DWl5ODibOE=
X-Google-Smtp-Source: ABdhPJxgHzmPS6IergjQtiI7q1NVC+0VFIg+hic6Pj0BIwe3WI4JTYXFdMX/jDxY1t+x4hvmlO/lAw==
X-Received: by 2002:a05:6a00:1807:b0:518:422c:b751 with SMTP id y7-20020a056a00180700b00518422cb751mr56247231pfa.81.1653941203341;
        Mon, 30 May 2022 13:06:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8-20020aa78548000000b0051b560b0a98sm2114218pfn.159.2022.05.30.13.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 13:06:42 -0700 (PDT)
Message-ID: <629523d2.1c69fb81.43914.4d58@mx.google.com>
Date:   Mon, 30 May 2022 13:06:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.12
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.17.y baseline: 181 runs, 2 regressions (v5.17.12)
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

stable/linux-5.17.y baseline: 181 runs, 2 regressions (v5.17.12)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.17.y/kernel=
/v5.17.12/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.17.y
  Describe: v5.17.12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      39555c443b4f5c2406e81d4ad66224f963e43d23 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/629502b7991aaadd56a39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.12/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.12/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629502b7991aaadd56a39=
be6
        failing since 5 days (last pass: v5.17.8, first fail: v5.17.10) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6294ff9855c641e200a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.12/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.12/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6294ff9855c641e200a39=
bcf
        failing since 5 days (last pass: v5.17.8, first fail: v5.17.10) =

 =20
