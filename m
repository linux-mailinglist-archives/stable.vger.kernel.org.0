Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137C2114A9A
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 02:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfLFBs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 20:48:26 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38718 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfLFBsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 20:48:25 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so6026294wrh.5
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 17:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o69krFFR+NSwbeQsUR98vwYUeBGOyB61BPZUwVKrJ0k=;
        b=uiUhPZQftlk93r24uTkn2J62sGyy6qPIW8bi5419DAh87LxtBEfxa8WANOacA3jOvQ
         PU1ywJlkriV3Ao5WPPj4qJfdiGqGfKKUijYnAZJUQFe278KpKbWA754fwIoauQNvtEoX
         L2+W2ofTj4ujeKjTGFsNKlVFilnJK0eSJ/QvcFlxlmRoxrHqCwNwJq99rOgHlqZFp+bc
         MB5XpP24sMHHeytVbR1RpDwHkGcjehAeHbv70XMrYaZAfegzoHEZ/leD8cctqYm5tnzN
         rhElPuPOnffnkzhvBLFHnPhBSXaG85Rku+HoNSg/TwQchXKlzUtEFijxONHSi/ZsJvza
         Wusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o69krFFR+NSwbeQsUR98vwYUeBGOyB61BPZUwVKrJ0k=;
        b=HuPHxJACTZE3CJSlEGF3cyMUzNPHbieUk+cvanx4NhZPVmxJuthJ5Vj0T60cfJlBQ2
         tiICkbylRvbTgBYQQj/Z24WhS/8kdaOQga/mu01fJ56gfMaW6EVqyzXxawI/wUWMe40i
         IZd/GuTA94vhn6ggJzR+SOFr8YrEPuynlSiPGMmbXFhZuYOwHYmDTBNGKUtdCltNxwfo
         0vT4U+AghhS0fDU8OREz7748S0Z9xUbq0khU3Pznu5p5jewGL00a8+XC0NwC519syRBZ
         zlzGwgPQKTFMB120OmWnb9TvqRaVaAoRpsqZTnx0RmXwVBsqq8SoOgzqx6L3U/g4EPeg
         Xquw==
X-Gm-Message-State: APjAAAXZeK3w9Vcp3uwGuxGrWZXjGxDGbxcwS3K+WLN5MMGkJavBDejR
        SDEgv5Zf+mL5n8p+4ZaPp/rizYRVqV/HCg==
X-Google-Smtp-Source: APXvYqzma4BRx8QcCmzPVsIwR+hJUmj5Y6uPuf2KJXq7m1EACH8AWWwtUu2Wmx7tuNnnFWM45w9btw==
X-Received: by 2002:adf:9124:: with SMTP id j33mr8257279wrj.357.1575596903554;
        Thu, 05 Dec 2019 17:48:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j12sm3690240wrt.55.2019.12.05.17.48.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:48:23 -0800 (PST)
Message-ID: <5de9b367.1c69fb81.2478f.4bdb@mx.google.com>
Date:   Thu, 05 Dec 2019 17:48:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 137 boots: 2 failed,
 128 passed with 6 offline, 1 untried/unknown (v4.19.88)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 137 boots: 2 failed, 128 passed with 6 offline=
, 1 untried/unknown (v4.19.88)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.88/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88
Git Commit: fb683b5e3f53a73e761952735736180939a313df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 23 SoC families, 17 builds out of 206

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
