Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0391D5C611
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 01:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGAXyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 19:54:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44157 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGAXyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 19:54:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id e3so6091314wrs.11
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 16:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=06m+tXCyIgH7DqrW0JRau5pjmZnizZhljSywY3dz7G8=;
        b=KTGs6KA/jvt1hLqvbsAHLIqY5QuceemWUQHc7ojtMvLfljHOP6zP7pxrp+go2oD1o4
         VuIc+HmddbAeDg6j6/gmXyHWD4DTrXAbbIrU0QqD8rZf4hnmhF7yiO25oR7k1SG+qoOM
         qKywQ7IezzcecO1rHb3almSIrCkUtWVa6kAEjTZGe/+cgU225GYZZ318BN6wKULrIpp0
         uHUsk2cCy/Blhmb9HyxkfKNqk85VaFQcEWy8QtW0QNU6j69Rmlkqb56IPbMupLW4uIij
         EAj8wTS69YS8GTCjF4QhjOhv/IphtkBjbcawoUk6L0p9ksN2b/SNFwXXvSsCkUq0YbjC
         Q5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=06m+tXCyIgH7DqrW0JRau5pjmZnizZhljSywY3dz7G8=;
        b=WlbMB9ldvp+A9lnNxFWRgpV7kMbdRBHlWjshif/DkpGNBD3sVbUttGP2IP4uvNecB3
         0VNlQ8wuslWPT7nI1lNpGYwTP8RLWDE50/P2b4Vi3qfFSRenlDHo1mUnjKdPwlamKU1w
         0tZGOQKJ+M+YTAfatCA0DrUCs2pl7mNDqfjT1+Jw/bGQHVoWXvyy2z2kYpIcYhShn5KK
         ZUO4NFntJoHnq2EtgSGRpc8RZnm6jCFOWa17blBUPTDvsdjAFu8sIzdDXplPnrg2Epy7
         Xc3MDIlq9ljKDzzpmEDE7HyC+gHTLeh8XnBRJxguK5QhvEAwLOBpzh/816MtsdXEAJZy
         EPWw==
X-Gm-Message-State: APjAAAUCBKKM6OEnBDhzJ0nbGalz7LBl23UuO6w7I/XxrB1d77cCr4iq
        c91ago8fSj6f5ZUdk066nBqcNA7bqF0=
X-Google-Smtp-Source: APXvYqwBNGgxrahWzOMkntvPpmX8mWANAv0Fir5pSdoMJddj6XKxf0HzcD4gXeIYlk+TEvhwPy41dg==
X-Received: by 2002:a5d:5143:: with SMTP id u3mr20940483wrt.118.1562025260748;
        Mon, 01 Jul 2019 16:54:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y44sm13077921wrd.13.2019.07.01.16.54.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 16:54:19 -0700 (PDT)
Message-ID: <5d1a9d2b.1c69fb81.705fd.ec5d@mx.google.com>
Date:   Mon, 01 Jul 2019 16:54:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-52-gd067e35a398a
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 110 boots: 3 failed,
 106 passed with 1 offline (v4.9.184-52-gd067e35a398a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 3 failed, 106 passed with 1 offline =
(v4.9.184-52-gd067e35a398a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-52-gd067e35a398a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-52-gd067e35a398a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-52-gd067e35a398a
Git Commit: d067e35a398a4ee51e50535259162d4334aab5b6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 24 SoC families, 15 builds out of 196

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.184)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
