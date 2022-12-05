Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5664224F
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 05:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiLEEfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 23:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiLEEfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 23:35:53 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A2657E
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 20:35:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g10so9714505plo.11
        for <stable@vger.kernel.org>; Sun, 04 Dec 2022 20:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=muMBUUHvOc+InY089tJqzd0leIvjmVFmnhnOtKW1Oz0=;
        b=ytdDy7JesnPuHSRuc6J0RbV9P5zlrKe8m0iqV3wOFlzTRUNAHhIRbbhb2lX4B+5peO
         N1RYZv7zLkUxo7RzQtTg9DnYBkmTJ1Z7HqFXG7aXyO69ALW2nbdmA+NruazFR2FnRFvr
         2THuh6y3YPtRy8sD22QG/KVjNUJJdWd6/YMr1SLmHD2xwAsh3DWSRNxXyNlP5ejzs6pM
         rKuqXuCVC7oD2UHFExPVhpEOQa1Hqw2jP1YNhXf9GHmhh/LqrfDdhys8lHhk1rbopl3F
         CjjBD177QfL5b9dAu+hq81r6ksmUWp54iiPPfgcPFdT/K4S1s6DDKcb1hytx21mHFZnN
         k54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=muMBUUHvOc+InY089tJqzd0leIvjmVFmnhnOtKW1Oz0=;
        b=WhkkNx2HC1/8oLkGO9OILD0Gp2VJwAPfm7Q7Mv3AmYSQXhKjgeWCkdoqOHU2kSUhn0
         kMY0jV8DxHVevJFG/AhvwcxGukeavhpzEEobVCcEnRW0vSZsLdXRZ70NfLbrcjYMWGrP
         6JingY0e60UX8856gQxmbIZ44jhUse/4MkiRXJwB/9GK8e+Ws7v5jHHJOvMTx+ujUFWr
         3P5tZebomYPy1zCpNoC+Of8dlt3CZQadQjUnc9NN8Lr5y4Jy/O4+zgrIRIxZNGcgnuHG
         rBP0IsUKi46QwbjJobUkDgcxHSPFJ9QTnVWvTwUoBb3dt8COm58ErZDaE2S3O6ThFkPl
         N6zg==
X-Gm-Message-State: ANoB5pkLMSLgIuVhbkjlAm8dgaV3N2YrjJgMN6d6o1E9K4g/2Yg37GwE
        EbkYQ+Xn5kAXXo7ukRSShlKdJgCAzTrpX+1Ut4Yw2Q==
X-Google-Smtp-Source: AA0mqf6Hmm3UppikOOL4V2+pK2UJPDDY1uhG2YW3kVMQapi67yDrbNIeQls91BOplgaiOz5u1t/kTw==
X-Received: by 2002:a17:902:ce90:b0:187:19c4:373a with SMTP id f16-20020a170902ce9000b0018719c4373amr76016455plg.163.1670214951207;
        Sun, 04 Dec 2022 20:35:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902eb9100b00188b5d25438sm9486414plg.35.2022.12.04.20.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 20:35:50 -0800 (PST)
Message-ID: <638d7526.170a0220.9dbdb.16d8@mx.google.com>
Date:   Sun, 04 Dec 2022 20:35:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.157-89-gc25b559cba5e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 127 runs,
 1 regressions (v5.10.157-89-gc25b559cba5e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 127 runs, 1 regressions (v5.10.157-89-gc25b5=
59cba5e)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.157-89-gc25b559cba5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.157-89-gc25b559cba5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c25b559cba5e3f04339722bc2467bbedc0d8c50e =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/638d43abade70e74ed2abd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.157=
-89-gc25b559cba5e/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.157=
-89-gc25b559cba5e/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638d43abade70e74ed2ab=
d17
        new failure (last pass: v5.10.157-84-g8306f7a271f4) =

 =20
