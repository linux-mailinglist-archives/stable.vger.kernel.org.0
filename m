Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C84F1DC1
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 19:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfKFSsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 13:48:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38333 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfKFSsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 13:48:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id j15so6609183wrw.5
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 10:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cOUdqW8N+bNPYe+yV4wpYDcV5nE+wSZW1N+1LA0KzPc=;
        b=O1nxHt0UWsTgNdZzkNRkp+4o1judZdLnszHQEd1VDx2Zt0iFXsWS69WVej4GO+SKCM
         i3rh8b9smerEyKuOuvNvo/hUUxFb5B3pY+JmiFf9aFC9bzRVOQw1V8WWc+lz6Eo1NZjW
         CRCRRBp+HXi/BeS9K4Tex6J5HJr/4Nw0PbWtvQy+nj2bhQweBXVjrhj0UkO7Y1tH0psw
         /YpVWGaYDyidS/5aA5xXXIp2Vg3DSj+GAxl8YPpMVaVkD4v0XL0jLapikPHBiE0+uR1x
         tnBQ5ZeoDjbFCcnkArLSTiHdpHMvWEwAUjxJYPAUgQ1T0IdoRBIEjoBaody8Hcus1JYX
         l1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cOUdqW8N+bNPYe+yV4wpYDcV5nE+wSZW1N+1LA0KzPc=;
        b=Oohvxt5dankW9Lw9Aie7EwuxF9ri+Tca3DOeVSjLNAWanIb01795rRE9BEh2/fDk1s
         D9ml+X8yQSt3PUVrN/+nn6nNqMh1aCct34WKWsXurWL3rkXD+jE0pXPSBQgtPTfripR+
         MsXrEhsEBwgWTROMMtWAXhFVBFxl6WqiSNLhmcFfE6DMflYwoOY77mrpEagj6T6nXXl5
         a/+cRJyZQ3/E6FFzDWGPOucCewsFtIz5tNOMWAqixf06JI5pe8jRoKVbo+MwFVjW738I
         72M88YC7DgX+aA4spIGgPQxLkM2824shFHrwKXMMnV2znK28BjDEZFeES5AX5RlVaYcP
         dR2g==
X-Gm-Message-State: APjAAAWd1PTHrlJ+AAJfX6XPQxhF0YicZeRvwnV9VRFx5XO2TkrZxxCz
        kVvUDjl33BL9m551uKH8aRbEN+EsN0s=
X-Google-Smtp-Source: APXvYqxRrRa7fp4sWOosBKNyXXQgNi2liYKhvrx+Izbq0kXOC5gziABPbJlLNHB6GadPiaTpcxCW1A==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr4184053wru.184.1573066079648;
        Wed, 06 Nov 2019 10:47:59 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x26sm3422161wmc.14.2019.11.06.10.47.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 10:47:59 -0800 (PST)
Message-ID: <5dc3155f.1c69fb81.b901.3182@mx.google.com>
Date:   Wed, 06 Nov 2019 10:47:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.9
Subject: stable-rc/linux-5.3.y boot: 126 boots: 2 failed,
 117 passed with 7 offline (v5.3.9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 126 boots: 2 failed, 117 passed with 7 offline =
(v5.3.9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.9/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.9
Git Commit: fd272dcd73353e737928d50497ec113fa1d347f2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 16 builds out of 208

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab
            meson-gxm-nexbox-a1: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
