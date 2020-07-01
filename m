Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882CF21106E
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgGAQSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 12:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgGAQSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 12:18:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D80C08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 09:18:30 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j1so11208471pfe.4
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 09:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZJXq00vg86PXtb+kH4lW4zLSMCp/mYW63VM8r+m7/9A=;
        b=LEKGLn+71Zeh7YE1XBSGcBqYiJ21A7gQ2HVuMQfqLn2wC8reRZdZxE7c1A/15yGUtX
         TwM7cxK18o1UODbb9qz8shyykYXG/4TOZTpquh4uMRB3Oh+spv8ypZrIOxU/bDBZLLXV
         WBNpGCLNItr6O+P9uC4xynPe2M5vGFVhzV85cWqk2ckNlKKStDKWGe2odAOvYmeN0mQL
         4uGKeLcGl1ILidzVbEMtCdeTtihswTq/bJmV7dmMaoc0SyKwi/lPbq41wWkL3ezEqM/L
         cXd2ymrUnRoOvnmYXDnFeVfOfjFtRAKMxw+n5QE8SF3ZTakPjSdLkl2a4fLa6YMsDbty
         USfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZJXq00vg86PXtb+kH4lW4zLSMCp/mYW63VM8r+m7/9A=;
        b=ot2UWduqe5pmSZIEF9lhoAlip/tyhNEfRURk0xuopNhkf1WYEqFm/YEd7YEV89SSt+
         JQcOtvSPsuo0SMRbGtJlDocjKc6DcAOHEJDHfX4UrryaNbByarW1mjQ+rJTCIMTfVB9f
         vv7JFMSGFQKhgw9lIDDeOLjaKhD1jNhK9u6TpYcf+FUHbzvZuFiRjj7x9t3ogAADS5qv
         o9kkjJS1TUNroBfrOPP6aUgOBkoQruCgGzezmp/gWR6o2lfdVcx9tGXqTLBGL7zclsMY
         pH85UMx9C+yYAG8FE5nvBtZ2DsgzkJWxQpVBOW5tTEKeTWJQ4kG97syfhd04EvJGftnw
         d5tg==
X-Gm-Message-State: AOAM531KC7J3gh6sqFlfNiWZBtVQUY6hsI8Bk7oP4j9XCH4z7S+7n7gV
        oHuvhwS1TwVLxr8A0zomXq+Kb6dXjWE=
X-Google-Smtp-Source: ABdhPJz3Fyh0WX+bGmMbPpkmMCg3LneAwWuj5AuxjMs3PqtWiu2V8HW8MYZIDtPmcbcX8f5wNRicjw==
X-Received: by 2002:a63:580c:: with SMTP id m12mr19996440pgb.446.1593620309681;
        Wed, 01 Jul 2020 09:18:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o18sm7156398pfu.138.2020.07.01.09.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:18:28 -0700 (PDT)
Message-ID: <5efcb754.1c69fb81.2f9dd.1c4c@mx.google.com>
Date:   Wed, 01 Jul 2020 09:18:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.50
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 61 runs, 1 regressions (v5.4.50)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 61 runs, 1 regressions (v5.4.50)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.50/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.50
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e75220890bf6b37c5f7b1dbd81d8292ed6d96643 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5efc88bbd8fc15bfe185bb2c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.50/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.50/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5efc88bbd8fc15bf=
e185bb2f
      new failure (last pass: v5.4.49)
      1 lines =20
