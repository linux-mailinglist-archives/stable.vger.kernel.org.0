Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9DF482F1B
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 09:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiACIsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 03:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiACIsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 03:48:43 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2DDC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 00:48:43 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u20so28862893pfi.12
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 00:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZL5wowc+s16pO/sUNsB4SrvFBCROkZzLF5VTa7pn8zM=;
        b=qRks16wlrJY/P1sGUuKC2MsBQcS3NuXPv7vbP6ENSZf2Ga5wXYBEKqYsXmvylUWfWe
         +bT5TrTsDLBNOOdoBc5xmhDFmzctoU3Kri94eHOVtA5oGLcdv7FHkySgnLjCejjCkVdY
         QbuVe+/UpkAvBK6qC5gfiWGL8kLjQ2QJE3FCuoMi+Tw/8rtGvLv3tB8Pem82xqqm70La
         UEZPkFjA8q/XHjD/fB/OQOOOa/G8fWe2sEpUQBrX5hlHgSXvnAcZhZf+G6hSs9Rj63Xu
         t8YoClg+fkfagEEq31fonxeo50lhdach9+wYxrpiCXb8jsmHdThBaYi1F8Znm/+1fvQr
         6k5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZL5wowc+s16pO/sUNsB4SrvFBCROkZzLF5VTa7pn8zM=;
        b=4nyXCRQYxLQLEijipVBSgDD5jV6N4iEQpe/wWU8E0I90BZVoxX5UuJa5o4PAkr5VUW
         QUJkgimoKDC0EOiYnpKW+MQcQvEBpiYpqFLOrlB2dNfK6vr/OtAzvXTmHhZyZnOZ/GkY
         1TkIJZx5op9KdaS1E/zEmvXn2d1I7f2JmsIRuTY62NvdIcHOR9HR0e2D20TAm0SJa0vz
         s1u9a8CXJxxVf0+h6j74ZxigQXNu1rkx1JbsQgLpJwFO6bVq1605f0UsOSbCGarsNaRh
         /P8WokPigW+A2dj/nE/B+8APbCzrGgh2kV8BnUG1WN0EY+LZk/M8qrGMjtIJbNHGxts4
         dwXg==
X-Gm-Message-State: AOAM533OJLnVhTQf0O8+Nb0BJzfrIFJN776w8wwXWTSJIa/qnLayMprb
        Mzf8Td5/+P37wlLdmpZN9xFU+YAIyJGYA3j7
X-Google-Smtp-Source: ABdhPJxHLxLlkGQBaaeir9KadxN+26stESXxELeq/UahfyGTd625vvl8ZxmYLPyhoqCsoCcmILASjA==
X-Received: by 2002:a62:8f87:0:b0:4ba:a2f0:5f88 with SMTP id n129-20020a628f87000000b004baa2f05f88mr45564492pfd.80.1641199722680;
        Mon, 03 Jan 2022 00:48:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21sm37699953pfc.75.2022.01.03.00.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 00:48:42 -0800 (PST)
Message-ID: <61d2b86a.1c69fb81.92e9d.4a32@mx.google.com>
Date:   Mon, 03 Jan 2022 00:48:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-3-gc457fc40e7af
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 119 runs,
 1 regressions (v4.4.297-3-gc457fc40e7af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 119 runs, 1 regressions (v4.4.297-3-gc457fc40=
e7af)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.297-3-gc457fc40e7af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.297-3-gc457fc40e7af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c457fc40e7af4256f884921be0b9d1f2ad007649 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d283fedb9b428c0cef6749

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-gc457fc40e7af/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-3=
-gc457fc40e7af/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d283fedb9b428=
c0cef674c
        failing since 13 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-03T05:04:42.278769  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-03T05:04:42.287764  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
