Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE426159A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbgIHQxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732055AbgIHQsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 12:48:39 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29501C061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 09:48:38 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d6so4379524pfn.9
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cykhbXzSiwEpgysAd+cXMXuILBQL0Ko1ZNsC7sFEuKI=;
        b=t95LOzcFJXa43RPQvWS5HMDYofcL1XGHacIY65tcArT4IQnQSU4vYRTP2V8xnss+sv
         JnSVzpxZPEmjwkqUqZFa1cVWYbgONqoyX1l42yxEoZyUUNo7YegZ9qJDQWqAWf6YhxBE
         6OMFo9x80n1OSg8fzrBgskgwTxxesJ3hJ+nwr5Bo4mz0u16swxFPvNUZixW4np1wLg85
         +3W4MJN58l/aR1w1odQvVQhGFx1/pQxBsOcwUsm/4SE2SfSh1HMrE198YFpubqZkGRs0
         VjNXN5/Z4lsUKHy7ge8gkdMsN4MGEe+J+9HEe8AjVSQqFpymba7egirR8ZPGIfXTT+j6
         ucmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cykhbXzSiwEpgysAd+cXMXuILBQL0Ko1ZNsC7sFEuKI=;
        b=YJ9PaWm0Ic8I9PZdJJSB6YtzQSqaJfL/WpU+GYUpL55TBAa5C0bnkg2s3QHVNc5+JN
         7+08u27lTB+RKeRgoxnxhSUYpBV2VBquZZRAA8bMYz2elqOYqad8Q5ihLkwIhIBtCYMN
         uqyZr8AV3/btVxKK6pqtONOyopl/dLCv/glNhAzE0bYMDxfyI4plpBXXvqc1ASUxjrCA
         vAK0lxlsM/N2PXeGiGd6DnW1L2+frQn8/WI0v/GpYh8RHZwCwfkIIvyE8zMDuxyRgSXu
         mKqIFyGrlTYxIypF+zG6Qo5SOb5o/OLriFoxR98ln7A2OzBwZMlsCABQ0B8DGx2POp5H
         2o/Q==
X-Gm-Message-State: AOAM532bklwQIFcaKpHAYBvFu92pCVKiL0KXMy1Y4tf2/uzhlCpC8Emr
        YundI5ZPYx580k990VmzgE4/iikcHaOCLw==
X-Google-Smtp-Source: ABdhPJz0dHfZ10jUMFcE4JNTK25KtpN6NMYaitfgOmzawp+y2YOsnDrHq9JHthRmGPDmmr/5bwuMGg==
X-Received: by 2002:a65:5a4c:: with SMTP id z12mr20569000pgs.10.1599583715684;
        Tue, 08 Sep 2020 09:48:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl10sm15629pjb.11.2020.09.08.09.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 09:48:34 -0700 (PDT)
Message-ID: <5f57b5e2.1c69fb81.2bcd6.00b3@mx.google.com>
Date:   Tue, 08 Sep 2020 09:48:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.143-55-g58651549ea03
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 157 runs,
 1 regressions (v4.19.143-55-g58651549ea03)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 157 runs, 1 regressions (v4.19.143-55-g586=
51549ea03)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.143-55-g58651549ea03/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.143-55-g58651549ea03
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58651549ea0369e2dd16baee518e5faa846eccbd =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5781e60d78c66569d35414

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
43-55-g58651549ea03/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
43-55-g58651549ea03/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5781e60d78c66569d35=
415
      failing since 49 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
