Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1CA291484
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 23:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439288AbgJQVBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 17:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439266AbgJQVBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 17:01:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4D0C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 14:01:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l18so3576905pgg.0
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 14:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qa8EVFv0nmB/iYdCK/eZoAI5/C9JrIORQcFnLJJkMxk=;
        b=i1whRi63/TdwL/paCwvCws1FbXaH8T1GN9CZ4eOw7ue8NTUy2sl+cEK22y3QANuTvD
         oxniekHfvy2WAubcvR7NxhxIT8VDOGOKyT35XO/4Li4g0AVLDwN4jNhYTXVYvVAoQCPT
         0lzBy+EMZ3+1Q0SHTO1n27ELCCwM91Rs6EitZB6e4h7d/QMt+IAye0/C4mzkD93v5JPt
         kLlyIcVP2atuAHhldfylE7PkTwmbv0loo/2WQVC547wG/Jshx4MqXh64xNhtwTieb6qB
         28XUT6GkrNbDZO+qGClHehuth8rBFkfhAPS2eLPyH2IHnRCtKQKi+mZ2f3in16JuL3cB
         +2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qa8EVFv0nmB/iYdCK/eZoAI5/C9JrIORQcFnLJJkMxk=;
        b=mooPDW5zid8qzTTZ/CWVzEt1R2nx9jWlpWUxXtni8Ye4cePeL5pWPqMfAVKXaJN/da
         bGjrYYEQt3hulD6AglUcU892ra6NoyfJm1zeEMkncXh5ULRSr44glu6flgri+T873nbD
         VOzmx8UiX07CmoTstOSyEVxoPFE60cq0p8tb0p7+302HvM/NNo519XQfgkdoZkxn+WOY
         xac/TlspqWDSqiOO8tYKP/pmjU4rbxCoO7zYBKaZDN8MSwvFIMXHMSot+rXzRbNN6wSi
         qbQz7bVg4yC40ZhFjSlkHfgZn1pSzLDCY07GltxCtxnvZunhBgLrqln8HLU8lQOAyj7w
         E3aQ==
X-Gm-Message-State: AOAM533RBhtgnRzmkRVRFq9a0333g7oTukaUpFV8amjHjgSFumqAq4v5
        VKlsTSDbaXi2Nxpvo51JihcheJ4yWpmzLA==
X-Google-Smtp-Source: ABdhPJzkj/CtoYLLM3zR+iidN49hAj76mQkIutNZbC414gmkDWiPoB7qnp1a0SmMMxQUdYiqcLte0Q==
X-Received: by 2002:a63:cd48:: with SMTP id a8mr7972853pgj.83.1602968498239;
        Sat, 17 Oct 2020 14:01:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm6730544pfg.104.2020.10.17.14.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 14:01:37 -0700 (PDT)
Message-ID: <5f8b5bb1.1c69fb81.52ba3.e5e0@mx.google.com>
Date:   Sat, 17 Oct 2020 14:01:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.72-24-g5d35a1803455
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 204 runs,
 4 regressions (v5.4.72-24-g5d35a1803455)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 204 runs, 4 regressions (v5.4.72-24-g5d35a1=
803455)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =

rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.72-24-g5d35a1803455/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.72-24-g5d35a1803455
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d35a1803455f87d7209e825d761855f892fc6ff =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8b210589d5e4e0f54ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
24-g5d35a1803455/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
24-g5d35a1803455/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8b210589d5e4e0f54ff=
3e1
      failing since 188 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab           | compiler | defconfig       =
| results
----------------------+-------+---------------+----------+-----------------=
+--------
rk3399-gru-kevin      | arm64 | lab-collabora | gcc-8    | defconfig       =
| 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f8b1fd980390f5eee4ff418

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
24-g5d35a1803455/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.72-=
24-g5d35a1803455/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f8b1fd980390f5eee4ff42c
      failing since 18 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-17 16:46:01.929000  <8>[   23.315460] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f8b1fd980390f5eee4ff42d
      failing since 18 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)

    2020-10-17 16:46:02.949000  <8>[   24.337085] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f8b1fd980390f5eee4ff42e
      failing since 18 days (last pass: v5.4.68-388-g8a579883a490, first fa=
il: v5.4.68-389-g256bdd45e196)  =20
