Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E9527BEBF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 10:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgI2IDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 04:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgI2IDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 04:03:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156F4C061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:03:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id u24so3229021pgi.1
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mnjnu7kt9oGewaWIaow9fmjLUEjRmueBC14Spyl0JZk=;
        b=hB4NR2icJ+C5mHgBrpue33o05spTaW7k5LaKH5DpxhK7Ja86Xi4ijSByKb9DB0h1NF
         v2xpJbcjevxrke0EaTRz9kvClhDAs6Dykur6JHtk2zf17rSw3TwPvui9+sLhgNKsw+kz
         /cj3lSWpNi6XnCaeRpJE3zw5UGQ01QnLfpNyzSrUtxdEeTBN42TKx71a3DiynmTNy8VP
         AFNG8vFKkOdW5G3E2M5tQ+FkVSM169C18aIG3xnIvIOlMTPfCPKdZ9RowSqnQVkx7f3K
         4uj9YlzX4l30Vxi3MQHZSzP5tWbdNt3A0mNEIL17QSsmZ+2lFVpLLsdFNuUBnQlQ+/Ge
         utNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mnjnu7kt9oGewaWIaow9fmjLUEjRmueBC14Spyl0JZk=;
        b=KL6vUysIJFFgRlaLXm4lpq3dLZ9pWELu9hKcSlCbk/GWBsi8pzipkUBR/UN9anRAib
         8fA9rfxKfvXyiMpbr51GQkXhsGo6yLRD0pO1whk2XYx7kJrixRavLuws5EQxFZGrkBOW
         bw1haQCYBiSgLodb1Hhq9H9L98sHwBFQg5xkUlz7VZVsjbq4t5hPXEhgstkk7Xja+3/h
         TBNwvIdhzu1w7aK6UasmsBEgx6RwMXogv4urxEt8NNZKawemW1Bi5Y1H0Xp3bmfKYlY0
         wmUJcEToDOtu0YypDwOKSCg5/Xmd0NsEENW2xhTtUVsWdL/LVpUhLdrXYLU2cLI/25lr
         DbxQ==
X-Gm-Message-State: AOAM530NhdvAwzdxW+E70h3XRRjRUeL02UT+sAzyUWIXmDJhR4obWI2Q
        w6+c+0YIt0z+zvSuIjy6K7oAxvlSPg3kbw==
X-Google-Smtp-Source: ABdhPJxUfBN5elK8SjG7rhtXTdAU42/dELnCiBTx6Le/tlHaYHhpjCJLdAbA+4l38fSCc8PfEbB5VQ==
X-Received: by 2002:a63:191b:: with SMTP id z27mr1375320pgl.373.1601366630174;
        Tue, 29 Sep 2020 01:03:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o67sm3803207pgo.8.2020.09.29.01.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 01:03:49 -0700 (PDT)
Message-ID: <5f72ea65.1c69fb81.5be2c.7cc3@mx.google.com>
Date:   Tue, 29 Sep 2020 01:03:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.237-116-g25327539ab69
Subject: stable-rc/queue/4.9 baseline: 64 runs,
 1 regressions (v4.9.237-116-g25327539ab69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 64 runs, 1 regressions (v4.9.237-116-g2532753=
9ab69)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.237-116-g25327539ab69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.237-116-g25327539ab69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25327539ab69b7c74cf47ac0c1fa11a173a90e31 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f72b873e0bb6e9346bf9dba

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.237-1=
16-g25327539ab69/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.237-1=
16-g25327539ab69/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f72b873e0bb6e9=
346bf9dc1
      failing since 0 day (last pass: v4.9.237-13-g73039a4e470c, first fail=
: v4.9.237-117-g67e11f2ee7fa)
      2 lines

    2020-09-29 04:30:39.662000  pu: 0
    2020-09-29 04:30:39.668000  [   20.614013] usbcore: registered new inte=
rface driver smsc95xx
      =20
