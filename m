Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8754C1D349D
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgENPKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbgENPKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 11:10:19 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78B8C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 08:10:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s69so4372968pjb.4
        for <stable@vger.kernel.org>; Thu, 14 May 2020 08:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3CxmvlJ8Sv2R94vXGEpM8e6/uagnUBjZtSaC0RWG15g=;
        b=mrE0hzDFATSCtga0U0qFPaSjxTGYXTRFtw8KjjhnnulgWwSRAWDDcyCvDWySupsNhm
         Dqh7nTeslkzfcG7/sPmRDoZdN4gaUGAe+1fnEdE/a0RA+hp8T6fYzzsNPlRZGgQAG6Ko
         k2vmBs7+R+qKID9d/BOe9P6ztPu85htmRJYbE8TqgGPBS70O8EXofpyY69/Nh7V7mLBi
         oHvxCPIH/4b6tcXLYV6Rl5t7ZbSV+Hc33VUqM9Ig/K+G4BjuXuEmCXQvBPkHiXSc7fgq
         QprudBT102aw/yaRdsTMQx8LqeJ/WS3HrNOyw8aShJt9IP692ZudLNwyWCc2pvRhbmo+
         GP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3CxmvlJ8Sv2R94vXGEpM8e6/uagnUBjZtSaC0RWG15g=;
        b=QSY8OWM/AsR14DDP3T7m0tRXrAgYlaQb3121AAeYLY/Dq9QGJHLyrdbdoEtfK2+7rd
         fS4KzqE52xy5PwBlRC/5q+1pkKHGwnaX6w3+fEINzFyQFZYGw5l8Ib2Gn7QzzDrSwXet
         hU3/xYqqXBem1BkXCtJHH9quViqFmME/MYTK7SebyEPvKs3mNR278clnGgYB0oeovcxW
         XGzkzuEzX4ZA1lcBWh/M5D9oFnnXBrnIjQ2A7h0bolJU239qZMGzPa14KyYIozfMbWgN
         Npp0ZYxP1uPLH9rIDzkG2gUpEZifNTmXuJnsbSeKpRPhcwkuKTsrBIQqYTElVEZEIWum
         S6eA==
X-Gm-Message-State: AGi0PuaqX/vRgFu8FMT3FpXcgXGVSYLKe3MWMlgRM0hzr/R6dD0iS6EW
        BXYLTZS+hzKqUC1Oo0fR8TNOFxbli38=
X-Google-Smtp-Source: APiQypKIyIthvaZFHSqLcwgBpT4siFHgWbkMxCXAVfX7L6KM4xfVTtidN9yJrfPeyXDmJwSOnZjFow==
X-Received: by 2002:a17:90a:7a83:: with SMTP id q3mr41696574pjf.162.1589469018867;
        Thu, 14 May 2020 08:10:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g43sm18575388pje.22.2020.05.14.08.10.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 08:10:17 -0700 (PDT)
Message-ID: <5ebd5f59.1c69fb81.5b1ec.1aec@mx.google.com>
Date:   Thu, 14 May 2020 08:10:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.41
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 125 boots: 1 failed,
 118 passed with 6 untried/unknown (v5.4.41)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 125 boots: 1 failed, 118 passed with 6 untried/unk=
nown (v5.4.41)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.41/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.41/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.41
Git Commit: cbaf2369956178e68fb714a30dc86cf768dd596a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 77 unique boards, 21 SoC families, 18 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.40)

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.40)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
