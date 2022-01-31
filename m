Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40704A4A95
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379587AbiAaPb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379645AbiAaPbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:31:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D20C061748
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 07:31:40 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id qe6-20020a17090b4f8600b001b7aaad65b9so8047274pjb.2
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 07:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PAXrKLUU7Jh3/JdjUCSBBDC+9QcLSjQvEZbNrdAKHBs=;
        b=2FBMV+oQk38xQkEF7hwYJ/ru5h2TnHtkoBTs3uY2zyebxHhKLfYj/KqgG4vBdkjZXR
         uTTu3my23hpZVZPc8+HQ7FxcwlcZZnK1pXBLYjF1fl+nLXnH7sJc2HsnYA8go0zA6VgG
         +WJFLy+FxCsma8NTbhhwqZBFNjaiU9Q7mHV2IGFk+544RDX4ByYE8ueeVPcghVwEF1fI
         lm0AA8WTKC9ARyiv27LB4A99Qyon6IMMbkTXnDo0nUn5MS1s5Nf7flXePvJmbt22yLJ2
         UNgnREfJhNQrTSqg1fzrcsOLFY+a5aUTho0fYYE5N9+Ilj6zhTmacx41MDdwr+e3v2kZ
         OYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PAXrKLUU7Jh3/JdjUCSBBDC+9QcLSjQvEZbNrdAKHBs=;
        b=E09wtSUEueQ/6SklQI4m8V+tmPs8Iiy4L8dFCJjZYM7DLanIfUi1Cai25zf9jkmEIi
         Y+KFKxP6p+5bIcKDlFjpF++Cv64b2LyiqU19fr9C+x8l7bTj7W40o3fiphbnm3s671If
         XLws4eIimiwkSuNJNLFfEZqiC+tvChtMEmo32sQ5aZS3CkLv03L2zEf/Tz5T7SbJjKar
         h1rNRbHmHI7yIxJHihHbD81+aTL0UDykKFpjbJJjNuMlA5SuNh6wYY3pSfDb1y2w8YK0
         P8kGg/pF7CJkK2kkDyu0PGr6b/EIJbuMII7SaJOoSgoqTNDGIZB85T9KQ+uj75FS4wMa
         yhhA==
X-Gm-Message-State: AOAM533yHiQfJWQSlrCH1dTyvjZKUJyCf5WwiCpn2vd2xps3vfsDLa1S
        mPl57mk5GJHD1J7XL52jLtpp+kRh1hSnxddD
X-Google-Smtp-Source: ABdhPJxdZ97JDpuHD6FfBS4bBqWA6Wd4M9xeZuhCH18fAnYkSUXOuuZnG95/zH8gaztJBiW1YK9WIA==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr25289169pjq.68.1643643099539;
        Mon, 31 Jan 2022 07:31:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mp22sm11571869pjb.28.2022.01.31.07.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:31:39 -0800 (PST)
Message-ID: <61f800db.1c69fb81.29b52.d99c@mx.google.com>
Date:   Mon, 31 Jan 2022 07:31:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.301-23-g9b80ba4cf655
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 88 runs,
 2 regressions (v4.4.301-23-g9b80ba4cf655)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 88 runs, 2 regressions (v4.4.301-23-g9b80ba=
4cf655)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.301-23-g9b80ba4cf655/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.301-23-g9b80ba4cf655
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b80ba4cf65526fb3356a5e3e7d02aa83f223637 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/61f7c64724cce399e8abbd24

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-23-g9b80ba4cf655/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-23-g9b80ba4cf655/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f7c64724cce39=
9e8abbd2a
        new failure (last pass: v4.4.301)
        2 lines

    2022-01-31T11:21:35.970335  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-01-31T11:21:35.979575  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61f7c63c5f2b5884a8abbd22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-23-g9b80ba4cf655/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.301=
-23-g9b80ba4cf655/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/bas=
eline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f7c63c5f2b5884a8abb=
d23
        new failure (last pass: v4.4.301) =

 =20
