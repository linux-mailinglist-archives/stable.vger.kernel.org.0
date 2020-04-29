Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40281BD454
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 08:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD2GB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 02:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgD2GB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 02:01:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B865C03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 23:01:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id fu13so337946pjb.5
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 23:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kuE0E26/TX1j/2SBOAfvxO1uB/xBDMEJDA15lEegsGU=;
        b=yN+aysCEsTDL9AlkHTqB8VstN4LBU743/4oNXs3ybRrYX+EKMZ+ujW8PSZmoRZwpHt
         BSa+JpN419c8FX3aRzkjJXBrF4/ntv7FT/B+fpRvbXxVYUqqYKlxTvYMWmC/cbQmDSY+
         /e4xn+Zm7l9fvSsX1oTWlwKKvlg6wDIlHvvVOEOQhX9Jrf/ULxTeKLyaNqRWbCH1rpMc
         VSVw8XhdFr112rSBPEOVZcGypXV8HyHIh1+k5YQaoX/A4zLnXReTYdgyYGXtUlLVGcjZ
         LZIfhL+LEnSlTCt8M9KsG0xPPXJhAhLtpjOHqQ4b6OFW1U4rVFSNyRlWYKNycH7xk+Ps
         NB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kuE0E26/TX1j/2SBOAfvxO1uB/xBDMEJDA15lEegsGU=;
        b=GFet7R0ybjA5hM6UQaMdN7gnEu7HyMIiBKjgIeXHCR9LYZEixWBNptgjOFT/socfGa
         LmKkUR4PENRv+m3xTyIy2AxlrCULSK98UmQ4z3bCMS/+z4Rn2YaKW0dPwglqoUeQ/J9G
         lFIE+ZatGEkHoo6P1nCCX4C5Sd9FCZ1qJa607E/waI6M9vjec0QYDGPCgs1hoPK6EdFi
         RLGP/oTC9B8tLeaG5i77GOzvGvX1M5rPSwn+ab2fVZ5DzX7eUjxIzJLuobFijBoeCBXs
         cpdc/fZxqSlyjtYIhG358PCeLwdKGgfHlgYTeou/NcggI7MI74wD6ssxzqfcmKOaNxyP
         ymtA==
X-Gm-Message-State: AGi0PuaCwFzWhw4fc9HWk77nK1YtxChoJQyud7QhZl4/p3l2sUPGNQvM
        PB+yCQByZ53FJtJ7AUED5VzzwB8HjNw=
X-Google-Smtp-Source: APiQypJp9Zfo+OIMECDefYvi3aDlwFiC3dIdm+JC785XeWTFTEcWxc0W2XPimHPM0M2QNSI2E3vn7A==
X-Received: by 2002:a17:902:a40b:: with SMTP id p11mr33285603plq.304.1588140086104;
        Tue, 28 Apr 2020 23:01:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g27sm133551pgn.52.2020.04.28.23.01.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 23:01:25 -0700 (PDT)
Message-ID: <5ea91835.1c69fb81.bd2c0.082f@mx.google.com>
Date:   Tue, 28 Apr 2020 23:01:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.118-132-g3fc812d65db6
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 109 boots: 1 failed,
 102 passed with 6 untried/unknown (v4.19.118-132-g3fc812d65db6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 109 boots: 1 failed, 102 passed with 6 untried=
/unknown (v4.19.118-132-g3fc812d65db6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.118-132-g3fc812d65db6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.118-132-g3fc812d65db6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.118-132-g3fc812d65db6
Git Commit: 3fc812d65db6b5ad19f0ef548492a25ba2a276bc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 16 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.19.118-131-g9815485c=
f882)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.118-131-g9815485c=
f882)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 46 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.118-131-g9815485=
cf882)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
