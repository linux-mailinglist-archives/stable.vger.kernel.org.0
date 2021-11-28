Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D594608FF
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 19:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhK1Sfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 13:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhK1Sdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 13:33:52 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D3CC06175F
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 10:25:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso12010259pjb.0
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 10:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5n4iy8I4Wp65LCOFm9hmhu398boF5x/q/ah08I66qPE=;
        b=qvBbb/IBGC89hfV4MsWrDfcbn8AQVerManb7266dzqZ6yWq9tvOLzpLBAzR2UvGO4+
         0NERaba1WdGuua6i/ebvP+KGU+F9HcR7F1lIdMOPib5Yf6WaaNU+U2ZOcooEiruQt2zT
         8FuYbwv3/EkYezCcHmOzHEtTUZRsN4fuMLzSAQ8VQBaRehdumiJlxtig9RqzHcyj0vQc
         NYu58wqy/7fS8vOZ14UgercHCFH7JRfAmvtHXPgZnFVDM5hPLVkK03cp1HJlnrNq50l0
         7Dkhp9vkHG4bGjEQIA3NgT6jipRfPAgxjcCBeUKaa0ZWscEjZcmeTAHn8eTmEZ/TWHT7
         nvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5n4iy8I4Wp65LCOFm9hmhu398boF5x/q/ah08I66qPE=;
        b=2BFGNyXb+87psCQffo/lRsvHRY1aSMWtBz4lefnddpX92q0rVvEpH8qozjfkzYEvKU
         PbzUSK3pTt+h35xO8a4KwB/KGCICVu01+tjGpkWJ1D/9XWL3dvYPu5S+2s+6k2Kbi//5
         AkeoNtyPIIrJOR02kganv2qidxpSOAko95oXdesx+RMQr9pnYEQ9i16u8BGTimYpTFUF
         essKrXOTRMjQ/XFSPsL6uqXwC09WdQALQCh00ky+pkmzoVG53pYDkf4A3TH6QDjiQEkz
         x7ENeFmJ1yaSTA6tCCXiOXvwB2jzL5MOj2KYilxF0MrzdUJQ22CBTwCukpfTi4MBctpJ
         FCIg==
X-Gm-Message-State: AOAM530/V13QxUNsLfp2PzJBw2Chg2ku4pIAgol6T2KMrzgJdIGqM5VL
        HT0BqQAnCYnBHuJRBatNyNeLUtO5gjszxP23
X-Google-Smtp-Source: ABdhPJzvSxyhkLt631ySYJ5nQQcA9ljEFpUni8Q/m+cwxDyXJ6TRjg9/vuBs/DNT0o/Brcn3A7b9mQ==
X-Received: by 2002:a17:90a:e506:: with SMTP id t6mr31480260pjy.9.1638123900569;
        Sun, 28 Nov 2021 10:25:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o22sm15711380pfu.45.2021.11.28.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 10:25:00 -0800 (PST)
Message-ID: <61a3c97c.1c69fb81.ca20b.9ad7@mx.google.com>
Date:   Sun, 28 Nov 2021 10:25:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-10-g7e7b737eb9d0b
Subject: stable-rc/queue/4.4 baseline: 73 runs,
 1 regressions (v4.4.293-10-g7e7b737eb9d0b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 73 runs, 1 regressions (v4.4.293-10-g7e7b737e=
b9d0b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-10-g7e7b737eb9d0b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-10-g7e7b737eb9d0b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e7b737eb9d0b2a109a16728c057667ad90565c6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a3909cb9ba29cb0618f6c8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
0-g7e7b737eb9d0b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
0-g7e7b737eb9d0b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a3909cb9ba29c=
b0618f6ce
        failing since 3 days (last pass: v4.4.292-160-geb7fba21283a, first =
fail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-28T14:22:00.862612  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-28T14:22:00.871941  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
