Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA42F1259F2
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 04:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLSDT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 22:19:59 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42189 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfLSDT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 22:19:59 -0500
Received: by mail-wr1-f42.google.com with SMTP id q6so4417489wro.9
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 19:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LnXD5r3hFH+MEUtjx4QBE0EEvoehzCWexnsJ/7LZk8E=;
        b=Ze0++QssmrwdgGZdwkiBOYWo/q5WNvNM0WgHgDfBrSDOcaOE1bzXMMqo+ZW+SaADdc
         hCiGx6A79l98DqPkMTv+Od61242XX9IyNNFTEYgsoGtVBkKa8Ot6sTGQ4Yyi5uJxZgzS
         tuO4mqH8Z/vgBGcZnsVpjUwZZak+WXHuQKJ00ZrAHr9E5wht7+cTzj3FmgibmAL7B4g5
         gX7vY/50/6q1ql8fVFXGlb5A88So4TnwAd+9ESAxpRzy0Rr1r9TYUvaDINAbVdezFwPr
         cLJxjTnz5RVUVxIQoS6xMyg61aRj1gGO+9pDr/oe5k1NNU3HTZu5gX/4hyllQGMBy99r
         hY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LnXD5r3hFH+MEUtjx4QBE0EEvoehzCWexnsJ/7LZk8E=;
        b=NJ2Jn0/bCL71HDziEiFm9Zo5AWiGr8wgpIkEVR2DBg5tO0uLHmXbjylPBLj6pZT0hH
         bL+beB0C5mGcseSOfiCfF46Ge8Bsh0Pt+ysuzh+mqNL8BThzSdimccrsq5v9aIhN0P5H
         TDFZBTOzFLSemntMUHUhN+Kbvbw4Bg3OW8Ag3TZ9Uazv28WhGYvDzb/DNjLdD12NvTs+
         3r8AM6xV3VhYsl31MOh1+d7stfbQuTiJP5MK11wAcX7KQlb2hkn4SPyzq/+x1i0AEgut
         l2VMSb8c7QgLaolhkrkpFFUKi1TBv9+BUrqNczbCnIdZslEELRXxhQbTleAedd/Rn12B
         OhAA==
X-Gm-Message-State: APjAAAUiYFousa3jwTlC0ufEuAATnlUv3b+hOvn1+sH8wIPsOxurnbem
        t8uXQVLqpizjYgCvVORJimucZZxwDQCgqA==
X-Google-Smtp-Source: APXvYqxrEt09gorCdp/sGXhZhoHLecqPs7s7bLSdk+PjKdsB7erswwsLnQirWgA+M9tFZEPtHZN74A==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr6872924wrh.371.1576725597154;
        Wed, 18 Dec 2019 19:19:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 60sm5036416wrn.86.2019.12.18.19.19.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 19:19:56 -0800 (PST)
Message-ID: <5dfaec5c.1c69fb81.b9e99.8fee@mx.google.com>
Date:   Wed, 18 Dec 2019 19:19:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.90
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 90 boots: 0 failed,
 83 passed with 5 offline, 2 untried/unknown (v4.19.90)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 90 boots: 0 failed, 83 passed with 5 offline, =
2 untried/unknown (v4.19.90)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.90/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.90/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.90
Git Commit: 7d120bf21c05cbe30a679f0feeca884eeaceb069
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 20 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
