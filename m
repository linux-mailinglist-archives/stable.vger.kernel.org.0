Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A3B280369
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732672AbgJAQB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732610AbgJAQB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 12:01:59 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7EAC0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 09:01:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q123so4962866pfb.0
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l6phxV+iU+MceOZOuXE+je47SUhRThfsKI3LYE7Tmww=;
        b=CLDZHLMfudQJBwZjsopKfnfVe4bYtquHjGEXQsLRtpeV1/or0sWkNwrkUqHGfMTmom
         +6TrZPc/+s6U60WgIYbet+cQKFTiaQJ8HahXEXNPkl23SiuiXZRE9ShgZhjtdHYEMoOA
         Q5dNBK6/DuJxBg+tVY6UbIul09ya2Ew8NYHI9eqG/J+sMW7A1cZQZ87lMVk9axzcCM18
         NaLvhlJtgz8lToTS9/qCcI+ZsArRFO1v0XBv4QXEHpTmidjVysT0jmbHKz8Ty86PdkqP
         rCtaYn00ts1jOemhi2akEB8QOGQThEAjtqaa1QKA7X3Jr8TlvwAibGWj/g9F0IQzeAhD
         4C0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l6phxV+iU+MceOZOuXE+je47SUhRThfsKI3LYE7Tmww=;
        b=Tfh+oL3kzheR2m2vVUKCE5vTG74K2mg0bbDtiPYtKiRPgRW88I8e7Xd81mEs0GfCqt
         d+MUxsEhEkP3C0doR5nZ8iO5E6rdl4d0pcI2juyqJlygD2tCVu/kBB97++r2SbScfRtU
         fWEuedRGenmb8hKL0YPKLBFi/xtET9FfHj71ObPOYUywQyfCgph+yd/8SCDIDiQpt1Jn
         AoKC4vIu7gJkpsUOZKpzwP7yjAU6j/O0yjKuUyCUoqFjN0qcpY5RF7UO2MzcIw8YyB4b
         Ln5ZIBDr3hGX2eGXZUOOiWk/5q7CKycGqQT7knqnbOc60JF1oVTgPdgv6NNjEENeZHKB
         qM9w==
X-Gm-Message-State: AOAM533+4996f7sNY8eF4+2GCBhG73ELlirl038BD9gg7wefmUcB95mr
        yctB35XUQOyFyXeCzVMIYCjXxk/VUxrarg==
X-Google-Smtp-Source: ABdhPJx/QNiQDLO4qGR91SeFMWd1Fti0djlA7xv6Wwpep9ek1A2lEJQbWkDTfZ5NuhBwfwxukRf8Vg==
X-Received: by 2002:a17:902:7483:b029:d2:ac2e:db20 with SMTP id h3-20020a1709027483b02900d2ac2edb20mr7801951pll.60.1601568118292;
        Thu, 01 Oct 2020 09:01:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10sm6347596pfh.217.2020.10.01.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 09:01:57 -0700 (PDT)
Message-ID: <5f75fd75.1c69fb81.4f07f.d978@mx.google.com>
Date:   Thu, 01 Oct 2020 09:01:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.68-388-g55f018a501ef
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 161 runs,
 3 regressions (v5.4.68-388-g55f018a501ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 161 runs, 3 regressions (v5.4.68-388-g55f018a=
501ef)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.68-388-g55f018a501ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.68-388-g55f018a501ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55f018a501ef10df60b0eaae53980fa9c89984c7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f75c9b629354c239e877172

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-g55f018a501ef/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.68-38=
8-g55f018a501ef/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f75c9b629354c239e877186
      failing since 1 day (last pass: v5.4.68-384-g856fa448539c, first fail=
: v5.4.68-388-gcf92ab7a7853)

    2020-10-01 12:21:01.417000  /lava-2675923/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f75c9b629354c239e877187
      failing since 1 day (last pass: v5.4.68-384-g856fa448539c, first fail=
: v5.4.68-388-gcf92ab7a7853)

    2020-10-01 12:21:02.436000  /lava-2675923/1/../bin/lava-test-case
    2020-10-01 12:21:02.446000  <8>[   21.700863] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f75c9b629354c239e877188
      failing since 1 day (last pass: v5.4.68-384-g856fa448539c, first fail=
: v5.4.68-388-gcf92ab7a7853)

    2020-10-01 12:21:03.465000  <8>[   22.719876] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
