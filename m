Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA19220AB28
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 06:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgFZEYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 00:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgFZEYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 00:24:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C63DC08C5C1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 21:24:15 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k71so957522pje.0
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 21:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=epceeTfZiF1Ubzr5d+mWuB10syOG4mjsr/xPnZE8vDQ=;
        b=zALPL4WxOWf4qkiqzX+SWPKCJRWs5Xdr+GNaNJo+KNcCipK6f5nXB30zuQ7hHMeDc9
         EYZ9pWPIva+YjkIs2TEeEmume9Pg/Bxf75VRQEj1mXpECc3Ek+/Z3Lm6+W6UBI84Aco2
         JmYBC0R7c+fhgDtTdtmIxoU/ccaJQpp349VCdGjmab1hnpNq/HcYal7L8S34UVehvcGE
         GRa9jN+JFphPstaOFZGfee5NFYlkgsSGBI2mp1xQvsgxe11CShCVbyki3W/FZPs3rSEQ
         L8qbjHHgWb017NNlJ8j+07HuiSCBnmdh1Xe7UkDNA+DUNPFoysZPRK9Ws9roPydJ+kO+
         iLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=epceeTfZiF1Ubzr5d+mWuB10syOG4mjsr/xPnZE8vDQ=;
        b=uFwv7ocO3JXe2qd8UrrId71o+ECRMog3B2KfGP/+u26PQacxxkfBd43GxFXgDFkJ8o
         FVKQxYSJXXmVo5VfwcFFIdbDFZMzjBzOxdn9WJK1pNN2F2+KIRSSVLbG3A6n4ktFtfmS
         L3kavUpGND0+jnEX29NrBEDSRcwjXPWetMQhwRSRNQzNsx6IkrGCzHg49D7EltlMCvIg
         JgDD5mA0F5gC6sl8UvWoewjPSHSMQ1K4GscOQwokb+IVTH5Fp790/RNrStKe4Q21EkO3
         Hocf5lRE206WOnIUsfVts3rTfPbSE9V4Ua5/B3omyCQJtmQZrynuc/uu3klZtncfCANw
         vA5w==
X-Gm-Message-State: AOAM5308P4+8IV5EEvau+Rgif3hddGb9+2g3Z4AT+HlAu8uvKc5S1T0w
        h79DRTDImMR/qFVHKkt3diVT2QdV32o=
X-Google-Smtp-Source: ABdhPJzES1ztIzab1tPlVWdJrd92MNVWRLg5c/s/qARCgCnJ0RCVpP4NdZi1AZWmjL3cWtF68K3KLg==
X-Received: by 2002:a17:90a:987:: with SMTP id 7mr1269176pjo.186.1593145454205;
        Thu, 25 Jun 2020 21:24:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm10626305pjb.26.2020.06.25.21.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 21:24:13 -0700 (PDT)
Message-ID: <5ef5786d.1c69fb81.d027a.e259@mx.google.com>
Date:   Thu, 25 Jun 2020 21:24:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.186
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 59 runs, 3 regressions (v4.14.186)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 59 runs, 3 regressions (v4.14.186)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 results
------------------+-------+---------------+----------+--------------------+=
--------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 0/1    =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 62/68  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.186/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.186
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f49027cf4ff06c384e4e16a8d45dc77bf6af3577 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 results
------------------+-------+---------------+----------+--------------------+=
--------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef544e0478faba0ef85bb3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef544e0478faba0ef85b=
b3e
      failing since 86 days (last pass: v4.14.172-114-g734382e2d26e, first =
fail: v4.14.174-131-g234ce78cac23) =



platform          | arch  | lab           | compiler | defconfig          |=
 results
------------------+-------+---------------+----------+--------------------+=
--------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 62/68  =


  Details:     https://kernelci.org/test/plan/id/5ef549772e40c273ab85bb4b

  Results:     62 PASS, 5 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
86/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-i2c-tunnel-probed: https://kernelci.org/test/ca=
se/id/5ef549772e40c273ab85bb56
      new failure (last pass: v4.14.185-140-gac53308e6db6)* baseline.bootrr=
.cros-ec-keyb-probed: https://kernelci.org/test/case/id/5ef549772e40c273ab8=
5bb58
      new failure (last pass: v4.14.185-140-gac53308e6db6) =20
