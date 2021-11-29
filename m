Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B9461014
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350337AbhK2I3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbhK2I1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 03:27:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103FBC0613E0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 00:21:20 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z6so11565268plk.6
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 00:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZuoRjy2zkfcMlEgPr9xog73K1uyLdIEyIdD02hZzgpE=;
        b=ZqfvE4U+DWLQOjlVe9GU5ZY4dS8xlpJqReklp7FXtz6liGKFw8hmSgqtyJX168MFwD
         xbu00EnqnasVZjeR1/mHFCxQDYFv5PfJo+QINy2UHdEU8zVHg9x3HIDp3QYQ7N4llZTd
         s1Am8Z1LHuiCD1a60HlolCY9+VhvjXkaLbuQ2V4+xHMAl9ZRpPgXgZjsmcVyL5veFaH8
         GlLMyZkj0lh7VmOL5cxvwTSrS3U0eoj0J3vjfanTv7OQne3a5lxfKO0IMQeM2qbTg8fq
         M1Yu0dSKqVYOqQp/dXX2iz5Nhx/jseBhoBL6GKZqEttdGJgVLvLR2GWvcHvfxC+EPYam
         TM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZuoRjy2zkfcMlEgPr9xog73K1uyLdIEyIdD02hZzgpE=;
        b=mwmK4XDbUZIzUXy31xBohVk+p9py0QbuXo2xi1nLZpPxC1/r4WzR9e4F/XUb41qfVd
         17HGf5cMzFytgXtmA5O8YG75tJ55FDZPDSstq3E7tcaypuH5bqSDCISoGSTKl5oxi5YR
         AZ0U3FAqXwjiYApum/xHg+PwTPEUnqWFQ7c9Dpoz0nkNT/9DFZvIpdkLKug6atH5oeWq
         NeenRLl0A/2hey2WBOW8MryoW5tF8r3DW101D+5F2Q2vuVA8x08XY8kRvI3waUvocKvY
         D1f9+9B6wbudvsaPZgAF1l8i89drgiess9LV1NpU0lbQ6WzR6S+HjYtk7/dv9iuYeQxv
         r6Bg==
X-Gm-Message-State: AOAM5319/nth4zBn+/HBECFMoIB429TBgmYum8z1DZnBzVltDncqcmPa
        9ii0AvBcO5c/IvsrFIiNIh+oBrcm67w/P2MN
X-Google-Smtp-Source: ABdhPJzk/Ekhvle2BZ/n65s0sM8kRn2axiR9Kao/itmAuOL+7ns9fhz8uwUkPVuecNfSfS1nz7gcRw==
X-Received: by 2002:a17:902:e547:b0:141:ddbc:a8d6 with SMTP id n7-20020a170902e54700b00141ddbca8d6mr58043110plf.27.1638174079420;
        Mon, 29 Nov 2021 00:21:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm16899915pfv.176.2021.11.29.00.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 00:21:18 -0800 (PST)
Message-ID: <61a48d7e.1c69fb81.64c22.dcf1@mx.google.com>
Date:   Mon, 29 Nov 2021 00:21:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-21-gb6277a4128e8f
Subject: stable-rc/queue/4.9 baseline: 119 runs,
 1 regressions (v4.9.291-21-gb6277a4128e8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 119 runs, 1 regressions (v4.9.291-21-gb6277a4=
128e8f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-21-gb6277a4128e8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-21-gb6277a4128e8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6277a4128e8f5bbf1f39a4c0c86e24bb09ed2f6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a454b47fef1c5e0e18f6c7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-2=
1-gb6277a4128e8f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-2=
1-gb6277a4128e8f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a454b47fef1c5=
e0e18f6cd
        failing since 3 days (last pass: v4.9.290-204-g18a1d655aad4b, first=
 fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-29T04:18:41.627758  [   20.345184] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T04:18:41.670315  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-29T04:18:41.680126  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-29T04:18:41.695414  [   20.414489] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
