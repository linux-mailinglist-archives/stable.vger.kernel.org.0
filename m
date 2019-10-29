Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408D0E89CB
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 14:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388702AbfJ2Nlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 09:41:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34524 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388604AbfJ2Nlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 09:41:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so13728694wrr.1
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 06:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WzC/rKAbLR0JzwhY3uw0zaCrhsiUVDMHGAq0oAK7wBQ=;
        b=lNM7pYp+lCxu7p7RdNi+eMETqCfBKh4+9QQ1j1n1B7FWXnTbDuAupSCEKynWh7kEGd
         5mVqzv9gXLjLpNOAeupk89pzLGEhhfQvVJUYS8t+E756CFSBbqXTbrZGsFVR/7nfcyml
         Pq1mzno9o3eTiMjpf03cd+dgdNtu+jO+UYsCIGLP3zENNx/myc/R6CsJTfPvDeOT5NlX
         flxbqBiDoI7Ejuo4/uWe/pzul+DiUAv4A3fk7WEm+PMSHtEnOsYSZJjzwM3DT96gEVrl
         sG2YKAbKDkzwCfTUNjDwrTJIXeW4u8oL9qMJABWshnyuLv9BV0yCygnzGZtX5PaHDq1P
         5XKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WzC/rKAbLR0JzwhY3uw0zaCrhsiUVDMHGAq0oAK7wBQ=;
        b=OC/FcZp6VmCIO856ZMkEWHROdT42NTNs8sW43wjDHk6HG1Xb9NOFRl+WLyWMhdXBGk
         vLvpyQg1CmLVtSRGpYcq1wm5FniW4XlHd2Yc0wdDNHk08niUV8lVhn1c5KbInD/sbWmk
         xoGAi8/vqHoleKPlu/1Ct/f5WwcmC7gjN6yt939Q6J+vBoNRcDcGjsGItGH9RyuCQV4+
         JHP0DQ2I3HL3RIvf9LQmJX37NVmtMQac3ZS4hqsxQnTBCOhl9j67cG9qohS/zw7VVsdu
         ZWdXg5cdKVVzNjmi6mnaWmxg3GWEkfUgTAHUFfG4LlmCxDjrKQCIyI9Dn2+Tf12FHmPW
         0wLA==
X-Gm-Message-State: APjAAAXVKgYihNBzlkqxCuBym5kKenSLIJeKhULStqEy0qanQyr1levd
        6pJiXeDPJTl6+NlxOdrdg+wMUxoSdeR7Ag==
X-Google-Smtp-Source: APXvYqyeAWAU7rEpz7Hr0eSN3QfO/rsF6lwXFmugSgAq3QWnFfw/nHmLVHldTrYrVE2qYDENpmQqbw==
X-Received: by 2002:a5d:464f:: with SMTP id j15mr19944162wrs.366.1572356513057;
        Tue, 29 Oct 2019 06:41:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm2834359wme.5.2019.10.29.06.41.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:41:52 -0700 (PDT)
Message-ID: <5db841a0.1c69fb81.120c1.f2c5@mx.google.com>
Date:   Tue, 29 Oct 2019 06:41:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.198
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 47 boots: 0 failed,
 46 passed with 1 conflict (v4.9.198)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 47 boots: 0 failed, 46 passed with 1 conflict (v4.=
9.198)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.198/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.198/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.198
Git Commit: 9e48f0c28dd505e39bd136ec92a042b311b127c6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 12 SoC families, 9 builds out of 197

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
