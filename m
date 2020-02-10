Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B173156F74
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 07:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgBJG1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 01:27:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56015 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgBJG1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 01:27:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so8456365wmj.5
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 22:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uRBUJjJSrIUJDTrQyBGkSN0RI0bgKP1dWI+1FVHML2Q=;
        b=S3jDgtKEg6xg30wCuDrQT2ufJihyEH9Inq8unbmQ91oi+tLZ4/dheJLR0QOkdRFL/w
         6G3QfHqO0v26Hsvkc4ytFxeuIUTqicxyAbFsHK83mcpCjXVcWXUxxfpT1smi9OkAgKL/
         xMGXEyEgVLN3MPVK378LQOYlnV++SStlzr4/5OKc0Pxl8s6G3lzKDyhdyqnnvFEGedV1
         7QcwDVWwEiLyT/qjHGOdgysMrdnWbjw3K0xQzsWY5IyYHFVKHGJBFL0GHvvgF/L4vc8i
         WbSyP/OczVXRPGrjQWpGmS5Ug68rSB1e7dme6gfKzdYJqKVLfsmjRtTBFB8SRvryaXGm
         iydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uRBUJjJSrIUJDTrQyBGkSN0RI0bgKP1dWI+1FVHML2Q=;
        b=eb8cdx9bovMOJuxfLjdDKOEC22KiZdZw082Af5d+uaG5+lmUW5vdaNTBjUy1iCT+kw
         L8NtRUuOuTrlsk6mqrdv152IvcOQdbRQK0ihJ9i71remq9tBhNTVSqBG+4dmJwXdhVhJ
         hIIupXEbibUyTFDjWAnhyDmb+Em5ExdiqnbXYjWReOXYzvNJH+xqqCqob9Vfh9cPGLk3
         9ZlPT/cojyFvtHw6Kb5gL+lIE3+/RQ2QlF54ckpjtB47s1EBSEyC5QGhIet+dsc/MlCX
         NI3nmzPl01RzKpyFuZZE+ocG2v6Z4ywfXkRe2L7PUmiwqfDw6VctZRCABTTTSydPIWEZ
         vbPw==
X-Gm-Message-State: APjAAAXHB+Qr20d8R7cHLR71PKLR9zv2aHCgrgBzsNDpfQwS9jwETGJ0
        HE8VxDR3cLaoY7vLXTB/wdW/rT1u5K4=
X-Google-Smtp-Source: APXvYqxu1aL86anX9TpkUrDGRoGphWqjPoFjeOwvKKIfTqVnK08euk9NwfLVMRF9MjPbgaWecltsmA==
X-Received: by 2002:a1c:dfd6:: with SMTP id w205mr13797707wmg.151.1581316030644;
        Sun, 09 Feb 2020 22:27:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c9sm14034946wmc.47.2020.02.09.22.27.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 22:27:10 -0800 (PST)
Message-ID: <5e40f7be.1c69fb81.58d87.bcec@mx.google.com>
Date:   Sun, 09 Feb 2020 22:27:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.102-195-g27aadf011414
Subject: stable-rc/linux-4.19.y boot: 57 boots: 2 failed,
 53 passed with 2 offline (v4.19.102-195-g27aadf011414)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 57 boots: 2 failed, 53 passed with 2 offline (=
v4.19.102-195-g27aadf011414)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.102-195-g27aadf011414/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.102-195-g27aadf011414/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.102-195-g27aadf011414
Git Commit: 27aadf01141497774aece9bde2d44ff437f6fbb5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 15 SoC families, 11 builds out of 136

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.1=
01 - first fail: v4.19.102-96-g0632821fe218)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.102-102-g=
77b07d6abbd2)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.19.102-102-g77b07d6a=
bbd2)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
