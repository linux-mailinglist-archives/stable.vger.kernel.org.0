Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8527F49E9A4
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbiA0SHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239087AbiA0SHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:07:47 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC4FC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 10:07:46 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e28so3346431pfj.5
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 10:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VG5t2tvzJgCgpUriO0CdKVQXpHwFerG8jNG4TIQSHGs=;
        b=7z3mVNBIrC9la/33H+9MMVMhrwDNofx/KAs+jhAOlsdkVU/Kz20gVOPnsa75WVzlit
         a3lsNdQiNHWgT+v2OOiehevtboKTofrZMSfAmpxg4H6id9O9j9XQf23Evo5ecCA13MsN
         DOuCTslvuz3w1yEr2rL7ormTlS8shtwexkI2rCQxhkBEzDLqJiXjaFU/GEt2mX13qT8z
         KhzyjAFijB6WXdow8WwtMsWMLovnernc2EijqCLm9e8l6rIYQukztZfS9g3Q1LQjLwY2
         XMtA9QTXWMbgEMbG6ZBbCe2SMw6oDa4toqqpi1r3VjrVqDqyL7kmEOwqXtr+Qu5HAWVH
         h+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VG5t2tvzJgCgpUriO0CdKVQXpHwFerG8jNG4TIQSHGs=;
        b=F1s9f5RvUuY4RwM1YyNO0yMSTzK7HS5RCobpW7eAAk++E/gh9hs3h9Rcxm/zp2Uk5P
         VeIw9SwA6e25TPk3cq0Q/27sGV5EyE2SYMut34pB5GjfZZgqCKXi2P0RIeDmr0/TYw+o
         OMENrZZSaxNZOs2jSXuzTO+U4WHtFWt9P5o/E+CWnDMcIH4h9X+G0QLqEhdrvaD0k0ef
         alyw8C10TnsDC32PNrs9QPbU5pBTIddbJ2EruRy18GVvV27ng7pBeG954zUP6iirtDsz
         QmIsatfZFdy4yRC2piNvhOWPF3IpmRieb2l0A0IcSt+FnFA55iNbkraAWYNvamzmnZfZ
         IY0w==
X-Gm-Message-State: AOAM53166vZjBnYsvJTAmV9gmDREPtn1ffmn9+/uM8rH7zoHHga4Oj8V
        JwVbSYOLuVoST+DjoGoo4W++SBHB0DZo3NjMVd8=
X-Google-Smtp-Source: ABdhPJz3W6ZVR5GFx4ebAvQ6NPO03CcmQ0DXqqQxC9Wl95QGXVe+Q3RFnDiDzjwG/nwovczbX0ghLA==
X-Received: by 2002:a63:6985:: with SMTP id e127mr3587167pgc.264.1643306866377;
        Thu, 27 Jan 2022 10:07:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm6428138pfu.72.2022.01.27.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 10:07:46 -0800 (PST)
Message-ID: <61f2df72.1c69fb81.2e5f0.157a@mx.google.com>
Date:   Thu, 27 Jan 2022 10:07:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.94
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 170 runs, 1 regressions (v5.10.94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 170 runs, 1 regressions (v5.10.94)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.94/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c525532e4f872078206789f5bcd12bba7f689780 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61f2a650a58b278b92abbd33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.94/a=
rm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.94/a=
rm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2a650a58b278b92abb=
d34
        new failure (last pass: v5.10.93) =

 =20
