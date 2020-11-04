Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EFE2A5D5E
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 05:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgKDEcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 23:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgKDEcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 23:32:04 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9410C061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 20:32:03 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id x23so9693899plr.6
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 20:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=InyuqF97WmloJvAHFGmaolrhU2BDa1J4NBmbf0OWz3U=;
        b=hC7U27zwIm84MQ2FZetUz67eiCNZg7CXYamq9N6ZOxQWhh+Y6OKpmhvGuyQ3kdhDqt
         aTD3VBoj07dxmNMbM5mN9uiTa5O/SKmRoOOGfwHAApqyWlYHuDv5bExoNdldr/zKY4w7
         xmk969mUp5ij1ncpqCqxEaEyriYp+ZvrcfxiVgqoIaTu73UE9LASQ64wMxapwggJvjws
         o7tFB554+H9xDLO6jdBqjVBtuxL/FwLdGSt//ECXzbedbDYfFVsqp09adHYwIh6lWk+X
         9vxgqUDqgZ7QPFFWKvHjfSE5NIsX6oiHAoHXTcMI4pEmYlPsxKbhsw9w9cOCJk7hk/Bc
         HelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=InyuqF97WmloJvAHFGmaolrhU2BDa1J4NBmbf0OWz3U=;
        b=f9TQe57Grz87xEY8yPA+6EZeY+7vRkBA/N4jN37I6YFOeQP4cfsnqvwikF6imDovPE
         k/IdUU3YwxnhlBwXme2mZPDONQVqXDqM9pmPIO/7w9Sh8juFRG+PkB1DPsVQW2j/wqgS
         sk5BgvLDK5+/Pr+KvzII/nn5UkDE+eekFUxZjiv+9d++a3Qigv5mMBHqyyFKmzkJQjFu
         E5zqxGbusUOVC/GMZYKBoSgRQIxMsbwnw2KfUi+1i2DbLgO+KwQbTOKIAh4RJ5VTLKxX
         5p2iWR51G53Y5tq/q4LPbPZm9T0wl3L8Qh/P0oTmKspr7VUGXxx4QPk2WF3N+pO7k4fw
         1uQg==
X-Gm-Message-State: AOAM533tP4J1x2ekH8rvIRtzNUZC6UklLt1nWKrowAeDYRaG1KB8E3uT
        29SrPsYNB9JGBQ+cLscD56SJUFNTTrkvqA==
X-Google-Smtp-Source: ABdhPJzvP4lt5x2HvgXqAUGfOdlgVI74GacHwdXya5aXqV66oD9MQ84cYImMTyZ/UmxbUadytyvLtw==
X-Received: by 2002:a17:902:9681:b029:d5:cdbd:c38c with SMTP id n1-20020a1709029681b02900d5cdbdc38cmr26762517plp.85.1604464323091;
        Tue, 03 Nov 2020 20:32:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17sm685665pfq.141.2020.11.03.20.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 20:32:02 -0800 (PST)
Message-ID: <5fa22ec2.1c69fb81.6717f.285d@mx.google.com>
Date:   Tue, 03 Nov 2020 20:32:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-192-gd404293c7653
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 172 runs,
 1 regressions (v4.19.154-192-gd404293c7653)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 172 runs, 1 regressions (v4.19.154-192-gd4=
04293c7653)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.154-192-gd404293c7653/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.154-192-gd404293c7653
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d404293c76537ecf3e7724c90c5f61f7e8844f01 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa1fa7ecaba0042f8fb5318

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54-192-gd404293c7653/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
54-192-gd404293c7653/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1fa7ecaba0042f8fb5=
319
        failing since 140 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =20
