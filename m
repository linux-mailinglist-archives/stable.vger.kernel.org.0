Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9344F1571D5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 10:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgBJJgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 04:36:52 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39610 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgBJJgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 04:36:52 -0500
Received: by mail-lj1-f194.google.com with SMTP id o15so6315297ljg.6
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 01:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5PgeW19XRiY2U6cJ7SIIC8yWYuGaodH5j8A5zm8r+RI=;
        b=MWTK1nQvvHMG8FI9w3d3mFARNXbfYHxZJlhX0AfAhsSC0d0Aif3dh+COvZxGp2v+QW
         i56w/WgajszMeWuR5kxn6i96onU+F7qIDV4mvpfsgBaQ/EGdq08rp17JR/jOW0uZiK99
         u0cZjGSh5ONOuc2o4zxJm8Y5x+PcdJ5JsHwzoXSAhMdeMcwTJFvpVyl7e/AeZJEUPibd
         q2fpaWLqK5/jlEoW+5NU0QvR70Vzj7BAj9T+qBjdmqf9qI9o997WKtYp4b0gplnhffsE
         V14qw6fY3SZzWgVu+IhNGzrdvdYgzxxB+P/T8hG91vxbo0ibvVHa19FPwaEsAaMpojJW
         0ANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5PgeW19XRiY2U6cJ7SIIC8yWYuGaodH5j8A5zm8r+RI=;
        b=igEE8ASD7cD+/aNjDA78zT5Rwa5rrBoJmgOLLn9QAPGN3+43mjJyH6F+3hfqZRqhcm
         tllDWiL4yj6x2zx7q+5E5BT5WgF+nYxNi3iRBaa9iz03V3YWX1MV/Z157SI1sPC54sYW
         cOOTzz3DaUt2BJ3V72hWkCYSfvbq7f132RgZ/TKlKW51ZkBNVXO0QA3M3fIApVPo2a8h
         V+1dfRJwKMw4elSnucVOGRfumbqbwYHmITir0q2IWDsBoXbT6SjxM/d+4OtBSYc20faz
         PVvXGbqcUVzGpK20zIqq6WrJFYEsoa6eMW7ao9fuP6CXOf0//pzAuuNurLK5vN2mWdth
         19vA==
X-Gm-Message-State: APjAAAXpRVhnEEdAo+0Z6SoTAnJp0yo+gkojmcB9v4l7R/5fuS0FMNWQ
        2edCt80ZsFv0mhRfSi+hTDff6FJ3JRU=
X-Google-Smtp-Source: APXvYqwBHBv4xIaDAWCngEGPvagvzXNZP7OcVvD5uu7PdYuSNTonPAGoeyjMeMwN2YSKbR1tSNc6Pg==
X-Received: by 2002:a5d:4a0f:: with SMTP id m15mr837718wrq.415.1581326947454;
        Mon, 10 Feb 2020 01:29:07 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s22sm14285512wmh.4.2020.02.10.01.29.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 01:29:07 -0800 (PST)
Message-ID: <5e412263.1c69fb81.d4595.de8c@mx.google.com>
Date:   Mon, 10 Feb 2020 01:29:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.18-310-g0b7e0557aabf
Subject: stable-rc/linux-5.4.y boot: 137 boots: 3 failed,
 130 passed with 4 offline (v5.4.18-310-g0b7e0557aabf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 137 boots: 3 failed, 130 passed with 4 offline =
(v5.4.18-310-g0b7e0557aabf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.18-310-g0b7e0557aabf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.18-310-g0b7e0557aabf/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.18-310-g0b7e0557aabf
Git Commit: 0b7e0557aabf00c5080165d454fd6081e869b968
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 95 unique boards, 26 SoC families, 19 builds out of 167

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.4.17=
-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.18-307-gdb=
4707481a60)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: failing since 1 day (last pass: v5.4.18-307-gdb=
4707481a60 - first fail: v5.4.18-309-ga4a7eef3f918)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v5.4.18-309-ga4a7eef3f9=
18)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
