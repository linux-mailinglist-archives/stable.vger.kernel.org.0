Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A394C3B0315
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 13:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhFVLq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 07:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhFVLqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 07:46:24 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6052C061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:44:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t13so5046993pgu.11
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sH7qrzXHfrOEe45upx+ex/mNU+hjSuGQDDrm38SLhkk=;
        b=kFs3IlWTSLXxda0Q/iD8Xlpb+bx6HVBb1F4fyQ9FnanwhI8r0pEi9Z4Ud95XSKngUo
         x9jy9DuIgjT27IOn4EVpzwvqr9Q2ww5JRJB9122isx4KBg6wzFt99nqSv9irdYabunLK
         4IJLNkkGTMSB7djh7Lcec9AlIeD8lOtCOEBqfGsZRZYfWfJYTqPRuObHG+Y3NWWPZtcT
         OdAg+VNaxqPiYtBYZW4BW61syB2F/sHtaviTfnJBPLmuHqm5ZFohS/At0PZgbzfo0HT/
         SmAPtBncMyYWAoQrXug3bE3/Lvkb0wa21YoeHb6nuTE7nuw+X9t8wbkcCGZC2BlEXxwG
         GQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sH7qrzXHfrOEe45upx+ex/mNU+hjSuGQDDrm38SLhkk=;
        b=o3duj6I5KVapmoLrzM4CRv3ntDBsFaqN7dC4WUFf5HfoM6SAOMtYBCC9IupO0Vbzlm
         ZhEIFZLVgx8Ce4VpUqkScLlt20Gf23Bub+2EVWp4OBwNYYnDSbBhIGwu+jjq4m6Hu7DP
         sG+AWpY07AOc24NSunqpbjZ0kCKwYWXJmjl/Ya0bTCczId7JHlGVvC18+1XTPZSgnAi7
         UZAF0W+vFoHKxW+DRp6LKXsrisOkBYNHURozSn7h86bCYCdqwdTovMD+MKPgjmGadOk3
         L/DkT7lRisKD0uwXHVycspf8/wisMAkwt7GPETSark54Wi7B8kJbDqqoUrMcxj6k5WyS
         3MoA==
X-Gm-Message-State: AOAM531Y9nLHnEmEAPynneeYnDH5bughgf9VTxiA4e1ZvIhQ3/PTGu2d
        p+TTf+guCoh1OVRpECITcDKEaZOe4pwiOw==
X-Google-Smtp-Source: ABdhPJxMGY4qeF2mQ2Twh0uDFWfJ6l0PPz+Fboq+cb2k9lB/25f2Pf7Ujy/ZQSwQiFa2kGjE7g/fpw==
X-Received: by 2002:a63:5966:: with SMTP id j38mr3327260pgm.451.1624362248250;
        Tue, 22 Jun 2021 04:44:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x63sm481069pfx.205.2021.06.22.04.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 04:44:08 -0700 (PDT)
Message-ID: <60d1cd08.1c69fb81.47632.0cac@mx.google.com>
Date:   Tue, 22 Jun 2021 04:44:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.45-147-gc00b84692b51
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 182 runs,
 3 regressions (v5.10.45-147-gc00b84692b51)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 182 runs, 3 regressions (v5.10.45-147-gc00=
b84692b51)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.45-147-gc00b84692b51/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.45-147-gc00b84692b51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c00b84692b513471386cc0db08f8ac9020f88659 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60d1a34838a7c7c66841326d

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
5-147-gc00b84692b51/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
5-147-gc00b84692b51/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d1a34838a7c7c66841328a
        failing since 7 days (last pass: v5.10.43, first fail: v5.10.43-131=
-g3f05ff8b3370)

    2021-06-22T08:45:53.902418  /lava-4070896/1/../bin/lava-test-case
    2021-06-22T08:45:53.907621  <8>[   10.870304] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d1a34838a7c7c66841328b
        failing since 7 days (last pass: v5.10.43, first fail: v5.10.43-131=
-g3f05ff8b3370)

    2021-06-22T08:45:54.921119  /lava-4070896/1/../bin/lava-test-case
    2021-06-22T08:45:54.926336  <8>[   11.890043] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d1a34838a7c7c6684132a3
        failing since 7 days (last pass: v5.10.43, first fail: v5.10.43-131=
-g3f05ff8b3370)

    2021-06-22T08:45:56.347232  /lava-4070896/1/../bin/lava-test-case
    2021-06-22T08:45:56.364168  <8>[   13.315964] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-22T08:45:56.364401  /lava-4070896/1/../bin/lava-test-case   =

 =20
