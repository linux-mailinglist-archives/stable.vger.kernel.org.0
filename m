Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957B746F9F2
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 05:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhLJEod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 23:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhLJEod (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 23:44:33 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B812C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 20:40:59 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so7397576pjb.1
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 20:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HLceWRMsFYb5KmDfll4kVSXOWV2zFhsSJ26LhBxDtz8=;
        b=rJXUxN/O+0wlAZt7uIXnj30bqyK/qU6ESdmTIiFvQNW3r+Il7Rl8Je7YMpMAEkdSlS
         8RdNjLzTmeYM1gOCFi/hGnNz4p2eVgAuKyaZg+rcsvxUwruJpHqTx8YTZW+AJ/dO9JUR
         CWIvSPXFQltMJpnDB033voWa4YKJPtC7beaLR7HaLzHjKJe+wy5y/iDMfgBOXwHCZ8m+
         dd5liDF2EV7nIaVkGLZE+D2I2WmUVkH5bJBTfcA6eiYCdD6x0xQe0rcMOdQSQeML28SV
         p+PnyzdDoA1tJz1CpV2LlhYaZ2+zfmJMTRQDqhIAdbxfW0MpNvUggDsWd0qpRD5WtRm8
         v1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HLceWRMsFYb5KmDfll4kVSXOWV2zFhsSJ26LhBxDtz8=;
        b=Ywa1XAK59QXG/Kynl0vzIJ6K/jzfkQT0dlAwMN3TfDEG8IXl/z3H+Vh7v4mwMW1NFy
         LsyoMOYtI4hbqXWJOj04KYId+lX/8z2GUVl4isIF4ntjy4NsqFrYGCR7SKxggz5KBgXx
         T7UYG8A/mpZok7nZ40lxcTuyNsfKTntzXwFfgTLkOaWyzM6fQnxKar2mcL/cM7mbA4eA
         clKe/iRybpxscc0wJ5LsFhTrS7OwxYe2oemKWcz1RztURJ5GNk/71LcH93/PROADmLj9
         ul5ItEb8N1R4ag3TioLmEKLXwyXn4GJctq0/z/IwsxY2KYKF9L0Elqq7m9Z0oHb2qX8v
         oLOg==
X-Gm-Message-State: AOAM531Scct9QrY9kaXIlfZIa660vR5D4tWnH+kTxa4LEBur++UHE0l4
        Zs1jAxwdpVVP7s4uekwB4fdvf4yVeueChWhJbJU=
X-Google-Smtp-Source: ABdhPJyhuQFpR/h8GDdERBV/DSyDpAAOfcP3Of9bjl+PmxGGSUvQwKmd5yJeLV2Wjnv8cFuYLNBChw==
X-Received: by 2002:a17:902:74cb:b0:143:6fe9:ca4 with SMTP id f11-20020a17090274cb00b001436fe90ca4mr73382799plt.2.1639111258557;
        Thu, 09 Dec 2021 20:40:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ms15sm1114859pjb.26.2021.12.09.20.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 20:40:58 -0800 (PST)
Message-ID: <61b2da5a.1c69fb81.dcabe.4f6e@mx.google.com>
Date:   Thu, 09 Dec 2021 20:40:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.219-56-g730dd2023c98
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 195 runs,
 1 regressions (v4.19.219-56-g730dd2023c98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 195 runs, 1 regressions (v4.19.219-56-g730dd=
2023c98)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-56-g730dd2023c98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-56-g730dd2023c98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      730dd2023c98834a93b7b3082e5ff1a61c2c4646 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b29efee3e9a19ea4397129

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-56-g730dd2023c98/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-56-g730dd2023c98/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b29efee3e9a19=
ea439712c
        failing since 2 days (last pass: v4.19.219-48-g6cc188def9f7, first =
fail: v4.19.219-48-g68edce585def)
        2 lines

    2021-12-10T00:27:27.263964  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-12-10T00:27:27.273539  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
