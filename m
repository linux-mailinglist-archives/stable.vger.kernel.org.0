Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E92F5BB0EA
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 18:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIPQKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 12:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiIPQJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 12:09:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AF82CE3C
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:09:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so122576pja.1
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=MmVZBZvUzAirFSqKhs4KwOTEu9PYDFSCpaivOYYZjK4=;
        b=UwQi4I5LzARfbeeIIHGotDt+f3x9TfhCln315+EmRGq3yxnOLip/oZfJd8MoFzFnQA
         sfyhGJmUgmPSSNRB1bc2wVdOoQyR5Qi/RSxbiDx3luObh2HYc0sd40Vejiky8e3aRsTI
         aJFJ0R/SZR4Oq++gg+YYpmPaUHIZXQgE0AImvFtLM51HSj1TXjRu0qCydWIw5dgx9kao
         tS/omQaVI88EHEJiijIoYFyZgRWDKgZiojSDiek2FrCpfcIszHbukQnIM8Wf2PIt0yFV
         CTT6lEIw03vpqTrqKpH0V7S5ywq7RISs9Ci8dshbJJII1Ba8tRHYv0tSyoYkdCG9E2Nq
         Z+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=MmVZBZvUzAirFSqKhs4KwOTEu9PYDFSCpaivOYYZjK4=;
        b=OyMR29AQXSaGY4UeEpu4DkIEy5aOT1FDX40uCh1AK24uvHV74nlz8xd/Qxy2VuUotI
         G9uDcOem3UDFqtczZyz5rn1xlPYLpiQly8zOdIzveG0wJA9an+Lg0SUmMPu6f9lLBgQi
         HTmch7ctheJe0f5ulrdbcBhmHLxk46LEF0/j0tjrsUCnj++O+Lcz3+aOGO7XxHg0vwYu
         X6Lb7LVxq/pqf5VBfD4VSO1d4653MncwDuFW9zt4qr9CWXATrHm52FBM5Wiv27q/xTCo
         Fb7H9dskwi4eu63/OjPx5duNldEPdCeJJmF80Kc/NtscYH5h3dOtPypNlwxcgU4mkLDW
         KW7Q==
X-Gm-Message-State: ACrzQf2NLBPYK2PsVxM5eeAJBWBxEa4kmTey9XkWeReFdOSODURXAyH7
        VszqlJRD0RvUXdK6N3o3oDyHdXVij6tLugs9TEs=
X-Google-Smtp-Source: AMsMyM69wwpSYBmFaoLoz077ImSQUAcHwI+45uaPJm0xa5ILFduR/6xUB2MYVVNwiW0AAM1tSkpCXA==
X-Received: by 2002:a17:902:e402:b0:176:e82f:3f4 with SMTP id m2-20020a170902e40200b00176e82f03f4mr532877ple.107.1663344597874;
        Fri, 16 Sep 2022 09:09:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3-20020a170902d48300b001786b712f0esm4186441plg.227.2022.09.16.09.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 09:09:57 -0700 (PDT)
Message-ID: <63249fd5.170a0220.caa49.8585@mx.google.com>
Date:   Fri, 16 Sep 2022 09:09:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9-39-gf5066a94bca4
Subject: stable-rc/linux-5.19.y baseline: 184 runs,
 2 regressions (v5.19.9-39-gf5066a94bca4)
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

stable-rc/linux-5.19.y baseline: 184 runs, 2 regressions (v5.19.9-39-gf5066=
a94bca4)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.9-39-gf5066a94bca4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.9-39-gf5066a94bca4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f5066a94bca42cc8cc64e9999063584bff59f8d6 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63246b2e9c82bfff783556d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
-39-gf5066a94bca4/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
-39-gf5066a94bca4/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63246b2e9c82bfff78355=
6d9
        failing since 2 days (last pass: v5.19.8, first fail: v5.19.8-193-g=
3acd07a8c4dd8) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63246efc957e9d88e0355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
-39-gf5066a94bca4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.9=
-39-gf5066a94bca4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63246efc957e9d88e0355=
672
        new failure (last pass: v5.19.9) =

 =20
