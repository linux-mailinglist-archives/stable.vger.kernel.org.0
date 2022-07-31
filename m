Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184DB585E1B
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiGaIWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 04:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGaIWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 04:22:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280FA11C3F
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 01:22:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x7so7962382pll.7
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 01:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZFltir/sExpPMsKtC99B7xSG+RDI7IVkNbh1KNy23ak=;
        b=ypMEdXbPxRXazZqmh3MGF0RpOZliIgXhYmkADfxPKthmxtMk+B304pskOfWutCmbd3
         UgN5KzwM8/iePp+L4xwgdgR2B0SgKtaddiYJjRdNv21zU0QxEFb6wnTN2v1l/xO61YSY
         EsGvhC/KWngvI9wXa3MsYMg8+mYKeiUKJDfa0kBc3Y1/9n1mWeCdQusziR8UyOhs5Csi
         C/MHbKgcW5b/DGUCtI47BpqIdYmS8bwG1LSaPWfHj/QrRfcjbhp1O6Iad5UvicYLpjMj
         n/U+8CM/uDuBXZ1W5yU9aZ0q6H8r33cIGnz2eWNOnsv7TwYmDUxRO/3kttRrP5zFkcP+
         h3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZFltir/sExpPMsKtC99B7xSG+RDI7IVkNbh1KNy23ak=;
        b=QfEdERbgFqIj9cwZyfuLg9c6bVlF+FCVaA0HSd3k4LdfG/iS54XLtFkXa2I+r7P5Vt
         nLWMPbTbY5pT21vIKKzq3iA1+Tgg0xYoG6LhIlZ5mlU3A5iJ0mol+BZwthMYmC21jGzb
         vRLZIc0XQ3kTCQ5x27BkjcVYHzrD3q3+ML52zY5EcJKT4+AubjgDXopDiiryPD3nP8IS
         LX2Y3lViATffBT8Qgkoj4BGybeJrVdUPI3CLyrTIKF0NWYyIvF/ceF2+J4uGqEiaAiLe
         +8lUaBm11+RKQC1Q/pSBZVY+3nuT5EsksUKoywVfZbnx99iFuo+8HCvUUXBppMI/OqkC
         nOmg==
X-Gm-Message-State: ACgBeo2n5EQyDQ93c0h03C6zYONLQ/CzdqZz5rGIEFMXBraIcajmRdVe
        aTfpx3F1z8dQmbgMOKrDzQCO1D5MrjoetA06
X-Google-Smtp-Source: AA6agR5Tey24k7cCqPd4Pf7RJ1zNr8EU7who4w9z9GbqfzO96jcnQXC10rpskV2WS8Ffu5e9SuOdWA==
X-Received: by 2002:a17:902:e94e:b0:16d:12b6:b9fe with SMTP id b14-20020a170902e94e00b0016d12b6b9femr11420755pll.152.1659255734532;
        Sun, 31 Jul 2022 01:22:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14-20020a17090b018e00b001f21c635479sm6163304pjs.40.2022.07.31.01.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 01:22:14 -0700 (PDT)
Message-ID: <62e63bb6.170a0220.5c40a.8f7d@mx.google.com>
Date:   Sun, 31 Jul 2022 01:22:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-237-gcc715161ac9db
Subject: stable-rc/queue/5.18 baseline: 110 runs,
 1 regressions (v5.18.14-237-gcc715161ac9db)
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

stable-rc/queue/5.18 baseline: 110 runs, 1 regressions (v5.18.14-237-gcc715=
161ac9db)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-237-gcc715161ac9db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-237-gcc715161ac9db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc715161ac9db2b8e9a81b05e568d5b8776d6f73 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62e608b6ff11071495daf0b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
237-gcc715161ac9db/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
237-gcc715161ac9db/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e608b6ff11071495daf=
0b9
        failing since 25 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
