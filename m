Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6524473164
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbhLMQPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbhLMQPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 11:15:33 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F207C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:15:32 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id d11so6329542pgl.1
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7Pa2XLViY4FBOcP+Thh8PfbYZoXGtH/TK/SbTBlSTQI=;
        b=dDS2SmwfHtWM9l2ly3kcz2QP+cqoDcuyPTbFEd97SKB0z/wRQhMCm6nKjcFM9hRG83
         6WHky659cOcN5V5YlwACOL0ilmhQjCLBBw0n32RurrBrjIZpgh2JNOjXhNwJQCu4wWHb
         BhHrMQsGnj+PffehdNibbxszVVY8GxYRu3isjqruL5WjKUjm3Z/sYVMNcaeqbTx3/eiV
         B5gicrB1rpNS+pr27vUP5uTQoTOcnrEu6uhyy+CpvqUB7bInK1WZGR09PmTVVvPF6KJ8
         MgnHwDGE3evLotpvJ+8dfOMGyt/z2NQCYFDkn7hqNki0GItgD4X32hWi3WJMaOXh/+tS
         QKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7Pa2XLViY4FBOcP+Thh8PfbYZoXGtH/TK/SbTBlSTQI=;
        b=7hcg5As+WCbzOQcfZkH+xWAtZLCZggjEScCKfuXjjCX0RyPjs4cWMFYthWLNvRqLD0
         CmpOenEjvCAuu4I6PxtBGnr7B4169xNFq0XyADQgPbSsXkIEt0Tom12kwSpOIxVWoNNX
         4ElEdzL/nZt4QT5cJVeNNeWOWEVEh9bzTFrklTEAI8q2+8hDzMxPdWJ0IeiqpdWei4Jr
         s6nJEwKqz090l9XO0pWVGhJlQBcxGf0UJcGmwsp1WOZy6T2MSfRVZ5JFZJ4PCgf1YljS
         Ksw6hQDGiMmt42qxFYTt7Y36ukKX1qkZXlukIhbduY0rAsxFjzrcnVyNitRgJl34EDTU
         G8iA==
X-Gm-Message-State: AOAM531IO8eK57DL4YQJhTVX43IHcAIGDb6gcxVSwBdPrzbyHuzUmejb
        9t+MxklbbYaKkFixq8LG80DUEynjvSrcpIzU
X-Google-Smtp-Source: ABdhPJzBXZbRcV+zHJmWVaGfKpKyPD8SZkOa06YziYlJk10Q4y59R+okUPyBu+HW7ayop+qNqJxcdw==
X-Received: by 2002:aa7:9207:0:b0:4a4:f59a:9df with SMTP id 7-20020aa79207000000b004a4f59a09dfmr33948645pfo.63.1639412131595;
        Mon, 13 Dec 2021 08:15:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t66sm12937413pfd.150.2021.12.13.08.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:15:31 -0800 (PST)
Message-ID: <61b771a3.1c69fb81.2e4e.470e@mx.google.com>
Date:   Mon, 13 Dec 2021 08:15:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292-43-gad074ba3bae9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 121 runs,
 2 regressions (v4.9.292-43-gad074ba3bae9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 121 runs, 2 regressions (v4.9.292-43-gad074=
ba3bae9)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig+arm64-chrome=
book | 1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig   =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.292-43-gad074ba3bae9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.292-43-gad074ba3bae9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad074ba3bae9f56fde437a2ef3ecc555430a6f16 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig+arm64-chrome=
book | 1          =


  Details:     https://kernelci.org/test/plan/id/61b73959b4e7ab958a39712f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.292=
-43-gad074ba3bae9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.292=
-43-gad074ba3bae9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b73959b4e7ab958a397=
130
        new failure (last pass: v4.9.292-29-gdefac0f99886) =

 =



platform        | arch  | lab           | compiler | defconfig             =
     | regressions
----------------+-------+---------------+----------+-----------------------=
-----+------------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig   =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61b7386ed36f95aaba39713a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.292=
-43-gad074ba3bae9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.292=
-43-gad074ba3bae9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b7386ed36f95a=
aba39713d
        new failure (last pass: v4.9.292-29-gdefac0f99886)
        2 lines

    2021-12-13T12:11:02.997499  [   20.124511] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-13T12:11:03.041654  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-12-13T12:11:03.051016  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
