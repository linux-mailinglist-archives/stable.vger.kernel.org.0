Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC91107CCE
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 05:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfKWEeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 23:34:06 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45097 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfKWEeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 23:34:06 -0500
Received: by mail-wr1-f53.google.com with SMTP id z10so11005941wrs.12
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 20:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MlkSmCDR0tIkLUcNT3Xkdux3BkqofRtk+EqIUUZYOXU=;
        b=E2xGKULYiKzui+lv0g1wlxJ3CnAoWFQbeIPmN9MipUslUduTD1Ll4zDmztEmkRSQbQ
         GDXxa7VQ6kXGnADy2TDvwXCbNSk9K/HzBJ0QJ8E8LJ792BEptXIbGHGyeCDRiId7p9hM
         jIRinbifAvv8wD2ElNyd2SdCuQ33jvAth8zdzdDN+3TcuyflEA1xe9S3nD+nB5Ldhqhe
         4G709IAMfSk6n1BUwKEXTW4/DrxzmWU9AINHdp6LHq4fUGqAUbxc5VCnqkDPMkC2oo2I
         GsgaRUCiOb0ezEkEO+5YVWToUouBQ4wd2d98TxyzSB9zDQO45Gw3uKBKGlB0OXAHLOT2
         Umyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MlkSmCDR0tIkLUcNT3Xkdux3BkqofRtk+EqIUUZYOXU=;
        b=Yu17h43Oc+o8ZWAsfsfFafrqAGVGf95rb7sx/OSsICdnu4dXOAJ2izANkOgTfxp3wd
         zSbIMgYgSH1XyPKvSvg0VX2XaO0cUvdC1NpWnb73vgz48GF3jsiwEP1GP7NMPbeUV4aS
         ukL8a0WQIVzCPMgvTKSqqXIAne7N1h4LdMPZTZ00fNm4rPINycgTN8FbhiADzNHLrHcQ
         Q0sim0GvQx42pbWqSG0jOW5JUE3H/7+HJAJjeeDC93ZAsEsY2kSFPfHro/vUzhPH5WEq
         Z1VzPpgVKyoql5P6IUbyHNxa3uRj1uCf4nXTyuac49nxUSy5gt3VmL2/lFO2/OaduB1x
         N63w==
X-Gm-Message-State: APjAAAWvgjA9hwDk2MX8wOyyn2wsaA/jRwc8mfzaYX/2VLE6ACBgwOP2
        Mc7+fMcxhJpal87bzMxwNeX50qW8zNNh5w==
X-Google-Smtp-Source: APXvYqz2DLp2a029SVcbSAIHPDBpjJc94tzuqNMf4sY0iJo2mG441xBJpjhBP2mzrdBvULuEDSkSUw==
X-Received: by 2002:a5d:6706:: with SMTP id o6mr20738638wru.54.1574483644114;
        Fri, 22 Nov 2019 20:34:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o189sm517505wmo.23.2019.11.22.20.34.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 20:34:03 -0800 (PST)
Message-ID: <5dd8b6bb.1c69fb81.3f48f.1e7c@mx.google.com>
Date:   Fri, 22 Nov 2019 20:34:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.85-221-g2582c18680a8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 100 boots: 1 failed,
 94 passed with 5 offline (v4.19.85-221-g2582c18680a8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 100 boots: 1 failed, 94 passed with 5 offline =
(v4.19.85-221-g2582c18680a8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.85-221-g2582c18680a8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.85-221-g2582c18680a8/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.85-221-g2582c18680a8
Git Commit: 2582c18680a83bdf438bc174d58fcb026bf366d8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 21 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.85)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
