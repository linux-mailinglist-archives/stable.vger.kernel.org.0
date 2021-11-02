Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC47443842
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 23:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhKBWNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 18:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhKBWNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 18:13:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB80C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 15:10:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o14so324386pfu.10
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 15:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4Pk4RDvoWMw+6lLZ5lorR0oksJAGqL6E314+oLbo9TM=;
        b=V4tzZ14u8sCa6l1Keu43pyuLbKdis7bv5Y7J2scLi/XNy/ppJ++eJRtU3ZwSqRgH3P
         hl/zrV/6iYOUQlb/MXqelY8VN4V/KqzQsSQK0IEBSTKKzB/OBrjc0v63QK4ShQkvXJE9
         oOvh0EfwI+Xb08gHkHbzWRleNAkoZq3y7yE65C9NI0jB9l1DoJ/ooPFO1fulNA/yhbtR
         dS7TmicgjB5YzI+OuWizyqJMiRj0QbExetcYgUc2+NqP+xT6f2FwaMJwFHuUx3rjdpj7
         OGnK6F5ka3v/w7g1qsGE8Ivtdx9jg6VU5QcW4Iqt8p28dgm07MC2J/mf8nwqeo2nBx24
         PxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4Pk4RDvoWMw+6lLZ5lorR0oksJAGqL6E314+oLbo9TM=;
        b=fVb+1PpHkdF+5ThByCYytJGDwfJg2XR38GLeV8c6BI0X+AukUjuthOy70nn8F7Oj5S
         iXHixiSZ17E8Y7Qx9oQBaoePOODtzgeGc8c2AQm4KUt+q4hX+RHvJS+DuyvlB6F7jh5f
         PbRpxr/baADLWMqt7c/RSLq5E9G4Xt3L+uwkRnsPhitm7z7T6//Z0+x+VkgVqZXMp/Pt
         AOVjk8+eBZwOdT/eEhd2YRc6CBakbbVG4UclLpo17ij3sPHU6bht7qe78lAjlzaK02kJ
         j/UN5dg1pouQMCBJSzgS1XCa8Z0EGlAXcbure7+g0i50GCyKqSPY7DIpCikRFiVjwgs8
         RRFg==
X-Gm-Message-State: AOAM532fXf3gHJooXzXLPw796UPcbw85F/Fj/GWKmOT7ZfH6JHBCZAsD
        hO49A/krfcBOYlDQGCy7c+HXk5Xq0/ZkcwqH
X-Google-Smtp-Source: ABdhPJzPVj0sOxyUqj7DgZdriWjN4vdtV29CGHMlb7f8lPoQAfEQdrN46agRFB4BCZ2Nf0EMhZJ7nw==
X-Received: by 2002:a63:7f0f:: with SMTP id a15mr30140466pgd.9.1635891045687;
        Tue, 02 Nov 2021 15:10:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mv22sm80276pjb.36.2021.11.02.15.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 15:10:45 -0700 (PDT)
Message-ID: <6181b765.1c69fb81.72e92.0739@mx.google.com>
Date:   Tue, 02 Nov 2021 15:10:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.291
X-Kernelci-Report-Type: test
Subject: stable/linux-4.4.y baseline: 72 runs, 1 regressions (v4.4.291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 72 runs, 1 regressions (v4.4.291)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.291/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.291
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e0018f4c9325b36ae75a591d54879bf9a9f41a26 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61817d1c29a435b95e3358e9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.291/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.291/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61817d1c29a435b=
95e3358ec
        new failure (last pass: v4.4.290)
        2 lines

    2021-11-02T18:01:44.673154  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-11-02T18:01:44.682189  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
