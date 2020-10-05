Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618FD284228
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 23:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgJEVf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 17:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJEVf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 17:35:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E713CC0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 14:35:25 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t14so6788728pgl.10
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 14:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3f6bZXWOikhW2GPNAonTPuDKOGIjBVxdZAnGBWxe3Nk=;
        b=C28o+fxEduNM33wcS0N9+yIjxfddkENDEYKTcpOqxJjQknyiFN1dZaRdFWCz7sK7Wx
         /78tZQUqrRJMesw0BIwf0UcC05sa8dvDf1QeGEh3YOwFKb2Hp3QLpazaxjoIuZyK+/t6
         4umIZcBA0ZcK1hw+cxwogGNDhj4aOUrtHghcyL0Iu9VIvoWcWcel9YqC5IV62vYvT0iT
         X4sjlj7aYuqZkbVNK31kptaRX7AAxWHqzvpFQj5zBNSpKVnOYYxCXBWTSLBYFohJnh7u
         zywVvUEiLMVIPEMC4R7kJGxjYtkI+BTHJa4K0PpCU5P2TvKdLyOL6kOV7xZmQ7FDondq
         k49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3f6bZXWOikhW2GPNAonTPuDKOGIjBVxdZAnGBWxe3Nk=;
        b=B8o+ZoKz4V0u95ec7H6hjUxVaEm/HRfZ95x6mqDuB/nZ2yogN3fR9hnAtF5gdl7LDr
         8wLJcfO3gCw2B8vq07IWshzC3YbuaJpUvNtZv+Q/giWseFqmrenb1bku4t1pP1KpqLyh
         BvFFapZtgK46zJk2Hos/99LFOihzh58uTs12iL51LPTR7j1ozDm4IbJBx9icqzcbgFBF
         lnf5Et7KVX7AV0S9WqkyoBx62pkamOKiJJN3mj3dyaKYygdNCG2fwR5skOUOMKciUrfh
         FK4cJfvhvmh8fijANtFWx/687mTgHz1YuuuXRaSML8ls+hzZ+qidt4i1vVnF+hUxKZBQ
         I4+A==
X-Gm-Message-State: AOAM533PWv4/J7Ttx4KpK2KxeCey5aiRHfKBGWDt5OI2k58mozCwmwDH
        YgBiAPpFHWZTUPPuMEkbgtOmnFzp3pO/yg==
X-Google-Smtp-Source: ABdhPJzgFLnSdCUKeCjuYEbVnnEYOd72tsaBm6Cyr9mijcvzKw5QIQWtrvMVQy5WSt4x+lXe0nNHUA==
X-Received: by 2002:a62:7992:0:b029:152:76ec:38c2 with SMTP id u140-20020a6279920000b029015276ec38c2mr1650250pfc.70.1601933724897;
        Mon, 05 Oct 2020 14:35:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c131sm928516pfc.46.2020.10.05.14.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 14:35:23 -0700 (PDT)
Message-ID: <5f7b919b.1c69fb81.d4df.24de@mx.google.com>
Date:   Mon, 05 Oct 2020 14:35:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-85-gda2b43ea1667
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 115 runs,
 1 regressions (v5.8.13-85-gda2b43ea1667)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 115 runs, 1 regressions (v5.8.13-85-gda2b43ea=
1667)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.13-85-gda2b43ea1667/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.13-85-gda2b43ea1667
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da2b43ea16670102fa5e664b6258281dd1b57d2f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7b556ec31a6758ec4ff3e1

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-85=
-gda2b43ea1667/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.13-85=
-gda2b43ea1667/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7b556ec31a6758=
ec4ff3e5
      failing since 1 day (last pass: v5.8.12-99-g7910fecf197e, first fail:=
 v5.8.13-3-g58c57ca2b2dd)
      1 lines

    2020-10-05 17:16:32.952000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-05 17:16:32.952000  (user:khilman) is already connected
    2020-10-05 17:16:48.693000  =00
    2020-10-05 17:16:48.693000  =

    2020-10-05 17:16:48.694000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-05 17:16:48.694000  =

    2020-10-05 17:16:48.694000  DRAM:  948 MiB
    2020-10-05 17:16:48.709000  RPI 3 Model B (0xa02082)
    2020-10-05 17:16:48.796000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-05 17:16:48.828000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
