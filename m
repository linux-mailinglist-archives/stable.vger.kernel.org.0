Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A32D267C32
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 22:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgILUBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 16:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgILUBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 16:01:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCB6C061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 13:01:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id bh1so2551785plb.12
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 13:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=em8tJmMymnErwlRQelST2hUaNVmZ+ErAN4i/eTQlPyQ=;
        b=rFrTcunP1qZ9OlrBUWtM2Mbb+zp/hbaFpBjQLY31QThS0idovi8zGJr+ao+bhe+Jzw
         uVz/QIDb3ZqAlQL5ws5lVX0uRkQV4WoVpSBGlNu5iclDPXmZZ9wQMFJbFvffCCIU/z0X
         q0BNzmA2XqiXJXdnjK4/Qt12/I65Mtj71+6wPAuq9gUQWxTMfqNu9XHOIChs5ihAccwW
         TEusxVr/WdIS+K0VyB2gnm0QFoJLrKh00McVaRSiN0m7nwCHKM4rP9XDuk3ZdkpAJGHE
         OKxkqFsikGMy4YGcBYLKEQ2rWmFLva4Okc7gZPYrSNL9JsftHPo9yUtuxCTkd+iLiCSy
         37+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=em8tJmMymnErwlRQelST2hUaNVmZ+ErAN4i/eTQlPyQ=;
        b=nLCTI4pzy02d0zgSaLdp0ZAx52vd4LFxk02usJLYf2RQw000YnY/Xg0pkakmRIaVSW
         jY9C0wszm8BcXT7j+4lrm+YYrAXlZUW2EiES6pcXsWEYgNsge1Uc1Nedf6lGT9qEbt9i
         o+LCWXuCZYywvRNNE1z0Wvv0LPIkGNTfkbUYOFw+JGPBU38AEU23Yvb3F1UL4xblyNrR
         Yr1XlHd9Xq4Mw4EyEG++oAQnxwc1l14Xj/MUljUNV6fR+vpB4Ek8HFm5KZvQ5PfRRTiJ
         E9NTPpLX09VCNM+z8S7rHy0dODlGExBGSJsliftsJ5H/INEt2QcqN+5MgfX3vIYfvjqP
         JVTw==
X-Gm-Message-State: AOAM530J7Ncjrv+jjhT4ePTOaKe+nPBUMKvEg/VGdhKsGnYIqdj5irg5
        t2ttx/SM+SRN/pLRCBJeBt2E8CFudM5fEQ==
X-Google-Smtp-Source: ABdhPJwEMiSHuUfyTz5dnxq5SxCc7qzsU4Y7b/zdZV49rzwwJjIasXz/eqN8Ac1ZdmRatCrM3y6uvA==
X-Received: by 2002:a17:90a:8c88:: with SMTP id b8mr7383360pjo.118.1599940899086;
        Sat, 12 Sep 2020 13:01:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm4673835pgk.73.2020.09.12.13.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 13:01:38 -0700 (PDT)
Message-ID: <5f5d2922.1c69fb81.24a37.b7f5@mx.google.com>
Date:   Sat, 12 Sep 2020 13:01:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.145
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 167 runs, 1 regressions (v4.19.145)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 167 runs, 1 regressions (v4.19.145)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.145/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.145
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a87f96283793d58b042618c689630db264715274 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5cf092bbcb7f4f45a60927

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.145/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.145/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5cf093bbcb7f4f45a60=
928
      failing since 58 days (last pass: v4.19.124, first fail: v4.19.133)  =
=20
