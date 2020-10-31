Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E57B2A184F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgJaOvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 10:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJaOvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 10:51:04 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A2EC0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 07:51:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a3so867621pjh.1
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 07:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wWoFyRLnhSpqrKQBC93ATUdD7zEhoXZ+xevAlLLCzhg=;
        b=Huyk69zdiPFmZXurP8Bxot8H9YpEvIe4pYBt00ZM++wVTWF1TDvbiPedmBWlRSh9ba
         tZU+n64d1Wj2qffqWAGSWpYZgClc35g1z32NLHSL8QHX7xeXVpZPHByO22yfJMIP/Rnz
         oY/4joMjW1XfPa0yc/gPblzV+ScpsAz20t+wGVzOQsLXEgIis4M6QrVaihS73YXfAuDX
         K9ik6szHQjkfCdV1ku4BmQ5eafpvQ8LNHILzviLSPdjVia4Uc0hWQBuabKnZxeAVfk5b
         k7EvszdPr5vezPwnt+SWcUXxDkHWSyx7kTqj2mT1VK37SidE+DX5b2qlA9dNFWFTYyyh
         0/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wWoFyRLnhSpqrKQBC93ATUdD7zEhoXZ+xevAlLLCzhg=;
        b=BgUSn9MB4/Ru5yYNY3cj+HVpDsSsqjs9c0+J1RCHWai2+U1O68WqkuL4QUymtegS0u
         USQtWQ+MPYGWD4OJLjJmNSL3L0d5E2BkqhJSUcbYy9kW85gNnK38WzK6SP/tj0KYo1bh
         e0fsaVBbozJVs+RInQ7kqpA2NlZY2Z5JsGEMAiZwjIFj3JNk55hUzuw7dfotgf43sdYI
         tSTKiYchj/DJFhPycIG5dqzdfiXltyrDaFUYzFBeyDVdpqNIWg0GvrKsDiYKxxr7zhQh
         /9X3rQTeAKJl6H1JiNGNSeerDXN1oRWWxALp5Zk63jb8LqBdjMXSXc4J3UbzEzU1h05+
         1dUQ==
X-Gm-Message-State: AOAM533vc9YBAij94Cwu4266WsEH31m29XEr51Ymsft265tykIxe8zd3
        44ggsXKd5Pucba47nJb8BRLPfdf40+cIcg==
X-Google-Smtp-Source: ABdhPJxnJhAnxCyNKkNpqvXH8elC4gNJn6U7cQzy4nVjgIGz2uDeieNWvaFu12s59NkbYlNJB8myOA==
X-Received: by 2002:a17:90b:4a10:: with SMTP id kk16mr8911770pjb.77.1604155863436;
        Sat, 31 Oct 2020 07:51:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b185sm8744607pgc.68.2020.10.31.07.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 07:51:02 -0700 (PDT)
Message-ID: <5f9d79d6.1c69fb81.ee4fa.432c@mx.google.com>
Date:   Sat, 31 Oct 2020 07:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-8-g9b3912274eb0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 1 regressions (v4.4.241-8-g9b3912274eb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 1 regressions (v4.4.241-8-g9b391227=
4eb0)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-8-g9b3912274eb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-8-g9b3912274eb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b3912274eb0c27eec6f95e4af629a0cedbc5933 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d49533d1548fe963fe7e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
-g9b3912274eb0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
-g9b3912274eb0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d49533d1548fe963fe=
7e2
        failing since 0 day (last pass: v4.4.241-4-ga5b62fb44d07, first fai=
l: v4.4.241-4-g0d795de442ab) =

 =20
