Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D307E4F6D12
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiDFVkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbiDFVkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:40:04 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ADA76281
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 14:20:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m12-20020a17090b068c00b001cabe30a98dso7007396pjz.4
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 14:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Oz9yOu4qgCky6AYkHxkC4rmGA/BY6K+v28EZvT9Jdmw=;
        b=orueSc9cVoFsQG/nkkPJFCxodrku06yaxfYGpjgwFjrV6QxCnrTyVXk3M2B47z9GQr
         6hq8/HyMzrLu7GKWZsacY+FE+gY+PxUa0CQ1q2+Rkx+C6WnjIm81R90vmPp6T2BlkGdh
         vwT0Bbu/94dcleuRAd0R4/9rXwW78jWuQJF1M128XEWjwbvpYxndPOMG1Eg0V9Hbsvax
         b7wFR9ckNKtST8Iw7wZYeMZEZZ4qU5y/J2sNepfjWOIPcOVst+duumh+lygBN6+qNEgW
         a4JwpJ3frGWZxXxPLCYJDXKV5tiIPhn5BsSFkaC6pJFlDJ/rW4Hpdn3KG18kTByfkNtG
         S5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Oz9yOu4qgCky6AYkHxkC4rmGA/BY6K+v28EZvT9Jdmw=;
        b=sfptWGtfbtuKFa0XOwo9+mwXrx60JGafLbMp1bU3wpmQqqHLV6A/Ggh9VPj30r71Nk
         o7TW/huNSa80MLp8DgL+8mA1k0zZzNAQ/lvm7On1U4wNeXiKaeJVam1IrmDhmRbCXzNv
         d93g1GyV6CuNP7mcFfbPjgtq+t2ifWEl3W8R1OlR3YUkvtgdYT23RGbtIah0F6lMoclx
         lj4F6X05dxnqhUqO5ZI1NRDDO0WgQKbm9zUoh17kl7Pe3freuF/aUo35tA8DpZC0Br5v
         SnnUJWiMZ1BPiSNvd/jy3iMkAiT677YyqiIHV1wedzMVGd+CD8rjsF48KsWyGwtWsB03
         0jrg==
X-Gm-Message-State: AOAM531ZMYUOABfTS5vzSci/JV8Nxmdven/TAz6OQI3MOFisA3tttPDr
        evMABMOKy7Aq9IQIdvxVc0RpUhjywKZnkj+kldM=
X-Google-Smtp-Source: ABdhPJzD5rdM8AR/dOUyewz+Hj3GWXkE7eWMEXId74mjWnu7PaEJXYOLEcD0ds64io0EyLTUKT/zxw==
X-Received: by 2002:a17:90b:1082:b0:1ca:aac5:5553 with SMTP id gj2-20020a17090b108200b001caaac55553mr12112070pjb.235.1649280015018;
        Wed, 06 Apr 2022 14:20:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b188-20020a6334c5000000b003995aef61c2sm6119970pga.86.2022.04.06.14.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 14:20:14 -0700 (PDT)
Message-ID: <624e040e.1c69fb81.37d1.1275@mx.google.com>
Date:   Wed, 06 Apr 2022 14:20:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-367-gdcc93affc98f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 28 runs,
 2 regressions (v5.4.188-367-gdcc93affc98f)
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

stable-rc/queue/5.4 baseline: 28 runs, 2 regressions (v5.4.188-367-gdcc93af=
fc98f)

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
el/v5.4.188-367-gdcc93affc98f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-367-gdcc93affc98f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcc93affc98ffad8d106904d74f0a04a10d10855 =



Test Regressions
---------------- =



platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/624dcbd8b556112f33ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-gdcc93affc98f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-gdcc93affc98f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624dcbd8b556112f33ae0=
67d
        failing since 111 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab         | compiler | defconfig       =
   | regressions
-------------------------+------+-------------+----------+-----------------=
---+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/624dcbd756e55abcb4ae0699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-gdcc93affc98f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-gdcc93affc98f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624dcbd756e55abcb4ae0=
69a
        failing since 111 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
