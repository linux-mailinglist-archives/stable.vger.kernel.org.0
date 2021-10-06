Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160E1424A80
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 01:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJFX0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 19:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhJFX0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 19:26:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99289C061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 16:24:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c29so3723063pfp.2
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 16:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N/u1iDu6cta22r/CHdSy35sAXBnibAT+ULfUOFAjkYU=;
        b=FcUnmxMAb9OqopbbbngxTR5pYzK3mduz0taRtPYPKSfFRN3/vWOhq0F/FIc/rHgwBt
         hxeVdchgd6AQrN6291MGFJA9Jv3a8GsJbt1Jp3I+E8a8G9MXW+DOt4bVNTeaekdTVlT1
         4uSEumIJKuCuwMQFt72s8a+qI9iM25SZ8n7Y6uilyIQ/wMX5HWfptlz4MtWyxkBskHKq
         jiTXqCi2SVu7CJX+OsaLk5QtG66eMZ0ppDCoiwsxsKKwBRiarrtC3uDegltgDXTvIdQr
         jdWLd1DSJtgp35JZrQNerv3wUrhTWngQkYY+9s1Ul09Cq6j+uH+ao7OcKMw8Zb/OFiJP
         8x0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N/u1iDu6cta22r/CHdSy35sAXBnibAT+ULfUOFAjkYU=;
        b=g91c/tfVXORBkpwM0sev/MrBP2hqS/B3Z3U2f12Et3p0dEvYA0wmpp9m9/XXqvPVJd
         79bxP1QQcDCvbV9gTCxtqsaqsHskEe6YcCiqcfOOw9+DSfI6kVacExOed5SnyaM+2WJJ
         3GFUWgxCV6eBbwyDoBnaQGoBA1Nmr20/HNtedSI+XS/d4LjFklp+39aMcckPMdB/SKLk
         86aRWvIHfvjRAmrAmt09lSrkrq8WdanbkuQC1WEvDqNx/MolmQ3k2kQlSrWRQ5iBMbCR
         XDsxlA9HKxYlQCvXxwsFI6UEM2AOykEq0Y0bUqazgEvf2W/yLdoIcYqlfXPeG0AAn7+d
         VMeg==
X-Gm-Message-State: AOAM530nTrIHKK7hBYrBB6HryDXSWocgdFIbMJbahzpMi2bTRwDuAmQt
        T+zZ2W4bP7zjMiu0V9l1ZlCkwZt9JcbZpFBL
X-Google-Smtp-Source: ABdhPJyAlRhdZKLuwHjpEwKDRpFCVOfTTtuN4YaIb1BHhSzu0N/Xmy3ZoJ0tCO1KhY1ps0EIBSNtWQ==
X-Received: by 2002:a63:8a43:: with SMTP id y64mr686543pgd.390.1633562688892;
        Wed, 06 Oct 2021 16:24:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q6sm8313765pgc.1.2021.10.06.16.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:24:48 -0700 (PDT)
Message-ID: <615e3040.1c69fb81.6d754.a012@mx.google.com>
Date:   Wed, 06 Oct 2021 16:24:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-173-gd1d4d31a257c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 181 runs,
 1 regressions (v5.14.9-173-gd1d4d31a257c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 181 runs, 1 regressions (v5.14.9-173-gd1d4=
d31a257c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.9-173-gd1d4d31a257c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.9-173-gd1d4d31a257c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1d4d31a257c9fb5087c34e33423b99ee508fdf6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/615dfb78ff4daff79b99a324

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gd1d4d31a257c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-173-gd1d4d31a257c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dfb78ff4daff79b99a=
325
        failing since 2 days (last pass: v5.14.9-74-gb50148bf3122, first fa=
il: v5.14.9-173-gcda15f9c69e0) =

 =20
