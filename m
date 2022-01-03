Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9410B4834D6
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 17:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiACQhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 11:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiACQhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 11:37:47 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F18CC061784
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 08:37:47 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c2so29884613pfc.1
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 08:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7b4Lr5nem66yGA73AjW6y7EGvjiGwuiZDX57LCUbM0I=;
        b=afleQwz18bL3bvbguOVZh+74F3vS6Cc7/wQtjgnLGhSnROLB4AWw4GC/KNtE6xEWAs
         RFMFLH6L5obw1SHNCVj9Hv0f4mpF5WBW+hOZUZKJrW26jpAadOK3N6/6Nkq7+Fm5uSk0
         QoOt5LLcn4kImMs/gNqBJmG0UHyMlKk2axe0bMaqhyfnRU/OySGRjfdm+PQ4IgUiM6t9
         nQTks4XoV6H+a4nElO0V5wSLCoXUAVV7t/c+F/NT9I6S5a0bKkk3QV/E/8xQtHrOqW/q
         lNf8MyHJGMvUKqx2POmDi4k7i0l0d2AXa/5rw1x3279hht0ys+02oYw+J6c0DH6oGJOm
         KhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7b4Lr5nem66yGA73AjW6y7EGvjiGwuiZDX57LCUbM0I=;
        b=nBXXzlLzHnKAh6K5eX6b47/aYMeqzPb4oM6UW1du8r8yn5mW9o598cMysHjE3XVarv
         H6WhkP+w6uvQ7jWuTsEjOvIPj9jDHeaAS1cLs0cuoM7bNt0HO3HdMrod6HFwSPsfWN+f
         LsX0/v1zFRf2ikKFp+lERyWtzsVHK+eCSl1JM+WAkhJfwZmL0T+mBo5G9ijaZtaa3OFh
         kK7bVXdnViASq4jdl/9czovA7hgwG+BprMWqHZsBz0awQ4p5WRYRbgbSQB5CaMq0eQrC
         jb4/A/4pX7IQ98HLK1sfAcUqDJXRfR2Q8hsa5MyjUoDApYWMFHBYBISJAjgZEgcEepgF
         Z7gQ==
X-Gm-Message-State: AOAM531dNDHtklGJl6dHaH0jwP5QhAThD7xbozeyhpHpfvb+7F+2VleW
        agA36d8/gGRXCGOmBiSgit/qCLjm5waVB8i1
X-Google-Smtp-Source: ABdhPJwEgx4G0UBvNmzuv5UMS438H2AijSG29X/KIMo4kaKINoT/4gKWBHpb+s8td9wWYGUEqWheHQ==
X-Received: by 2002:a63:385b:: with SMTP id h27mr21455707pgn.281.1641227866528;
        Mon, 03 Jan 2022 08:37:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z18sm41720501pfe.146.2022.01.03.08.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 08:37:46 -0800 (PST)
Message-ID: <61d3265a.1c69fb81.69cb6.e1ba@mx.google.com>
Date:   Mon, 03 Jan 2022 08:37:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-28-g8a19682a2687
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 165 runs,
 1 regressions (v4.19.223-28-g8a19682a2687)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 165 runs, 1 regressions (v4.19.223-28-g8a1=
9682a2687)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.223-28-g8a19682a2687/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.223-28-g8a19682a2687
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a19682a2687b7bdb06f09624798f92bc348c03c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2f554b7ebe5e8d5ef6747

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
23-28-g8a19682a2687/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
23-28-g8a19682a2687/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2f554b7ebe5e=
8d5ef674a
        new failure (last pass: v4.19.223)
        2 lines

    2022-01-03T13:08:14.605637  <8>[   21.203460] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T13:08:14.648744  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-01-03T13:08:14.658405  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
