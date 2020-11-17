Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31EB2B5A78
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 08:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgKQHoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 02:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgKQHoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 02:44:21 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDF2C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 23:44:21 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id i13so15589496pgm.9
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 23:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ibufVINebxG/WvdlvSEbopoLyn9JciWAoqVh9ZhbfbI=;
        b=hyAzrxL3hVqfdNhFrZ1PGY5F8OvCp+CiW8O8L6i4I3daALi9q2OkEjYdS8qUSVJLi8
         hGxwN8vhLp7fIQPwInqwNiToMmm//YFD1zG2V71tqQB/SVnyPYw1t6gEuhorAhHKIs/Y
         AewbnMhJm18UYR2N0/SCJFBjW5G099z4lj1JaFsbrmcLNPDQ9ZsD6Rk8nxtpEqMTDO1A
         sM+q40p8aAub1SC+UoNclskoucvIgKl2DQ/7/1kIxuoeKHiqAbcYNI0iVy5BzGIkIlw3
         l49e9xbzTf+rujGVeVQz30XTRYRY73sqAtBOdIprOj345/WGNr2jCjlC1M895mYPB7a6
         o9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ibufVINebxG/WvdlvSEbopoLyn9JciWAoqVh9ZhbfbI=;
        b=YWiMTPOh144fPsmR9kZ2ZQvENGkAUB0jdCoAQdEQmC53Z1m6nq4zC+UA1IYTdj/5YN
         +usTGHafkWqJli5aa0E5PWijRzCxEYLYf9heRpjIsn7mC2yLPlZZrnItrJjI+LCdhLI6
         by2+m767NglfbwQcv+W0rdARiOAlFtnXL6hDWEJl563nDda51L62BFKLZXYk4HRdIxO+
         TFdBsXCIgZLzGxwnlCMDgEB08ZL3i5GM52ZIM4NVN6M1FL3Ams7inz0MZyo4jU+Vo5F7
         YHxMWBMabSnCeyeH7sCPnPgtjFdWbmOEVt84DTXqWAvzk3/2H9DwLeJt0IFdH9mH6bkI
         J0NQ==
X-Gm-Message-State: AOAM5308Vj5pvHsAtLp/FZ/lFn1JbarwF9G9xSaiLHV3HmFaOJLLOiUV
        L51YNk1lP5KBVILmUfaw4qDNjHN6Wth77Q==
X-Google-Smtp-Source: ABdhPJyyjfXFtwODH8fLZ5VXCHfRQ8QDXgsz+oxU5eEN3Us+ZPdJbeWWWchD3xRhxC6fQEiMQkp84g==
X-Received: by 2002:a17:90a:680e:: with SMTP id p14mr3530034pjj.34.1605599061142;
        Mon, 16 Nov 2020 23:44:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t16sm14582372pfl.75.2020.11.16.23.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:44:20 -0800 (PST)
Message-ID: <5fb37f54.1c69fb81.361c0.1123@mx.google.com>
Date:   Mon, 16 Nov 2020 23:44:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.206-57-g106ef0d11ee4
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 58 runs,
 1 regressions (v4.14.206-57-g106ef0d11ee4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 58 runs, 1 regressions (v4.14.206-57-g106ef0=
d11ee4)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.206-57-g106ef0d11ee4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.206-57-g106ef0d11ee4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      106ef0d11ee4695a42a4544818b1b6dbf22379e6 =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5fb333f07e16472dcdd22e62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-57-g106ef0d11ee4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.206=
-57-g106ef0d11ee4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb333f07e16472dcdd22=
e63
        new failure (last pass: v4.14.206-22-g2ec7a9bf443b0) =

 =20
