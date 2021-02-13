Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D7A31ADD8
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 21:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhBMUBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 15:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhBMUBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 15:01:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1277C061756
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 12:00:43 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r38so1848463pgk.13
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 12:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5WNYS1WTlMpqmETfAep7vtFOgTIf3z3l3XtHuTUYoac=;
        b=zW4MdJuDouRVjHn97my/Om093yWMycPc9Fi5tWfiTp5khcdvVngC4RGpjf59wifxYF
         W2HLMek78dAuoHHG7jh1us9vRTwhOBstRCxgRwDfj8DSN0Lzdu77Pqi77hGt0A9EkwzD
         QZ/Zyf39vq7pKtpoxWWRSHbbMTatktosl2Zo1tIhhgBLwN5V7e+5v3LqiSN1Yar+2ihy
         /WAJxFOx1gHyLpSXWnuQLP579bv4HDYljvd3fJ4QNPXkOg3QkeicTDStSbdqYNaBZobS
         d63ddoGl+fQ464g4zLEezBH3GZB7rCDJS+1w7PJJuu0Evwvz8C/k7XhOeHhWNCbzEQwn
         Uo1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5WNYS1WTlMpqmETfAep7vtFOgTIf3z3l3XtHuTUYoac=;
        b=BB/t9zNAEe86u4X/qnwgdULnh7qENGt/zfeudM55y12pEc4keGhIQej4qhhAwnqfYA
         aV5hfCsjRErANiG+uEVFjgtdCjXoVuguCHg4zJFGr3PNZgg/ivQYVrxzRKtZn2kOVv0O
         fDandh17nYIX+SH/DY1SR1whrERsAfCP6XBYLYisVF+SQCLZFaHeoEop6LWtzBr6tPj2
         qQFWRIQt6kZOl3r6aKNJwhgaHYjL2dOgPdwBcBfzuzlo0ddjxi4qZdLf6jZjGlJuuBui
         wptjxrE7YqK5gGdkI875O+bLGkrDyUpemyey5CWjbXlJYkU74x6mcKppxIIH+8CZigo8
         YeZA==
X-Gm-Message-State: AOAM530qVGZyQx8+NwTl5PgHMjtEHs1/DnrtkTXdINqAc9iUL0oqDwy9
        6T4MnelPTEVCp8gHhv9WQp5+NL0B8pWcXw==
X-Google-Smtp-Source: ABdhPJycgYxips4guoEar957we9pby+TZ/oZyVQ9/MuzM6irBITVpUPFYYnBKQsyeJZ6cCH3XnXDaA==
X-Received: by 2002:a63:504e:: with SMTP id q14mr8560694pgl.306.1613246439594;
        Sat, 13 Feb 2021 12:00:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm11203514pjq.53.2021.02.13.12.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:00:39 -0800 (PST)
Message-ID: <60282fe7.1c69fb81.b22fa.8e40@mx.google.com>
Date:   Sat, 13 Feb 2021 12:00:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.98
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 90 runs, 1 regressions (v5.4.98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 90 runs, 1 regressions (v5.4.98)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b9a4104c902d7dec14c9e3c5652a638194487c6 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6027faeb1f7947610a3abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6027faeb1f7947610a3ab=
e6d
        failing since 85 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
