Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56C8289223
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 21:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgJITp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 15:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJITp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 15:45:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B08C0613D2
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 12:45:57 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h6so8037813pgk.4
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 12:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xqzDess+W75v8PZ9eM2eNDquoQzIa0vae1rKJ1YmAG8=;
        b=CNkw3FqB8sXprvXBxfHFB/pJ3l6MIv70Q8j2pDQ8xC3UJxG7Ri37qYsAxViD1RWS0x
         fHjcNqa1RCWyvWZWR2P0mfqQ/BVQo9rcRtr6joeBFRonXe/uTnzFXOXAPUsgyruVE8BT
         6G5TeOgzTErzk3gOakSqZ/uy7JsqPCpgp3kI3jwAxNOSXo3XO8tyOHq5xBqePPCHGnCY
         /oS4bgEmjFQoiuFQPERYqknCTc8XDo+GuUMSPCey7AA0iWz8L0KtKUtTtRI+ZQGXslU0
         PjiNeAfyoULlUob0ZnZJ809DIvSvifdzcQ5AQK0Is8NhYFImQh6+G8nfdMZkxHip9ZzV
         7BMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xqzDess+W75v8PZ9eM2eNDquoQzIa0vae1rKJ1YmAG8=;
        b=Y7jokShmQf0BMBStXaePhijf9HFax+V8JEVHw7mXDb2gYS+YmyPXM9dpGVEQvuDJiw
         Qt+3lZpo5lXsvOWtnCGgwOFAfOgJTBSZPs6BIbitC0uNLI/xNGTh3VX9plchiE4x3ROO
         pZpTDusoIzDUNHDXq9AXr3CkpA7sgqIwr+dG2nkMPoF+CBVLbPQuNqK/gfFb1IRMZ+C5
         Oo1kqQ47TFUgWuTwiagJwHuNkR/IbPq5P9RKhLHbiqfVg2AN1o6MDR4W95o53zchoC3f
         XQeykiI6Zi9dL/GMDAEHSystimuOy4UT/lefxrLf02GyEYx/xyni5ZQ8gPbQC77e/+ae
         jG5g==
X-Gm-Message-State: AOAM530WTgdZ8PzW77iedEMFQ39AR45P2DI9riiRjUaE/5cUMwTIH2vY
        o/nXEyI4OoZmVoGFLmy/Zjm2egyXlJdRoA==
X-Google-Smtp-Source: ABdhPJzGmvSF8BEVb41Th9/QJTO1oOwyuzsHEwKvPazBeaKBYeF0gSFR3/SoZScgeK+5+P7Lcd/tJQ==
X-Received: by 2002:a63:396:: with SMTP id 144mr4895472pgd.364.1602272756641;
        Fri, 09 Oct 2020 12:45:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id az18sm12672803pjb.35.2020.10.09.12.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:45:55 -0700 (PDT)
Message-ID: <5f80bdf3.1c69fb81.cbfdc.6f1a@mx.google.com>
Date:   Fri, 09 Oct 2020 12:45:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-31-gff7df5c6ca79
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 52 runs,
 1 regressions (v4.9.238-31-gff7df5c6ca79)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 52 runs, 1 regressions (v4.9.238-31-gff7df5c6=
ca79)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-31-gff7df5c6ca79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-31-gff7df5c6ca79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff7df5c6ca79286d467d017c6f4ba773391e8c79 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f8080d9d16c09564c4ff3f6

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-3=
1-gff7df5c6ca79/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-3=
1-gff7df5c6ca79/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8080d9d16c095=
64c4ff3fd
      new failure (last pass: v4.9.238-26-g1959353b3c5c)
      2 lines

    2020-10-09 15:25:09.527000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
      =20
