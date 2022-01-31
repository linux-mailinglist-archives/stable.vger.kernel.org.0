Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1E4A48E2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 14:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349056AbiAaN6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 08:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348918AbiAaN6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 08:58:48 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E18BC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 05:58:48 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so18440218pjj.4
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 05:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vk8uCkePn2BjKMbYI3Zgpp05CbQ65vg8SFvn+nU5220=;
        b=iROdhr05YGK+9noOGTf4GeitFFtCuDZIYQIbf2YERKy6U7wnjhiVUtlLJqhC8ln8EG
         YLWCqXiZ8oT1lsr793eR0gS6mswPyMyFbbz5qMjyTba6a8Tv0zlcQTTdNzxfGmbNYwhv
         HoSRTpJwZrXkcqXvInhcSjZItPuyLqjiuRoJTZLsSOr/XLNKztkXaUCNznw4vVESQ6Ia
         aWjgm7KfcnNV6bIYptMzpvlRQ6db8mP43bZhlTumrn9UwQQ7+oFoFw5YEC3PQrdG+Mxb
         CjY1AcPFT42ir+fgnHQDca3CLYafm7F8lqWNObaOP5ebTARp7RDbl3yjoSCIcvcsj1LQ
         vvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vk8uCkePn2BjKMbYI3Zgpp05CbQ65vg8SFvn+nU5220=;
        b=Yb54TePsOdeZZ+ay+e2Flik6+IPgBLdbv6jsbv6p4dLARni0opslMYepgSbZ9TEDg6
         I5DsNNziip8uptVM1AKqjGlbQLrtQ7I9qes3Vn3RSjwjMUXDQzUMnL4DwPIgyLUxVD4F
         IMM4o6VyOuACOURNjUFdFh592mg9RjM8EQP4pVW5YMWCJ3QE/MxaI4WmHNAdT/hNSlq4
         Ge5HWcc01oaOzl0EqdzxnI5QLI8jDbJJa9yMqlNUGfSseP4kbqwqCT+0h1snyCk0kfKM
         A994jeOYnuA06+sFBJ5C//wwZOGSlgX+y1tCYsx0VA6hAa13MAcQhwvYMn4m22pkmOj4
         9qVg==
X-Gm-Message-State: AOAM532nY+cklxep40SI8Rj4IgvPg1MiFNPTs/B8FpYWpDIp2FlU0AXK
        SbZjY1gxSc2OYObrtFis30+ma7exGDgAm6QA
X-Google-Smtp-Source: ABdhPJxiI9j5FRoQtQvAI6z7Gfwh4Lgh7yT8gQuAXWsa09Szs2fC6s+24u+rYKDLd31TxBdDDLBJXQ==
X-Received: by 2002:a17:90a:cc15:: with SMTP id b21mr24899787pju.153.1643637527830;
        Mon, 31 Jan 2022 05:58:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm18962928pfe.49.2022.01.31.05.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 05:58:47 -0800 (PST)
Message-ID: <61f7eb17.1c69fb81.7a4c2.0a47@mx.google.com>
Date:   Mon, 31 Jan 2022 05:58:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.227-47-g0366c2cb37a1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 120 runs,
 1 regressions (v4.19.227-47-g0366c2cb37a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 120 runs, 1 regressions (v4.19.227-47-g036=
6c2cb37a1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.227-47-g0366c2cb37a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.227-47-g0366c2cb37a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0366c2cb37a18c7aa1d928691b08252cc9e4de7e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f7b6df1070d8b1b9abbd3c

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27-47-g0366c2cb37a1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
27-47-g0366c2cb37a1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f7b6df1070d8b=
1b9abbd42
        new failure (last pass: v4.19.227)
        2 lines

    2022-01-31T10:15:44.195920  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-01-31T10:15:44.205130  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
