Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A614625D9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhK2WoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbhK2Wnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:43:37 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065E5C096743
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:33:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q16so17283022pgq.10
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HkmqrwUWOLhlVKYOGnEHMBXilZuxoo5aD9KTDUhOrQI=;
        b=OAvftHuKV0j5kU1yyY6bXWU0+mHDHTqk/3yiUE8srkxuDb7IC+m7DKVLIO+ZDHpf99
         6dakb5kGNfisvrW/7+7KEvBcV+l88agPXce1PAvwkgtVpysywJ41F2H0cNLZmIIcpR+5
         Va0K/5E6npPN4+40Q5Esc1G2Ol6znFdhQy4oDHw/fbGciJG+7yXXbEm1/SbVZseO2tf6
         VJtR0QIrZniEybfbezyG8BXlxvABbKUoXhsBoFw2tYN+e8mYxNa9sp7vg8t0JZ/rQiX1
         YgF537ohUXYEDm0mzwverLnjPZUQbMrDMTD0MkLJpLFxv3GZ3F2tKqHiig8HsUdVa48t
         1wiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HkmqrwUWOLhlVKYOGnEHMBXilZuxoo5aD9KTDUhOrQI=;
        b=53ThpS1Nh10wBGqLILLiLW6YCoDSDtJZaDbl/f86bLtNVFCPrroy0Mop9dO2v7GACl
         900+pEy8X2HLj0RX5lsC7gkl9cdNQr+JKYEy37f+fetzzeOkUc3G4hoSUOwuddRT527r
         v3bp+wkF2zbXgk8l6cEM8/mJfCmVyauNLWxKY2PUIDtTde1vuyBdepuqcRJmqqn2fzlb
         TUU/+39t525G7/zzD1PepnD6syyXwouWZV3DnEDGoRibBCdMFrlgxa02yJMFR1VkheJP
         t8KSApFjwgpK+pPJIjTWIwuzObf8HkkN7LFTIhHiWJ7D65a0FDdf/4VCfNCTdU7Q6NWy
         CT7Q==
X-Gm-Message-State: AOAM532VX7+8RKbjBd/CqYU7j5No78wEO/hotF+GI7e1b+bHgodFsB8w
        GqUcwJLlrMTR5lQHZSmPB+r/9loLc8Azy5/K
X-Google-Smtp-Source: ABdhPJxZ11pKRaSo9G2gEn+o/B9YkMNetrmitLnvNb+UEgWFShM66UiANFL3Qbj/sy2xZOYL3TgxNA==
X-Received: by 2002:a05:6a00:198c:b0:4a4:e75f:75cb with SMTP id d12-20020a056a00198c00b004a4e75f75cbmr41885345pfl.38.1638218024412;
        Mon, 29 Nov 2021 12:33:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9sm14014050pgu.12.2021.11.29.12.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 12:33:44 -0800 (PST)
Message-ID: <61a53928.1c69fb81.be988.46e7@mx.google.com>
Date:   Mon, 29 Nov 2021 12:33:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-59-g1172201594ac1
Subject: stable-rc/queue/4.19 baseline: 127 runs,
 1 regressions (v4.19.218-59-g1172201594ac1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 127 runs, 1 regressions (v4.19.218-59-g11722=
01594ac1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-59-g1172201594ac1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-59-g1172201594ac1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1172201594ac196cb971348eb890c4106b5bf093 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a500d1ea01ffcedf18f6ee

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-59-g1172201594ac1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-59-g1172201594ac1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a500d1ea01ffc=
edf18f6f4
        failing since 4 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-29T16:33:08.305650  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-11-29T16:33:08.315211  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
