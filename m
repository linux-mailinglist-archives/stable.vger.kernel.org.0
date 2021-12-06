Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE7E46951B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 12:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242562AbhLFLmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 06:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241994AbhLFLmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 06:42:10 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5288FC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 03:38:42 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id u80so9892451pfc.9
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 03:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YIbJOUAZhgx95ilqH/C5SBwSEEM5hVfjaMPq9GLhMps=;
        b=sLMWu9SC/afjbLiMYY0aiFeqiywXsojoIM+tgt4/+WnI6OmogNkB4i2mIH+nUzjKbM
         se0W117o4CEHHbVI6Xqsk736q9NCrANHh7ewqyhzNUZuySg5d3npiglOpT+YRsOtWn2t
         k2aV2tpvq36fjyhvbrOO+6REDjI1aLCpe8iS9QuFItL/cemb33T9UYjFrIaHlDWG53hN
         i09QXGlwbeaR7O0LedQqBRUtL2q4KUI7hYrVy0FBEJ5iTy6ZLQFaQ76nhMMghpg1RWzm
         fNIc+k5862um/FBGWOo9yBWdr0xlxagU9U5hB8DUwoF2OdfcSVEZNMRysmBD2B9JaJOv
         ZcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YIbJOUAZhgx95ilqH/C5SBwSEEM5hVfjaMPq9GLhMps=;
        b=cWC2kGJJpXqyUF0AuQIoWlY2EBEsXiKE8EQhzAVY9Eoy66hht462HUrX3gL1/7Vm4P
         DDfVwGgQA4V4tSKhz5QoQl4gZCcWXxhbrI/RCCrsbo6jqY+QWEjNcipktZAWVMfYCM/L
         4kVP+sRk4q95llM4mLx6lJ15QEeiDjfuA+0JaPVtMW2Oam0cM1F0YHf5Dzh7TXkwilND
         fL62CICIuJ49VXuHzm3NGbbiMzLzI5ALlOVPlCL2xReoS2dWTgM7/WFDAXIzr7smY94p
         060MAjqGoEpL4fao9EvBzpVKk+9YGV9cB/+WVkXoJsXut3SQSNYvfvlJoyf8DW5/ahn1
         LA+Q==
X-Gm-Message-State: AOAM532n23jgtP3XcGVwuLLK1MJ+n7/FNqZDVU6zNwbRx7SjDwLHy7dD
        s5MNT33ihK5/2MwSezpxinyz8x0/1kqUJSJv
X-Google-Smtp-Source: ABdhPJyBnciFW91rYhDvaYG5Phv7Gkea81a0UA8aNIiiXV+uOpWWyFbBXNF4t62Io+ulJRNIIOMI0A==
X-Received: by 2002:a62:7f06:0:b0:4ac:c0ea:249c with SMTP id a6-20020a627f06000000b004acc0ea249cmr12183353pfd.82.1638790721664;
        Mon, 06 Dec 2021 03:38:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v13sm12523843pfu.38.2021.12.06.03.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 03:38:41 -0800 (PST)
Message-ID: <61adf641.1c69fb81.988fa.2b6d@mx.google.com>
Date:   Mon, 06 Dec 2021 03:38:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-96-gecce7fba8d835
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 106 runs,
 1 regressions (v4.14.256-96-gecce7fba8d835)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 106 runs, 1 regressions (v4.14.256-96-gecce7=
fba8d835)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-96-gecce7fba8d835/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-96-gecce7fba8d835
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecce7fba8d835eecf8baa237cf9787ba19355046 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61adbdb26cce7cbeab1a9482

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-96-gecce7fba8d835/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-96-gecce7fba8d835/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61adbdb26cce7cb=
eab1a9485
        failing since 0 day (last pass: v4.14.256-86-gce5b7722e4968, first =
fail: v4.14.256-96-g0a8417bc52507)
        2 lines

    2021-12-06T07:36:58.644853  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-06T07:36:58.654188  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
