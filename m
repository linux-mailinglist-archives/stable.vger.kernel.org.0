Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BB0449CFE
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 21:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbhKHUUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 15:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238385AbhKHUUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 15:20:07 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A95C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 12:17:23 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m26so17154138pff.3
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 12:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sZtx3NaLL0KhK7wjJ2IvtcuAqVMaMIl/Kz5C+2AWUMo=;
        b=ocalqRfHu23FRalIRcRQ0KfmBU4KFU6FT0lRiOOYUQ9djr5JHmjKypRMJbYQe/VQrE
         d02TvGC2W6Cwad6z8YEI7/QcpVVFbR39VH53cQTd8nAQXAJFOT5V2USO/WA0BeABENUu
         Lrfe9574ePTJ7oITHy+0q1mRCD8BruHFO4HQNwHry1FC7acKfPKe0N3HGYQKxXcDvoVV
         zkYxBbXtDdoArA+hrLOAE/wnZ6ssrNRn9eGoDmMgR+3B9vkLwZD3/QlSX5/VD7stuyBv
         Bzemu1KOH0gf8EssvL1u6ZYv1OMI3WtI0Ypk13992FY2C7UBsD3eiaUw1aBwVm8XBIjB
         yBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sZtx3NaLL0KhK7wjJ2IvtcuAqVMaMIl/Kz5C+2AWUMo=;
        b=7QAzk22PAufEKxPj/LO2816E9bCUCI7XXZuVcz/AmRuaVtjhmnkx646emvZFnJFc1/
         4To0WhyNZZYKcqhIG1d3d6Eqyza9YQKhB42+XdSjfKDWKjEnrgN2oAS+Ar7yhHX/F/qD
         tbkKZDkM23P1phcGZv7ejoKKEDBS53vCP+nWGFEb8G3NNxhtrpMQm0KdyZERoW+BQZaf
         72s7xhwCs/rK9+jrIcDgM7IriRn3Ogr1ZxcPVHTP5b2dDfU1Bv3ATdmbWQdsh7NmGLAP
         3eMWHJX+grasHqm+1/xPW0Pw5BHyJWHNxxziupVImi4tnFTIN22UiWeG+I8v54ROHiL8
         BHIg==
X-Gm-Message-State: AOAM53062dQa9Sm8avWO5g8U26/ZJCA3xBw/c1hUjZ3lfnksbAcgM+Lw
        89tLMBwUTWjilet4Pt4RX8rp7JR5mP76nS+R
X-Google-Smtp-Source: ABdhPJw2jNgHE2Pi7cBtuqUdqBD0M2ZBiHXp2EHoRRohj4jXGLMK96gbpNSAovMCiT558/kn1DJ7YA==
X-Received: by 2002:a63:6a05:: with SMTP id f5mr1593882pgc.398.1636402642399;
        Mon, 08 Nov 2021 12:17:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mg17sm189225pjb.17.2021.11.08.12.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:17:22 -0800 (PST)
Message-ID: <618985d2.1c69fb81.c2b4d.0e41@mx.google.com>
Date:   Mon, 08 Nov 2021 12:17:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.158-5-gfcfd72f4e220
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 207 runs,
 1 regressions (v5.4.158-5-gfcfd72f4e220)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 207 runs, 1 regressions (v5.4.158-5-gfcfd72f4=
e220)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.158-5-gfcfd72f4e220/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.158-5-gfcfd72f4e220
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcfd72f4e22001dc7180ab91d9a8ede4d8687897 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61895ad235594492c3335916

  Results:     66 PASS, 4 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-5=
-gfcfd72f4e220/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.158-5=
-gfcfd72f4e220/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
61895ad335594492c3335954
        new failure (last pass: v5.4.158-2-g54dd0c28ae4e)

    2021-11-08T17:13:31.193474  /lava-4927886/1/../bin/lava-test-case
    2021-11-08T17:13:31.193820  <8>[   12.693570] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =

 =20
