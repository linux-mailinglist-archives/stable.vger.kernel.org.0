Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1970F484407
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 16:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiADPAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 10:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiADPAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 10:00:42 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808D8C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 07:00:42 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id y9so4418656pgr.11
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 07:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/d9ZC/qTOPeMZGnSBAzD+xRxZGmfCaB9zNPEOpA+D+o=;
        b=5eg3f83Xm305ideNsgnap4GulXNYoEr+mZL4vccHFy7BP9fcV6G18d+EE4R0b0E3it
         bjc2M/uTZv9SpRseocg0CiYZd3E6HHNKpdVHJs30Mo1feApPf32FzvncOJKvXdfqRBo2
         +e1CqQtEs5Q7XBVlNYJ/+1cWmkGM9V8YWb05DaJvNtkkUCVSh9zWZunEJCgA1RA+o3M6
         ej/HrxMU3B7xkOg4oZK+XahY2farrOeCRn1Z9y/VwY8cIli9GsK8Gl9jsgpLERp7j6cm
         Nk/Sur9gd5a6mHje6d47s53DLCBJRirkFMTj5qDSdPm6J0cUcGOv8jxxcRM6H8IlsaZU
         gfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/d9ZC/qTOPeMZGnSBAzD+xRxZGmfCaB9zNPEOpA+D+o=;
        b=zNhnPu4uBc12b0pEW/TNY+f8x3uZVvZRAC1zhM1tI6wZ/tSWbn9I1ZDave/AOhl2+0
         OOL7X2xtUZ/7sitqjwjGdRU/X8AWS6GPy1dlbNV+HFMLXwSfBUqoKuYXGg3+HnbfHtR6
         PjKQxvyPla0qMWZnDcu6D75HKVEbsv/45sik/4Qpfx/J99ydJcVFZl7RJ9i3ukhSRPZ/
         Og2UHKTtt6zH5IPdkClH2+8patuuJXgEfnH1QPrfbb5rIaVhRCue02qvs1iKl7nkPuc/
         di0rIJUsrt86sHnTriVZzvtJ4SIy6OmMy+Ow+WbiMscNpJuyE/zidD8CavvXEUHqqFNI
         NYWQ==
X-Gm-Message-State: AOAM533XSEj1m3c3GNfNBHSqCdAuKlEC+EKG6TJvsDyZYwFkpH7oYLJH
        a1l9L5qx09ZAqjCTAow3IYFp6+Q90FN7tMrm
X-Google-Smtp-Source: ABdhPJxEHmf9cl+gXbzvCS31KFAhGWtFJSslrQVBi5oShF95S5IzYkVGvvn2b3ewJLSluWdl/yWOnA==
X-Received: by 2002:a63:154f:: with SMTP id 15mr44134416pgv.521.1641308441408;
        Tue, 04 Jan 2022 07:00:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm44387022pff.106.2022.01.04.07.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:00:41 -0800 (PST)
Message-ID: <61d46119.1c69fb81.77805.35bf@mx.google.com>
Date:   Tue, 04 Jan 2022 07:00:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-19-g3451b7a14a52
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 122 runs,
 1 regressions (v4.14.260-19-g3451b7a14a52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 122 runs, 1 regressions (v4.14.260-19-g3451b=
7a14a52)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.260-19-g3451b7a14a52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.260-19-g3451b7a14a52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3451b7a14a52c21672b2cd780ce0e95e24a01f30 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d41f67938063e98bef6740

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-19-g3451b7a14a52/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-19-g3451b7a14a52/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d41f67938063e=
98bef6743
        failing since 1 day (last pass: v4.14.260-5-g5ba2b1f2b4df, first fa=
il: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-04T10:20:05.060915  [   20.158172] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-04T10:20:05.102170  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-01-04T10:20:05.111345  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
