Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8CB48A054
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 20:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243900AbiAJTnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 14:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243901AbiAJTnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 14:43:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825F1C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 11:43:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso317550pjo.5
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 11:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z3NaiKYtgziqCcR12XIxKyTsiY/O2NWckGmnF9fTAfY=;
        b=3ivpp8nQUehj3CjEsl4WU+bYNqbCEDThvdlZ+GQn5BR2w754go2AMJs8PNFZi6Vy0E
         G2luuZ2jKqagJmVdltFFsndNOdbFRW+wXHNmIYYCsmWYonVjg4F3dnRuZSzAo7kQeiwH
         sP2+2aocFSBYOnC1TqA9B1T18Wnwtgx9ju4m2a56XZRezFeuNvGKL3mCYhmWPeu74bnX
         z923CeiFOpiKqITOi2YxzD246s1CZMaDHMGs6Zp4RT0uz/QPJ4oIdWjb2RPNY9Wu8ccp
         4KQIuEmKE0RH30mT/7WXj1ZzL3EFfbqAZkar6P9n4TcCEWCV7Wb6qLdA5ddbVubDUG4F
         9wIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z3NaiKYtgziqCcR12XIxKyTsiY/O2NWckGmnF9fTAfY=;
        b=kJDHevFqaSIOUiDnNYBj/xlQycTrDMJGNHb5bixrtJ+bm7i5azMwY0kgx44O9tBglD
         oymKz4NuiKlaqHxerhX5SuqRYbMjklUzqKXaR8veuCL9Wg5GA1AhyU25NKo8EwRUdxxN
         nAPpDGkBnnYhGKsI1822TfYqJ+O/hnwUiUDitpWcvv31g4NGUsCEvl7SXii81rm6MPnE
         iBzguY7TzGcxXRRjf1ZY4nBvFO9JqdaeJjJMCIchdDgBhZraJ8M6CZfTlMap9ApCnccN
         j7BxQJkkwmqEo9fwKpWH8LRslYDJbKA2+KWRMqbeE0iYvTe+ZGOTciU+iJBLmohA6H6y
         JI5g==
X-Gm-Message-State: AOAM532sEFgsMJ6BoQCR/A8cy7r2OKsG3UbOpM/5CFVtBWYa6F75Lj1E
        Mrdok3pGQk5PgWN1sSGm+AimfR7joKxeaxoC
X-Google-Smtp-Source: ABdhPJzt9DG98Et7qdvd1WQkjJnlkH2Sr6hC3bPLT2wPDY+yYo5LxbzdmgKXxDtNOn0AHANB9sjzXA==
X-Received: by 2002:a63:d34e:: with SMTP id u14mr1068542pgi.327.1641843828678;
        Mon, 10 Jan 2022 11:43:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mu2sm10103393pjb.43.2022.01.10.11.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 11:43:48 -0800 (PST)
Message-ID: <61dc8c74.1c69fb81.d3c65.9f59@mx.google.com>
Date:   Mon, 10 Jan 2022 11:43:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-22-g688dd97d1841
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 126 runs,
 1 regressions (v4.19.224-22-g688dd97d1841)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 126 runs, 1 regressions (v4.19.224-22-g688=
dd97d1841)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.224-22-g688dd97d1841/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.224-22-g688dd97d1841
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      688dd97d1841df9fc689897105df7075ed3c50c9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dc57f8da4e92f3abef675d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
24-22-g688dd97d1841/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
24-22-g688dd97d1841/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc57f8da4e92f=
3abef6760
        failing since 7 days (last pass: v4.19.223, first fail: v4.19.223-2=
8-g8a19682a2687)
        2 lines

    2022-01-10T15:59:41.675691  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2022-01-10T15:59:41.684987  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-10T15:59:41.702106  <8>[   21.331115] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
