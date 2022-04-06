Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F844F6A26
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiDFTng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiDFTm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:42:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD7418CD31
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 10:50:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 2so3267443pjw.2
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KsbyiUom51SYp+5Mb/5nUfIDL1uwtXorJ/8u2G8ozCo=;
        b=I8DP2XQth/U5JLc+S8gk9GiucPwfOryCnbtOaqjz1sL2DE4TLBxeGKiDWY01OI9heS
         LcE9TRJ3u9GQELFRUeTIhD9XWFhISTgwyAHI6HG2YU6J/ygHPNMMtCHokTf3Unc7SorI
         fq66gSmHnYCEy3P3lPEMeVa24hqKq2NlunYM6YECaWZmO5IgAkcLQ2h4cfpvmsOQHrxt
         7Gy9p2kWnTU9MJqfK22wyPq3ipa0FDeqnWU8AU87etEp/jr7Z9fwDkofjQ1lwm6j39Vn
         /gkgEKCZBRE6X0r/KChrSvf7KXhY7fY61FrguhtMC4VMLFSbyfPcQbKq6vFWgSG+vQhW
         dpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KsbyiUom51SYp+5Mb/5nUfIDL1uwtXorJ/8u2G8ozCo=;
        b=urVanaisaWEo0E9tX1DL3gwrEQNGz2lcIBGLq/JOtgOi/1xbF/DKOwaCTpazjnufZc
         bm6b0IWnHf1n4ESc/tp049TDoUvg4DGojXyY5BugjE/QbOaD/PmBowRp62jwO41TBx4u
         KQrcnbbtR9Ml6Po0MXxk8oQTdAmkwelvPC2vacfbDjzAlZRAY2aqIYbGBi1cBVYDQXiR
         QjvOyCQQtHEao8LAY7JprbFORYOkb/09i5tovVHTDqjnee1xtqi5if0NGARiRsrQh0g2
         ra4XhM+Yw+79L8eyk/HATPjsOH1sA4a5nMv/H+tEDiqQ2xZBRRKzKBZkIenwFvkdGDDq
         c1Aw==
X-Gm-Message-State: AOAM531NntISmsDLXATkhnp+HRLX/RoTsSu1IzDzTQ8BIW4VFhpj2QyV
        RjCSm7tGHGMYQSighBpHagBF8LLPnkPnbxxXt7w=
X-Google-Smtp-Source: ABdhPJwnvC6Wv50FCfJ6+giB6srNRPW+uSLofL/p78yKOJTJD6w24zZxh1rOkrdoclRu8cPCzXHm0w==
X-Received: by 2002:a17:902:c105:b0:154:81e0:529d with SMTP id 5-20020a170902c10500b0015481e0529dmr9851395pli.1.1649267429958;
        Wed, 06 Apr 2022 10:50:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm20676421pfv.24.2022.04.06.10.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 10:50:29 -0700 (PDT)
Message-ID: <624dd2e5.1c69fb81.b9d8a.5c68@mx.google.com>
Date:   Wed, 06 Apr 2022 10:50:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-367-g999e2e13ea75f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 61 runs,
 2 regressions (v5.4.188-367-g999e2e13ea75f)
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

stable-rc/queue/5.4 baseline: 61 runs, 2 regressions (v5.4.188-367-g999e2e1=
3ea75f)

Regressions Summary
-------------------

platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-367-g999e2e13ea75f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-367-g999e2e13ea75f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      999e2e13ea75f28b915b769d36e19aaffd2a5cce =



Test Regressions
---------------- =



platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/624da071224f231458ae06a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-g999e2e13ea75f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-g999e2e13ea75f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624da072224f231458ae0=
6aa
        failing since 111 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/624da073200fc5854bae0686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-g999e2e13ea75f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-g999e2e13ea75f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624da073200fc5854bae0=
687
        failing since 111 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
