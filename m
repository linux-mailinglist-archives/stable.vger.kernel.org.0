Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E546689240
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 17:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfHKPLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 11:11:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34855 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfHKPLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 11:11:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id k2so16650835wrq.2
        for <stable@vger.kernel.org>; Sun, 11 Aug 2019 08:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FMo8OZ+qDIDqJY2hCvoNdWLJraWLAzcCL0l0Ua15JM8=;
        b=fLuY7gvQ+EbYwIRbAgvF8BBK5bsQ8YRgvO6MVcwei9idUjVb1CdIz/GVu/kS6FNN78
         OQC4lPCeaTEkIW43VBR7n++Mir3AhTe9juoQo4qYLUcG9NfZt8Q04s0dbAC1oAj/8Lzc
         6LccXqRTzI2VDZvIDR5Pe9Hyilp9GOwbbJvALz9NqdYEMFI3pQc1qNpFnNoK9fN+17QM
         yysAHOXG+jXjgcB+bxDpRWyf6BGlothUTIgpjgqcUpWLcjzGSzoR4lhYp3JeTcTIcQVk
         maxirNnUEH3EB9fScNby7CgUo5lGRxKbqnYewNknwraoSts4+2SkbbAhzKxczifw/h6Z
         Br3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FMo8OZ+qDIDqJY2hCvoNdWLJraWLAzcCL0l0Ua15JM8=;
        b=ldN7d8KikpdN0Sj2gcb8aTvGLKPPDqWDAB9LqptQ/kxKEb2gAdzTfqD5JOigmxvtEv
         +OVTIyaZPaW01+z6s6nuW5HtIQuzc5Juftdi0/BvCfMEtxfvfgx2zUTkhkt7B8YKzQ5D
         LKn7vSzJpJ85TpA8YdxdAgijUtB3o5ayyaZl0mtt8RDiWrWUAMZzKEWiL2n2HywGsWTN
         44caWj1iD5mxVkCMTju1ziflYfdRvNFZxRbFix2cY0qeVhnBf0+8WOQn0DsvjsfJjQPL
         jXL+tSWFoabZVzwkKIY+91fnyiKb7uQ3jTEHgmWmeIMxbD5BsmXRUwA34Y5d2BDirQUD
         NtVw==
X-Gm-Message-State: APjAAAVuYz/JUqRb1sVE4mbrTQ2K4B52BgMh/eyJEXjqOchCtKDcSGzq
        QTxJRUn17EuA6FCPPtHqJPv/Krv5WlE=
X-Google-Smtp-Source: APXvYqy5q1IXmdWVKg6j4xgrWzWIh7R8hqSSXOQV4YABnvoZovQTOe1psgvRjZSeGhu3/JWdN7EKFQ==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr19759152wro.31.1565536283357;
        Sun, 11 Aug 2019 08:11:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o16sm14351633wrp.23.2019.08.11.08.11.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 08:11:22 -0700 (PDT)
Message-ID: <5d50301a.1c69fb81.256b4.adb3@mx.google.com>
Date:   Sun, 11 Aug 2019 08:11:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 46 boots: 1 failed,
 44 passed with 1 conflict (v4.4.189)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 46 boots: 1 failed, 44 passed with 1 conflict (v4.=
4.189)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.189/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.189/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.189
Git Commit: 3904234bd04fa7c40467e5d8b3301893fae16e87
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 10 SoC families, 9 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
