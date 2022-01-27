Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5021449E98D
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 18:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiA0R7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 12:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbiA0R66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 12:58:58 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB10C061748
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 09:58:58 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 133so2940909pgb.0
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 09:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2678qcE/18avhZTOXLqPLGHdSybTPsOfNffYVMgkfjg=;
        b=KCNwGDYu6XW8n9SEkXqXYE82BvcnlYxqVSfGhBcD2WhWqTxiU1M/fuXMIycrGx5vfM
         blFhqTyl7VgNnAS9pkx4PIJJty5h0+rE5CFetNuNBYXNyrzOUVc70xnsV+Wkfi+dKuOL
         hpOXveVF+Mh1moVuTUSpxGMCBOaX+j0TSPBeed4+SFBnjdSR/BjjzbAmR0ATRU9x+Gco
         F+PbLIj0quVGeDhf0yJLzt6VlCLLG6da2CEZJbbQ1L62ng/7rjYR5soJefS4NwDJcPpb
         kzLcCeyNl0zpnjjDk9/Ht1F9ac4Ge7XKYwfY0Lr6EskXkDHnFNUwuC5sw+/EUP5hVJuG
         vmYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2678qcE/18avhZTOXLqPLGHdSybTPsOfNffYVMgkfjg=;
        b=1PCBHF2ywCcQDWJ2sOFmfLlIBuAwMUIvS/cQ7rfZM1BpE8C3ILbCa1EI7FjBeui5He
         /hJkqp7LYX+9MngnXz1LgvruW//LSAH/a6iJRU9pEc5HqzaX5SDhNIgiT+MWliamWVe4
         FAtnxqUVFH+NdFpyBpPEP9IHQAzT/1sluoAlMyzpMBpsgX2xp2LiBqS4Y/dbRovNi4Xz
         8/HDsiGz12DnnKmesRAD+8iQmPb9DzJTtLWuXt3DZUvqo7YztAYL0/Z13gUBBEikaDo3
         b/DJcrpNesbh4IxF5XljMpN9J1NXKYpHZAM8UddTFz4kuktnA2eE8mD69vS0Hnr+0xhC
         NFNw==
X-Gm-Message-State: AOAM532ZNJ6sSK983+gQdVsVZXauxS39M2r2uUevEjrj+rXbU9PsC86g
        PeLvyBTHvwO3f1JMot9+dzkNuhaKru7g/uOboWM=
X-Google-Smtp-Source: ABdhPJxSRcPJf8VdVHLoe1Ev01NeSdz8cw09EZaC72xUiigJh+rfZJJS7GYTzQIuIS5Ud7t2GMVl6Q==
X-Received: by 2002:a65:4b82:: with SMTP id t2mr3528741pgq.607.1643306337697;
        Thu, 27 Jan 2022 09:58:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n42sm5472577pfv.29.2022.01.27.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:58:57 -0800 (PST)
Message-ID: <61f2dd61.1c69fb81.24eb4.e857@mx.google.com>
Date:   Thu, 27 Jan 2022 09:58:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.17
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
Subject: stable/linux-5.15.y baseline: 191 runs, 1 regressions (v5.15.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 191 runs, 1 regressions (v5.15.17)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.17/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e8a2995c6076721d496d9458e13142caa7ba8753 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61f2a2f80f25fdcaf7abbd26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.17/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.17/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f2a2f80f25fdcaf7abb=
d27
        new failure (last pass: v5.15.16) =

 =20
