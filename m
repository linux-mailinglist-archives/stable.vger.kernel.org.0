Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416B6487F2C
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 00:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiAGXAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 18:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiAGXAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 18:00:46 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3C6C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 15:00:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t32so6824755pgm.7
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 15:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ekgfw/EXYm3GJBzXcPPdUykDM5scm80m7jkG4MJxdCM=;
        b=XJKF+GU52ePKNyfz2q30tI4jsGeOY1CkugsyzL/HyoLvU1P1cEE3xLmXmmvBFSXZ1E
         RtP7kya0seppFlByMHj28steOEOLKFjV2Uvm+6vchIAxWnK1pply96s7zjyib9t3shlA
         vbEEatosIiYhwvEQ/OmzdfPhyHbi/RgSd4FDxxNXPfqnCwiZ2KdH+jfGQymJYrLefdBe
         VYrBwImGSOqiC7Wrwg0NmyyR/K/XOphfI6yzVQ0eDqI9NqhhzYdgT+qoVYSXAUS1NSQU
         wZVARDhjDmWMZ2xGbSRoUPJSXBaS72QXJBylV1VZ7jPHcmZrQxJNKKMb0ccJHUp7xf7o
         cWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ekgfw/EXYm3GJBzXcPPdUykDM5scm80m7jkG4MJxdCM=;
        b=dwdimDFg3VbkfEqVI8xHY+3S4pbnbtPGekt761c5mkFMFQmPEkmAC5YQFJEWu4CdQr
         NzOApXZxS0pbr3opRC4IiKk6WtUEy09+t2TXWADsfhloxrwvV3pzOABQaX2i67M53KfZ
         cswUMXMeyPkEDXjFs3mZPwGp5HjJ5vKrBYIlIu+kLRlJwIGVIax+fDRdulupTxG8uLA2
         mWeom3l3T2mulm4H8e8NwRZwJfidoLyVoxVRKVoqF+5h11cJyciehw8nVJMm4yFo9ooZ
         5HzSKKw+k3UiDvkO1NB9eHh+yMc3JfGAi9oaJvzyNHSGLIn6FbgLnRuQThcL7u17Fwxx
         pA7Q==
X-Gm-Message-State: AOAM530bOmD7G1d+kyb2gMFdNdVj8lk6O4B57yX+8E8o39dJhJVTjSYF
        uvX4sbAVP8BN0zcUXMEzgaLndehmDr75FWG/
X-Google-Smtp-Source: ABdhPJxm4v6jgOW8WjFeht6sLuCex6/a9/k8ZC/1ebJ3wgvgwQA0hUJREusRJ3jDedUeal3cjK5ioQ==
X-Received: by 2002:a05:6a00:234e:b0:4ae:2e0d:cc68 with SMTP id j14-20020a056a00234e00b004ae2e0dcc68mr66773911pfj.60.1641596445818;
        Fri, 07 Jan 2022 15:00:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm9413pfu.13.2022.01.07.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 15:00:45 -0800 (PST)
Message-ID: <61d8c61d.1c69fb81.1c3fc.00b8@mx.google.com>
Date:   Fri, 07 Jan 2022 15:00:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-8-g4d5dfa912980
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 135 runs,
 1 regressions (v4.9.296-8-g4d5dfa912980)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 135 runs, 1 regressions (v4.9.296-8-g4d5dfa91=
2980)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.296-8-g4d5dfa912980/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.296-8-g4d5dfa912980
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d5dfa9129801b931a3fc8b1bfa7cf1fd88a56eb =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d8957981ed496244ef674d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-8=
-g4d5dfa912980/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.296-8=
-g4d5dfa912980/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8957981ed496244ef6=
74e
        failing since 0 day (last pass: v4.9.296-1-gdae9eb7a8688, first fai=
l: v4.9.296-5-g7203781ae31d) =

 =20
