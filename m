Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A44348E42E
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 07:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiANGU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 01:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiANGU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 01:20:57 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACF8C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 22:20:57 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so21053382pjf.3
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 22:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1PiCUjSVbeNlJMp+6mgCcbobhWJhexRZlkXLZQn0gys=;
        b=CZKIA7nxWwy3O8viTF6sSPYD4iODhlUCmP050aBLmpaV5Z31va6Yh8CP+VlPZxtMzr
         xMWgbzE0tpwhpt4NXWb4pXbEmY0fCX8A8nzF47W4jzxF/1y4TY/IN0Q7MonR5Zw9GOGt
         7CCkgyCVt93tzfA9GVVddAEnSJ7iM4Y0tw3aSklYpLGGcM9B9tvIOo8serU4doJ8ItlY
         BYQjrwAeA08MM2RyD8r3OcLenUl6knpsBfTTSu2QDmaUT6dgdAenP5lBe3+AUCs9h55f
         T9+CrHJiCwbLEDOHN1GaV9ngCOAgtojNZHIf1NFmv/zzj+so1jZQm5d1b50hY0OHYgsQ
         Ho9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1PiCUjSVbeNlJMp+6mgCcbobhWJhexRZlkXLZQn0gys=;
        b=TLO1pqd5wx9QXuSd8IaBD5185cnl3PX8F6FuY5GEImxwDG+Y5qdM8Lv9Q58JMLsnXw
         Pqci872swF46csX21VFk8GPGGhX3lRpASH1CUq2HmkKT03TQqw/vlNdqODkuhV6Opyqs
         Dw9OLleglM7/PLCNG6vIl5XXrIgQ0chr2FsLmQ31vwcEtHp1QjmUSdJN4JpAw5mTZKDF
         gR+W1qqXzQWU9YIXAcz4KyOkVaPfemuwMj3ULASsFwoJCe3p2nRH7QU2ET1SwYYqRNUv
         HYQE+7+lEIdQDdiyVHQ8dBiKF9+i00rJSG2HRQjIwJAqOeRwPdekVSwbs+KvOZh1xOJc
         JbYQ==
X-Gm-Message-State: AOAM533HgK4Al6ONxCv/SIiSTsze8wiXCUstxrLRmYMUgwaYX0kUjaxc
        tEYKawqrjIiH8hOjw2tSow3UiC5D53FOzj1ePi0=
X-Google-Smtp-Source: ABdhPJxoKEI9Vky2RKy/Kz4kwLqHgutugT7DvxxXTpVyitegfwAvBLwWcU4vEwzD4Q9axeQZ+MtGeA==
X-Received: by 2002:a17:90b:1c0b:: with SMTP id oc11mr8994661pjb.236.1642141256477;
        Thu, 13 Jan 2022 22:20:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s8sm4659918pfk.165.2022.01.13.22.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 22:20:56 -0800 (PST)
Message-ID: <61e11648.1c69fb81.5a47b.d796@mx.google.com>
Date:   Thu, 13 Jan 2022 22:20:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-9-gcd595a3cc321
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 132 runs,
 1 regressions (v4.14.262-9-gcd595a3cc321)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 132 runs, 1 regressions (v4.14.262-9-gcd59=
5a3cc321)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262-9-gcd595a3cc321/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262-9-gcd595a3cc321
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd595a3cc3219f3c3943ad8fcb09d8e0f8be7813 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e0e15245c68ff71cef67b0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-9-gcd595a3cc321/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-9-gcd595a3cc321/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e0e15245c68ff=
71cef67b3
        new failure (last pass: v4.14.262)
        2 lines

    2022-01-14T02:34:32.053868  [   19.972564] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T02:34:32.097805  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2022-01-14T02:34:32.107259  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
