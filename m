Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F78C13B5D
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 19:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfEDRVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 13:21:06 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:40986 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfEDRVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 13:21:06 -0400
Received: by mail-wr1-f48.google.com with SMTP id c12so11753092wrt.8
        for <stable@vger.kernel.org>; Sat, 04 May 2019 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fVnRMo/Stn5BIelH904P1/8/E/mzSQjQHmrNrCIDKF0=;
        b=Tk5kdJ6YQQYC+SSL+sbvEkk6QjRTbZqeN4OlkGBla8GPk65mIGY6KBABA5Jz1e2dLr
         EltxSHRRAiI6AoA9xy/t57p4msMeFhkYy3wItIOyDqR7g67lu/1c57zNOP64f+BQAMlr
         b/6UEScbgP2ZwEvBu/syHR22Nfjb6Vs1isVBMBri0UqKKF88RMByTWVbEai2AbIPAd4V
         H1M3SFiBTRWstLMJpiS7X4HOOGXl4KfHcRlrXZdBgPR669g88kN3jU+eRPPgtusK7OoT
         hNuWjfZhjwJYjXFXVZcEkq+NI7s2VtkCeQMT1VlIuAu8IMuD5MtoXN7m/gYv+0EaPFHe
         bIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fVnRMo/Stn5BIelH904P1/8/E/mzSQjQHmrNrCIDKF0=;
        b=e72MgoIw2DM0qI8kYwQPRxxk2MsCUW6TtZzZfaMacX8ljz5UfRoMbRBcw+jmrvvtA9
         pNiJzm7PoJiF1cQYtPfu4f/b8mXWLh8aSjh7I/gvj/gjBfcgi0lvGAC1UCwpPvT8UhE6
         IMf150kJ4BbEcBOtwZE6SZwSk3JDzTyaLuahotrDK9iTaLXE6JlMLlasn+uHyQll9oMS
         OU4nMfVCsCs/wtDPP9VvpyORJStLrajRCR5RvmI6HuYoioaieWixvXSfTfmParDN6600
         k97UWF8z86SsueeyxP5Uu0ST76+9UeTTqKpiQA/UB2Os/GGIp6LUWUyUO3yJ6OS1L+1O
         IsfQ==
X-Gm-Message-State: APjAAAVBANymMCR8GsHyKMAj45km0ZHVlIjSrLac8xmq/lqxoPV+4d/V
        413AHhxOAGFkA/hE9+iHMP14fFiTN6g=
X-Google-Smtp-Source: APXvYqxO3eNcp5nHap3mQQMhjBesy/ljn5g3/hZHBat1ajTJhKV5Et/KJ3xgDSkwc7YPwr7DjMjzsQ==
X-Received: by 2002:adf:f349:: with SMTP id e9mr3217501wrp.71.1556990464433;
        Sat, 04 May 2019 10:21:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d6sm3824218wrp.9.2019.05.04.10.21.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 10:21:04 -0700 (PDT)
Message-ID: <5ccdca00.1c69fb81.8a6c9.3cb0@mx.google.com>
Date:   Sat, 04 May 2019 10:21:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.116-2-g6a60e13ec3d7
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 123 boots: 2 failed,
 118 passed with 3 offline (v4.14.116-2-g6a60e13ec3d7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 2 failed, 118 passed with 3 offline=
 (v4.14.116-2-g6a60e13ec3d7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.116-2-g6a60e13ec3d7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.116-2-g6a60e13ec3d7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.116-2-g6a60e13ec3d7
Git Commit: 6a60e13ec3d792233fabad80f8472958fdddc6f8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.14.115-50-ga=
4aa5bff0752)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
