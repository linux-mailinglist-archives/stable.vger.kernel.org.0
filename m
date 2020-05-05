Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11411C4B88
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 03:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgEEBba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 21:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726482AbgEEBba (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 21:31:30 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6ABC061A0F
        for <stable@vger.kernel.org>; Mon,  4 May 2020 18:31:30 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s8so347570pgq.1
        for <stable@vger.kernel.org>; Mon, 04 May 2020 18:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vKs0EaFdBB+kxh8SmDzxW4DxiE1VWluAo8ftFu3RhOA=;
        b=kr8M0JhyFcB7jNArN5e6q+vHOMSgEX4XKPG87x3HdEdBOOzyk1tdPpLmwJZ5vr5sNy
         b34/PBZF138T3Nt//YRb2AvvSNoqHfXGtUIHwsZ515tTTcKV5gech5GP504f8v8bZkC5
         19ri6pm0LYOmAbirqheCkX0X/TXgZruWjp4I3uKqKuu6q2XmV5w2BJGpfKv4siPf8uN4
         BxEgMn732sjXwUlzwqeFXj0qT5Nyy1jLYcgH1Lhup3GL4tGrEHcQVBYNTS2Utir5o9zO
         JuljG+C26Jmzc58QMwW/KWdzq4HFyXeM6YBpH9FXfprGlNg81guNvInEh1pPUEOeD4Sf
         qIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vKs0EaFdBB+kxh8SmDzxW4DxiE1VWluAo8ftFu3RhOA=;
        b=E/hl2wKT4dhWDGHNuajT+LfZRSCJaYJgVNn4d2eaR64s460lvpFhRRy5sJA2gaJ9OW
         nG8bNhurKztEe66EQ3hdaRXR+0DXMr9Jg4PuG6BG0UlMsdl50j8ZRhXh3l+8vwGbyCR0
         pEvgUJNiJEQ1atBI1bDj0PTcIr+E0uWmpr+tYC/zCHQLyMRPqW/A7ebcsfjEscx4dbaT
         yGolKmBbcfLxl2umA3B1FXiAqCZvz3jhrL5C4/6T611D9k2NxxYSY0EeLHU5fCPgyHXK
         mRorRhz/wHKC7y1EjAY9zUSuxRY83ZhFn+H28Uck0Zm5xoEwBEyltUx9pfe74RDhSJJQ
         pWQw==
X-Gm-Message-State: AGi0PuZWfuOhsTC93XpSwHwydkQc/TUK4ciqjYGuK/gaUiiwyW5XKW06
        hl6WmGasteHhbBA1TerdMcCo3jqaNuM=
X-Google-Smtp-Source: APiQypK6Cf7Gz96HYHpbe73Qbq9IZ/8sybEnJghaLhLB5s04k/VPvFJevrK63lKvDDxf6TjN6e5/jg==
X-Received: by 2002:aa7:8b0a:: with SMTP id f10mr801397pfd.268.1588642288999;
        Mon, 04 May 2020 18:31:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u9sm309695pfn.197.2020.05.04.18.31.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 18:31:28 -0700 (PDT)
Message-ID: <5eb0c1f0.1c69fb81.b173c.16eb@mx.google.com>
Date:   Mon, 04 May 2020 18:31:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.120-38-g2e3613309d93
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 138 boots: 0 failed,
 127 passed with 5 offline, 5 untried/unknown,
 1 conflict (v4.19.120-38-g2e3613309d93)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 138 boots: 0 failed, 127 passed with 5 offline=
, 5 untried/unknown, 1 conflict (v4.19.120-38-g2e3613309d93)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.120-38-g2e3613309d93/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.120-38-g2e3613309d93/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.120-38-g2e3613309d93
Git Commit: 2e3613309d936ae445288baa881ca1775f300f6f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 86 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.120)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
