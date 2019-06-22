Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6714F58F
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 13:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVLyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 07:54:22 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:37983 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVLyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 07:54:22 -0400
Received: by mail-wm1-f50.google.com with SMTP id s15so8943497wmj.3
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 04:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xtD3PhquXfAdFO5lInimGjL/gQBRbCKuG4OmWSC/+vo=;
        b=dxNwIZoKv5igAB8j6GPPFgaTOZ2p1kYy1/5oMt6jt5sJGDWZHjx+JIjHWBRu0Iw17U
         aFvonJE6BAcfO72U1wMPDvt3ZjgPpPoAXqWGH5G7jnRKgzrAJ5gAkL4lKwVnbvGDxDJz
         d+u6Gr1h8LJgIVH9ZfsJKKWyKQ2sQ3MKLgZuVetsTIywnr2XGDEF0aGlHUB+FN3c2GsB
         AXejLtU75aAxLCsBFtxqMRC/CZ7QNG2Lpa0myztCCRx87qRKJk3OQzOSo3ZEWw7egMTd
         TXao7vj3oT60jgZKJQC+I6zUXu8w+rC1/LP+eSIgQdtfOeoaHAzNWeGHkrMaKLmKfnks
         vDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xtD3PhquXfAdFO5lInimGjL/gQBRbCKuG4OmWSC/+vo=;
        b=PJ03xme7b5LSDgA0sRwqOhHG9gl557s6pS5ubCQqsQSERBWXaDRkvweJJeAcrDKp/n
         g31/DMB+VQVJbn4WPZK0MO6wtj4ALg+++9jhNr8IpoTUpKFdFy5Cikjvixi37RCxaqw0
         jM8h4EN+ixfoS7geaFIYmxLTOj1JNatg41mYAZPYRJQFt0/PoAkyWAPxtXvzxErNKRaG
         jVbQ18lyZdqz31qMMonN+0tSIUXi5L+8XNJAI7tHo6OTtFaCqa5811J6lfKK0IgLlR2l
         YfE8ETvFVia91f4v28z5mSC9z9Su5PtJ4qFrpM/S2o5XHavgR7NgGZPriPnrM3D2xiDO
         05ew==
X-Gm-Message-State: APjAAAVawNkEsf/BKlDIPE/aPn7pByHzY4Od4E2UgTFbDlqpgIbUgqRm
        0LzQ4IBA9UPAX7v2yt/d0WVc5aCdND9toQ==
X-Google-Smtp-Source: APXvYqzaS3OqbeQVcoWM2d5AhbDMYepW5yqKj+mBgNNLJoiYE1NMXRkA29Wst9/U9M7VjouTZ8ojtg==
X-Received: by 2002:a1c:f515:: with SMTP id t21mr8375692wmh.39.1561204460524;
        Sat, 22 Jun 2019 04:54:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p13sm4121987wrt.67.2019.06.22.04.54.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 04:54:19 -0700 (PDT)
Message-ID: <5d0e16eb.1c69fb81.b73a8.67dd@mx.google.com>
Date:   Sat, 22 Jun 2019 04:54:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.54-2-g1632ae94e030
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 134 boots: 0 failed,
 127 passed with 7 offline (v4.19.54-2-g1632ae94e030)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 134 boots: 0 failed, 127 passed with 7 offline=
 (v4.19.54-2-g1632ae94e030)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.54-2-g1632ae94e030/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.54-2-g1632ae94e030/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.54-2-g1632ae94e030
Git Commit: 1632ae94e030a82bbb3d60b63e3fc677a5ff95b2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 25 SoC families, 16 builds out of 206

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
