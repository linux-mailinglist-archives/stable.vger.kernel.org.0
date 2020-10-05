Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066E2831B1
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJEIOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgJEIOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 04:14:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F9FC0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 01:14:48 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id x16so5528459pgj.3
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 01:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HcEgayJrANr+Ikk1zd8K1ibtDSp53UKSTWdl27m/55Y=;
        b=hoGsL/fSxGcpFCh2BHoBA0FlVZpRLhFtGrMhrsJxi607VDLQDJfygAz7EIAFqfxoJq
         PPKz9qf8K95ObsYJWm42oobru5fKd8R0q7estt7CAcvItrTe2LQ1jRXkhBfOnSXfiAPP
         Fd56WizJ+UnKU+fw0l/EZdmqGobvp/j74fBsTIcJQPRG4ng1Ms5Q3CwVsfC+ZoVxjRzg
         AT0NaO1iIC3qD12Y4Zt5AxAhCulezpsyxRlTRuj8pj6vTBBfm0gI7PTJcvMyaODDw/mt
         vDcw/jQeUiaVkWXsnKFZ4z01Iy/sKwGDg6+W3AITX+0ljJdBSQprzkOckhkPU6G4bvfY
         3Cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HcEgayJrANr+Ikk1zd8K1ibtDSp53UKSTWdl27m/55Y=;
        b=ugCFLGgv+zenw5ErDJ68QuidyKEuSCwm2waXBOVPK4uXnsGT3FThLvSKs1mSZlIVgW
         5LtEgfBwrH3SMYoKiKn9TsA7bkuWRMV4PY5nasBWSOt2qqzUNNogQbtDR8xsP3UnWabn
         1tSixUtuC0EPN42GExPOz6ERrGghLR5iWnO5H14FsaPunCz1pfVPAmg2vEzmFu4ibRRW
         ekU0cN4w6VTGTHtv0wXVHyVAplcMMfK7XdsvpRn8Tf/15rtxSbDpAOL7lBJ1xtviqpF+
         aLVBG1BjXndk/bAso80HEmqmKGuX4hYUBKvigM3qQWIWYJlX/LMx6pOR5yCbSKKtD1TT
         WPng==
X-Gm-Message-State: AOAM5325ipwRjLWJ0d97vkNL6SLlekZE4UmWgo+/R5YY9CW5hrkSsLDF
        PJiI22WxayElwjFbd9ciCKltkRRIe1MaiA==
X-Google-Smtp-Source: ABdhPJwo4a1YiIrN14RefJTK/GBvwodC1uca5bofnWUlX8qxyoz1yV4g4AtkdNAr0+NKUd37yBLocA==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr13367345pgm.175.1601885687892;
        Mon, 05 Oct 2020 01:14:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk17sm9376757pjb.31.2020.10.05.01.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 01:14:47 -0700 (PDT)
Message-ID: <5f7ad5f7.1c69fb81.9a44a.242c@mx.google.com>
Date:   Mon, 05 Oct 2020 01:14:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-78-g30a327c53e6f
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 105 runs,
 1 regressions (v5.8.13-78-g30a327c53e6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 105 runs, 1 regressions (v5.8.13-78-g30a327c5=
3e6f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.13-78-g30a327c53e6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.13-78-g30a327c53e6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      30a327c53e6fb07ec15795d96c775225c8c16b54 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7a9d3586a50006884ff3e9

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-78=
-g30a327c53e6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-78=
-g30a327c53e6f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7a9d3586a50006=
884ff3ed
      failing since 1 day (last pass: v5.8.12-99-g7910fecf197e, first fail:=
 v5.8.13-3-g58c57ca2b2dd)
      5 lines  =20
