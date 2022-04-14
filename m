Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C255003C4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 03:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbiDNBrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 21:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbiDNBq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 21:46:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389096455
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:44:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5so3782670pjr.0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SELFo4k9jFAHcIH2Fm5cBwYqpAauxOWDZ5OWyBvapMU=;
        b=yTn7dQXriQuk6kUmA/t1qt8jJbnSb0MxW9rkjDgZyowBTYmcFHHlOs/yLM8QIFODKP
         2QN+7Wft2RK9bqkgurYiQCM7KNTFUMeng5gGo1zR840PEQ4cBDgiyhgMMzDZLWeAIXkd
         sWxQr+MQfI+xf6Rv8ArFa3knF/xUvJK11hDoLKRMshI9qZF0q/uryE8Hn+yHVlKogNLN
         3uaHRI9rZEN67OWGz0+b40m45dENLtEaohZzqJ8m3Z7Emy10OJvwqQ9zc6s5QasayYvl
         rJjrAAokKkJOpvBmJoHfv65RsFDtdlhULETBwQblWzKHwuQxG9eLVHZiBFj7ehqNa9po
         koLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SELFo4k9jFAHcIH2Fm5cBwYqpAauxOWDZ5OWyBvapMU=;
        b=V3YeAZBQxzPYw7SVl0ObTMcdwM6zf8z0cbtOZP6AF8yYYYFWXOe6mJfIzkMlAAppnD
         e30tT1Tjjn2nnym2uQuwxt+YdgpA0BGk/7TN9PicyYS3nug/2cex8aQysdZO0zQcqjgO
         xCPZ8PcHUp6jnzbWYIJUJs40YCobn/GgscLEBeFKBzCKmCuR1s09oYNyO8lHIyTheueG
         wksxdY8fYzYJUJ1b/PjaJISImr7KsTePgU3maziz1Yc0sgIcyGAX+o2kBOXaRxDol3TF
         RgS1YOWoieF1lHqdADDB1p0yMH9aDD+l3M7CzbwFrtLPWpEhRzOaZm4tEDLgr57R4nt4
         T/5A==
X-Gm-Message-State: AOAM531a7MsAErsNZl1vSewTm1+3fkL3gH8545/5Db9KIOPsBMFJLnad
        UoHnf2Ju8ifEFL61SNX6+RLW2PjIMvR+YX1A
X-Google-Smtp-Source: ABdhPJyFRTddyOLUYoWiNCXc1sk5abL+bEvECtDbPvAnawh8h1ghZ3ww2Z/pqlRv8kcy4m7dur+o/A==
X-Received: by 2002:a17:902:cacb:b0:158:694f:240e with SMTP id y11-20020a170902cacb00b00158694f240emr17383577pld.153.1649900671240;
        Wed, 13 Apr 2022 18:44:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lk16-20020a17090b33d000b001c9e804f2c6sm4591057pjb.56.2022.04.13.18.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:44:31 -0700 (PDT)
Message-ID: <62577c7f.1c69fb81.d6516.d12b@mx.google.com>
Date:   Wed, 13 Apr 2022 18:44:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.275
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 106 runs, 2 regressions (v4.14.275)
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

stable-rc/linux-4.14.y baseline: 106 runs, 2 regressions (v4.14.275)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.275/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.275
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74766a973637a02c32c04c1c6496e114e4855239 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62545fd051def9d07aae06cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62545fd051def9d07aae0=
6cc
        failing since 4 days (last pass: v4.14.271-23-ge991f498ccbf, first =
fail: v4.14.275-206-ge3a5894d7697d) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6254608dab94aa7d06ae06d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6254608dab94aa7d06ae0=
6d6
        failing since 56 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
