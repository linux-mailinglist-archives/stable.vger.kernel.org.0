Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35BE548056
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiFMHT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiFMHT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:19:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68381ADB0
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:19:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 187so4988650pfu.9
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iETuPKnEXrDjCWmhzwSLfCDqPNYGrvihX3Ha/8aboJI=;
        b=TXuL7TSP3pv9Blw5gAruQp6bg9yeQGi2QKprKhkSNulOGi6F18rUtJhh27ctJjmTTu
         oKFVDIriWHF8lyG9Gn5RzIAv/ncpBO4gDuErN49Gm3zpkp/uaQZyumKue/QujAu4T5oj
         wvthZAxx624RyFwdgCfqKJZVPMQWwk0NQLPQ8tpcGwkmGtjRxF6UVBJkHQSES8orpiE2
         ZSisAH5nb0P4GlW/5E8fKw7x+MA8mc8xO62j3e50lJ4GYImSAHYegq/Ho/MGZW2Cefj9
         7aU+X5YjCQ+bGAa2lhcXRt3oVtO/yKfRG+BY+n4M/VVJoxy26KlWa2nZx2xi2WoR6zaa
         AJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iETuPKnEXrDjCWmhzwSLfCDqPNYGrvihX3Ha/8aboJI=;
        b=SPcAAvB0qqkMOomrGw6DwLSzGyY7Q9Az244O8kQTkVKaUaIsID5CaLoxA6zlDLEOxI
         w0P8ji2hBbXW21P1e2b8VSLN69xP99rP5CU9bLll+DqOudENhYqvJtu0xbLgRaeqw8Ta
         AVu7ZgJzy/AhhH7JfAK2sUNZ11rHV3qmuHvVTSeDiyUARiGooxO8TUJvJng1pca7ZSJi
         UFt+tz/CHhAAEsdDoNWxoPEDSunQ1WBfVuUvcguYW2CM98N9s60Clrx6Y7+GvRbNmk6R
         nVKOTZRjtr3bBUiuqKVhJZqJyAQisZJoYPO/7SVAIl4QPJ6QP+tHyTqA1wtPUc2twQu8
         XJ8w==
X-Gm-Message-State: AOAM5318YzD9guKTbTokpEuqSDn6Y9U/bD97xBRCfjl/FPpMnefTvP36
        oP/b1fghIEtYczgo4FX9G0QUtz86bTSnsIgf06I=
X-Google-Smtp-Source: ABdhPJzRAKZOFNs4MqUdtc9XrTs6GbufVAN2C7SaPlE4m3sA0kd3VQgt6NS8ArKe7d+7I3GoeYgosA==
X-Received: by 2002:a63:d154:0:b0:3fc:e1c1:50ea with SMTP id c20-20020a63d154000000b003fce1c150eamr48773326pgj.67.1655104765961;
        Mon, 13 Jun 2022 00:19:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h188-20020a62dec5000000b0051bb61c0eacsm4525604pfg.20.2022.06.13.00.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 00:19:25 -0700 (PDT)
Message-ID: <62a6e4fd.1c69fb81.e221d.5193@mx.google.com>
Date:   Mon, 13 Jun 2022 00:19:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-1024-gb80ef70132a79
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 95 runs,
 2 regressions (v5.17.13-1024-gb80ef70132a79)
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

stable-rc/queue/5.17 baseline: 95 runs, 2 regressions (v5.17.13-1024-gb80ef=
70132a79)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config            | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-1024-gb80ef70132a79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-1024-gb80ef70132a79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b80ef70132a794057d4c61d9c9db5ec52110f498 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6add2d3349c07e7a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1024-gb80ef70132a79/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1024-gb80ef70132a79/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6add2d3349c07e7a39=
bd5
        failing since 2 days (last pass: v5.17.13-907-ga980fa631e355, first=
 fail: v5.17.13-928-gfe5fcee7b41f8) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6ac1ef28deb76efa39c3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1024-gb80ef70132a79/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1024-gb80ef70132a79/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6ac1ef28deb76efa39=
c40
        new failure (last pass: v5.17.13-771-g1bf589e90ab9c) =

 =20
