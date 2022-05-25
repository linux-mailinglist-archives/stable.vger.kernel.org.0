Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1853455B
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 22:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiEYUxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 16:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiEYUxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 16:53:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EDBB0D2E
        for <stable@vger.kernel.org>; Wed, 25 May 2022 13:53:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id i18so2664760pfk.7
        for <stable@vger.kernel.org>; Wed, 25 May 2022 13:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yO2fn5h5JDHtsnqBDKoa+3e2T2R1S7keiHxr78sXXMg=;
        b=0AiY8RhAkoSsi4ZlNnSgHrGsMiMJoVUB7cZsp/7Ht3wxb3KjFcS/9qIDPX4Sg4DUWA
         ruNrReDJ7oWZP8PTK0SMwofDj1luc6r9jTzyAoKSoSCwm/wTChBJ/wTuzpSh+ZS4sqJZ
         9v1LUESGzHHSlvmU6R8YL25QeL7sFCapXWsd8jgJqqBOHADgHIHw/3fahOoBGS6u53xR
         bqHRPOF3fBbpPdFezdTDgThmet2ibEHYSpGyjGobuLK9NWsJfpjGTPYR9ZQ00Rxcv4H6
         Cji3ElLNfbo1sr4pb7KNNwt24Bq9hHdvGlhI7UFTolYoCM+IDMuoJsK49NN+daamCW0z
         gBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yO2fn5h5JDHtsnqBDKoa+3e2T2R1S7keiHxr78sXXMg=;
        b=6OXRsk2HUNlf8lbkWP4De2cNoys+31VKwtjgGQ+DDNlE0ankN6XoLnnfUvC6bh75Wm
         Co/zTNilfZgqWRGSz/VMd44NPHf3IKCafworWXqfku87rYP0/RgFghkcs4bCH6+nIirx
         gxMA9t4vkDe7HSVMNMdztv2iquZnFKuzKmQMSlCybZ8lQFfenH/bkU9pMtez0u6Jxbm7
         czx8+cqqYPs98zJXOgDhH6lpcte8n6qlKAmKmvDF+Tiq/TMT1wpBl3Z3NnoliuHIsnDc
         hbmdbCdxQmrJPbg3f6sXquVYPNUoPUKyLLR6oQ2IjK2oxMqzmYzYYgJlyF1VXZ/22N2l
         VwPQ==
X-Gm-Message-State: AOAM532IiAegLIXedF6n6UgV5r2wsKx+hNurTalEsciwnCkDNngc92IA
        edKW6Uqp3qXz67kco2nN0F4ga4Xyfc9IyuuFTcw=
X-Google-Smtp-Source: ABdhPJywiHa8ClticTqqknTpmpzO/MJKEblMooisTRGZ8O4w7DZCxBzYgX1TPpo9EsS0szISF0iqIA==
X-Received: by 2002:a65:6b8e:0:b0:39d:6760:1cd5 with SMTP id d14-20020a656b8e000000b0039d67601cd5mr30489196pgw.379.1653512015173;
        Wed, 25 May 2022 13:53:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9-20020a170902bcc900b00162380b5497sm2685738pls.273.2022.05.25.13.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 13:53:34 -0700 (PDT)
Message-ID: <628e974e.1c69fb81.4a24b.6fe8@mx.google.com>
Date:   Wed, 25 May 2022 13:53:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 123 runs, 3 regressions (v5.17.11)
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

stable-rc/queue/5.17 baseline: 123 runs, 3 regressions (v5.17.11)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
jetson-tk1          | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig =
| 1          =

jetson-tk1          | arm   | lab-baylibre | gcc-10   | tegra_defconfig    =
| 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e960d734930b58bd6ce00c631ea117af0764473c =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
jetson-tk1          | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/628e885502acd7db75a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e885502acd7db75a39=
be1
        new failure (last pass: v5.17.10-1-g9160974af883) =

 =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
jetson-tk1          | arm   | lab-baylibre | gcc-10   | tegra_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/628e814c5c1c3d355ca39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11/=
arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11/=
arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e814c5c1c3d355ca39=
bcf
        failing since 2 days (last pass: v5.17.7-12-g470ab13d43837, first f=
ail: v5.17.9-158-g0fff55a57433d) =

 =



platform            | arch  | lab          | compiler | defconfig          =
| regressions
--------------------+-------+--------------+----------+--------------------=
+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/628e65e205a5ff3310a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e65e205a5ff3310a39=
bcf
        new failure (last pass: v5.17.9-159-g2d0a99577edb) =

 =20
