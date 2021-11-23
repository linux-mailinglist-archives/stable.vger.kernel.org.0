Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1571D45AD2E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 21:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhKWUWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 15:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbhKWUWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 15:22:33 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61939C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 12:19:25 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r5so118529pgi.6
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 12:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ozs6Q2LjKmqcUzc4UzXhfTQOlOFKn3Jd+B9QwF1sDEU=;
        b=QfAg8Fdgs+9VEcdB2eQGZHUOaRkxgOA7Ze+WfIxwPvJXC/19T84cQFgtwIluxahHhH
         RDUHGEUNLPQn+6R3r6l+pMhV+KNxllEYX7L690lKrcSsIcgV9NjM9Zl/YFU27MR8Q199
         eSis1NEcyKh+RivqR9uixHJy/5XLkAy3+PSplSXtGbh2sL8XKsQe8AN7GAkQcWJQJ1Cr
         St5TLDhhRi3cDCeWVK90RGTHnm4tx3MY9u1ShgT21jtlscnfk3ceP4+cRP8pkPbVZIoT
         2F4ydMnQnBO6goeTX7ltlFUeiagjJ9O+wuVlkWVM7ONRhpx7sAmYVcAEnOMIOsxxM9Gi
         3GaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ozs6Q2LjKmqcUzc4UzXhfTQOlOFKn3Jd+B9QwF1sDEU=;
        b=wfRuJxNLMcPnnlnE8rkfz8/yplIzKX0YY3NGlIqRGWBLQCI4mIIu8JSn2OnIZ6N36/
         SZg5NX3lpdWKY+SgpgWzKZzRrTBxkPzky5ewTla+qcSg9u6jYMgRmVGmQbalHchJjsKr
         4L4LZxPo4EDpbFW0yfIxH2hU2VRMSMnC9SCxTanhOFi+gp+4Zo44P5i0vRCTndvqFL7E
         73wXQff6mKlzSFh4Xa/z8csvU1rblXSaJ9lWdCjekKNHhQ5C9lpXZOqGNpbnzvlD/h0+
         nDbdxNp3gZw8LXD5NF2VYREn0HtsFZmOEBzKWq9lSql+5LvzbNA+w6oOjqb3sxXroqCU
         +WKw==
X-Gm-Message-State: AOAM531h5wi8VwMDB8q9XoYc0JZmYjhRixNZuGSaMymEUhB5P7iUgxda
        2gdnXhr6thQ7G0XAhh79sPz2cWYp4fhKWnXO
X-Google-Smtp-Source: ABdhPJyxLvXr0bpqKMm4XfbZqUZO2orjKPLfsJXtfni69CsiX/ZDOwvPWnRe0NGMQn8fLUcW/6o8ZQ==
X-Received: by 2002:a05:6a00:16c7:b0:4a5:d9c1:89da with SMTP id l7-20020a056a0016c700b004a5d9c189damr167233pfc.34.1637698764810;
        Tue, 23 Nov 2021 12:19:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gc22sm1816791pjb.57.2021.11.23.12.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:19:24 -0800 (PST)
Message-ID: <619d4ccc.1c69fb81.8e432.44cc@mx.google.com>
Date:   Tue, 23 Nov 2021 12:19:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.4-257-gdb939df2ad534
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 162 runs,
 2 regressions (v5.15.4-257-gdb939df2ad534)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 162 runs, 2 regressions (v5.15.4-257-gdb93=
9df2ad534)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig          | regres=
sions
------------+------+---------------+----------+--------------------+-------=
-----
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig     | 1     =
     =

odroid-xu3  | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.4-257-gdb939df2ad534/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.4-257-gdb939df2ad534
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db939df2ad534a836750c0261bd0c8c8d84691f2 =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig          | regres=
sions
------------+------+---------------+----------+--------------------+-------=
-----
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig     | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/619d1367734dc67364f2efcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
-257-gdb939df2ad534/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex=
-qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
-257-gdb939df2ad534/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex=
-qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d1367734dc67364f2e=
fcc
        new failure (last pass: v5.15.2-121-g0299785967d3) =

 =



platform    | arch | lab           | compiler | defconfig          | regres=
sions
------------+------+---------------+----------+--------------------+-------=
-----
odroid-xu3  | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/619d32a90e0ddc75a9f2f03a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
-257-gdb939df2ad534/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
-257-gdb939df2ad534/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d32a90e0ddc75a9f2f=
03b
        new failure (last pass: v5.15.4) =

 =20
