Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0171262112
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgIHU0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgIHU0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 16:26:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DE2C061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 13:26:13 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id v196so247506pfc.1
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 13:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V/htnDSaGbYmClX2t/aMPQNCXro3h18VAlZ+JH6ETFs=;
        b=mNnlgTp2rQTJcFPbGVUfDqvPoY0QxEnZrq5Ni6RPrVngX97Iov3j5fsS5wIagk6L67
         rLeu7JJgu5SzU45Na5QzXLrQrAgY36QIKcG9G/rJ/O9Dlemo4aGgC3SvGzcceORsAOed
         Binp+gOitAKItQ93v/tR+4198H5bYqE4e47tZhfRKBjCFped7yaS25GNPq3SQdflkIUa
         Y0CWcHhSIPyDm3yN70ZB8a1ZPi+LmIsIVFo4L8CVsemCbdcoL+Ju5qpaiVwk782dMK8/
         kbkKXhSN3quEiohbCWi7gHGTtOfMSiefm6VDknPybZ0uqfHmIE8dkJMzB95wUf/8UpTw
         ptdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V/htnDSaGbYmClX2t/aMPQNCXro3h18VAlZ+JH6ETFs=;
        b=HtBUr41fTBXF0uY5yXXLg1cltuoUN+eHwYdR3bpFi00S7BP/XpJi5YSQ+qoUfq3Xdw
         xNdsBhO950aXOGt5dhAkzjhwj/LoZc3Uw+frL4cJAhkRfiCGZh4Pxye4W/7qUN9ptDWI
         yrVk46SubQ/4mwyV10OmhwvgRLqmZ6RtA0yr8PGNGnvw+21vI3/1MNxw5NYNJ4to4nkK
         5YgMi0aJQ33InwxBqWOKxzlx1FG0WnUa6VOatmjsQ6QyCSV9rCB2vrWoYUPlyxBxYDjk
         SGIkdYyxJMy4L0oCeqgt6byukEkxFwHOFk7B/9Nc08ZwTJTmC36dunhIZZvQKMT426Uv
         ZBkg==
X-Gm-Message-State: AOAM532qBK8JtW3g1Bit747M5wiXDq34T1ZM+1HYxEQdRhbJAi5Kzfps
        jE0BgbXBeFIUTQpaRdPftq2PnwDoYWtHMQ==
X-Google-Smtp-Source: ABdhPJxG1WDtfFlAabgYdSRIEAsT+pEj9kUxhK8HHtGTtQDD7s6/FLecF81xmo1+brv9jYdROp6jIg==
X-Received: by 2002:a62:17cd:0:b029:13c:1611:652b with SMTP id 196-20020a6217cd0000b029013c1611652bmr694380pfx.11.1599596772253;
        Tue, 08 Sep 2020 13:26:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3sm110600pjf.42.2020.09.08.13.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 13:26:11 -0700 (PDT)
Message-ID: <5f57e8e3.1c69fb81.a899a.0757@mx.google.com>
Date:   Tue, 08 Sep 2020 13:26:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.143-89-g539e30e8c9cd
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 165 runs,
 1 regressions (v4.19.143-89-g539e30e8c9cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 165 runs, 1 regressions (v4.19.143-89-g539=
e30e8c9cd)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.143-89-g539e30e8c9cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.143-89-g539e30e8c9cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      539e30e8c9cd0a71379976e504f64e148d714ba3 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f57b50ee488743b27d35379

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
43-89-g539e30e8c9cd/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
43-89-g539e30e8c9cd/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f57b50ee488743b27d35=
37a
      failing since 50 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
