Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AEA483A70
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 03:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiADCBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 21:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiADCBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 21:01:53 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5D8C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 18:01:53 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so39221469pjo.5
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 18:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WEid+KB6ITwkF183wBkz59zmrvgOMxAt8MhbslYA61A=;
        b=0va9MXNKLo9KAxaArGCPXMD4+8n4IdbmOFsW6GHwy/TfoiYH1xoYNqj+DaI7z6HoaR
         Wtl+/071v8SXDip/l5FsHraqmPIqNIxcfbR5lw4DOLc9htQBplpHFTUBxcAC7Wsrm0ve
         OqLzUKh530xZpN0qc3cSvnBxwxWFWrOsqP4kRWQddGooHAu13m+v+h4raE0h3mAVEJ/p
         g868efPxIkmTwIF5jzPr83K451dffQCA3EiEXfNnfwnnxilqs5tVEHQzrH3rZpBRmC6/
         XN8yKuGdfJVyJhA3767ZfPLzQHlshuh6n3IIlHOHzZDeVr4bHOwsPjBPf+NhYJP6L0/v
         YR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WEid+KB6ITwkF183wBkz59zmrvgOMxAt8MhbslYA61A=;
        b=WuOnvr+KGc16IcN3kMUxRcGhAqGUnnJsQDouTLQQlU78+W+/TpdVje9yvopUmB/pM+
         wqqcpF7SLTvtPkSV4IZiST6Ic2HLKKuktKg4MxABHBeu+LJ73/rNmwTyqV6+wfKtpNB6
         yIiPsugkTvpmXZL0Qft5o+gdvS8WMjdHNAmz4Mwq9UibTm7H1VHDqixOxqii/UYlqeLc
         M0MVKLqfehPShXNvRryuuHxt1a9p3ysFh/bGKmmTZOpPtI141EpFbXkTz8/Qw1tErmgb
         JI+5byofcY3LZ7Io57T1d7ll4Sdy4VBsC+YztnX6YDETesiqJZMBAiLJ9faf8saYpms2
         FmrA==
X-Gm-Message-State: AOAM53117usvJT5uFHUKk8MAhVrmaZpy0hpFBbKkfXNqD9HRdNyoaLHT
        PdTg/KxMJjqPMd3mClFZl3Jqk02ZjmcR31m0
X-Google-Smtp-Source: ABdhPJzSpV5MpjEBDFeVyuhTaSbfRCOliLz0uhsU7PmqBvOe1H9p3cjhjQGKlxhO+vHq56zgJAlFkg==
X-Received: by 2002:a17:902:82c3:b0:149:9715:21c4 with SMTP id u3-20020a17090282c300b00149971521c4mr27385590plz.157.1641261712760;
        Mon, 03 Jan 2022 18:01:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm40965053pfc.203.2022.01.03.18.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 18:01:52 -0800 (PST)
Message-ID: <61d3aa90.1c69fb81.6ba89.ae9a@mx.google.com>
Date:   Mon, 03 Jan 2022 18:01:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-13-ga2f26742147a
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 111 runs,
 1 regressions (v4.9.295-13-ga2f26742147a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 111 runs, 1 regressions (v4.9.295-13-ga2f2674=
2147a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.295-13-ga2f26742147a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.295-13-ga2f26742147a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2f26742147a81e7996c772832147c52477e0b6c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d3766b2e1c4fcda3ef675a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-ga2f26742147a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-ga2f26742147a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d3766b2e1c4fc=
da3ef675d
        failing since 7 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-03T22:19:05.165997  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2022-01-03T22:19:05.175397  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
