Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEDE43A465
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhJYUYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237810AbhJYUYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 16:24:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F2FC0F4A6F
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 13:04:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k2-20020a17090ac50200b001a218b956aaso910814pjt.2
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 13:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vabNJtpUwrw/PJIogH+5YQZi9gJ85Z14PXgmYLdrd6w=;
        b=19ZCIWZH0O5SENgaG9vWYl410FVOKsXzC8tnW9euYHqnqeHAzE3cuFN0W4lbm2cgZk
         Tuyz5wRzdbT+LBaV8KvVEKI/sjx2wN9DqAMmFXAx6etIDdkW1JdgSGKNopOVik2R8xkf
         3OOgGbX5h9hT3/imeyd7xhrbdm2+M/DwxIEC6yuuW3wLJ2h7TBntrzWYOgIvOXNqMWgd
         598euK6xCHR6Najs2GExXRoQwB0LZLDkXaQgfoKS0N/Mevqfxyqg7OH7d8kZzosFW87t
         kgpEjU5lDL5bYNOH83cHW7JrNEdl6/Y/6M05y8ls9l5ROxeLSNWQnGPBLCRM1Pcu6U1C
         m/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vabNJtpUwrw/PJIogH+5YQZi9gJ85Z14PXgmYLdrd6w=;
        b=w7O2WtWRFsNPpk2BqC033xgL3YRDt85qk1b9I4TDi8QUKUqJsFCmcgzAbwEiiNVtqx
         fF5214OOwzJxyh+YO/d9INTDgbznOmx2oW4Suy7qu3FqVbZ4mDFAno/GH8VTyw1BBPxd
         yiYF5wYsYT6Py2WKa+ILlkUTLQRSPoEtmx3FXeHLbZdjgFfX4FLD70G8gb7dZ0thtovv
         PuObj0ZV4tqDHF3DtzGDCRtwpTxXZfsL166s7E3cQXLfqUiXZmD5N0Xf/5pVKTtClgx1
         KL697f6Kj95VfdPpnl5xKPdX8cNzEXe1doS+P+U8OvSWmevO0Wra+8F0Hgup2deDD1WS
         UTaw==
X-Gm-Message-State: AOAM530gbaHEkZPg+EUwgebOefZmQiSMEDdDPdF0igW4Vc0BJkgImR8f
        JNsKFB8KarLACwxLahorzvh9XKMpLnsnUQ==
X-Google-Smtp-Source: ABdhPJypepFYuPRrJK+qUP9h6ftvqNPMNIHupDJicN5/EDP9KI6tUtsmLo3XcwJyDAPB2ro09OfTjw==
X-Received: by 2002:a17:902:8b81:b0:13f:3d30:f624 with SMTP id ay1-20020a1709028b8100b0013f3d30f624mr18486262plb.51.1635192262003;
        Mon, 25 Oct 2021 13:04:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nu3sm2766770pjb.25.2021.10.25.13.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 13:04:21 -0700 (PDT)
Message-ID: <61770dc5.1c69fb81.eae61.62b0@mx.google.com>
Date:   Mon, 25 Oct 2021 13:04:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-164-g68a11a49c8c1
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 148 runs,
 1 regressions (v5.14.14-164-g68a11a49c8c1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 148 runs, 1 regressions (v5.14.14-164-g68a=
11a49c8c1)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.14-164-g68a11a49c8c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.14-164-g68a11a49c8c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      68a11a49c8c17fe85c19402e6a7fcd537f930f38 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6176d821b2112f2ca33358e8

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
4-164-g68a11a49c8c1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
4-164-g68a11a49c8c1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6176d821b2112f2=
ca33358eb
        new failure (last pass: v5.14.14)
        1 lines

    2021-10-25T16:15:18.580606  kern  :emerg : __common_interrupt: 1.55 No =
irq handler for vector
    2021-10-25T16:15:18.590486  <8>[   10.553923] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
