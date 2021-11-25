Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F2445E0E4
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 20:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349729AbhKYTSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 14:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbhKYTQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 14:16:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1266C06173E
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 11:13:06 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so8367059pja.1
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 11:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wSEVLApcfws17GBGwFgXcRPjwIIZz+JFNJmiS6nOHag=;
        b=zWPt9qfqi0dXD9BOm9N4bSqzVpGShjxaW8eAJT7rDBH37MRs7N3cfZap/Q5jAcOYHo
         DYEmgX9qyYtu7pIheciuAXXL+Z14F6fhGVHGAFU0aSYKJSR4+Yya+FWq/vJCt0Zk16TX
         X8Q73PXBV2CILak6CuHj5PjzWUVXNG4uuFG5faOZ/SqDeu6gzE9RwY90DsNgnO39RBNp
         llp0NWyB8h4cW+Q+oe6USnztWGBI5QUV5gKGicM2WvmtYVwgBTkj50QDBwsZ+yLb9xBN
         OsrUqMhgQwuek8WIwFOfKb0xRxnXEYMLRDuQGUfTTTl40k9lQ/Owkn2MgmdIUifKdxmD
         c1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wSEVLApcfws17GBGwFgXcRPjwIIZz+JFNJmiS6nOHag=;
        b=rBwuBxaDUnFpHkSkDquV3n+ZA7w/cNCy75q//jxbjEbAf4rHRXPLeOPfRXTJsB8yAk
         k4kSajET0bLTHMlvFead6Xq07R6y+BOLm0zFlZ1oHUZhDG9Z9K0NMRWsD7p0b6PpKr8X
         RfedsRLCSMSSsfSMtrC10P2I+WxlNuzGTwOLicGucZ/IeFygqgDumQGiS8mJ4i8KvFxT
         1jlsTScxNM7RY9c93NfPCX1P4ATA/u+C6QdG5gvyKWhIz/7RLKqAiF4CRqsYmpUepbuC
         lqqLcxBmZeSTZ8OTv+TpHQ8ubJboEZ5fHlnLkfP88wmBKr1S7lJE4S6iiTKeKz/yP33M
         7rBg==
X-Gm-Message-State: AOAM531QMAc5KjZjFr2hbzLRvyozY8yeVDdyM/3a86aQ6IGVQgO5qlJx
        PHxO57EBHjwWo7EtbbHE9V7lRVTWdL7bv+/m2X8=
X-Google-Smtp-Source: ABdhPJy4nSZTmae8TY3RmhEmYvpZiZXy5DN8tBpkumTbR+b8HNhHmFOI3pfBxrm1pZkTyMaoCur51g==
X-Received: by 2002:a17:90b:1d0b:: with SMTP id on11mr9574479pjb.163.1637867586227;
        Thu, 25 Nov 2021 11:13:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id md6sm3437380pjb.22.2021.11.25.11.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 11:13:06 -0800 (PST)
Message-ID: <619fe042.1c69fb81.7a74f.93f8@mx.google.com>
Date:   Thu, 25 Nov 2021 11:13:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-161-g62979a1e3cbd
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 103 runs,
 1 regressions (v4.4.292-161-g62979a1e3cbd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 103 runs, 1 regressions (v4.4.292-161-g6297=
9a1e3cbd)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-161-g62979a1e3cbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-161-g62979a1e3cbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62979a1e3cbddfcb8770c866801df877e46c1338 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig                  =
  | regressions
------------+--------+-------------+----------+----------------------------=
--+------------
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/619fb021b7db50f9a1f2efb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-161-g62979a1e3cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-161-g62979a1e3cbd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619fb021b7db50f9a1f2e=
fb7
        new failure (last pass: v4.4.292-162-g118b5f50cf5b5) =

 =20
