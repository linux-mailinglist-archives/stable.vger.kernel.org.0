Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8516502A88
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 14:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbiDOMxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 08:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243415AbiDOMw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 08:52:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99361BF51A
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 05:50:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so7561446pjb.3
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 05:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1nLZm32rSGhmiNXK2VO17yUm3UANBuODQsUrGOd74xA=;
        b=NlqnQXgkkwJefeYFvAMYBeiE4Mh7GNr6KN/CnuQrpZWVlSIwBvb/rlTttGiXE3snam
         a+ONt1kRKjttTvmQf3DgJpcxsVluK3qu+LTWFgJjPwC5xpnTNy48L/TVoEE7m8yRISOU
         0g9ztSYuPI5jnkMy8xjLpq7pcIftlmHYeIooMPUKFGAERN3DYhRmAc3oJZ9Ess/Nbn9F
         RrRHAsvFPFvdTdXtkLmklz/LmH3YgJN3B+90aUsqeytSstNx9lM6epYpugIqvvf5hvQo
         135UY6yD1IUX1Ip09QkmWsYkN7vD8aNtXLyP5CnHKvKVUDiv7ebBWSGb05CX1lJquyBf
         RZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1nLZm32rSGhmiNXK2VO17yUm3UANBuODQsUrGOd74xA=;
        b=Wgt2IejpaZGoNN1GIhPW4TsTJUuVUNan2FeKPH66YwrvYoAn9XD17HY55hvTiRM923
         5QcHoeQAw4DJHiifpM35R9IBX4YjWyfTpHbJ40ZlqjVZmaHXwwpLP/dcmkkBUDPvjpEd
         7dCVND+uqLtPyb+ARu+UCRlQz6UWzRfvFcrtTeN/c+WFrejDm24HDfKohEnu8uJzMW1b
         LeAF4xMfoi91OR2f+s4MS3XrkZU+ha8cUWa1TtIF1HuU/ecA+sAqWOtc5QiC5b2ZI5xN
         rhD9seKSpwzTnr5OYntj5vcmEd2drVO92WEMBXOqJ1A5WvW6HbgvE9D051wVlHR4SvMo
         c1fw==
X-Gm-Message-State: AOAM530BvYLHBcIKbxGlE8nx3jLQjmYTKedv2xLSFo+rwYoHsEfrqUpy
        mtPUgGEdEFkpTrX9AOna4xrrTLGsHwhWIN77
X-Google-Smtp-Source: ABdhPJzNf3H/fMpvHnn9E/zuvcWWig4Ho2mjaGWpPLzRU0wdPNbHeBbdSlZnWe+wlC2ikH7pxiiRMA==
X-Received: by 2002:a17:902:7d93:b0:14d:d401:f59b with SMTP id a19-20020a1709027d9300b0014dd401f59bmr52866664plm.14.1650027031026;
        Fri, 15 Apr 2022 05:50:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5-20020a17090a2a0500b001cba3ac9366sm8608300pjd.10.2022.04.15.05.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:50:30 -0700 (PDT)
Message-ID: <62596a16.1c69fb81.50f33.7887@mx.google.com>
Date:   Fri, 15 Apr 2022 05:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-260-gc9041fbb58790
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 86 runs,
 1 regressions (v4.14.275-260-gc9041fbb58790)
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

stable-rc/queue/4.14 baseline: 86 runs, 1 regressions (v4.14.275-260-gc9041=
fbb58790)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-260-gc9041fbb58790/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-260-gc9041fbb58790
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9041fbb58790d1ebc2fc5306f0faf6d9d060147 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6259397efe5bdf6766ae06a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-gc9041fbb58790/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-260-gc9041fbb58790/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259397efe5bdf6766ae0=
6a1
        failing since 9 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =20
