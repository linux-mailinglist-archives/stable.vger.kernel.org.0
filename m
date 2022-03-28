Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8044F4E9F01
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbiC1Sgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 14:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiC1Sgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 14:36:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB64CD6A
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:35:08 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q19so12887782pgm.6
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X0dX1BHnz3Ogr7ykqgTc+QH1fL8f+TNN5XrO2gN/4cQ=;
        b=S7LKPD6KGxkwv8KHggb1j8jEWZ3EYIS2gKyHwXeTdMaWqdQG9eBlmSk/N0XFA5n72a
         C7gd3X7/+pzaVGRNAYRW6RmH73800Ny6fZBHPsj8TntliNnYLs05NZMEa9nmQ82kwRzm
         ZpcqUW0Cq/7QtVAdhU5GPltal/ilcq2GhQFcNtRVNoOE5cH7hXoz/zeyjAX1wPB6+VEY
         qTzzDHWn3jjodUd0mi71iagJb+Fa23USjt3bb422RsSwyFJ8Iq/GdZtomMOvEdC6tC6f
         MkFD8q7zcvZGUuZsCJdkVjQcY5Doh1ocpiStEzc+Mi7u/f4ZpTLz8kpPz6J2va5QdwyI
         6YTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X0dX1BHnz3Ogr7ykqgTc+QH1fL8f+TNN5XrO2gN/4cQ=;
        b=sOKU7dMzO5c9fSTPSPWt3LANX7GduS9sK9a27CmXq1D/4J9GU6LMcY+V5W5BdL0WWu
         AZ2SwPX7u0Scxp1wkQPTN38TQX2D7VqW6ihKqYhbW/Ur1a7kwRMp6m6kOzwbGzOzhq9q
         XZS9xmViMOARWoi3Qt3OJxl9eMpIrGwWdi9LVf9lfPSaWMxh91zf/kVHHlmz+zB5QFOF
         mgzdIQMf3Rr1qXO78X0sNRNAqR+P5JKfOlW5xQGUh+yAaatjvvUzxClS74ghvnalr/ZF
         MUzITuTmTbbjlhyuXOKS84Cl7pxm4X9caWElG3qL0Dwaei3IWUVM9EZgAg6IThAk8gfP
         jkKA==
X-Gm-Message-State: AOAM532fFOGR7guX1Lng2c09GbJ8ZEsig8MkkAVRQza4XA13IBph/Cqd
        5UQg/cg52PBUTxF8YqdYeoh0XAqOQpNIxInMGb4=
X-Google-Smtp-Source: ABdhPJxCARD8apODiGmFkGZgUyJB8h6NQHAIQwjKODsf29/GRHBLXkg7eF8A5khsEIN5cSrVHqLv4w==
X-Received: by 2002:a63:e52:0:b0:382:6927:a63c with SMTP id 18-20020a630e52000000b003826927a63cmr11100413pgo.437.1648492507515;
        Mon, 28 Mar 2022 11:35:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t2-20020a056a0021c200b004faa4646fc1sm16910839pfj.36.2022.03.28.11.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:35:07 -0700 (PDT)
Message-ID: <6241ffdb.1c69fb81.e7911.bf02@mx.google.com>
Date:   Mon, 28 Mar 2022 11:35:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.274
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 91 runs, 2 regressions (v4.14.274)
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

stable-rc/linux-4.14.y baseline: 91 runs, 2 regressions (v4.14.274)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe   | gcc-10   | defconfig =
         | 1          =

meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.274/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.274
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af1af6ebca0e28a97e5f802b9da695678fcd226a =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe   | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/6241c3c729e87dffd9ae068c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
74/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x-libretech-cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
74/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x-libretech-cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241c3c729e87dffd9ae0=
68d
        new failure (last pass: v4.14.273) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6241c3d029e87dffd9ae0698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
74/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
74/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241c3d029e87dffd9ae0=
699
        failing since 42 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
