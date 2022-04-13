Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DBD4FF7AB
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 15:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiDMNeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 09:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiDMNeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 09:34:23 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7076E53E3D
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:32:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k29so1792463pgm.12
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 06:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b8m6E7K9EMcOZJ5g+j4poNjomm40Qxw3XSs+QI56RP0=;
        b=jQZprDBYuKjSxjDsuaka9MzwQIykh3/ZHLw7TcLWDX5Ei5ou7fYxEvYeVcclcpeCx3
         lfvYEbyWxpYlqMhRKonoINnRUeOSVn0S952SMyUqe4mvIGLy1t4MWuG1qEz4mZFbBAuK
         EInLqwTsSQHP5FuhBTu5T5aiYcH/hcR7IeiUZi6pjItXSLzzFGn55praPrEwjH6aeQGN
         Lqv/nRBSPL9iH6hHKLpTu/ljZB8yxKpBmFGZpvwMmR4gNFx2L48KEmhDPqCkGne2L8sM
         iMjOr6I5sGScy7YDwfPn2Q/KfriNXNsvNxjTNA4fWO0Sy0nV+iZIa+ZNDdhLYwILWzXa
         oCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b8m6E7K9EMcOZJ5g+j4poNjomm40Qxw3XSs+QI56RP0=;
        b=258tvp1aOOH+JFQscQZJZOhmpAQihudK4VIFSpregWf2vm5LYaZOV0RTyA9txfjOVL
         I2ey1pyIYZeOOIkJEKU+2FfpWuVCTB5LUt7cScO9Fr1/7+UDP/NTFo4TukUY2RaYiqqk
         0eu8WBRAGdX7CLGGDc6j1pVlh28Vxe2l3ft3zZlUFbfkrLq9qcHHlGweRO/dDcNmCmmz
         ZYgqhCZZsD96Q0qdLQg0fReVVfRKqRDymG88WMKRaAj3Enll1wmZf3pQWHucyXJsI2vO
         NWx1TiJur2GOU6y5UzWFXIYuZX6UiTt/NlnnqpxQUHj3mfeAQx2zea5vFj1HO6YN81uY
         mZRw==
X-Gm-Message-State: AOAM533ZxR0lvl4zuRgU3kwyVBqV/H/I9SR787ISJK0CSdc8hg0A6XLo
        J0srBxpeBugvrmgRC7ff4yU7eDCEx0CL4Ar/
X-Google-Smtp-Source: ABdhPJw7uyP/GuXrRGjOKGSJnidxSBpAU4njIwjdG6nd2wTUpbRBKYp84yaKQccSS4P9PTdD07NeYA==
X-Received: by 2002:a05:6a00:814:b0:505:9fad:4240 with SMTP id m20-20020a056a00081400b005059fad4240mr21259395pfk.15.1649856721592;
        Wed, 13 Apr 2022 06:32:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm6198349pgn.72.2022.04.13.06.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 06:32:01 -0700 (PDT)
Message-ID: <6256d0d1.1c69fb81.de0a4.fb20@mx.google.com>
Date:   Wed, 13 Apr 2022 06:32:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-200-g3dae3b9d0daa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 59 runs,
 2 regressions (v4.9.310-200-g3dae3b9d0daa)
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

stable-rc/queue/4.9 baseline: 59 runs, 2 regressions (v4.9.310-200-g3dae3b9=
d0daa)

Regressions Summary
-------------------

platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

meson-gxbb-p200           | arm64  | lab-baylibre  | gcc-10   | defconfig  =
                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-200-g3dae3b9d0daa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-200-g3dae3b9d0daa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3dae3b9d0daaef0da005f9bfd63b1d6a61dd8d72 =



Test Regressions
---------------- =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62569feac6abbf3556ae0691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
00-g3dae3b9d0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
00-g3dae3b9d0daa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62569feac6abbf3556ae0=
692
        new failure (last pass: v4.9.310-200-g85abd612436d6) =

 =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
meson-gxbb-p200           | arm64  | lab-baylibre  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62569ea6b98dfdbf73ae068e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
00-g3dae3b9d0daa/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
00-g3dae3b9d0daa/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62569ea6b98dfdbf73ae0=
68f
        failing since 7 days (last pass: v4.9.306-19-g53cdf8047e71, first f=
ail: v4.9.307-10-g6fa56dc70baa) =

 =20
