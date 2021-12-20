Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932FA47A8C0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 12:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhLTLcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 06:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhLTLcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 06:32:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65769C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 03:32:00 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id v19so7848702plo.7
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 03:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dgajf3KGwzOP4Bq90LOk3J+X1JWhOtfJ1qjvuoACP+M=;
        b=rmtIxHjLnL7tMwAmDuYhfJB/yxn3A5Mx59f7xWF8muQZ5ZhceSZtpauHxbsvmr3K7G
         kZxSNEqyml2O5QrmeccY8I8W8QSOcXoEEHmVaRXICdU8C9QqpnbL/kc75IhJnhNEwo1G
         /2wA92oChL0RFgyAUbQr874EH74Yx4VKIKiICrg/s7Nzm7Kq88VSJGo2JsA6OZ5wQQPs
         7obufZKdiS3ZFw2TmnC661a3rGii0pMAaBMRXmz2vIQ1mHOxjYytbr5Z1SPzbEBxi8lX
         4bFjUFTsxA9CHu3Sp+iLLrtIV5me4x2tidkhepSNoFyg0ZPlZ/vwshn2yDV+csEhW7tD
         qJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dgajf3KGwzOP4Bq90LOk3J+X1JWhOtfJ1qjvuoACP+M=;
        b=AbPbfefL/5YwerJO90XJ2hBZ5V1iUbC/lg1iqp9VORLHkRBLRzwuQgmSh36SXMrQ+E
         k6bpTVR7pfWm3C61RevwNF56C1Y8dzgq1iEt+MoOWt2F8qDEBFhmw6mGh/jkTBiijZkP
         UZDLpSjZhr57j+JrHk2WS989hMs9f4bLIfJQ1T23ubxRzt0CkC5xP6S9nP0qmBQkFuQH
         yRFtmVt9/UWj2YZ+g0mi6hlYOku40DmtzM3wERlYts0lvi8s/c30TvsqXNduQiNd2f46
         a1HcLDjAIrAZ530YWRS92PfDtw3JUDYIaCknfsE3mqrijZd6dE48zqVfz433kcz0H6Vi
         S6zA==
X-Gm-Message-State: AOAM533/cCkkJWrfI0Fkjj1u3pf3J/048L2jxicwE7VS6Ro4zZnSl4PX
        JUo/t1eCB2dZNML6ju+ttzb9lgz5A+F+VmxY
X-Google-Smtp-Source: ABdhPJxaQpFPm2i6VNfUMV7Dykp12Op4PDbJA3+K8RFd4i19+QIkvKiV04s5NPfMyu83NXd2BBi6OA==
X-Received: by 2002:a17:903:245:b0:143:c5ba:8bd8 with SMTP id j5-20020a170903024500b00143c5ba8bd8mr16148048plh.64.1639999919717;
        Mon, 20 Dec 2021 03:31:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm22308807pjd.0.2021.12.20.03.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 03:31:59 -0800 (PST)
Message-ID: <61c069af.1c69fb81.14b8c.5213@mx.google.com>
Date:   Mon, 20 Dec 2021 03:31:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-30-g9e8d8c3eddf3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 1 regressions (v4.19.221-30-g9e8d8c3eddf3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 1 regressions (v4.19.221-30-g9e8d8=
c3eddf3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-30-g9e8d8c3eddf3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-30-g9e8d8c3eddf3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e8d8c3eddf3c64b3a5d161eb35be96926cf1f52 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c02e8837cb441745397120

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-30-g9e8d8c3eddf3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-30-g9e8d8c3eddf3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c02e8837cb441=
745397123
        failing since 3 days (last pass: v4.19.221-9-ge98226372348, first f=
ail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-20T07:19:20.297585  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/111
    2021-12-20T07:19:20.306830  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-20T07:19:20.334755  <8>[   21.584747] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-12-20T07:19:20.335292  + set +x   =

 =20
