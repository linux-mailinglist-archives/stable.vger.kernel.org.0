Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C3DAB96C
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbfIFNjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:39:06 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:45160 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbfIFNjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 09:39:06 -0400
Received: by mail-wr1-f42.google.com with SMTP id l16so6587327wrv.12
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 06:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PMoORLvnq399f0E47C3CWqqtdUoONf9mVExUvUImGhc=;
        b=DuSmkWhtoNembndhPiE4L7AakIMcMHF2X5w/8uDbbw5+vk6eNq2J1qSmXlH+LPt6jw
         e3XXgtPTqOalHPFTfWW5m5/8E7gdpigc61OOjOsKQTIUR37hJcBUTHQKJccwn9947N1x
         3lHjOi3m2ItWD9xP8Snztg7ZCv0od+8pp6bfpBkyssX7K1j3drL/xOEtpBxqpRXjaj0m
         bHrqiz8e/Bx5vJ6py3z6QiWeeIXXnXUiLW3ALQ6jdkJh/CU+H9S0AJg7zqdtWniltBRy
         tB9tZXGKY4OETEF30ukCLNlTSo3r0AiVMOHhB44uEkU2F1nLzG5nKM86okqwIU7u4r19
         ZlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PMoORLvnq399f0E47C3CWqqtdUoONf9mVExUvUImGhc=;
        b=RErpVghSt7yEL2ARhN4MUzy36G6gvxRWMCg5PCJZlzYZYw7tRnIU9dBvdgN7igdRBV
         vim/ipBfxe0QPtfUvDoswWoXLYUg8c1GQje9iYKAVUwSVcWV5roN6ZlXQYwApqKXgu/y
         /HkJARnt06D1n2ShYL2Ozjfu0B6zeKX7foa9MJHMmJI0ZdCP7jBN37LS0eEpFYMEUlp5
         e7u4x18R4tnbnNucCG8ijMzGwNrr9WP/0uXlgjiC3wU4chyzHrqsLS/o4iH0m5Mo/kR1
         5MhLbAwkSM/4DEDYTT0llizngcU3BUJ1xYgzUUBfgDqpgOIGEwHNwcfXTQG8rluidTMJ
         dXGQ==
X-Gm-Message-State: APjAAAV9CRCXaFaSIeOIDw7tWj2luKuBan0h+pWyn1eH3O5NOD7Ew5HC
        dwWp5bZfxPJhrL5ptU39G/oTZJaYLI5I4g==
X-Google-Smtp-Source: APXvYqx2D9bFCZwJby3VFaruMSpOknB7/FH97flSCNVCcWPoUDIYVpU1dH4y5+M+OUKg0H3VuBCQ3g==
X-Received: by 2002:adf:ee10:: with SMTP id y16mr4803292wrn.47.1567777144419;
        Fri, 06 Sep 2019 06:39:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y14sm8672387wrd.84.2019.09.06.06.39.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 06:39:03 -0700 (PDT)
Message-ID: <5d726177.1c69fb81.52ad.a63f@mx.google.com>
Date:   Fri, 06 Sep 2019 06:39:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 78 boots: 5 failed, 73 passed (v4.9.191)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 78 boots: 5 failed, 73 passed (v4.9.191)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.191/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.191/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.191
Git Commit: bf489db05ebf7106dd77f79e6edabc45fc318416
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 15 SoC families, 11 builds out of 197

Boot Failures Detected:

arm:
    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 5 failed labs

---
For more info write to <info@kernelci.org>
