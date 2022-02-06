Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970454AB158
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 19:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiBFSmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 13:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbiBFSmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 13:42:50 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82BFC043186
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 10:42:49 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id y9so3158085pjf.1
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 10:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FTPcZ4Nopx6VpBBQHRtuOmygT/ZaMYxp0yvAVoHWQFA=;
        b=rPoS4+rw2Q4nY9/kf+jSD8SEn+6+BUEG9VypJe2M0Kb7k8egBmaC+njgcg/cNJS81s
         ZeIIVxNxPZZw0mHC/RFoP22SB0mg3WIFntiqsEuEuIbJ9XtH0TsCQ/IJyZuJB9xqbY7a
         vSsxWMcbPoJ5/rKB938+44UPsfAIzyM/jIdn4BxLaPJVEko6Uk9HVm712cjxS0fnwI9j
         h01G+Y0nxHlikSt3MQsVn0M32sYz+G0Aru4XYYPRFsvJRGZV3FlzOB04HWrR0/OFZu9k
         mDwDHoFx7tL4iooAVYASkbsMkMxLqNeGcsOSpish3qajbrdavV1NG66WsmFHPs3x6TTI
         eVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FTPcZ4Nopx6VpBBQHRtuOmygT/ZaMYxp0yvAVoHWQFA=;
        b=evC5omCpZ8Hf2+GsQIi5evlJWpvbvSPib9thLVzCtMyDPu9sR+eKTOCkyT9cizXzaX
         CFxX2oNABJPWh7bLyIlXGLNBqTrhLNAQAQF8A8OXv1pNZKp8bhXYUSxsi98wzBmdEsO9
         2q1iaYfLZRJoDjK+E4zX5zHOEtWMmTp3TGWaW0IxE8VsGgil4nzKBZ7NbSC/BoRGuu8T
         0e8W6LhAcpCysTu2Yjv3sij5voctW+IOERXJ61KK+yYY+tjaprr8acHs0sgIvGAsBqo5
         EzLsniS/7SwcbioXnZNV19Ou/Q6TS2znTI0nhitF2+tG13SUUsAnLCah+mOTqgMGE4/g
         lCYA==
X-Gm-Message-State: AOAM530W9Affgo7b5qBw50yxclxGUnwvnZyIpMhbaQHjdkcu6+TNejWq
        oIcG3TEF3bmRol1Qodk48VkNyZQtGB50e8lF
X-Google-Smtp-Source: ABdhPJw4lU++ttOPHn2AUJFDVB8z3BBlfUmuH+QLX3Qcn1qAaXdWNvarLoAAqDnuGgY8wRMakqMg3w==
X-Received: by 2002:a17:90b:4a4c:: with SMTP id lb12mr10097918pjb.85.1644172969331;
        Sun, 06 Feb 2022 10:42:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id na7sm20966612pjb.23.2022.02.06.10.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 10:42:48 -0800 (PST)
Message-ID: <620016a8.1c69fb81.9a609.53ff@mx.google.com>
Date:   Sun, 06 Feb 2022 10:42:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-66-g44b361929f73
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 119 runs,
 1 regressions (v4.14.264-66-g44b361929f73)
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

stable-rc/queue/4.14 baseline: 119 runs, 1 regressions (v4.14.264-66-g44b36=
1929f73)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-66-g44b361929f73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-66-g44b361929f73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44b361929f737c96db5b92a48ac5047bb459e812 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ffddfdb66adf34a75d6f05

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-66-g44b361929f73/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-66-g44b361929f73/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ffddfdb66adf3=
4a75d6f0b
        failing since 1 day (last pass: v4.14.264-40-g54996bdd9ffc, first f=
ail: v4.14.264-45-g6b11d619aed4)
        2 lines

    2022-02-06T14:40:39.920397  [   19.922576] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-06T14:40:39.958752  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-02-06T14:40:39.967937  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-06T14:40:39.980831  [   19.986328] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
