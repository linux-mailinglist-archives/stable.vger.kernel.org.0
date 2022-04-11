Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B074FC5DD
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiDKUfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 16:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiDKUfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 16:35:14 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9FD35DD2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:32:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y8so10434402pfw.0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 13:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O7chtKVZYkOcykfTsNzAc6JoZ4w9BDcgxdVScVCvMLg=;
        b=63u9OYnILa8BiuRJphj3zOEjfjVm5YRN5EI8JxSSx0NDx3gJTZERftAyrj0137WL3f
         tbmm9wBswXyTS+CJM3cRtmMAVD/S1IsHvaVDBWn3fgJs8PRuAgcAWjuhjFN0Hx6M1zq2
         4yU4RUIGNB4NyEU5vzHen1AqrgwTuaQEiXHtawibISLrXPEXvhyzqyFKUCg5/0fQ4zt6
         798eFZIPKMV18l7TYItLFqNzHl/jx68FCiVnL/8aqgOcc+2pD6SGZRYsY6BBMKHTW06g
         boMfXR8oyvvDlAfX+fWLAkEVk2xeGvGIdKUZ/XVaqSlIBrfv6b3wVHNo/wDKWZhZ8bZk
         3cLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O7chtKVZYkOcykfTsNzAc6JoZ4w9BDcgxdVScVCvMLg=;
        b=mlAXtTR+/rNg14DQML18bLLkxwliHPKpCYxjsTCMrZzuPuvbc+bmi7t4LG+0X3gnES
         83UdPNK8GOw14JodGnLkifP2gfJ1k8fuQAToTSnm8LBEoi9OtDxWzy+W5I6io4mDD4sA
         4FFIzvSnmn7d9T6X4jBTvioPqjV65/wF72sM1hesEpVtH5cv/Qnfc4K2kVV9STazCi46
         o0fVVrBv0YXsaJIbYBXattwUghWo6BLi4Kf2Wi4ZuXWaoxqHFqCybP/R1cnodufaaGI/
         YEC6YgauX2wkuoL3ulD77pIdHcpt/LfR1CE/uu4jNwhiT09qSSloOhVlVJQHVgX7ugTx
         a5MQ==
X-Gm-Message-State: AOAM531pCwqsBZCI7vRdd5lW6GUrX+lOIFq6ZPyad/W0tA77UGTyGinN
        E3ddRzjoS4FRKPCHEDKL2lZ2LdoswzqRmNlp
X-Google-Smtp-Source: ABdhPJymkzYRvhKUmKfsO49o7ollrcwLYNFbUtjxLlOy0V16qabsgOppApzYTl24gfZ0Y5WzajsYdw==
X-Received: by 2002:a63:6c4a:0:b0:398:604b:7263 with SMTP id h71-20020a636c4a000000b00398604b7263mr27890857pgc.545.1649709178815;
        Mon, 11 Apr 2022 13:32:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11-20020aa7888b000000b00505bc0b970csm5449485pfe.181.2022.04.11.13.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 13:32:58 -0700 (PDT)
Message-ID: <6254907a.1c69fb81.4ab85.c7d4@mx.google.com>
Date:   Mon, 11 Apr 2022 13:32:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.275
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 98 runs, 2 regressions (v4.14.275)
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

stable-rc/linux-4.14.y baseline: 98 runs, 2 regressions (v4.14.275)

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
