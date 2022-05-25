Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB37533F6A
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 16:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiEYOnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 10:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244853AbiEYOnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 10:43:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412EC3C490
        for <stable@vger.kernel.org>; Wed, 25 May 2022 07:43:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so5299984pjq.2
        for <stable@vger.kernel.org>; Wed, 25 May 2022 07:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d8qDEZERuw9JXGhY9xEMgwh93/ASU2eRo2PhiyHq+v0=;
        b=Xn0xc9Eb9JPvWuvFeOmJY+j9PSJxyyKnMzn6cI3En/11LA1/sBNiN1Lt+Wt3cMOs8W
         Y8pySHghSpadGren9I/nF66WkhO4M2JyLFn026eANEGT3qIt2PfDOSRlOKk2E8Z+9dYY
         zQh1D0SVWzPAPYBfiybgiMFWJUpJnmuxfI6pZiOxalYXZHDof5pf1WBMFufOFWuTKarO
         rIk7ejo1/iD2LJ78C5cLCclsbAHsd2lxo5vTzZIVSaCQ3MKoJjMOd+VRHoODXYeoDK9D
         NtegCWLmFQP7HYGhd2UIwoNsFCZ3eBjXUxXmtQl2DuxFKC2bGakC8yA3UN3kpnOIfyi7
         B6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d8qDEZERuw9JXGhY9xEMgwh93/ASU2eRo2PhiyHq+v0=;
        b=GTuV0+wUIx2stBX4Ht8GE8R7i+HaMeO17ueUMuhQ3xuOZLdNHALS7mEmakyLBXwvxt
         gEyvEZ5xbcuwVApHjHjeBeTywMP0OypePBFbEX77THRhOIct4KlQzb5qdWEkyvc1ZQbW
         86TJL12Eh3tg7AJxzWX6LIIrhuITKU6ZUKS7nfHZpB6R860dHezlnPi0EzzTR82iQMlY
         IL8Oy9JnrEteAZN4kqGna0ze8BMh/LnrEZsFItFneI4wBY32AC8zG5YJrhpjcDZz3ccm
         89QsFbTldlYU8aM4vUa4i8KgNmhsGIlcUG87WLtLrGS8be1VSKK4v5aABdnJASIBmQ/L
         M6DA==
X-Gm-Message-State: AOAM533p8pLLRftDMqR9/yz12pH/O0JuC0c3ADwhrPDMlzI66J+RZphF
        IgFeJrEgFtjQvONzzep+vwgP69gqiFR7RwXE/NA=
X-Google-Smtp-Source: ABdhPJy9DuGAY3ykVaF8CgilxvGVme4oT8uaz/jinihtqvsYBld9CWAPapYZU+SDRQ6xW4PRisfAYQ==
X-Received: by 2002:a17:902:8693:b0:161:e28f:f85f with SMTP id g19-20020a170902869300b00161e28ff85fmr30290526plo.17.1653489790682;
        Wed, 25 May 2022 07:43:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14-20020a1709029f8e00b0016191b843e2sm9325092plq.235.2022.05.25.07.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 07:43:10 -0700 (PDT)
Message-ID: <628e407e.1c69fb81.56a40.6175@mx.google.com>
Date:   Wed, 25 May 2022 07:43:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.10
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.17.y baseline: 114 runs, 2 regressions (v5.17.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.17.y baseline: 114 runs, 2 regressions (v5.17.10)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.17.y/kernel=
/v5.17.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.17.y
  Describe: v5.17.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6c468bb6fae847a154c7ec54cae85f83c9d17a90 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628e0f100b12247894a39c01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.10/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.10/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e0f100b12247894a39=
c02
        new failure (last pass: v5.17.8) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628e0dbd669658d833a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.10/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.10/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e0dbd669658d833a39=
bd0
        new failure (last pass: v5.17.8) =

 =20
