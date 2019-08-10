Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3351888847
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 06:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfHJEzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 00:55:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54714 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfHJEzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 00:55:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so7521322wme.4
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 21:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=TE626OF7ps8WUE97ci/gUNr7eXf/F0v8GP5SopSyxTM=;
        b=bEbzX7IfVmi8K6vNHJOg1p25J/JLvZp3rGh5BwJGMbzW9nFnlkb/PmnubojvT10Ocz
         fChJwpgQ6dyBzpC0kcSkjeR/TsYnCnBhASXoLyZvB8TLSSR//uzWB27x29zqQoHWOvV1
         mBG5WF5QqgWHzrFxb/qOg5WKAhubcPnVpTdzT6xAxI/UZDdej2K0FRhb7xxRJzzbZP1+
         atxsiW5+mGnbT34fZzO5Dfkb98RQIKkEoHapMKAsjzWLzqYlWKaIHn/NzlO8ea5igeza
         wH69iHGfCY3RHDYA3FkdZCr08NMTUZK/xliVXhpQ/zj4peIaufIvBUZb8JsmH5P+mpLg
         2SbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=TE626OF7ps8WUE97ci/gUNr7eXf/F0v8GP5SopSyxTM=;
        b=PPZgMBG7v+vdhoWdyQENnUii78/4ztMl/yGIXTMGV6SnimABYD4KcVImS9usiWKfJw
         q4qlE+NsvZIY+7aYfUBe1OKikZB9z9m8nHd9zB2cEyE0GQAzt66xK+zGXRocgsJCorYf
         NNm2mioDA/CZcWF/7CGgSShULUx60Q7pITAtTbkYY8317/Mjtxi2d1jUaJXY9r3t7XfM
         PAIRSloReeUxEHk0zYEuMrOGzZXgbh6E8UmdrskyNsIuCvqrtqbEocKqaXco7WVMOOBj
         wu3bVe20MLkYoSvLkAGytmP6OUplfONlaeB3juc9M6zK6X8vn8SHHNn1pXzHQGjssZGD
         O8ug==
X-Gm-Message-State: APjAAAWLwwhBXJiXQxbZZDoHDy+DsBoSl4S5gRQINWLcM5GPsksYaVre
        1RSf0cdtP4oFBJeeIcJL+tnnNA==
X-Google-Smtp-Source: APXvYqxj+JMvZqc8AusHuH/lSHy5yZakb49sY3YvORpfqScSd3J29xuNpE6vfiZADF4DXgAkywe2Og==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr14573628wmb.15.1565412952353;
        Fri, 09 Aug 2019 21:55:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r4sm65023221wrq.82.2019.08.09.21.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 21:55:49 -0700 (PDT)
Message-ID: <5d4e4e55.1c69fb81.a181d.c016@mx.google.com>
Date:   Fri, 09 Aug 2019 21:55:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.188-33-g260869840af4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/32] 4.9.189-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 0 failed, 90 passed with 12 offline =
(v4.9.188-33-g260869840af4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.188-33-g260869840af4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.188-33-g260869840af4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.188-33-g260869840af4
Git Commit: 260869840af4f3d7b3b46c4047642a931535c196
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 196

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
