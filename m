Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F2C5B2543
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 20:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIHSBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 14:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiIHSBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 14:01:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FBAF10C8
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 11:01:19 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e5so886826pfl.2
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=GgNdAedwgmaa1G427XrxOH+5pWgZ0S9Hq6pbFB+wPZU=;
        b=3/S1TBf1o7T3qJPkb7Pmwmi0lGBNmQPAAy/CTOh+tiVhFRjE6uwyrOytTtbOqmuuwF
         unwrWXIRsQ3u2FFk92MDfHO0HGEedapESmqsvQXbpupjdz1CjADFR9R86CbG13ArxYtz
         h8YPGcAgfOz2tNT5836+uS5grOZu5v4uwDhbR4uG4o7cy7z1eIcoSD46aXAm4DkCYnAK
         tzYB+920Vve57W0Kjfe6Ai17sf+xYJ+9EWZRf9ZnQc4/IXW9Y8eMA+CVuC10KvU7YVPu
         PdBvKoObPUB01FypySL0fsPtwdCGSjxyRbILcsJpmnwv802WMt8VvWIDz4uEK+OhQ/PC
         fR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=GgNdAedwgmaa1G427XrxOH+5pWgZ0S9Hq6pbFB+wPZU=;
        b=nx7NpLo1G4YEJk4z+ro/pJQt+rdnRSU2rJqxQ+SdLUfQ8ILFttjyXsECQ6qROm30t1
         5Pct2SEu6vJrZoy2cPEDNcV5Kv5Ue1IUJS6GlZaxuASKoRA0QJNPwh9qEtaVn7pvinZW
         dc2qN0zJOkGdzzBqHKenRyHa5YrjE6bkf4yTrNAMP4nFtIYjb/IA6XejAYNvlw7xmyDh
         Wx15kLmaaQ3Lq1qVXAq+i1LO2bhOFgDmW0xf6o3Oq+YMY/P9v+2R+ymNlxd4oX5F/i6v
         AJp4i8BA05ZtVRRyoGp0w3IjX1iyv5LBuHekIvXTeN0PRY8HQl1O5apgqhL907envHHd
         Xl8Q==
X-Gm-Message-State: ACgBeo3Br6VLd67ida+H4A33HD/XvI4oSiwhaNXYtBy84ov5PqwAwb+0
        rWnW+BK9EdmNGjl0APpPkqjD+9eXcvLNLvpoUzo=
X-Google-Smtp-Source: AA6agR49jgE+3uPfWDOVUgL9K+0R7gfgJUKpmwVJ9vXQr3g75XRkpTxaDf4cSc1QYC5f3Tqy1ocyIg==
X-Received: by 2002:a63:6683:0:b0:42b:1d69:a0ff with SMTP id a125-20020a636683000000b0042b1d69a0ffmr8887836pgc.475.1662660079015;
        Thu, 08 Sep 2022 11:01:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16-20020a170902ced000b001753654d9c5sm15067797plg.95.2022.09.08.11.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:01:18 -0700 (PDT)
Message-ID: <631a2dee.170a0220.b47eb.848f@mx.google.com>
Date:   Thu, 08 Sep 2022 11:01:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8
Subject: stable-rc/linux-5.19.y baseline: 196 runs, 3 regressions (v5.19.8)
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

stable-rc/linux-5.19.y baseline: 196 runs, 3 regressions (v5.19.8)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70cb6afe0e2ff1b7854d840978b1849bffb3ed21 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6319fa5782c1fa0bd5355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319fa5782c1fa0bd5355=
643
        new failure (last pass: v5.19.4-234-gdd6b2254d7a72) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6319fb37aba520d05c3556ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuku=
i-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuku=
i-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319fb37aba520d05c355=
700
        new failure (last pass: v5.19.4-234-gdd6b2254d7a72) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/6319f769822b206911355674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.8=
/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319f769822b206911355=
675
        failing since 5 days (last pass: v5.19.3-366-g32f80a5b58e2, first f=
ail: v5.19.4-234-gdd6b2254d7a72) =

 =20
