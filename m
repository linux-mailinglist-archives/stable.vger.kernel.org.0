Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF72B27B5E7
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 22:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgI1UGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 16:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgI1UGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 16:06:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B90C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 13:06:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q4so1327087pjh.5
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 13:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xejPLKOcwCchY9nxSDpW2YWdQvzb2ipbEh3tSxW1VAI=;
        b=DQ29eC5B2uXoibnT9Etwy+HougPEzqSbjQf0u3llRL1RwCydSm5dex+nPhvme3hjNt
         QAHDRhoirZAZ+PDWKS94wMhqEk/gATCr88X4e+Cx99r7ihw/009HmTepHFsGl/y/bkT5
         1NgsuhfxdxxbwnD79OrBQI9SMSVjp0lJcWJmgCAv+LN2hnqDVwF5nA84h7JGG8xvEunu
         qfkS40QQtGPBb0eA8pa4YyGH4SILslF89sqG95KZmXrbTxAQsk6EZYRKYP328xFmRUGE
         YNKPyWyOXRFrBtjMZsch7/rlUHsTihyz31NbFckCxnT/WKLsp/1JN6p9YHogwOBttiO+
         7XSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xejPLKOcwCchY9nxSDpW2YWdQvzb2ipbEh3tSxW1VAI=;
        b=LsUWwVPlK9PJPJhwAnvSihaXa7pzmBeT0TkW/a7Fw10r5pS8xFhHWC3swq0vbrn6n3
         B16HTGJYjE/XKr9ClFwjD2NQEA6FEOj+zh7TKG8AdemeDM/kSP09y5Yn7PIG5sBj2hf5
         Y3IXRxQlpYKdrLJor3yh7AsKRhnDcvXb+2UXoOsZ2E6SeqbTgXfnOz2zhBSlrI0N5sjS
         +fxOukvI4exzcDt3G3rBFFnz/yQXAMbv+V1icskjkBmQd/TBfrNRweHIDYy71/6MSoeC
         xz/LmOiVYcxyDmIg0f4ZJnN2y9pIzVgMM03XOvjA4BrZpJwInHVmLYS8SGLLGCNpMOmZ
         +Ncw==
X-Gm-Message-State: AOAM530XcNKKoOdE1B3cLzRBeWXlxOHmiRcTn/GwVpixtJInt3OnVWDL
        FLtOmUL19f6wvebOiumJljFLuKBNwCvNKA==
X-Google-Smtp-Source: ABdhPJyaVpXL2qQgcly1gTugg/RT9gk55yRLtjwoPFTZexZF8WtQhXBgOKyzjCg+kwWQCfON+WJEgw==
X-Received: by 2002:a17:90b:3717:: with SMTP id mg23mr832775pjb.42.1601323570067;
        Mon, 28 Sep 2020 13:06:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i15sm2557112pfk.145.2020.09.28.13.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 13:06:09 -0700 (PDT)
Message-ID: <5f724231.1c69fb81.27982.4aec@mx.google.com>
Date:   Mon, 28 Sep 2020 13:06:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.237-117-g67e11f2ee7fa
Subject: stable-rc/queue/4.9 baseline: 68 runs,
 1 regressions (v4.9.237-117-g67e11f2ee7fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 68 runs, 1 regressions (v4.9.237-117-g67e11f2=
ee7fa)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.237-117-g67e11f2ee7fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.237-117-g67e11f2ee7fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67e11f2ee7fa7e7fed23702e8761fa1e57d06d8a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f721140c4ddd7a4e8bf9db3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.237-1=
17-g67e11f2ee7fa/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.237-1=
17-g67e11f2ee7fa/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f721140c4ddd7a=
4e8bf9dba
      new failure (last pass: v4.9.237-13-g73039a4e470c)
      2 lines  =20
