Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7650D3062FA
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 19:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344354AbhA0SEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 13:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344341AbhA0SEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 13:04:36 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1629FC0613D6
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 10:03:56 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id s23so840093pgh.11
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 10:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MpWviEFZcINweX76M7gB4qRLa6ztvcmrDoZecJ7CcjI=;
        b=KdC6Jsc5qvy+4XszZ+U35uUTStBU1/cM2DoubxtoPEmqFqkoPNrzIP+M6oyQR9uPr5
         vhzsD+P0MAuaP4I2kE6ImeT889oHzr7dwbMFZLke/kMGt0qqe3Dm0ANxAo9Wj9XgykLr
         zqYOGQI5AoN5MCHOkQaFuTR9KGcfvo67Zu6GHqe0PRgGeUEzhFcJc7US1xxnIYI2bSZF
         3jBcIzjALB5EwZHy0sbKgRzbTN8Ah74pwFb59oy6EmKKwD3vSAiIwEpwiIv4/kBlkobo
         KVdSUCmOVmHsosO+EcmutsF98ktiFXIdXTgTKoVRnjbVuoqVWW1n581i9Z0U5hCRfR8+
         V92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MpWviEFZcINweX76M7gB4qRLa6ztvcmrDoZecJ7CcjI=;
        b=D4tehmt1+r5Q6NePsvzhvOZww8I5X0lraasCH+oWbSjkx70ZTt2WUyDpjXVlt+V/65
         njkwhpOfsfM4Xpzgi4OqFiBF15YK6ezJ4czmIZ/+dw3lgV36umc13VTt+jpY+bn4SU3M
         +QnJwxc4eMy30uPnWF9EAEFVs/Na4NWeluzX/WHjRP6T1ZsPPl2UHNQ4h03DJ4tr4lsN
         7OAR0JVUuR6f7Rl43rKYM/l1EHT19MnxdsEq9eN7vwfiLZkhMlG5X3cVVHlCZJjdfOcn
         w1XDmDKHJnFLpB43qrAmCdxzQsFrcCEhTYQtu868Vx9YLLQPnq2s1NX/T0KRxGOUW0ck
         +RVA==
X-Gm-Message-State: AOAM530+q+sopKeHA4ItZMxO6ZS/2ezMNLB5yIVXgsP3IOGnI5Zz4ntM
        NMRoCQjwRLmOIOJc+mISawM840C0ULihRRXe
X-Google-Smtp-Source: ABdhPJxESPWs0qrRd9s5lCKrhw53QNLhiSK6uLHABGattZ3UR2Ds5hlv9A3GKoPycM6cFQ6bcCuJQw==
X-Received: by 2002:aa7:8881:0:b029:1b4:5b52:b00b with SMTP id z1-20020aa788810000b02901b45b52b00bmr11844279pfe.47.1611770635278;
        Wed, 27 Jan 2021 10:03:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a2sm3173151pgi.8.2021.01.27.10.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 10:03:54 -0800 (PST)
Message-ID: <6011ab0a.1c69fb81.a3a92.7924@mx.google.com>
Date:   Wed, 27 Jan 2021 10:03:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.11
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 176 runs, 2 regressions (v5.10.11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 176 runs, 2 regressions (v5.10.11)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b97134d151275424dc83864d6d2cf52f327adaef =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6011774f9ce0b01afed3dfd3

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.11/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.11/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6011774f9ce0b01a=
fed3dfd6
        new failure (last pass: v5.10.9)
        1 lines

    2021-01-27 14:22:03.153000+00:00  Connected to meson-gxm-q200 console [=
channel connected] (~$quit to exit)
    2021-01-27 14:22:03.153000+00:00  (user:khilman) is already connected
    2021-01-27 14:22:15.502000+00:00  GXM:BL1:dc8b51:76f1a5;FEAT:ADFC318C:0=
;POC:3;RCY:0;EMMC:0;READ:0;CHK:AA;SD:0;READ:0;0.0;CHK:0;
    2021-01-27 14:22:15.502000+00:00  no sdio debug board detected =

    2021-01-27 14:22:15.502000+00:00  TE: 311058
    2021-01-27 14:22:15.502000+00:00  =

    2021-01-27 14:22:15.502000+00:00  BL2 Built : 11:58:42, May 27 2017. =

    2021-01-27 14:22:15.503000+00:00  gxl gc3c9a84 - xiaobo.gu@droid05
    2021-01-27 14:22:15.503000+00:00  =

    2021-01-27 14:22:15.503000+00:00  set vcck to 1120 mv =

    ... (588 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6011774f9ce0b01=
afed3dfd8
        new failure (last pass: v5.10.9)
        2 lines

    2021-01-27 14:23:06.463000+00:00  kern  :emerg : Code: f9401bf7 17ffff7=
d a9025bf5 f9001bf7 (d4210000<8>[   17.093369] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-01-27 14:23:06.463000+00:00  ) =

    2021-01-27 14:23:06.463000+00:00  + set +x
    2021-01-27 14:23:06.463000+00:00  <8>[   17.101488] <LAVA_SIGNAL_ENDRUN=
 0_dmesg 639097_1.5.2.4.1>
    2021-01-27 14:23:06.568000+00:00  / # #   =

 =20
