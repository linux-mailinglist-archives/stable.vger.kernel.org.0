Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9731747B2
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 16:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgB2Phe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 10:37:34 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33160 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgB2Phe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 10:37:34 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so3127736pgk.0
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 07:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y39QbgGZuvXDWevRqTV4vlmUlBgQHBo8qm4AcIiuTPU=;
        b=jfapLRElrzPHVkN/Js7X20+LRhWmZXzEt+xOECM3WVsJRgiTnyXxAbs4Uh7UMkhhLW
         n9WAMb/YOiFBZLtsvShklUo75r7MJ3aGS7M9u7wGIk3E84+5SzssUYT/flJvg1Bu/BTK
         Mb1rvHzcDf1HY4fbp52bq48XLjh0Qj7WLpoO889+VXT0jaH+0fK6RpzXcbEFPHP9dwHM
         pXTUIfh3dAZbiPn6kLdt7CdPnF2Ta2XG3laEQuNiXyldIzVyOofCd/Ryvd4AhWxJno3G
         D2JxNwoQ/6O/jySritdAo1yEzqYMcwfpqWOLaDh+nD0oOYYVph25i/CcgrAGKX++TtHH
         wqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y39QbgGZuvXDWevRqTV4vlmUlBgQHBo8qm4AcIiuTPU=;
        b=tnXo949f4VqxZ4pGNx23I73eXt8B90Ao9V3etEVpUvn6PwpCia4d8vP+aguhLwQ60d
         GP3f591HIzfHgSOu0Az9tzuY6RBmSHCGMwTGzSuGxP6ubuJoornUvQUTWYk2ZF+ePJDC
         +53cX+rUc0jSebDvUlu2SgZww76RvUhywTMdydrqPFmN1AYDSD4LyiVpEMY2EMXh27aR
         w6cYPioeShGwKPsp3CUJN5fjJf53gfbWsNLDWtEDYZnRWeZAr/koqJrd1XqexwdQai/M
         r66NSKtO9qKKdva+9Ch/t/dRS5KpBH0vcSjgZPwsUn5Sjvd3CLS/PnehYJYVJadmx+tr
         zBTg==
X-Gm-Message-State: APjAAAX4lN2gZll5Iw5sAFxGHuoc94r1Dvvja6omwQ+zcS/flUaMnyyj
        yFSxR4+i+K7zUuCyEthiwvFM494cdgU=
X-Google-Smtp-Source: APXvYqzv6s8AoerjKt+fob3XDhqmhOtTQ5WbStGA2owKjJgdNNI9tUybAeSjAkItHAChRwp4TqDnEQ==
X-Received: by 2002:a62:6414:: with SMTP id y20mr7720735pfb.161.1582990653041;
        Sat, 29 Feb 2020 07:37:33 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y197sm16230741pfc.79.2020.02.29.07.37.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 07:37:32 -0800 (PST)
Message-ID: <5e5a853c.1c69fb81.15e02.9066@mx.google.com>
Date:   Sat, 29 Feb 2020 07:37:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.172
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 30 boots: 2 failed, 28 passed (v4.14.172)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 30 boots: 2 failed, 28 passed (v4.14.172)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.172/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.172/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.172
Git Commit: 78d697fc93f98054e36a3ab76dca1a88802ba7be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 11 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 36 days (last pass: v4.14.166 - f=
irst fail: v4.14.167)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
