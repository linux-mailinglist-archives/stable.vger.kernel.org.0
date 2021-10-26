Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A587943A96D
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 02:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhJZAvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 20:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbhJZAvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 20:51:10 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D8C061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:48:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w16so457679plg.3
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z17gVdBi4l+0MuAEfodhICTq6HMf071EV0QYyRrE4wo=;
        b=7bxdQgmOl8bHbBr7se0Hp/qR2jwL7i+tHpH5GpaxgYRHxQoPRdZv+PyMQd/bb/kqqZ
         YD8capXK0tlbaBmkvPy0wau6rzduNO4lOWrie7C2i7qW/lKeDUhW3XAZVDRUK/5MlNat
         nTxvu4ut7lBPLFOloDH7J7ojlJ6K8b84c+VAcLe2RelXKyxNG2GD0g0OPt4IFePDXcEK
         NzBbS4bb0C5obh4Ek3SDMrfU57PPOSc0JHJNbR7Ua+Rf4FZ+8/GWOPJYjPjWIC6g3gjl
         gfsKEoV5nhZe9ZPhWAyYEGR1nM9q+jY/cpGiN3w+58Af7Cq05IDpXsQ5wNjZzQ9N1hBc
         TRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z17gVdBi4l+0MuAEfodhICTq6HMf071EV0QYyRrE4wo=;
        b=c58fvhaclvJTL9rmFY9CTdRxm00WasswSmPDqYnZOJlGJv/kpjmN0VorrLl8poRxnu
         YJVRDixrmi3yM65KpstWtjFlrRz/8FteiypPHf/XAbSafjtElOElgn6thFGZXUGsegQO
         MdXubuep/8L6ifXxMVp+iQWYTyyd3SgvircUeULThplsjwrTRmznt1EOWQH7o8rmyWhj
         9KFRrUBZtue8hkKrEC7sbxULgmiy51CkqsveKoe/RffTvF43/OlL7nZEVn0H+aMY+Ffv
         WhQplhtN/BsPdDbFWMa5rXj+7Xr5aMI4JsZPX7VvvwqmxEV/+V2nfRey5DaMdtNeXhK6
         PUlw==
X-Gm-Message-State: AOAM532U/vEEdvwz7MCKl2mhB56cdtLAZ+iEl2OTytHRwLQhcO3xfm5V
        tNWcJ3QgpgjnNwJsG6MtJlNExXJBPJOCMQ==
X-Google-Smtp-Source: ABdhPJxk60a7ze8/KyZXdVIvB2x8v4dyA6VC7nlTD0rdY/Eft5ih63jVyTHfiInKEejLUYY/hSE08g==
X-Received: by 2002:a17:90b:17d2:: with SMTP id me18mr39306946pjb.132.1635209326940;
        Mon, 25 Oct 2021 17:48:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h2sm18503564pjk.44.2021.10.25.17.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 17:48:46 -0700 (PDT)
Message-ID: <6177506e.1c69fb81.9d5d6.1dbc@mx.google.com>
Date:   Mon, 25 Oct 2021 17:48:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.289-44-gd66b26fa6591
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 84 runs,
 1 regressions (v4.4.289-44-gd66b26fa6591)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 84 runs, 1 regressions (v4.4.289-44-gd66b26fa=
6591)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.289-44-gd66b26fa6591/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.289-44-gd66b26fa6591
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d66b26fa65910e03bfc0d2261105f8806dfe5b05 =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61773b76f3badd86bd3358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-4=
4-gd66b26fa6591/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.289-4=
4-gd66b26fa6591/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61773b76f3badd86bd335=
8fa
        new failure (last pass: v4.4.289-43-gff0ea1532ac8) =

 =20
