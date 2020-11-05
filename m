Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379572A8ADC
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 00:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbgKEXks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 18:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732086AbgKEXkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 18:40:47 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4683C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 15:40:47 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i7so2482379pgh.6
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 15:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q7IC+R1Jz7wU+3npOESYPCpI5/mrcs4sQOD3p0H/uoQ=;
        b=qcn05FGO9iAdJieZWgCg0i2KK8VIec3VobPdIEf2DeeMZbH4dn0P5Pt/1zZprYbhEX
         I+ofOCzIQACy3wNJqnHq91BYkMncSI3ymMDD7e3CeQKV9Te9PaBEm0f30v4rKXP7Z+C5
         zxjE4TXBQg+pvXUU+mboO4+NlGWyups2E2jvYGZTugH/GiDbD5FDms25uxti5YdyFnnG
         99mkC5VVBLjan9nu6akVSZSU64teXOncUoEmuPZZDeZgocMWNk/L4oG/QzVzpEOiZfkF
         J//nBwoUeXOBSfoDuVPVabQOMPadaVIB+apje4A92mjeeCkAm5yddmz+MkcsPNW2ANDR
         mGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q7IC+R1Jz7wU+3npOESYPCpI5/mrcs4sQOD3p0H/uoQ=;
        b=eXHyd2BGz/N5K6q62V3LH5+lQwDhIgBN8SXecoVnlrU3FRj9gZtQ1eYza/EwE21/Ux
         YllxHdaRQ66UtDNaNhBWlpRpFlKIiLRKxLxlzyqPcqioDoHG2p8tSznNS9O1mYAFCOZu
         lWcGLmJKXMDtyHY6Y3oDeC/6H5cTWTBy6XfT0zJnX86WLzCxjFmRXwZQxOWDR+tqQ2hV
         MNNE4BBp8mcTU1OH0kS03jRk9eM1BEjk4tUNUENMPE8PRWpnbrlGcJ48I79gqKoelo8N
         +aOSmLPNKvthopFM57yOwUMCCWwV2En4xmb2q4FsbcC/MJ6HgJoc7WOYnqn5gS5+0ys9
         Ekgw==
X-Gm-Message-State: AOAM532//ak5bWkOgGczRvWOo9jRkFG2z1aKGUxwAJIi/THa/MBc5sRG
        R+r3inIljUef65151ABWjdnzAAbBg6+e2g==
X-Google-Smtp-Source: ABdhPJwoI8u+lklkEpAP/I2FqDLxExacZqYx2PoCxyjjVXar9oKTmuYTmz2K64QOW44Jsxmo6CTQ/w==
X-Received: by 2002:a17:90a:74c5:: with SMTP id p5mr1890737pjl.167.1604619647064;
        Thu, 05 Nov 2020 15:40:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 9sm3807472pfp.102.2020.11.05.15.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 15:40:46 -0800 (PST)
Message-ID: <5fa48d7e.1c69fb81.e56c3.7991@mx.google.com>
Date:   Thu, 05 Nov 2020 15:40:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.241
Subject: stable-rc/linux-4.9.y baseline: 153 runs, 1 regressions (v4.9.241)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 153 runs, 1 regressions (v4.9.241)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.241/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.241
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d69a20c91691be92364526ffb084d750e3e7f7fd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9b31259e67b1653c38101c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.241=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b31259e67b16=
53c381023
        failing since 2 days (last pass: v4.9.240-15-g726ac45a50a6, first f=
ail: v4.9.240-140-g97bfc73b33b5)
        2 lines

    2020-11-05 20:12:36.762000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff234 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
