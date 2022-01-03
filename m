Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7112D483488
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 17:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiACQFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 11:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiACQFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 11:05:02 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A8C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 08:05:02 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s1so28911962pga.5
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 08:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rc+hvkKERJfsypcYy9M1t8MPOTLBkTpw/KzVu6SSRpQ=;
        b=NPny48eR6Z3apvNIgv2EP1Fhbid0paSteYmGP6zCR84ck/VBT2BmhDC1oCLE2yeiu5
         twOQFOiMyXFwhvKHhyFa2pSXyBrKIX91z6iIUYwIrtVDT68jJYY4sRxQ5U6Kqcl+uZVz
         ZKaB/uRneqwdfW6G7hkDG0EUxgrtKQe7wozVh6B8DCPXWEv+GS4H0GWhBZ42mvesFx2l
         Ar+ZML9mQVwIYP6mqBPK6wPYZIxudg1bfBcQt0tiLJoVMlQutx5xEgpbQneZRhp5b4BB
         lkVgqc1anDEFvaT67MuqC82K6awT1VklidEbnP7mes+sKg/EHS17nKLGeQVYyXvrNDsS
         NUPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rc+hvkKERJfsypcYy9M1t8MPOTLBkTpw/KzVu6SSRpQ=;
        b=dlCp4oaa4jgXXGALkdJt/yYZvBXpirBDx259gSzEINNg291CAhtJejW7mm7jH5hCbL
         9jJtS1Y7oyDnDUHxL5qnL93PXUxUvYptJ/65NrXxRFQf8ozCrUHYElYJpq8ZCY5+3DAo
         EPDTG77NWly09Qf5K+Pyjo/mjqDxPrE4lpTF3XNdzMNTKTJFaCWXxfAj9qt7FnFWv12w
         iB8+zR9ibA5aeSYNYJTN5+mT3oa38/s4sTnzJY8yckJd/CbXD6nOaUiRxZtzwmQEbuhM
         G9VbWeGkAvFNmToZJE6TBWzSqw3nzlCGFqQNvecBS+s5rkMb11gKsAsiU+cm+IFarMtY
         u8Gg==
X-Gm-Message-State: AOAM533ZLQ6roA6AMcvkycFmxyzgVtEhlORQtpIaLDWGmhvT6kRPzz8i
        VQla0z4MmYRpybItRUunELKEYWzad2KH8Ofl
X-Google-Smtp-Source: ABdhPJwNYHCE8v6J7hkfr2KJJdhtey6Cfo+P8a00jlGt5LFqLDsdFiJiLr4pj6+QNVbagF8mIJBKrg==
X-Received: by 2002:a63:9354:: with SMTP id w20mr3048730pgm.357.1641225901824;
        Mon, 03 Jan 2022 08:05:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mi5sm40385388pjb.21.2022.01.03.08.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 08:05:01 -0800 (PST)
Message-ID: <61d31ead.1c69fb81.bc27.a970@mx.google.com>
Date:   Mon, 03 Jan 2022 08:05:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-12-g35b04967ef14
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 121 runs,
 1 regressions (v4.4.297-12-g35b04967ef14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 121 runs, 1 regressions (v4.4.297-12-g35b04=
967ef14)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.297-12-g35b04967ef14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.297-12-g35b04967ef14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35b04967ef14b6bfdf4a27f8b80975b797d17f2e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2ea5e85dac8fa60ef675f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-g35b04967ef14/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.297=
-12-g35b04967ef14/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2ea5e85dac8f=
a60ef6762
        failing since 4 days (last pass: v4.4.296-18-gea28db322a98, first f=
ail: v4.4.297)
        2 lines

    2022-01-03T12:21:28.503698  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2022-01-03T12:21:28.512845  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
