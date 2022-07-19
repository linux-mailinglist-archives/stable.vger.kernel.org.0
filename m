Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35228579266
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 07:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiGSFZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 01:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiGSFZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 01:25:36 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A639264C2
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 22:25:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p9so13688600pjd.3
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 22:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f3SQJpARrotI73mAOO+Q3fNWQpDvdlQe1GVosKZy684=;
        b=sSvcg9ucFxQG2iojSseQPo3ZLE94OE0TaZ/bLOUee/so4lRpKCkU+fXHxvCbeF/jSV
         RJ+jnvJTB7XqV2KEHm3iyKSh9gisDtqMhxxiTDVe17Coo1aFP/JO7vAoBZqC93s4mD26
         2WDkGbR2iTbpLpIUoRQsEqKYofSof/QHsarvOjDdgQ4ceOC38Y8nPn9KtnwnuHRxsMrF
         GAnrW6KdXYKn4FEu5ivAU25gw7nsdXm0HvHauhj14E74kFlH0Ml0aerg0e10pqV9S5bI
         cLwmC2hEOnEyikMdzBTMZVgetLP8+QKTnX7xbJFdXIWDa/a4Z2Bf6gAToE73GS91ojNq
         T17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f3SQJpARrotI73mAOO+Q3fNWQpDvdlQe1GVosKZy684=;
        b=x/QsMYiV11ee3YPkyKI3YpIQrDHBkhAVVg3Fdaw/i/SNejgSFovAhPjzBPfX5QegRa
         EtjBKZ3CA6K6GwdZIbKXznKj/W0+ybvy2WNe/YiRe3CkYk3O4XiE8HgZ5QUgfpUZ1PdA
         ON5r3Ry1o5Xm8q7ZYoNSuXZSgstJhqjG4Qiv+vgngPKzDSKPOSWskux8+a4icZQW9P/l
         VsBxJ2tbfqv8izDBXODdOQGkSLDNMYhMgMmqVcDx8bJJr5qM9dl3erEiiXX/uF7Hazs2
         +rDVGQigjIvNTuevHPI8xJ5eRNQ/Ufh5GBKudhkCwjevS3fzavkF4ZnaHE5ONKUNErva
         D5hw==
X-Gm-Message-State: AJIora+CgAHWroAWlXcy4QeQ5Z04yGO09vi9kmFSndTgVH/LcHSiNMj3
        qT2xqU6ZYt08aCDfhXlIsNwnzD49suDTxszR
X-Google-Smtp-Source: AGRyM1ui/MHRF326gRueLH3Yi38ZXrxU8VDjNXAYa/d+co2x6tUNjZirRvZ1zp6855UWm6baY2Z0bw==
X-Received: by 2002:a17:90a:e7d1:b0:1f0:2304:f57f with SMTP id kb17-20020a17090ae7d100b001f02304f57fmr43273624pjb.133.1658208333392;
        Mon, 18 Jul 2022 22:25:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r16-20020aa79890000000b005254e44b748sm10220037pfl.84.2022.07.18.22.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 22:25:33 -0700 (PDT)
Message-ID: <62d6404d.1c69fb81.a8f98.f6b5@mx.google.com>
Date:   Mon, 18 Jul 2022 22:25:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-231-g6fff5045b5f0
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 138 runs,
 2 regressions (v5.18.12-231-g6fff5045b5f0)
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

stable-rc/queue/5.18 baseline: 138 runs, 2 regressions (v5.18.12-231-g6fff5=
045b5f0)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.12-231-g6fff5045b5f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.12-231-g6fff5045b5f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fff5045b5f039fe0764005f0f95475a4effa9d3 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62d61ffa378840b39aa39c27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g6fff5045b5f0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g6fff5045b5f0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d61ffa378840b39aa39=
c28
        failing since 13 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d60b2c4a645f0fffa39c39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g6fff5045b5f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
231-g6fff5045b5f0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d60b2c4a645f0fffa39=
c3a
        new failure (last pass: v5.18.11-63-g15e4c0612627) =

 =20
