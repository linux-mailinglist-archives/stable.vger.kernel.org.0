Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F372AC2EC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKIR4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729533AbgKIR4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 12:56:16 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45751C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 09:56:15 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w14so6243815pfd.7
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 09:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZOS+zogJ0H7n4Eok6jLW7rx+e7LepvrL/VFawtv6Svk=;
        b=ZPYbwviGRvgETJi1LdLV0+tV4Yes2VPdOJKr85XB3JB2VVroH46gGWa7alOeCJll1z
         3y7FdOVo5e+ByyXymSdUMelmBFgOu25FBibwuaO8mRgv+cPGZ2wsbTentHG+UU+xLQQf
         QVxUZ7OceVXvPGZovcRkY6KsuEfG/C2q6E+p1IQO0fiKhErMOSUA1Ua9aGEldj1mcIMi
         Io4iSc81vcT7URfGPpguFSreasDHGI/hcJFPH77SxZ4XZDMMnK0fqKQc1zNB4DS+5qON
         32sDBvKso29HjP4hmmmtwH3mWYf/Txq3YgUrsQ/vJbYYBoZQ6ZTfbHfZjI8sSyhWmZCk
         Ciow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZOS+zogJ0H7n4Eok6jLW7rx+e7LepvrL/VFawtv6Svk=;
        b=eIMHUuujFb9sc8Yg8CwlPMh/BvX/GdKLmMvggwLIgPXBpy/E4M6+FC7N9wcQU3AzbG
         dNdbCc+kCGkfQDm0DZYTG/6jR0Y4twLsQbL1+tOz7NewwYk2R4ZoyFfOwxIVsM6E73p5
         fNlORnBb9K7fwKXmXXcvwWC3DBVF/I8AZQT0Dx7Rvd3uq7QcfE8Jt2dq30BMQreX0Bs7
         6TilOQrjWKqvZ0F7rMG/39fDkl0kHYonzH4plaUrEOHtXv5rWqVbdBUI3gNsemmSvhWm
         mpEll9+0WVzdrw1Aq7uir0lqItHzlF6CM/tW1dwgnnSDsNTk22+t2JK8rs6K5axvo7Yt
         oW3w==
X-Gm-Message-State: AOAM532TMP9iIo7nxn/GnXbleY3XTd+g2H1CZLU4ICNJXfWmwhI+4VGO
        hM73+BEGwNTMt21fDQM/466n+6FfWfqbVQ==
X-Google-Smtp-Source: ABdhPJw2AMhh+fHgEAPw/oXaevkBPBHeNYUKwyXbMnSxJWb0G7tfJJlEt/QL4tUBEn+s3n6LSsft5w==
X-Received: by 2002:a17:90a:4dc8:: with SMTP id r8mr330564pjl.1.1604944574416;
        Mon, 09 Nov 2020 09:56:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h16sm136641pjz.10.2020.11.09.09.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 09:56:13 -0800 (PST)
Message-ID: <5fa982bd.1c69fb81.b7074.0657@mx.google.com>
Date:   Mon, 09 Nov 2020 09:56:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-117-g27cd0d331274
Subject: stable-rc/queue/4.9 baseline: 144 runs,
 1 regressions (v4.9.241-117-g27cd0d331274)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 144 runs, 1 regressions (v4.9.241-117-g27cd0d=
331274)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-117-g27cd0d331274/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-117-g27cd0d331274
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      27cd0d3312745bf513e0980377fef00f315b35a9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa94f283ab0ece32ddb887f

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
17-g27cd0d331274/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
17-g27cd0d331274/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa94f283ab0ece=
32ddb8884
        failing since 0 day (last pass: v4.9.241-98-gbb5ddb48abfd8, first f=
ail: v4.9.241-101-ge8d0a6534ab3)
        2 lines =

 =20
