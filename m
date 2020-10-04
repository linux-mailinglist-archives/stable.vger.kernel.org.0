Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C04282C10
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgJDRw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 13:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgJDRw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 13:52:28 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229E6C0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 10:52:28 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u24so4257046pgi.1
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hose/ca1Uf9VZs+TnoSf+2B5n6TcBKrnggGv3kFKMnc=;
        b=TcPIBEMmCCWupOm778J34wQrQ9kgRmjeaLWOVJJ5nRi37e5WmY19OH/vg6gBjZSWc0
         b8ZCh1PuOGQ8KN2R0per7zsDDGrCg8elK9OFIeCPz3/Pp/ckwTQX2MeqOSeC+5SKfDpp
         tcWlQKizb+9PNlBAfy7vvByKq1eRBuofgKAPCpBqEEINj0Yd0E/J214mOKnRd17KuVB/
         OkBeXUPeqbDekvLvg64tP5c4nbnMPMMoz88//GeXRDTkyJQZF4sbYuzKfdsTTqurtevk
         qzrK547yxGHVPmgIXTnB415TdaNAMD0m3bodD0xQubKfq6gaOw1+vpRgotIqSn7t1gvp
         UQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hose/ca1Uf9VZs+TnoSf+2B5n6TcBKrnggGv3kFKMnc=;
        b=bJ0cK7SEKbSySoDS9lH6PLjQ3b+nqKm5gy0tuXTMrLs+7DGlhw/giZtVx7UZ4T0TU9
         6RfGEjGWnVUC68/9AJR8Ho+h+h7jOZRtPeAKa2jgzSn89FkC+HFCOn1oJYdh9BPnHvRB
         MOoujHO7dhuUU19uBpnCkSvijetgmRXVc0e/PN53LUoW8oRdJ68IS+f54wVkm0eSCaKF
         1nDDePlDH4sM8/t3prNS24A9FiWYe1Az5GhBa38v/GhShmgT4fN/0IlxLl2EntgUrUXU
         2eMKmvrqJDVFkjgb7QCQU9vpLALPNMAYFBwWFtP9IS5KA1KGDNEQszM1873SCoNjTs05
         U77Q==
X-Gm-Message-State: AOAM532HHhxv3wXoTu42n3RYg6wAQtFNqAnIZCaPA4U2en6sOEWAFK7e
        CDsbOLQaEI0B+J4PLhiN8AMFJU7YoOWWQQ==
X-Google-Smtp-Source: ABdhPJyGfZ86AuS1gSeohRUic7XICqH9LN+uLNm5Fr094Z2U+EwyE6R3eMXTKZD8q+tS3ZnAG3o8ng==
X-Received: by 2002:aa7:8dc9:0:b029:150:e9ad:952 with SMTP id j9-20020aa78dc90000b0290150e9ad0952mr3527240pfr.61.1601833947232;
        Sun, 04 Oct 2020 10:52:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o23sm7848352pjw.32.2020.10.04.10.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 10:52:26 -0700 (PDT)
Message-ID: <5f7a0bda.1c69fb81.f609a.f598@mx.google.com>
Date:   Sun, 04 Oct 2020 10:52:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-6-gba39fbe0586b
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 59 runs,
 1 regressions (v4.9.238-6-gba39fbe0586b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 59 runs, 1 regressions (v4.9.238-6-gba39fbe05=
86b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-6-gba39fbe0586b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-6-gba39fbe0586b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba39fbe0586b65f23ea817f1a3d09f16d302ba47 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f79d1ff8d141b550a4ff3ee

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-6=
-gba39fbe0586b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-6=
-gba39fbe0586b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79d1ff8d141b5=
50a4ff3f5
      failing since 0 day (last pass: v4.9.238-4-ge285c292897c, first fail:=
 v4.9.238-2-ga41cdac0290c)
      2 lines  =20
