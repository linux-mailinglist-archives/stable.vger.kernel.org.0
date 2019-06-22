Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0634F866
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 00:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFVWLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 18:11:16 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:39014 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfFVWLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 18:11:16 -0400
Received: by mail-wm1-f42.google.com with SMTP id z23so9779330wma.4
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 15:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cutpM5qOo+itfxFwDNsxsBIAnL3/PxRa5J+9xY7dryM=;
        b=JjCBOJNG0liGbLUOib496asr/K6haE1962ycJQb9V5uWMTYqc/0vXJuukcqU4mr/gG
         YSq9ian4GC/6Az4jY7a/aUuHwPh1zekhfF5m16nia9UVevPcr7yponWuGo6KdSSmNEaD
         yxTHpToD3nSgq2wZku5PAcigkoO5l8ZwT32BQre1fIm0bPnfiLxWouOQQn6EZXq8l5+M
         S8zxvjlA6MBTi3+v+REhjI/xayQer67FY0WJU9/xzc3FCbFxEPR+2QohCbbQY4dYc1yf
         +ht7OgowPy7Lls+5NqMUDdb6cMuWIm+aUtjkF15BU5fcUV4dTsiO5x/VD5YOmOOf2x8m
         DwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cutpM5qOo+itfxFwDNsxsBIAnL3/PxRa5J+9xY7dryM=;
        b=tGRxDN9aOsX6cxwuWMKG64tWdP17JAHNQpPjTr4bcZfpJwR4yklyylKTlXF+FLiQUm
         OrU6XLv0tKMXfCtFzPUJa+LSRwmWeComL9cGOsn+d6BmegwtJc1UzQHH519lArgWdeCt
         sI8HxeBQ7knd2kGp8QFItB6PIpqAa3Lz5tB/daG/PRQQHBH58+J529NbsWO2g9E2kx7l
         7V+9+LOfKuHP0Eg3xzHxrf5Sh9YY4dK4Mk9OLR1siXiNLoxgRwsF5rngZLxAq0GMG2oc
         AahsKELJVw91Z+HnWd8V0rH3+Ca6zg68qm3XX4VcUpa8ImkrPnCPcbRhjliiTY2w9DPW
         h6Dw==
X-Gm-Message-State: APjAAAWc3KGwPrNX3TZVs9x2+k3fdYoSLcBzjj0hcA4wsvQvz3KxbIij
        RCQfQ6CG5BPA7On8ACPMlxWjUAivZ+o=
X-Google-Smtp-Source: APXvYqyJKCeAVJW3jjaiZ/8COCSaRIhsYYpkbygX8B+k7UZ8X90pOZyDJdJ90bC+zbVIJ8THtUPfgQ==
X-Received: by 2002:a1c:f519:: with SMTP id t25mr9210342wmh.58.1561241473646;
        Sat, 22 Jun 2019 15:11:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y17sm10619073wrg.18.2019.06.22.15.11.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 15:11:13 -0700 (PDT)
Message-ID: <5d0ea781.1c69fb81.b385c.bcc1@mx.google.com>
Date:   Sat, 22 Jun 2019 15:11:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183-3-gf30fc8fc02f8
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 104 boots: 0 failed,
 97 passed with 7 offline (v4.9.183-3-gf30fc8fc02f8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 104 boots: 0 failed, 97 passed with 7 offline (=
v4.9.183-3-gf30fc8fc02f8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183-3-gf30fc8fc02f8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183-3-gf30fc8fc02f8/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183-3-gf30fc8fc02f8
Git Commit: f30fc8fc02f8384b03e0be7ea8f503f4e41f1526
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 21 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
