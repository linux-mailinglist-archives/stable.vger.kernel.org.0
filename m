Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F686549BF0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbiFMSmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344252AbiFMSmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:42:13 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E3A64D2
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 08:24:33 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id g8so174739plt.8
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mQI6WFQXnrwgirpgFU2fxUK0AwxxiQEGZwcttlF0Bi0=;
        b=r3JL3LMRG0dA/cAuKSzGyskOKrWJAklapoK/aGNdSrWE6ba27Cvm8S0frqyh1c5tcm
         e10D7DfOesgR0szam4pzTfgsZENd6nRpnGl9noUG9fJgWbimcFk5k8RMQKzKmsHuNVJY
         oy0dQ19ZychC6KBakqfNFV0CWdcTv0q3A6XiTqjT0/OT3H63OtqmoXUnHC+XYiP398Wv
         ieVusMKzKmTQ5P2EQTVq6iwlP6YgYgcJA8J1V84glnRUj8uaXdbja74iXUQRBtFUg6LD
         aKZmwUlfUinR67AQZKDQFbcD1qIGsFienY+O4rNcXsJRUvWxmfToqJoApCy2aiyRc+aq
         +5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mQI6WFQXnrwgirpgFU2fxUK0AwxxiQEGZwcttlF0Bi0=;
        b=lzYkRwiFEhJ72DQji6shlFHe7IgLtyDNc5um50JWj4P7+jRE1VzVDJUU44MqklC6Dt
         +vyxR4K1LtkoxaCdr6stzQrTanezENsI/qpVIyIuikpPuyWCICZkLLgyoWNn8gd/UX5k
         MMY5tSr4YM9xVXjavQFegfkqkpnAagPY3Hg0aH1e3vYLRmea5PNRZZAVfq9MzOdYLXGW
         u4prYiyaCYNqEuvP3PqNIVFn1vbMSfVnxl5PqQPdQhtzO3IWgafT8F8cgRK9BYr9cUhY
         6oX/eu62690ndLuk8gBqu2lA3XoitO0eP190FQbEbdAqyIqN3S8TkV0RRkwsM4I4/oZ+
         Ot5g==
X-Gm-Message-State: AOAM531leApKrdnuQrUp97WeAPwzEtCsMYAK1A2XIPqKsV2AFu3IqsLv
        7GoLF2oCtfsaTdrKSNTvgicGnrU9Prj41Sjki68=
X-Google-Smtp-Source: AGRyM1sVjuo8vqFi/BZS72j8X8YUUtpY/NCCc26xtC0Sefh+Q5iYzr2qirtRN3tIINh9viACfQJ/Aw==
X-Received: by 2002:a17:902:7005:b0:163:ffe7:32eb with SMTP id y5-20020a170902700500b00163ffe732ebmr360124plk.18.1655133872614;
        Mon, 13 Jun 2022 08:24:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i8-20020a17090a65c800b001e667f932cdsm7525051pjs.53.2022.06.13.08.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 08:24:32 -0700 (PDT)
Message-ID: <62a756b0.1c69fb81.f6cb8.8900@mx.google.com>
Date:   Mon, 13 Jun 2022 08:24:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-1070-g8734870d7c3b5
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 123 runs,
 2 regressions (v5.17.13-1070-g8734870d7c3b5)
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

stable-rc/queue/5.17 baseline: 123 runs, 2 regressions (v5.17.13-1070-g8734=
870d7c3b5)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-1070-g8734870d7c3b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-1070-g8734870d7c3b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8734870d7c3b56701bbcc264fca8539110393f8f =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a72da46dc87bc66ca39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1070-g8734870d7c3b5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1070-g8734870d7c3b5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a72da46dc87bc66ca39=
bd1
        failing since 0 day (last pass: v5.17.13-1029-g0132bdf6be9af, first=
 fail: v5.17.13-1037-gb6b19f82d1437) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a72b844813b19459a39be7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1070-g8734870d7c3b5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
1070-g8734870d7c3b5/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a72b844813b19459a39=
be8
        failing since 16 days (last pass: v5.17.11, first fail: v5.17.11-2-=
ge8ea2b4363353) =

 =20
