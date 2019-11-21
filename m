Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED509104746
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 01:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKUAKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 19:10:01 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38525 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUAKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 19:10:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so2135875wro.5
        for <stable@vger.kernel.org>; Wed, 20 Nov 2019 16:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K2XbJErydaaHbY9ztKeJEU7v7GWgOtXIGrmGSVTLtzQ=;
        b=UC1uD1fV+2K6cU8/0/wm/2bARBLXHn742Sfhwz+KezPBAMcfXkqvU83ag3BA1ZDGDd
         Cr4sb208TS7YGoUJEUVBUkMEYTbjH0hq2co70BCP5o9XnNnUXJyTq7tPlxwUYgaLQR8e
         9rwoA6I1s7Hx82k9sbMXAUazB/khZOSl/SCdTc64sDWHTjdRkkj5Giiq5NJ7BQOW01Fx
         lUpxdX8I9uwdyBg0NmwhA5NR71zAFHxR4aB8dtVLeeGuYy43hAnwGvY5AJIHLyqZ2Uhf
         WGvLyy0HGV7qFIspn6F0bzxxMwmNrCongoWfxVIZwgpMOLR+XeiLPDqjQZ1vxfN3woFH
         f+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K2XbJErydaaHbY9ztKeJEU7v7GWgOtXIGrmGSVTLtzQ=;
        b=oSij4kE/p0lUBuHzvkoIEmsIX4QfefrO9XBwMWUPjI2ctbvbYlnwYyZ6qwtrFlMNrv
         thvTH9IhE7BwlBrkx4hL8BawX5a8+eSq+tcKIxzlhxZhS+s78UJm1Y3KWcZ8KHQ8SlQG
         es1svcrZoyA5qZAcxHzNH1p0KR8r6swnfA9cBRJlBI6eZexBy+3K01SVYemK5dqVPhtb
         53Zs4MvhJN2gCVA1UNSa2GN2GrXiijW9cbjPm+h11kSBtwuXYc1APd5MfMIG5RdPlXuP
         RidRbYYSe35nt6ALvcaQfMiH8uJoZzz+ySTeI3B1R8af+JUq5NtRy8G0MGGm0QOSJ9/z
         olYg==
X-Gm-Message-State: APjAAAWeMhAlsfUOdPFnQVKPbdUG3gJRWRsZW32pnp5IOyJmC8L/Gqun
        eKsEJBPya78vXGlNPsTiG3ldRhMJLLpIGQ==
X-Google-Smtp-Source: APXvYqzO2oH+T+hfFxN6nuIcjiJ39/0J3vFV8YKQaagkvIpnSaiCLhU32VHAXEA5KWZvtj9ZG9OJnw==
X-Received: by 2002:a5d:694d:: with SMTP id r13mr6636116wrw.395.1574294998856;
        Wed, 20 Nov 2019 16:09:58 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j2sm1069148wrt.61.2019.11.20.16.09.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 16:09:57 -0800 (PST)
Message-ID: <5dd5d5d5.1c69fb81.4d0fc.5adf@mx.google.com>
Date:   Wed, 20 Nov 2019 16:09:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.155
Subject: stable/linux-4.14.y boot: 67 boots: 4 failed, 63 passed (v4.14.155)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 67 boots: 4 failed, 63 passed (v4.14.155)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.155/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.155/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.155
Git Commit: f56f3d0e65adb447b8b583c8ed4fbbe544c9bfde
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 38 unique boards, 15 SoC families, 10 builds out of 201

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.14.154)
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.14.154)
              lab-baylibre: new failure (last pass: v4.14.154)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

---
For more info write to <info@kernelci.org>
