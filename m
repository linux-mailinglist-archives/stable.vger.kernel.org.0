Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9404D9205
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 02:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiCOBKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 21:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiCOBKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 21:10:19 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787C11114B
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:09:08 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso1007937pjc.0
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J8J+dlgBSzA1QgWGytflsmSAjEnLbVsgLFIZ3DvgzZE=;
        b=WJpBvou05MIH2VQWnP9c1Onzg2N18TII6Tv4EG+f3BFVOCV8jSE3fKU27adzBP9k+3
         2KS/nBm0HCofnpOnMDkdkBABBW077vvHlIMJaZ+AbRErR29WrVhICE/pikjXgNx4cNiY
         /Dp5QaNLDx4X2T4tkQYpdgOGlQ++hJBLlCnptjeNPT3LHp8/djEk44rGerFzDz/ZjDup
         JZy9I79t7UPSOAXfUc8lkd5pI0jjSzAOnnvW01FDJaeMvQXMTTH2i9baTDu/IFzf6ejc
         Fc6iVzcXOJnbMnflM3DKrKaSxTLnA3ZINTb4id+YjYM4/NKE0TUIUFn8G0G8guyAKdi7
         8hVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J8J+dlgBSzA1QgWGytflsmSAjEnLbVsgLFIZ3DvgzZE=;
        b=T/6Dv5k0TVmOkZBgprKs9R4nqXqvKjOMLqK9kzuR2EpBoWQlHiqhPiG4yauUXofob6
         K1AStQ9YPnvalSUntLLcgYktL5QZWQoSIHIv7hHiH78ANY8SXpccAWLPnH37zaGieQTe
         9JhlRZsy9PSDF/XpjfL+l23fJRBnNb3KuZiHPA/UP35unSJe4X+gqj58zhmZSTy0Ugdq
         6d9mzLt3GWUlYmaCIdW6gD2m1YoAyPmIVX97y0GSlFrDYqO7bJpToWyHXLAOHPbqyJss
         92cPAmC/NTWn0/RYW0NeXTloziMCedf8y0mksTGFClC/kNfbEl49oFetNgQrtCaZRTM4
         DwbA==
X-Gm-Message-State: AOAM532i3sWrxQP5dHjBVBUFIPEmde/cBQtUMDq06IsY1fXNac890pyd
        bmzT7LIvt7VnH6eaQA+bHH+/rpEYZC7G1dzyWH4=
X-Google-Smtp-Source: ABdhPJzyuSgeI6lmW9DYr/3wVDy+WzWJ8C33xZ/VQWKZf1MfFsGsbFw6l9zmqyk83JjTAtY+x+dwLQ==
X-Received: by 2002:a17:90b:3503:b0:1bc:5d68:e7a2 with SMTP id ls3-20020a17090b350300b001bc5d68e7a2mr1844250pjb.29.1647306547016;
        Mon, 14 Mar 2022 18:09:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nr22-20020a17090b241600b001bef1964ec7sm705497pjb.21.2022.03.14.18.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 18:09:06 -0700 (PDT)
Message-ID: <622fe732.1c69fb81.c4003.2ca2@mx.google.com>
Date:   Mon, 14 Mar 2022 18:09:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.28-111-gb411815a8fd9
Subject: stable-rc/linux-5.15.y baseline: 99 runs,
 2 regressions (v5.15.28-111-gb411815a8fd9)
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

stable-rc/linux-5.15.y baseline: 99 runs, 2 regressions (v5.15.28-111-gb411=
815a8fd9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.28-111-gb411815a8fd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.28-111-gb411815a8fd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b411815a8fd9cedbb6922e7601165c67d7abfa43 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/622fb59dd11c3044a6c62971

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8-111-gb411815a8fd9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8-111-gb411815a8fd9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622fb59dd11c3044a6c62=
972
        failing since 53 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622faf2c4e61db4d8cc62987

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8-111-gb411815a8fd9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
8-111-gb411815a8fd9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622faf2c4e61db4d8cc629ad
        failing since 7 days (last pass: v5.15.26, first fail: v5.15.26-258=
-g7b9aacd770fa)

    2022-03-14T21:09:50.218297  /lava-5878784/1/../bin/lava-test-case
    2022-03-14T21:09:50.229293  <8>[   33.548124] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
