Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A001C168CDF
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 07:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBVG16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 01:27:58 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52876 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgBVG16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 01:27:58 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep11so1727339pjb.2
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 22:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tfvK8kzP2tfT1KB3TbEJVpE1VlJliP3PeX2jzAojTIE=;
        b=X04kPLDh8dFI0T9nFVkOAQcObkytcGWgCNqDHHUZFKAsMuuWJwobP8aD7mSGchnY39
         UT2NTn5rjwYdCgSjJtQK05diYI32Se7usEaxhFsUUIoR32tyXlTSPQv+nckemmo8nath
         Z3h/Vfd1kz1Wuij1QchyNv2vnZJ8jrt/Dy4t8KYy0K8XW4LcjvwUIPTpO3cELU1hotAo
         qlTwQ4cqBFFCcb4054LyPXsQRRI3u5VMCjnQgkA446ZTZvVQPcnk5cAzxqQ21vABNttP
         xJe62OxVPL4bwky5zWvt0Z4w8g6QNWH+JZMb98ee2STMb8Eyr3ykgPHiUbfXtQgRPr7W
         EuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tfvK8kzP2tfT1KB3TbEJVpE1VlJliP3PeX2jzAojTIE=;
        b=VkCxQacaVsefIXB3q+hFOEKRV+yJdTBiseqsivZ2owMWWYBYW/rVxvgyqvsfiGI9U3
         9td9xvB1yMKGyTqBT5AgDxhD9npywBQ8hMeQJVlGaXgsLmeBksuIkHg37DcU416ZZEKZ
         uSQFwgWuYWuVpc9RCoKvuGcdWH4ukjkB67yBIGPF7MWoEfd1sn2fsCe2Ew+a61QF6+XZ
         Eb1MGrD4gXpWBqfXV7fRur5KybFX5nwkOvJqLPPXUU9JP2vUm11tI+jmbR0HVKqjsQUo
         LySpbry8gmLN6uYM37FHMBdrkGTjd1KJuyvqIY4Lyz/+rkTEsv5L+mwJOX0j/ij9YnKU
         LWAw==
X-Gm-Message-State: APjAAAWGgDAsxEHoeGXlLAq1so9AXTXtT/O+WTU8bBSol4H5T8oMXCLL
        nEfaVY99uZF8qXg6YonH5M/7pSWjv50=
X-Google-Smtp-Source: APXvYqyCIfKHWx8ZG3MQnD+jZShQqgo+kf9y+wKxQ9Yn3WBI8iHk1wOcF8HVqwGWqhtIPAc9LupfEw==
X-Received: by 2002:a17:902:41:: with SMTP id 59mr41515188pla.39.1582352877692;
        Fri, 21 Feb 2020 22:27:57 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm4998252pfr.169.2020.02.21.22.27.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 22:27:56 -0800 (PST)
Message-ID: <5e50c9ec.1c69fb81.dd05f.f754@mx.google.com>
Date:   Fri, 21 Feb 2020 22:27:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.214-119-gb651de82f0d1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 11 boots: 1 failed,
 10 passed (v4.9.214-119-gb651de82f0d1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 11 boots: 1 failed, 10 passed (v4.9.214-119-gb6=
51de82f0d1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.214-119-gb651de82f0d1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.214-119-gb651de82f0d1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.214-119-gb651de82f0d1
Git Commit: b651de82f0d1632e20519b862c0f85f0543773b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 11 unique boards, 6 SoC families, 7 builds out of 131

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
