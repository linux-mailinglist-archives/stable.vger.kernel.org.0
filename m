Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2D286FC5
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 09:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgJHHqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 03:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJHHqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 03:46:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10612C061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 00:46:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id u24so3591059pgi.1
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 00:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5l9CEKqWkYxy+/aZSOk03EKGUYOPCbwKWzwq8eECjf0=;
        b=LDL4+NvoTpw0ZWsBTRAdcEbBnANbkbnZBzKKeBkkfcX8fuEXXS+NyPqc+JWM27JaDk
         qrz+kY5m3FNOty/yDlZBbaAt80HEV8BQgd0diNVkTll4nHUQBeVpVcb2ScpZr+Hd07Vn
         Y/X93vDEEBVmZxfFbP64+YdpQRFqjRoDZrdxzD3o6oOFxKVMk3Lw8q/RrQb9w/B/wsmF
         aXOazNv6bTVeinXlNhmYn8dLJ6RgawbqbJ+RYkSzz2ryMjGqsEb5TDUPvmf70wPTlU4S
         fd8fcT3ydcil+CBLtNhqSHqUZZpFU7dbbO3TMULNmuc2KczsvYvDOBx8woaXXpNZkNkx
         egHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5l9CEKqWkYxy+/aZSOk03EKGUYOPCbwKWzwq8eECjf0=;
        b=rYqTGv7oz7Q9Iagal1QNBP2JghUIti2dcK757nTmFPkb2h40qOfysMPFq2I/oI7VZz
         7jhypYINLmR179NK9uLElGFYuSC348O9kV5wJHNuFyELHqzHRhS4p6cazogceau+newI
         pQ8SidAqaNfsHFoV9TANeWTJROfBwRhZpq1OTzsc6cLLZ4s1fV4rk+o8rwbbxB2+ECPv
         dURIeZ4t5QRiq/7bbV/L+KnJoXEjvQX4vz+6B6ISeghrxPxcHceNZxrLv9gbEB1r0Htd
         TIVXJ5rxZdOLp1Ics9cCHCyxBkHHZW0rZgYZuzxrzyzhSB2ep1qNfLSd3C6GQwaJRDOX
         gYMA==
X-Gm-Message-State: AOAM531Wx5Y91OBCimIstTsYj1e2v4jyTX+NJDJ8IMlofyJpFnl2ZE78
        1oBVcLQYYdc1e1bmnYFCIeUu3DWTxZz+1A==
X-Google-Smtp-Source: ABdhPJygtC20d6sRz+oVPrcu91jDduEGssUZOX2cXcThEMMtl6o/57qnYogXi1MC5Mizvqb+GOZHdQ==
X-Received: by 2002:a63:4d18:: with SMTP id a24mr6276430pgb.102.1602143195172;
        Thu, 08 Oct 2020 00:46:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm5987841pfa.69.2020.10.08.00.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:46:34 -0700 (PDT)
Message-ID: <5f7ec3da.1c69fb81.476a3.b81c@mx.google.com>
Date:   Thu, 08 Oct 2020 00:46:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-27-g8c182299cb6c
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 94 runs,
 1 regressions (v4.9.238-27-g8c182299cb6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 94 runs, 1 regressions (v4.9.238-27-g8c1822=
99cb6c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.238-27-g8c182299cb6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.238-27-g8c182299cb6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c182299cb6ccab0e0737921047a564e957fbd82 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7e86eef6d4a01f1c4ff407

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-27-g8c182299cb6c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-27-g8c182299cb6c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7e86eef6d4a01=
f1c4ff40e
      failing since 2 days (last pass: v4.9.238, first fail: v4.9.238-23-g3=
14770acbbde)
      2 lines

    2020-10-08 03:26:34.691000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
      =20
