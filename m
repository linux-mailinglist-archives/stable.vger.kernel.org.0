Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0489E25A002
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 22:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgIAUcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 16:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgIAUcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 16:32:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213F8C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 13:32:07 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id u13so388187pgh.1
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 13:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZmBwYSrysqfwm3UZ9v3+VE/qhjo/m3q3svW45wxTaA4=;
        b=rYGNkcUwbJ8Wu704Wx1ZUOgt1DlibEfoC8/sYNCn1++5OnXuAr1Ej0xLjhYXUGPAwG
         mS6dzLK7s2j+xLaWvo7CTQEt43OH7ITV+gS/ivWsN4z9OamSwC/QmDBL1dDr5blnbHFn
         AAczEPuYZ7YjoeO5y48fzLd1icM3CYajxzL2YlNiE/XjmCEK0l74DkMfuggjzSMSPlZY
         GyiuuRiUf7a+/ZUNyDlVasG6bT8fGQuFLN/TgR9vTUa/jMRhijwTEnYLYGdu0a+7X6Jr
         NTe1CoVcfygMQwwolPMsZloxv4cs+iiZHLPmtCCctQoF82KgEMPXesu/27d4H6DcsFkQ
         A3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZmBwYSrysqfwm3UZ9v3+VE/qhjo/m3q3svW45wxTaA4=;
        b=Wlc0SvoNlQfcla0Y2MFvfBaNLXLObVk85/UBukRhJLmxYEAUaRpU+EHU/3+iQZqzee
         4DQMCT3dMxEI889UZug50Qvlv1fp71gEp/zZ0h9ZVU1DBfkOKU60WrUmK3h85p/RW+WH
         bTpNINi2T2FBRwFUk8w5Q5ehybwMLxjrGlWmr2kMcIRke1gnhjQy3OEYypYNFMQSa0/2
         paAqqHT1PDPIILMRol8OOc8GUa44hRbCVkjatvUBwDFANGNyRplADCIfsUecP9uW4Pf5
         fGAqwYmy/D3ONhytkk33XrKdioJrtSqXKYnnazUPVqLVrQ0g+gS4Xqw6GkIEhS837PiI
         s4dA==
X-Gm-Message-State: AOAM530pEke7nCLM+mi2m2qCR0EjoGCKSFkk2618Me3yf9E63BkTsZ2k
        2Qh5xkRm96en+SjvjL02QoijpnR7C00BSQ==
X-Google-Smtp-Source: ABdhPJx/pHgdf90D2xggfhlzDGQOJLpUb9+1exJnob/i2TDK1aJXYY/CFx1r5ijFE8BI9uwleoNslA==
X-Received: by 2002:a63:1402:: with SMTP id u2mr2791386pgl.400.1598992326272;
        Tue, 01 Sep 2020 13:32:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q193sm3021089pfq.127.2020.09.01.13.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 13:32:05 -0700 (PDT)
Message-ID: <5f4eafc5.1c69fb81.13175.73fc@mx.google.com>
Date:   Tue, 01 Sep 2020 13:32:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.234-79-gdefc50a6f06c
Subject: stable-rc/linux-4.9.y baseline: 115 runs,
 1 regressions (v4.9.234-79-gdefc50a6f06c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 115 runs, 1 regressions (v4.9.234-79-gdefc5=
0a6f06c)

Regressions Summary
-------------------

platform  | arch | lab         | compiler | defconfig      | results
----------+------+-------------+----------+----------------+--------
qemu_i386 | i386 | lab-broonie | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.234-79-gdefc50a6f06c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.234-79-gdefc50a6f06c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      defc50a6f06ca62b5e1fa42add038887484154e4 =



Test Regressions
---------------- =



platform  | arch | lab         | compiler | defconfig      | results
----------+------+-------------+----------+----------------+--------
qemu_i386 | i386 | lab-broonie | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4e84b8dc87d12b7f08113a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.234=
-79-gdefc50a6f06c/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.234=
-79-gdefc50a6f06c/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4e84b8dc87d12b7f081=
13b
      new failure (last pass: v4.9.234-76-g5ca7fa185200)  =20
