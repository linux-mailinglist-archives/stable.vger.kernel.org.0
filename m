Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5F4D383D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbiCIRxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiCIRxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:53:53 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB15233E1B
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 09:52:52 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 132so2600926pga.5
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 09:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eJLLdZc1UmMoE4ori9QDQsFMFbpxGNJ9ccOK4w78msc=;
        b=ZE/tiOIVTtaCeu5siFHUusSBgJyHMFbdMql5AgHmgBizc2s3dL/yW4YOK1U5MtBXTc
         WRLGBxEx8ULGmLRLC58Dr2MJx+wvZQfUtHk3wWcguRrSbuV500NN6OZj5oj+cSeuOTUs
         LJUEHdOi+LgKNSPpQqO6TnVuv9ITv8BOj4tZxiV9BTUIeOyWm6Ggdaw8lr2q2RB5Ed5Q
         XgbwzG2T8Iabfvv+aawdFegT8elFgaWFE4d8P1GFtgxtrUyq6M+CVVVZqIHEXeTkgh2G
         DSAKg8mwopqO90B9J4nathNgdFPOdBVvNmuLzuS+RRFOWDkaVoeGMWm8hDyBUyS95+WQ
         5BYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eJLLdZc1UmMoE4ori9QDQsFMFbpxGNJ9ccOK4w78msc=;
        b=dMKYmDMbFd4guAWwO4bAy+4Ys3NifMmxD0xCKT/6yNzHd06q6Qn2gWFMJSvNlaPZS6
         U32sJbMF1gBU77gvfkOzkSl6TkakzcPTYZmpn6hNOHdEFYS64t9xlIzDE2R3UVpYK/1E
         tR76BiM1wtdX6imt0jRW3XxN2MR1zr0dtAvdAAo6fRt2cx0GkQ60v8DeLSbXxj2DhMZT
         d0Tv6/LwRhHPE3PpYlrapRZ2XJqeJJ6NmTEhLzHF++K/MK0KyylLyzFefkAmReCWuEft
         /97TZ1fsSJ2Xhv9u6bq0CIPk2A/fmAL+SyURr2EdSo3tT6O/tGvEDnCVIoJR8tpdbGbw
         7dNQ==
X-Gm-Message-State: AOAM530eXf0mUMK1XB3hjGUr9oJJHzS11anUMNxb4D8o5fzvXlD+DqR7
        8MG/szVlc7ZjxLTosg0Ehw1TwHxHqZK1yCUXkEY=
X-Google-Smtp-Source: ABdhPJxu/e5CHw9b0x5FDdGi3HV4NoUk85lrg/Ggmw9stgRvm0Ndlj5aOZwa0Qw6dNHPJEdJSjZItQ==
X-Received: by 2002:a65:6b95:0:b0:380:85c1:98e3 with SMTP id d21-20020a656b95000000b0038085c198e3mr704354pgw.511.1646848372088;
        Wed, 09 Mar 2022 09:52:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f9-20020a056a00228900b004f3ba7d177csm4141687pfe.54.2022.03.09.09.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:52:51 -0800 (PST)
Message-ID: <6228e973.1c69fb81.5e8b3.9d59@mx.google.com>
Date:   Wed, 09 Mar 2022 09:52:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.270-19-gbbc81a04d0e6
Subject: stable-rc/queue/4.14 baseline: 44 runs,
 1 regressions (v4.14.270-19-gbbc81a04d0e6)
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

stable-rc/queue/4.14 baseline: 44 runs, 1 regressions (v4.14.270-19-gbbc81a=
04d0e6)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.270-19-gbbc81a04d0e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.270-19-gbbc81a04d0e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bbc81a04d0e62bd58635214d3899c884d2520017 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6228b204bb88d806bcc62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-19-gbbc81a04d0e6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.270=
-19-gbbc81a04d0e6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228b204bb88d806bcc62=
969
        failing since 24 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
