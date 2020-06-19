Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69391201787
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbgFSQjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395408AbgFSQjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 12:39:40 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ABDC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 09:39:40 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h10so4701823pgq.10
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 09:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FddxAYToxXSoC81EgdJjKV86YJZe9gdiXwNHdupnl6s=;
        b=Kb2tNL5sUXMnTMsY0/6VAhUiI0rX3vd6xRSx/ixFZ/dBZF1QLiO03xXCvf9OFo6Kyk
         HJprILLNbOOpYpbP3wwnUKEjl7hvpSbIDCPmUZaqV3mdHbZKNfVk94RKd4aRs41jKud5
         Fwm4ZPg4pUrrNh2brSzuKr8Gy/Ym+7OJk9tfOiBE7UUZKOeQncVrgMRNrYjWVO+7sqrF
         T+mnZxrJ5WWuvaV5CMmPUDsKaOPJkIVkPaDbkapIUeuVVxhzyMKyelHW/hEwVzWZPYiU
         nMqv+sC0HixRmMrvrivn9fPbRy1VRJTm1+slkmB24IKeRGr2dbWtlq5/j2ur55Gj5iA1
         8ktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FddxAYToxXSoC81EgdJjKV86YJZe9gdiXwNHdupnl6s=;
        b=luIyabaAzoKQzVkgtTSHdt1cSJ8cjN7Tr6/gKvYbuYBFp5Fg5mflUHLYlVmazQ8I54
         vZ/P5JqZF/O2axA74w7D0DfKMZA8syNGD1YO2HY8Qmxm33kBeofiDPsFNBTnfIjatOY0
         Knx6ZtESVjI4L3cegrRK8mzV2jDfJnJvVlB8Q/WpBAHovwMrB89qtfZBMm2nLbvi4fvN
         mdM2pQtw7kO19GOdDZShiE76r3/jaiUg4qDygoxa6vzahnGI/60bnYmdYqUfns/v8Bye
         2CCKv/bmp0AvVuYaINT6WCl2+be146REiaAypmVjRcJlFWcbB/hzuhMv3WstHx5Lnmto
         R01g==
X-Gm-Message-State: AOAM532rQHAfytnywyWOwZZ/dWEpUGcLmPMwRiQnl+xZ6PnkGdbAz1lj
        ONgUzDVZimTbjnd5Bd8tzEYm39P6Lis=
X-Google-Smtp-Source: ABdhPJxxwoK0Ec322u8hetxdioDa4toPdabGtHJL41/oYE7U5Nnb8+GY8YIKpnNDp/Z0w8lrMr7Ofg==
X-Received: by 2002:a63:5a17:: with SMTP id o23mr3806626pgb.218.1592584778750;
        Fri, 19 Jun 2020 09:39:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18sm6324176pfr.106.2020.06.19.09.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 09:39:37 -0700 (PDT)
Message-ID: <5eecea49.1c69fb81.45d72.31d7@mx.google.com>
Date:   Fri, 19 Jun 2020 09:39:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-415-ge106c2769e2a
Subject: stable-rc/linux-5.4.y baseline: 60 runs,
 1 regressions (v5.4.44-415-ge106c2769e2a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 60 runs, 1 regressions (v5.4.44-415-ge106c2=
769e2a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-415-ge106c2769e2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-415-ge106c2769e2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e106c2769e2ac5f2ac077812f281dbc5f9c3b03c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5eecb54731594bee1097bf32

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
415-ge106c2769e2a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
415-ge106c2769e2a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5eecb54731594bee=
1097bf35
      new failure (last pass: v5.4.44-206-ga7debb64f8b4)
      2 lines =20
