Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964C24C180
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFST2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 15:28:10 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:34549 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfFST2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 15:28:10 -0400
Received: by mail-wr1-f54.google.com with SMTP id k11so488560wrl.1
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 12:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vG8w1Z/lSHfwBkac9XIzJ9r5L39O4POevoNFKTmz1MM=;
        b=k+9+MPCOLzFZ6SMUoXNCKdYcQSuKVgCAhCqJcZnYJoYIXYnRCzeVgOAqYLOK2LyIYH
         wrkE2cDxz0Z/IQ4JdSuoVPMvEMAumEuHsiMs4XN6H+1kTKf7DpjZ41VGXHzwCUVme5s1
         IYRtLImDlQ6deeraow3lQmOaPdgLKHC14AOINEgWQ023AkEDJzn26vnwK/VJLpxTFF/U
         8L5OLErRWRQDB6/Kd4X8oJ/M+ziQPnoGlxm5OghmirLeVO5EQvrKgovhqKUiuCLDQAvM
         s/kVPJrg5Y5RVb1QyOe06L4IRRyE1SkkvuMTb1E1gWFcbxGvmy0sDvgQwlG1Yx3APf+8
         +bGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vG8w1Z/lSHfwBkac9XIzJ9r5L39O4POevoNFKTmz1MM=;
        b=NPDSOYe8QbPTDq5L9xTGGXLnuSmeeHEGaFxDtUzXvtyB+2btU37lBcHXqBYl+tOcWm
         9mZa7pNEmzTu2pP67cm8TfJgHrduLU1A9XOpxmiTq6IgxTC0zbe1E9Qn8Gyca/9bXMGe
         x9cwY6njdY8URElP8+n7/0OuL+wokNt/vfIxBV4YgdNksXuo9wtG5iLQU4k7ONZtvakn
         Ckne4GIIi7gw+NJwRkM36M5KGA1yyTI3E2X1maxe1NdhsrEA3DUBWCWGIoGpq0ecoAd0
         C233a5NlETig6CyUNtiH2CoshfOR3r7otzVYDaqN3bsgCVAGPTlYAlTDBZnsYp4I+V6b
         sZhw==
X-Gm-Message-State: APjAAAWzyoHSrJtiiPA1LqTb1WFd0cFqtdDsY6eVWZMnJHefavlSBeou
        t/JPW+MN2EcPWoj2n8uyfXj/v9JOX31IjQ==
X-Google-Smtp-Source: APXvYqxXpaIxduwuxfOz13T/A8Uecrck0/OhziMkpti6GVqvCvPlyfy5c+Hrx3HZas46LApfJ9X53w==
X-Received: by 2002:adf:deca:: with SMTP id i10mr33492699wrn.313.1560972488314;
        Wed, 19 Jun 2019 12:28:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a81sm2544375wmh.3.2019.06.19.12.28.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 12:28:07 -0700 (PDT)
Message-ID: <5d0a8cc7.1c69fb81.f4905.e23c@mx.google.com>
Date:   Wed, 19 Jun 2019 12:28:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.53
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 120 boots: 1 failed,
 119 passed (v4.19.53)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 1 failed, 119 passed (v4.19.53)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.53/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.53/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.53
Git Commit: 9f31eb60d7a23536bf3902d4dc602f10c822b79e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre-seattle: new failure (last pass: v4.19.52-76-gd4=
86e007abd0)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-a64-pine64-plus: 1 failed lab

---
For more info write to <info@kernelci.org>
