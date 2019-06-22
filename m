Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65404F754
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFVRAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 13:00:41 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35814 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfFVRAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 13:00:41 -0400
Received: by mail-wm1-f53.google.com with SMTP id c6so9439954wml.0
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 10:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vqIhDUNoBJtAvWGFF8zrXpSoGX3ANXfecjAtswHLWvg=;
        b=zct/U8wBJmo2thg7bDXbXhyJhhM+xGJrO00Vw5Aq8BJEHY2dq/GZROmMb1sqDFbyW2
         p0OJr1cWJF71XkB3DssPQrNz3p2Wfn4dhDKLLx0pDquaHfjugxSemlsOFJ9yMyoeT5ga
         IRbflUUvkEkSI8NReH5BLF79l4jM1nPj8TZ90paP3K+goH9qy7jeQI9gjmC0iwbSZV8X
         C8AzjwU/iUY+X+4x7o+4RxJP1JgJM1vehpn5WPvYtmvNEGE7OfewUg1q/wlq8v7fdnnF
         WuLZwxLpLKnxD3UJGo1Ndx3gmzpeFaZmn5Y4kvHkAAq3x+gYrFninY/FczpF4g9qDiPa
         b+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vqIhDUNoBJtAvWGFF8zrXpSoGX3ANXfecjAtswHLWvg=;
        b=is6qejLNLJAcmqk6mpVAGVphSsJ361rCJEB5/ELVK4JvVSpfL9Wn3ERNXVsultzxmM
         NbFZ6NrM7CCJPIOw6mky119m7GUhLcpoQ9Kjxpxl4N5cYb4SwwanX02Xq55mwMr63ixG
         6ty4wEZoa9dvXQt4BjJro7gO+3pHePFZu7nqC5WwneJWgWfvMAF9c0snMChIVYbr/7aO
         eLY8j/HpKyA6vKsHZ0om46iI0LgyROglUCHYy05QX+odvKmRuWAL/E5MjwvLkvTg7XQf
         5jbTAG0Hlo3f35WNJuBAqgTVVtjBUFsWT80KgT6/qxHr9RQ88OCKfxrmDwbNlCy8Mcvn
         A0EA==
X-Gm-Message-State: APjAAAVh5niqkamYQ9bg061uvsgudXKU2/rmRFmiBhV8c6q7HSirCj6E
        z24QNH7rRxpOnrjevI7mYsNM4pIs7Tn+SQ==
X-Google-Smtp-Source: APXvYqzBLUSXdFKlZOBkeWDQ8uwFWVKvd9vicP9Inev1yYsszskezs3XtSB9zxy0wXGeJJzG3Xyi7A==
X-Received: by 2002:a05:600c:230b:: with SMTP id 11mr8227526wmo.85.1561222839274;
        Sat, 22 Jun 2019 10:00:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b5sm4220024wru.69.2019.06.22.10.00.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 10:00:38 -0700 (PDT)
Message-ID: <5d0e5eb6.1c69fb81.6943d.5f28@mx.google.com>
Date:   Sat, 22 Jun 2019 10:00:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.183
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 115 boots: 0 failed,
 108 passed with 7 offline (v4.9.183)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 0 failed, 108 passed with 7 offline =
(v4.9.183)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.183/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.183/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.183
Git Commit: 72f67fd749dba12f6412b8d57e680b435c3f284a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 23 SoC families, 15 builds out of 197

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
