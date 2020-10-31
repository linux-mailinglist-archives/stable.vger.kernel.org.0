Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27C72A193F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 19:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgJaSNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 14:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgJaSNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 14:13:12 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7465EC0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 11:13:12 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 1so4629942ple.2
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 11:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EQXdzdZKjNO3+NsaaAJj/if9H4Yx4B0SEwUYdokwiKE=;
        b=czAg8IUR9Ka8vLqdzEGuntHBVnYyC9vcIFzpoAYjgRfIPEvb1dgXByEzobKM5xb5CZ
         yA43YCia6rGona7AC0TCIdmf8nbACw8cb7CfWlnKk/eAw3sWSebg0jCQR6YmKLN4+z/T
         67HeAkLRK5fwjse6VEoJN+ucpdSrwoP6NrrSqePr2detBxvlAvc88zIknvd0t05LToMA
         OzA+gxyZiyNhNXEUQwfrgUBXuLJwdke0lXLXjpTHXQjM33egvhZRYhAoOqHQjRDV575A
         QsK8BFOaDhzYOYZH0CahXKiGt65JsoSWkMZvZ/w8ulRFGwTqjGnDhy/UWMcSfK3qVx/0
         LvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EQXdzdZKjNO3+NsaaAJj/if9H4Yx4B0SEwUYdokwiKE=;
        b=Dlj7RNiPqJ+CIoAnePsvy/9KjuYTGj4P8AmA52GLgaHpMkkWo0qA/KW3wSBYlGUKOn
         OHhoLulRvDQNtdeb5PIR9t92jkKD32SM4B7duhio5aqCzfGJYP4El/Vf9+vHH99iTmHb
         U53krDhl6MXtNrwaHUwZkZWHr/tztAG3fnE4UD35H8RDyb0LAbqUFNPS8BoJnJEaR1hV
         ON0Mng5p+vNqw23bGU+NDuPCA5gpwd4TzDtuLKQgN1aHjS1XP/GROZYmTgqlWnVz9B/o
         HkdWXH/czd5Q7+eUm9ek+EWXzJAQyIQkDmHEbjEtwfW/G3muGfJQENDE2dOaMRXkwiyz
         uuhw==
X-Gm-Message-State: AOAM531BTiFmjqGOmM97Gs/kqirATY6TRi9ZeFzr30xAsPw/y/BbHWUK
        n2c6vVbcRFAI6U7HJ1bEj8ZDfzu9Rw6/hw==
X-Google-Smtp-Source: ABdhPJyEgENUDbrd1ZdX+WOM7pB8hUfwaOzek8CCvPjtVgU1SDtnk64gqxd2njGNUoZjAYQFe5/tsQ==
X-Received: by 2002:a17:90a:e50e:: with SMTP id t14mr9371760pjy.118.1604167991510;
        Sat, 31 Oct 2020 11:13:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm6926476pjl.11.2020.10.31.11.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:13:10 -0700 (PDT)
Message-ID: <5f9da936.1c69fb81.81fb5.0e74@mx.google.com>
Date:   Sat, 31 Oct 2020 11:13:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-8-gd71fd6297abd
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 113 runs,
 2 regressions (v4.4.241-8-gd71fd6297abd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 113 runs, 2 regressions (v4.4.241-8-gd71fd629=
7abd)

Regressions Summary
-------------------

platform       | arch   | lab          | compiler | defconfig        | regr=
essions
---------------+--------+--------------+----------+------------------+-----=
-------
qemu_i386-uefi | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1   =
       =

qemu_x86_64    | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-8-gd71fd6297abd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-8-gd71fd6297abd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d71fd6297abd8cc2f7d42ccdd7810f5db6081e0a =



Test Regressions
---------------- =



platform       | arch   | lab          | compiler | defconfig        | regr=
essions
---------------+--------+--------------+----------+------------------+-----=
-------
qemu_i386-uefi | i386   | lab-baylibre | gcc-8    | i386_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5f9d76bcab51f548643fe7ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
-gd71fd6297abd/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
-gd71fd6297abd/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d76bcab51f548643fe=
7eb
        new failure (last pass: v4.4.241-8-g9b3912274eb0) =

 =



platform       | arch   | lab          | compiler | defconfig        | regr=
essions
---------------+--------+--------------+----------+------------------+-----=
-------
qemu_x86_64    | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5f9d762ae701e7c9ed3fe7f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
-gd71fd6297abd/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-8=
-gd71fd6297abd/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d762ae701e7c9ed3fe=
7f2
        new failure (last pass: v4.4.241-8-g9b3912274eb0) =

 =20
