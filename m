Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957FE28AB11
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 01:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387791AbgJKXYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 19:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387740AbgJKXYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 19:24:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1C6C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 16:24:47 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o3so2463419pgr.11
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 16:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EZgZdK5gdqfHqlYTFTmJn43LnvRLIQzOpfc8Kx2U1rE=;
        b=R0Zve6UAX0l2lbSZvWXQM3bJ8WPy0vC92FN7oXxMHoRf0ZUyqafFhCQw+NS0cxZCO0
         f65U9mb9LLm61JqJll1grKxaLvwqFaLEjphB2+LHasUfwFDh02wkBFL4xMSUipdaFOvl
         +Ocuy8zmxvPS7NI76VfVXqfS2MqmDLGj7sEz+MqUWjgWZrBdcq5OBanJUFG83G2sLV1n
         hM86eEw7TzDmvzx669HoLrbs6grLxSXreiubXoToVPuuWwQYT0Y+y3zH3Cs1fxNBQe6E
         By8W9xzl8Wm2PpxnvZo+gnvu2R/LPjGwAMnG0zlYzlDLJ7QJ28xYN96krMXFWP1VYp0A
         i/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EZgZdK5gdqfHqlYTFTmJn43LnvRLIQzOpfc8Kx2U1rE=;
        b=dM7T0fH64oOa7qDQfu4f/g34z9S9SoKCGDiRuwz5bWZHgqvqJJiqzg7xd0wI5hzKC4
         d/icY665qxNlT3/ms1S/KeGhutSRGz+MEVNSnj1LC6yHU15+OboOT+0woFBmCRPjlvgU
         /yr0EPdO1TLZ8fQVMexC6P3Lo9Q884isZ29RxpmKGVCrVYC2yXvcadTLtJKfILhcv2w1
         lsBkYQYjhCrbtGQcNaBo64EVju8SHd/lhAfsDlfCh3LSXOrIc08o1bWfq5dBZ9NsXRiN
         OPYwDdMWWDHP+HPCYddn4MJE0285lcxMx1iRma9DuY9zEoW+Jbr9UaVoHxGmOIEY0Tda
         2yCw==
X-Gm-Message-State: AOAM5320CPXcNA/8JvEGivTyaoCVf+9i2gZ/SJEgVmVEIy56Xn8A51Sy
        LOimN/5EokWcL8hpv8BwmMzQeJISeyZF5w==
X-Google-Smtp-Source: ABdhPJw65F/tC30smwH6ERnsbgk6R+2nPdKS+R+jNA5JaK5bcJ/2Ak6HeCubXNnGPtNYi8tDRcBU8Q==
X-Received: by 2002:a17:90b:490:: with SMTP id bh16mr16315729pjb.214.1602458686419;
        Sun, 11 Oct 2020 16:24:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z190sm18471227pfc.89.2020.10.11.16.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 16:24:45 -0700 (PDT)
Message-ID: <5f83943d.1c69fb81.9351e.3356@mx.google.com>
Date:   Sun, 11 Oct 2020 16:24:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-40-g03fa1d36a96e
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 1 regressions (v4.9.238-40-g03fa1d36a96e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 1 regressions (v4.9.238-40-g03fa1d3=
6a96e)

Regressions Summary
-------------------

platform         | arch   | lab     | compiler | defconfig        | results
-----------------+--------+---------+----------+------------------+--------
qemu_x86_64-uefi | x86_64 | lab-cip | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-40-g03fa1d36a96e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-40-g03fa1d36a96e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      03fa1d36a96e6c8c039a5c9b6b880eb994775f0a =



Test Regressions
---------------- =



platform         | arch   | lab     | compiler | defconfig        | results
-----------------+--------+---------+----------+------------------+--------
qemu_x86_64-uefi | x86_64 | lab-cip | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f835a3d8c8968302c4ff3f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-4=
0-g03fa1d36a96e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-4=
0-g03fa1d36a96e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f835a3d8c8968302c4ff=
3f5
      new failure (last pass: v4.9.238-34-g9bc7672e9390)  =20
