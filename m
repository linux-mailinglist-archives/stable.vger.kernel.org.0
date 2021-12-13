Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D84733F0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 19:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhLMSZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 13:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhLMSZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 13:25:51 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D198C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:25:51 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x5so15755722pfr.0
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 10:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mP8AcOAilckGC2gq6waNSRua2utHjB5/kpUv8/UPDsI=;
        b=wkW9E772bP58yOZN43FDtzldUiEnSPh9exAOeI7IC7nGyY1xw0CdUh/qx4uYvYE8Eq
         a3YGZueDhf62XZwuwrZv0JLyQ1HDCwiWMDEnn5qW0q2EzB2TNM6rjPI4bb+oF/IOKYyV
         xUjy1qXi6fhU+z/Z5rwkSGBh1GhYahXMtBYMEleyfxhpK4ljHvffSYRDJFgWEFl18CrE
         hOVkj4voSefmGQzcp8KAninGLVVu203aP7AjZSJFxuaTB6Lj0Hg5dwGeqacQaFXCSt6e
         GyvSQkqy/zw+T7AdzJMEzNjvYnv98MDxFIvToOLXTHbGZHgrOpeGxtXsg1M1EOUdoD0+
         cQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mP8AcOAilckGC2gq6waNSRua2utHjB5/kpUv8/UPDsI=;
        b=gs4Ui4jfJb90bAe/jlslAaWWIFmx/9SvBwY+hberj90Z6ytg/hMRs2lvf5It9/xag9
         3bHH7re+9XKY4i439Xg0uuZU4GPHgJn8IglXl9mV2/IxxlgE0316WlQFume74Fw0rhoa
         DclnufPmMaxPMautdOuEsg082JaNlhg+oS8UpKeZkm793DaQgb9Qeqs6h9s3J3odBXNg
         0QrgfHuiW8kTK6Y20RsI+XFtTCwBZE5RnpEeXMukvPbVZ8Cg1Gz87x8ZUo7L65VOu7jB
         wEK5yyEDLlpFhRc555vxcCk0//g7hblcOwCpfxN6xz1ibBJ0pLcas8d6PdDOtcOh1jo+
         qT5Q==
X-Gm-Message-State: AOAM533oqvFNQgQY9h/kD6GW5d476XlAiEjLoihkryWsfrehZ5Qj1rMi
        xPqYQUzfvXQni95s5K58phgnzzuDFTHb50ps
X-Google-Smtp-Source: ABdhPJwZuXUSwj9Lonc/jo8waUvuQfzt7IoJRbsnd8oR0RwLU3WnWEc27b6HsC423ZUO1zTVo9lytA==
X-Received: by 2002:a62:8c55:0:b0:49f:df22:c4ca with SMTP id m82-20020a628c55000000b0049fdf22c4camr9397pfd.11.1639419950801;
        Mon, 13 Dec 2021 10:25:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15sm7589141pjc.35.2021.12.13.10.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:25:50 -0800 (PST)
Message-ID: <61b7902e.1c69fb81.81d53.48dc@mx.google.com>
Date:   Mon, 13 Dec 2021 10:25:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.84-132-g4821c82036b6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 213 runs,
 2 regressions (v5.10.84-132-g4821c82036b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 213 runs, 2 regressions (v5.10.84-132-g4821c=
82036b6)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.84-132-g4821c82036b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.84-132-g4821c82036b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4821c82036b6ea484b0c57f3ea6cd08c16d93850 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61b756ad78576e09c6397123

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
132-g4821c82036b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
132-g4821c82036b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61b756ad78576e0=
9c6397127
        new failure (last pass: v5.10.84-99-gaecd815828f3)
        4 lines

    2021-12-13T14:20:12.698544  kern  :alert : 8<--- cut here ---
    2021-12-13T14:20:12.734473  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-12-13T14:20:12.734988  kern  :alert : pgd =3D a6cf7926<8>[   15.28=
5892] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-12-13T14:20:12.735230     =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b756ad78576e0=
9c6397128
        new failure (last pass: v5.10.84-99-gaecd815828f3)
        46 lines

    2021-12-13T14:20:12.736452  kern  :alert : [00000313] *pgd=3D00000000
    2021-12-13T14:20:12.786223  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-12-13T14:20:12.786726  kern  :emerg : Process kworker/0:1 (pid: 29=
, stack limit =3D 0xce2f0928)
    2021-12-13T14:20:12.786991  kern  :emerg : Stack: (0xc223bd68 to 0xc223=
c000)
    2021-12-13T14:20:12.787219  kern  :emerg : bd60:                   c3a3=
a9b0 c3a3a9b4 c3a3a800 c3a3a800 c1445b68 c09e3944
    2021-12-13T14:20:12.787434  kern  :emerg : bd80: c223a000 c1445b68 0000=
000c c3a3a800 000002f3 c3a5cf00 c2001d80 ef86cb80
    2021-12-13T14:20:12.788104  kern  :emerg : bda0: c09f10ac c1445b68 0000=
000c c26fc7c0 c19c7a10 aeb3e7b1 00000001 c3a10e40
    2021-12-13T14:20:12.829226  kern  :emerg : bdc0: c3a0f500 c3a3a800 c3a3=
a814 c1445b68 0000000c c26fc7c0 c19c7a10 c09f1080
    2021-12-13T14:20:12.829738  kern  :emerg : bde0: c144388c 00000000 c3a3=
a800 fffffdfb bf026000 c22d8c10 00000120 c09c7060
    2021-12-13T14:20:12.829981  kern  :emerg : be00: c3a3a800 bf022120 c228=
96c0 c267dd08 c2511b80 c19c7a2c 00000120 c0a23a50 =

    ... (37 line(s) more)  =

 =20
