Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5943164B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhJRKl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhJRKl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 06:41:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C84C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 03:39:47 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m14so14372865pfc.9
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 03:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0ZcLYYQWC6gz4hYMyMRz2d0u/bqSZ1DOQAZEDpnroIs=;
        b=vMRNNieOYBWJ8nQgXQLNol5DCc4kohfRylgrbn6f6KQHwDkgIWWEpGPMR4IjuW0zkk
         5icXs+N6iFrywdcxOhYnyisoN2g0V8f3ufU4GGOMwwQKzYHmPbAHZjukCTh/or7J35RG
         a9wkvixSjoKl1JX2keN5ckGeVxaPvobkGgZEDXN49rz8rBgLeVIvExjZB1kTQNRFIfOx
         8/v0XR8HuOEBLoXc2e2I+nkD+W8GGK2wrB4vq1EUfPoxyKUoZldhk4gzt+ZkRCNXUPUZ
         lenLFu9wcfIeftV0/9bLm4kWDiQbgIgZhfaJYVQgerB0N3r3YhJ1AyEkk4eLYQo6txaV
         YVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0ZcLYYQWC6gz4hYMyMRz2d0u/bqSZ1DOQAZEDpnroIs=;
        b=AYCSsh4qHJgVuNigVycaK5lt7GTmXU/VlMBH58Qnov4VMFFxinn+Spm/GdYZWyoqq7
         bQLTMuoWUVRmDSQQXXYEn322ZSNAJ6XhwAh4YfDRRsUb3BF5fhpJHvw0fx6MMd/rp58G
         9v7OFKvL5dnH5ptbaRbQ4sy6unni+9nnaU8Bf8zJcKsWj9Hv0F9De+K+GtA/yFNVLSCh
         fdC+CXSYyAzmp7W/3u3zSpyjlLZqz+f04potJC/aUmeXjTYMwWtNQ2/gBqJ0woMvcifR
         AJFQuKilmVV9w00kH52r6a+DOz2PF4kEYF9PvJKIoajbQsbcQyp+te4XoeIGkIWvssRe
         qJSQ==
X-Gm-Message-State: AOAM533PAqBE4LqoRjzrRw47NellBA462nltbDGAVR/S11iHTOMyEy8g
        Jr8zChZimspw11P35fH6DL3HPt5vlTySdq1P
X-Google-Smtp-Source: ABdhPJw6MByibhNoTpeFKcDCGp29F4dkHMYjV0ELaUmwWA8v4h0E3x32U6nXaMkJbdmenFFkfmex6g==
X-Received: by 2002:a65:664f:: with SMTP id z15mr22954777pgv.252.1634553586781;
        Mon, 18 Oct 2021 03:39:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s62sm12928966pgc.5.2021.10.18.03.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 03:39:46 -0700 (PDT)
Message-ID: <616d4ef2.1c69fb81.759a2.38c7@mx.google.com>
Date:   Mon, 18 Oct 2021 03:39:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.73-49-gb2defce123df
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 85 runs,
 1 regressions (v5.10.73-49-gb2defce123df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 85 runs, 1 regressions (v5.10.73-49-gb2def=
ce123df)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.73-49-gb2defce123df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.73-49-gb2defce123df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2defce123df7a2fcd513ee2dee3dc271fa00e9b =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig          | regressions
----------+------+---------+----------+--------------------+------------
imx7d-sdb | arm  | lab-nxp | gcc-8    | multi_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/616d1741855599f69633590a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-49-gb2defce123df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
3-49-gb2defce123df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d1741855599f696335=
90b
        failing since 6 days (last pass: v5.10.72, first fail: v5.10.72-83-=
g0d59553e5bda) =

 =20
