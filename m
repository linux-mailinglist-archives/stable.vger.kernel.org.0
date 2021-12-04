Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB3468689
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 18:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378182AbhLDRey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 12:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345154AbhLDRex (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 12:34:53 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BC1C061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 09:31:28 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 133so6237388pgc.12
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 09:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rNdQSwinivIT1a8dofBx0kfBgOgJSNZGfk8eFG5YSeA=;
        b=asbAgSJqIB61oneEn1lGP7TtSnWwLa62+rzsU1Qy8iL4bYVRGNJ0aT5XrP3Hoz67w0
         BOgL8GlpBIKfw6dhSgPedyXMFplgPkzKnPR4MAztI41MwPYJRiPWhpMG90CJHCzj86bb
         +A+sAOOYecnp93bWh6cN8LV+ggdULQP5mj7waM4JG86hBJNw3lUhb3lcsNDahG5iZVqO
         titXwBNo0/e7GPeqQkVWyx2FYmSaVErBp9PFyOizTrqIFVAzLRUqJP0Hc9GQFNXQOCJU
         BH4C4i44iNf2SDTlz4AsNWWiaZJPfZhr0XB7kxMOELBQZc6B+0alWU2vXu6bmF4SpR3D
         pvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rNdQSwinivIT1a8dofBx0kfBgOgJSNZGfk8eFG5YSeA=;
        b=KISQYcnEQQpXnJS06YDH2MAe2J4Iq0zP3uFuYw+GLa27aoVW8xIGYtZejgO8jJPmVG
         S5ICOUV+Dps3F7bh84xmw+4MbRLw6hn/uv5StERyw5oA6/tO8rUfgdwxrvvTYDvWPcZv
         oaAORNXB0ufIBuW8dpoQvZGbmgkxQHtLN/iNbeyj/3pmpnBzVstq+BGsuxpHCTnbd0ja
         gPNLFwXIeFxY5FNwAwsTE22d6q0NK3ZjJ4+2Ujsu5dh2L1srnqpw7DbCwb7zkKnXpek9
         iGsIZr5IV1UN2oy77AUXJCt/DDwuCoeQqxkkpXnx7ntmHtcKFCdiSyAH7sT97vMlv1bY
         HQjQ==
X-Gm-Message-State: AOAM533QBzlNNfy4y8VQZ9pTuaIUO98BprOfLDn5GVA3xESTFXRZrt76
        t+F29h6GfXwiXSJIuaN5UFa5dYsOi9337wKG
X-Google-Smtp-Source: ABdhPJxBHQA1/X1VtJV/LJ9AWdbq9JvQnrIs3gQAVJ6sLRiF7esQIDkYkmdR+mpxOPXCqnljHAtc9Q==
X-Received: by 2002:a63:150c:: with SMTP id v12mr10374613pgl.442.1638639086280;
        Sat, 04 Dec 2021 09:31:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm5465598pgg.16.2021.12.04.09.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 09:31:25 -0800 (PST)
Message-ID: <61aba5ed.1c69fb81.14a7e.0088@mx.google.com>
Date:   Sat, 04 Dec 2021 09:31:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-51-ga8ef376151abb
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 2 regressions (v4.9.291-51-ga8ef376151abb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 2 regressions (v4.9.291-51-ga8ef376=
151abb)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-51-ga8ef376151abb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-51-ga8ef376151abb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8ef376151abbe732da19a51f91bfabd9ce5fb0a =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ab74afc6f7b5d1e31a94b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
1-ga8ef376151abb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
1-ga8ef376151abb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ab74afc6f7b5d1e31a9=
4b5
        new failure (last pass: v4.9.291-51-g9e9032945598a) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61ab75388cee342d9e1a94b1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
1-ga8ef376151abb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
1-ga8ef376151abb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab75388cee342=
d9e1a94b4
        failing since 0 day (last pass: v4.9.291-47-g43f5262d9792, first fa=
il: v4.9.291-51-g9e9032945598a)
        2 lines

    2021-12-04T14:03:12.980025  [   20.148864] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T14:03:13.022878  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-12-04T14:03:13.035058  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
