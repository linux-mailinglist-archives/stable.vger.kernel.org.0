Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EBB468D77
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 22:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbhLEVmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 16:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbhLEVmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 16:42:54 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094DDC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:39:27 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id m15so8585558pgu.11
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 13:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i21KdxPjy3wsJmIPPonSWdss3uJ9oQQ2I9W7+Qb/i3Q=;
        b=ffE7/4EleXatRZiBVtbBA1i2x1UCXWD5AzHy2fS4P7Qb+BOQVuCuIBGalOSY6eh0lX
         Mtpw1caF46ivKnn062KqdwEjkR6gwwF2h9HuXvhqtCSQwkHhaMSOIFal1dSbNHaWuGZL
         TJE4DTw+osd0UgWFRcVflsV4/cW30Prc05kY1Ob0SayaX+/haYtYOeCLT+oopEKbMuVR
         6kEkFOrqohTBYTLWWnb3g+Erd+0/B121l6lOORIsV0AJ0d3GeLhE5J2ei8pu2MP0lv16
         rJK9DN99U/+EPMnyMUEf9Kh/MSv78fcOlO1GKwY/vlDuBjxcb3AbGn6vKTEQn1Wakl8d
         opuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i21KdxPjy3wsJmIPPonSWdss3uJ9oQQ2I9W7+Qb/i3Q=;
        b=WsuQnpqHFIoabdrI611qnv48p15Eda9/O0kXE02RnL0DFAlmrCDND1Csfo1aOBqjW+
         U9tZei+Ls2IUwqoKLc4tOyE1nKBaIGE90KAxdd+KUr4Pt1iQVL5CuXbosD8OnPVCHBCa
         7ClF8cMcJQnII9K4Ds48rqdfzYfH947qqnLf0TV9ZcqNTiwWqRb/CzRQXGd4eS9Le6yb
         p9sdBBaDtD3Adxdiy8tQ1eICmYMkzjblkHZW/Zwz/7MUwGmh4QEeG8tTnrwSZqkSWQCm
         f9NE+XXWN5RUuOuOew8gFql24/x2F5xdgPwx3D6J+is1qRcKXGoRg/TQh+ae99aNBJKj
         oJiw==
X-Gm-Message-State: AOAM532l2M/qJkPYGrjsJhBQyY/C2LKVfyn6JfuIAPzg5zpqwjTxT2Nw
        dmeCXiRe+6zKtuxJY4sAEvhm/C802k5BHSKN
X-Google-Smtp-Source: ABdhPJz9mLXqjgp5ryRVtpLRmARiXbJfzjGZr1F4DlTtuYEV88xvpewy8xWKzWvZ/D2JDRbxhvgpuw==
X-Received: by 2002:a05:6a00:888:b0:4a8:56c:d2c with SMTP id q8-20020a056a00088800b004a8056c0d2cmr32863570pfj.40.1638740366243;
        Sun, 05 Dec 2021 13:39:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm4643685pga.80.2021.12.05.13.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 13:39:26 -0800 (PST)
Message-ID: <61ad318e.1c69fb81.39399.d6c4@mx.google.com>
Date:   Sun, 05 Dec 2021 13:39:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-49-ga70466410dce2
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 79 runs,
 1 regressions (v4.4.293-49-ga70466410dce2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 79 runs, 1 regressions (v4.4.293-49-ga70466=
410dce2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.293-49-ga70466410dce2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.293-49-ga70466410dce2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a70466410dce2594587144b3c03b33494e98deb6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61acfafede4c44f5de1a9496

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-49-ga70466410dce2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.293=
-49-ga70466410dce2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61acfafede4c44f=
5de1a9499
        new failure (last pass: v4.4.293-32-g8d63932e73701)
        2 lines

    2021-12-05T17:46:08.914032  [   18.939086] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-05T17:46:08.965483  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:0H/5
    2021-12-05T17:46:08.974483  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
