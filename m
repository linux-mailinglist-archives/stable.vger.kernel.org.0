Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268BA133E86
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 10:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgAHJrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 04:47:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40411 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHJrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 04:47:49 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so2620689wrn.7
        for <stable@vger.kernel.org>; Wed, 08 Jan 2020 01:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=07M7i5djMSzJsbsfkG9IM6eUaq9Eq2xHbesq3jiEG14=;
        b=WwNUWOLOSY1W6kx1yUAvmgyGes7hiQqVzAybJndqTMzSUEV+MURGpgYc5yOJh1BQbA
         joKY5T5weixcciniH5j3zpys/p4wQvCiBCvbXtZkyrWryQEyQOwdRed2RVu/Qt+8VZfN
         6W0WgS7vIjqgu+t37EfMsBLnL8OSti9k/blGQF5pKXAY+dJQfJjN9zr2eA5/JVcCcJT9
         vfa+IBlHi6oIINwP29qpfoUhDep+GSxDPS4ydDJHijkSGd6nKGqwIq7gcdIpYH9ja4tl
         EIR3GFvxAVqNQcoET1vduvIeLxIfo2wZJgCZrqlbioN+fI3X7DwHA/bTt9vl8aql9WlH
         Tlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=07M7i5djMSzJsbsfkG9IM6eUaq9Eq2xHbesq3jiEG14=;
        b=S+ksEDgIPVqWVntVZWbKSpD4CF+HHqTDSttGnJJh4rRo0FPRm+5SMR3A3D/X148Zg0
         dyWti/UbhzVVfiDUkdw0EPyU3x6tGn2cLfPeXd5b8MHukIzEF3qFHtdpgSeJl9GF76qo
         nWUdi9a8AbGZyRdl+9i0dHnjE1+jHorenoEM6fScu02BUANOBzWfRiiOCyTbtcN5vrwH
         41sJaO0ICUL/wDWDDb2nOTDluz07OJ0U1vmMGTqt3m8z+9eJyodQ7D7tLGCVi2//nK6w
         VSPw7hOAzerajQrlDNFkq7CuwnVCQ8Iw2M6DFv/Wjg4Q2rgDE4Y56k1ilU14+vBnMrlD
         xJIA==
X-Gm-Message-State: APjAAAWzao1gA70e89+9ad5NghzJeGoD/3ug82+70+koon9lUjCZTlb7
        D4yU+DFh9/tXparrUwFVtj4BhFyez2O5aQ==
X-Google-Smtp-Source: APXvYqwGXxGO2WJQvwj8J8TiDjKMe1Lz1jKld02yix6ztXkbJF/NzGR+24GGoT7qrv4NP9WmOrRagw==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr3379573wrv.144.1578476866754;
        Wed, 08 Jan 2020 01:47:46 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b17sm3533784wrp.49.2020.01.08.01.47.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 01:47:46 -0800 (PST)
Message-ID: <5e15a542.1c69fb81.a689a.03a0@mx.google.com>
Date:   Wed, 08 Jan 2020 01:47:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-229-gcf22ed3c3fb5
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 73 boots: 2 failed,
 71 passed (v4.19.92-229-gcf22ed3c3fb5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 73 boots: 2 failed, 71 passed (v4.19.92-229-gc=
f22ed3c3fb5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-229-gcf22ed3c3fb5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-229-gcf22ed3c3fb5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-229-gcf22ed3c3fb5
Git Commit: cf22ed3c3fb53c3276a4c37ee1df4c4fec412ec0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 15 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.19.92-198-gec409c057=
7a7)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v4.19.92-113-g2=
686842f2160 - first fail: v4.19.92-198-gec409c0577a7)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

arm:
    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

---
For more info write to <info@kernelci.org>
