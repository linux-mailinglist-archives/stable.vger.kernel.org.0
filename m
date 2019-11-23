Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BF4107E48
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 13:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfKWMDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 07:03:38 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39766 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKWMDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 07:03:38 -0500
Received: by mail-wr1-f43.google.com with SMTP id y11so8690348wrt.6
        for <stable@vger.kernel.org>; Sat, 23 Nov 2019 04:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IpZldZrTcgBazFanXxqGwkwYjt4agUU2DzX0tzXJI30=;
        b=b2KCblHTxCtA9U1SxTjhuaKCl06tVIcgHlapTtG6j9SPVlHJm3x9pWei43iRI1YcEs
         Kk+nBwDV3RvWiOz1cYOeRvmMCVMDc+4bAMj+kMtR+yFYS43SVFNnQQn/9x/P2/l2lHNP
         vLWtJxKPAe4RZ8shW6F7XvPgXbn9Lk6eMTDp0rUAH/IwHGfmeZ00uMQWYR5VnPXcFDJj
         DGMV6EXMVr0NZJpl+HUBoKjeYkcg6CAyLNgvHR/jf/tUsqUN5p/REr+VmKsrGQVlYhuz
         X4h4q3bl4He5r5b/XRkriSKZQ5z3p8lVXuXOrEmz8nVFEhWFaWbnnZ7OAAWsd6Mm8Eqo
         +vVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IpZldZrTcgBazFanXxqGwkwYjt4agUU2DzX0tzXJI30=;
        b=TrJtvjmhwTmjak9O4ZNLGGx/eUnPLJq5FruE+9RWxdNC1U2/FJnmWGlypuG8aqmxM0
         Jwk0ceZF2/cVMXtd7v+gqEnqpXediUKzH0p0+MqmxxJooSFCG61+rJkfdLKNslMTIDen
         OkrnhgdxOkfo6yHU+8kN2rDkdFC73IntGoSQox4+1Nyn+9vUYL84+uUjvH0CLhSc2EIG
         fWf9PQe8LVKltYrNJc94EgMVVYdftVTZO6j7zxkxITep+WJndrO7Aj88pQdy5fs1UIov
         1naAxw+yI8418kQX+/LQ4muGjBUW9V43xa4ui7An60iv5kMzIj7fhu5QJypG7gEoC9pH
         BJMg==
X-Gm-Message-State: APjAAAVLQs8yn9floNKAHclGFZc2ifH89Wab+iVkLe+EVvXk1aglnuSN
        NjyxXiA/kW8xtRZ19elioDY4jlX/oPw6Cg==
X-Google-Smtp-Source: APXvYqyqW5d2QLbxiEPrMcqYtMVXWn8g/YAgI4vFeH4IeZ/G7mFxBClL9zdGi5WghJ/IhP3cmXyUvw==
X-Received: by 2002:adf:f744:: with SMTP id z4mr22521393wrp.205.1574510616319;
        Sat, 23 Nov 2019 04:03:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v19sm2035221wrg.38.2019.11.23.04.03.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 04:03:35 -0800 (PST)
Message-ID: <5dd92017.1c69fb81.f9ebf.829e@mx.google.com>
Date:   Sat, 23 Nov 2019 04:03:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.202-223-gc2ff777d9ae8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 100 boots: 1 failed,
 95 passed with 4 offline (v4.9.202-223-gc2ff777d9ae8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 100 boots: 1 failed, 95 passed with 4 offline (=
v4.9.202-223-gc2ff777d9ae8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.202-223-gc2ff777d9ae8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.202-223-gc2ff777d9ae8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.202-223-gc2ff777d9ae8
Git Commit: c2ff777d9ae88f46236e8fdb9654a87b0468b28b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 20 SoC families, 14 builds out of 197

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            qcom-apq8064-cm-qs600: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
