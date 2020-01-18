Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587A514157F
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 02:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgARByA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 20:54:00 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51329 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgARByA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 20:54:00 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so9141409wmd.1
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 17:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nLCLYP4m29BC21GzgvoIP7+72Z0xBlG9XApjMJE/SE0=;
        b=zt2LuP8dpmPzzDacgEKPNFM3XS9507b1kjk2khLbeZC6VyOq2TDhJNgnhLVvvQiMLq
         HVgNONJ/A6ATKhSxNWFCG7Yz72VqGyK9EKRuE/DM6308mxS/ACREAIJTeOWkLX+ASlGw
         G6U6ksR/0AzPZ+16Sd2e7KA26RC5AutDYsNCdDZAQDKXojRBycFBIQ3f3Abb15WSjpHp
         n05r+hcAjjI8PtyafIgNT8qPlNpEZVxact0BQZObOuUEEKcuyrUIJwZdds1zErnD19nE
         AyYkZOwpxQN+akHoN+qgP5TGaazYnqznkFX2nIs4vM7FTP5IPbr74Tf0zqv1vVvjMfve
         cPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nLCLYP4m29BC21GzgvoIP7+72Z0xBlG9XApjMJE/SE0=;
        b=DohxxnYSpLD1k7sHf1hPSlyxU2/ukiDp+lRIVIUordpQWY0nxPvVrViry1YQROcnTQ
         WuqHzDGFaSKHsG3UAtJGAZez4O8ApzsB/kyBVDniU9dgVxDztfa+oKwbZMzD9zRjQaH8
         xkDBFncIr6+TovhLoEGHDjke429Y00JBcEN5P71JLbgPBKbfu5xtZ2kBJWFvgi23d80U
         6Wi7nExW4EuYgWQbayYXxs//q+47hZMjkN3hZvWs2w5pwDKBtfwUJP+LOwX/w57K20yn
         hrjYRzCBD/GMvrw7nDC7Fbejoz2b43Mxks9K0tEZmbWVGYQ0OZxgY4XkD3A12HfpaiTl
         b6tw==
X-Gm-Message-State: APjAAAVUpcfRFEWTHDIlR7MJkNeN97dEFQeXh+2GQVq5vxG2xGbzjMCp
        tgeW+Po3rQmvipaAn8bjpvk1QXKUMhbMxQ==
X-Google-Smtp-Source: APXvYqzs5UlQHEjQArJlzqljmcWjxR2+0rB5J7Yvln5a5Bd48wLzEL68shJKHxCEG71bQwXbYn5kew==
X-Received: by 2002:a05:600c:2c50:: with SMTP id r16mr7280209wmg.74.1579312437773;
        Fri, 17 Jan 2020 17:53:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c4sm11846480wml.7.2020.01.17.17.53.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 17:53:57 -0800 (PST)
Message-ID: <5e226535.1c69fb81.9b4f0.f1f0@mx.google.com>
Date:   Fri, 17 Jan 2020 17:53:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.166
Subject: stable/linux-4.14.y boot: 68 boots: 2 failed,
 65 passed with 1 untried/unknown (v4.14.166)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 68 boots: 2 failed, 65 passed with 1 untried/unkn=
own (v4.14.166)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.166/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.166/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.166
Git Commit: c1141b3aab36eb0d9b2bcae4aff69e77d0554386
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 15 SoC families, 12 builds out of 196

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-cubieboard2:
              lab-baylibre: new failure (last pass: v4.14.165)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

---
For more info write to <info@kernelci.org>
