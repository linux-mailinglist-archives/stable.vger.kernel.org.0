Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4EA5B5E63
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiILQjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 12:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiILQjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 12:39:08 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0E93DF2A
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 09:39:05 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b23so9153403pfp.9
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=ODFIlOWgGebEAHEgj1Tq/aa4bqmiwkrqKl5p7Em1iQw=;
        b=Vay+w6oTcDAoAI6IIImJvOfxJ9WlZKpiusVivAXcAcwS4NDljj3BkNsYgorMGICqd4
         fuPrfBuUjV3+/U/zDufPrNtwWUx1L7Atr6e95caKiemoDeBtBdXAnLKy+Oq6kzJF0Un+
         iKF3mdwqUCcqnHaroFpyUTPcGUZfA5OrLI1+a9f+vi9mWWKr/Y4IsuaHjYmEPbkJcpy3
         9xFKo3EQ3+Yq5x7Y8uX099xhf6DcEG9l/KwHbu/His3HNhjdiE5N5y3DZqlTYYGil+xi
         P+6U86h5eDJ4J69hLDquQwM3DDoQpzmv1cYaBJI1ojMsB5Ir1zt7BfFSeVWWsXoCS9KY
         X2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=ODFIlOWgGebEAHEgj1Tq/aa4bqmiwkrqKl5p7Em1iQw=;
        b=x68aNwujGe4nyunxCMAvAAcP+KAqKYSCoJ/rRyA3vXnmtnf/02fSWi/fMwIMuAORuW
         a1LE7cbS5gmd9VFJ+x1VrBCIpw+pIu5ZZhX9ELoG38ujBpVixlZSjs2BprJMVJdm+xyY
         UnD9fuS3OMBL7P1+NypRlX+eYjRVZcZcngIJjrk4Ri+lpqmcwz8m4Lp8ObzOlNm0wbGT
         cMOKyNJE1YBA0wHoJyr06DJvffkNxvj6DURj+w/TdWPAuV0YL+pkjEFNw96aZ9pEd7Sv
         phw2KGnL7RNLulni1hY0Yd2uclLaX8NzD8zQ/T7ePTanB8Ot//sLuYO6gzRORzqcgzzg
         eAWw==
X-Gm-Message-State: ACgBeo0qRseLn+mruvZeVXupejy4kJauG54Y3fP72Vb9VzomiASa9mqV
        ajP+GZXLijrTuQOGAu/UWyF0Rk2xjJqvUt3KdDA=
X-Google-Smtp-Source: AA6agR4Dn1rz3yK73bFWXIxYkyhL4/pd2P8m1QA4/WNbqBsUNHE4fW2jcpTkxbjqyBF1kqhWzO8ydQ==
X-Received: by 2002:a65:6d86:0:b0:438:f775:b45d with SMTP id bc6-20020a656d86000000b00438f775b45dmr5593975pgb.291.1663000744532;
        Mon, 12 Sep 2022 09:39:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b00172d78876c7sm6320614plh.74.2022.09.12.09.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 09:39:03 -0700 (PDT)
Message-ID: <631f60a7.170a0220.21905.a6d7@mx.google.com>
Date:   Mon, 12 Sep 2022 09:39:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.257-78-gdb88b7709457b
Subject: stable-rc/queue/4.19 baseline: 110 runs,
 5 regressions (v4.19.257-78-gdb88b7709457b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 110 runs, 5 regressions (v4.19.257-78-gdb88b=
7709457b)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.257-78-gdb88b7709457b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.257-78-gdb88b7709457b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db88b7709457be77aaf3b55a1a4aeae6610e97ae =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f295efe4976738735567f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f295efe49767387355=
680
        failing since 146 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f299a4b53900a7e355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f299a4b53900a7e355=
643
        failing since 125 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f295ed3fc509cda355665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f295ed3fc509cda355=
666
        failing since 125 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f294bb7a49b835d355686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f294bb7a49b835d355=
687
        failing since 125 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/631f2986181df5519a355685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.257=
-78-gdb88b7709457b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f2986181df5519a355=
686
        failing since 125 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =20
