Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6DC13AE66
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 17:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgANQIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 11:08:04 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52864 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANQIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 11:08:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so14473431wmc.2
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 08:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=holMBSQkpTmLMCjTyK8zdA+zz3eVSdks61I3Kf0V5gk=;
        b=ndUB6nSwP0p10rd+j/FPp9e/5edRU3NdFav+FmWm3RUJSZqsMcQSI+mgzpW0RgfsCl
         IKpgta1VmQPtaw3PSlkBB4tb4AChorx80ZtYK215rDDZkBUMJyfy96Qb5MB6ep5RAVdJ
         4rK1Avv+M+VZUhEOh0OhdW3lj0hB7OWNrE1qtajTNHLh8VgwbQWhPTIgPxAllsEFzjJS
         bDAV4EeKEYL5bdBqpJTV7uKay4eXZt4E8KNqPl7gzFtSAJ4iKpy3tzZCbB99naEkdacZ
         wfopCY1LxZwnx8xV4X6VbzWupKE+M0S8D/FLRhc82DgWif1rLChUHKJAIoTVuKJHGB6S
         qzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=holMBSQkpTmLMCjTyK8zdA+zz3eVSdks61I3Kf0V5gk=;
        b=H/06QFVE/sashMHPtIhIPMmWNrCQkhFUgRmBYfIKKavMoB/4EReugpZzh4efgFkTug
         ytAQB4w3zR2RaSTJZXp5tPIbeWPlWNnl0lXa4H+oZYP006lzIvCxEoPdWxoktKF+Svs9
         IozSmqDgxzGqtvKZljqIq6ZflVhmfm0OCZ0Jy49qoVTytmmviGiucvOzTZr+ILe/iM2i
         rEP9Q5iSo33MxzjcUYlu3aaX/G2qNoaus+tCaFPWw5DMi62Ic75UmfPclP3J0LTEUWp8
         97WqVFjCIadCehB9zPT/Ky+g5sIhCm7A2KlOUmGiJPj0mohbohA5UrOA8TEqHLFrbfE5
         Rvlg==
X-Gm-Message-State: APjAAAWw/BtXaUZF0MOq3YKJuhGg8dpYCoZU60i1GkC5AIucHnJTZBQG
        65xucyVdEGiM454/hCIBv1+ly25EC96wcw==
X-Google-Smtp-Source: APXvYqwlhBsIsOeTWQADZV0azC6Y+ogWfJxpvCuSH2ueTXE5EmWLLZGEOPizkPweS2voX3B7oBPiRg==
X-Received: by 2002:a05:600c:409:: with SMTP id q9mr27861654wmb.19.1579018082072;
        Tue, 14 Jan 2020 08:08:02 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm18977490wml.31.2020.01.14.08.08.01
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 08:08:01 -0800 (PST)
Message-ID: <5e1de761.1c69fb81.8716f.0334@mx.google.com>
Date:   Tue, 14 Jan 2020 08:08:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.95-47-gdfa0afa6c984
Subject: stable-rc/linux-4.19.y boot: 88 boots: 1 failed,
 84 passed with 3 untried/unknown (v4.19.95-47-gdfa0afa6c984)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 88 boots: 1 failed, 84 passed with 3 untried/u=
nknown (v4.19.95-47-gdfa0afa6c984)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.95-47-gdfa0afa6c984/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.95-47-gdfa0afa6c984/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.95-47-gdfa0afa6c984
Git Commit: dfa0afa6c9845af29354433fb8c28e08f11733df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 15 SoC families, 14 builds out of 204

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.19.95-35-g2bdac5496=
636)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.95-35-g2bdac54966=
36)
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v4.19.95-35-g2bdac54966=
36)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

---
For more info write to <info@kernelci.org>
