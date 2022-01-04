Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B448489E
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 20:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiADTdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 14:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiADTdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 14:33:35 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F19C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 11:33:34 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 200so33579441pgg.3
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 11:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rinCZr25ie8uTE+NshQd1jqeQFU4LuK/lyTjmAUl/5w=;
        b=QCpdv7Lw5Qs7NMU62ZH/F+AhJhEASZ2h+UxvCceJl2cYJvzWhUN3GLG2pOE5fPhMov
         aXDRpXx1qgfJ91w9uNb+KCIL2pF6MjCDJyJsf1zNvzrId2T7GmJZH7HLAQpSPIhi740A
         vdiRs8myf5OPFJrMB2x/J3sAFGH42ElWHB69OwduBf7fmgS9gM8auzZt/fUiCURi9BfK
         e3Ys1qlxg2NSx4lUXYhstr7pFRZEOTVV2Jzh7tr1mrV/qwvkH1LM6/xKEFz6jgxGSajm
         axFRDFFGA5x6PQNxozpm40RSc5PnCzQBNnMmFy0zGTsD+I/T9M8FppXNqbn/SuO2Ry9c
         qsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rinCZr25ie8uTE+NshQd1jqeQFU4LuK/lyTjmAUl/5w=;
        b=8RTdT7ViyojcLaXZvQTPZx9cFtMTqW3yApCqwOyw3HaATaOWll4JfuC9w4RQ2VTnIz
         5zJziM0pEBElimL/IeeEDEh2c1rWsXWStORUhWOVAVu332scWUQiGBSPiOJA0Ktt3Rx2
         8HnKz9ycCsOqRBS6qkVGX59Jn1tjn2CQf4QffWxK/+4wxEWPcczwfSDrSL0TsLICHSNi
         f/6bPoCTCIUzZY8E5UvzYpxvGpP7Py0pZ3aw8NozH79PnmP6xh/wRVSgkPh+wmdkPy6s
         iKcibgvvbUhJ5Ykt1GLGvRTodSMJkmVk6m5k0p8HJaDbrs5goLqdWkCW7/z5LE3YR57r
         9UTw==
X-Gm-Message-State: AOAM53270kQwnIIsvQFt/rPbsAhjYQPfkO8RjWB2I4nJdyl0J7TpdKTG
        Joni0Fh+JLRG9XpJOUw0NENMbBCN+JXT5jgd
X-Google-Smtp-Source: ABdhPJzCRXNexFtVDZFR1AWYAqC4npdPotrXqQ4Xnup70fpBm1X9Y3GETd5NwMkWpk4vXA7q5eEERw==
X-Received: by 2002:aa7:96c5:0:b0:4ba:55c0:5e12 with SMTP id h5-20020aa796c5000000b004ba55c05e12mr52267560pfq.86.1641324814292;
        Tue, 04 Jan 2022 11:33:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17sm40164615pfl.125.2022.01.04.11.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 11:33:33 -0800 (PST)
Message-ID: <61d4a10d.1c69fb81.1cf08.c2b6@mx.google.com>
Date:   Tue, 04 Jan 2022 11:33:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.12-72-ge906471b84ff
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 151 runs,
 2 regressions (v5.15.12-72-ge906471b84ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 151 runs, 2 regressions (v5.15.12-72-ge90647=
1b84ff)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-g12b-odroid-n2    | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.12-72-ge906471b84ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.12-72-ge906471b84ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e906471b84ff06d61143716ff887a334b6e9c28b =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-g12b-odroid-n2    | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d46a457b1c44c7c9ef6765

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.12-=
72-ge906471b84ff/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.12-=
72-ge906471b84ff/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d46a457b1c44c7c9ef6=
766
        new failure (last pass: v5.15.12-73-gfc2a83cef6de) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61d46a5ccfe28a05bbef675f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.12-=
72-ge906471b84ff/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.12-=
72-ge906471b84ff/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d46a5ccfe28a05bbef6=
760
        new failure (last pass: v5.15.12-73-gfc2a83cef6de) =

 =20
