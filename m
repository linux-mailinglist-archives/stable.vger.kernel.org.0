Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014B657C57
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 08:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfF0GnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 02:43:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45837 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0GnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 02:43:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so1075209wre.12
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 23:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/uwN+RRhActg6ttNauasLhOCoeCxn4fgQUb0xHwTc0s=;
        b=xrHSA5NoAEJD9Z5HUy1Y3ec85LlNoqQJL2PxpTpviE6nQJjiEaHZ/DXbVK3ezW5H8v
         aNektfeWU6uKW4ZBsO2C2HDYdsFUYfBRU7iiNfJYaWjFTgvP/ts32VsPlgNI5IBT9TYn
         AJKpAhYAPDOwNPSzyi9PxSp8hXmIktRrh/y5DC7M4dekcmDUhXCRqFpRQbnB683oDHws
         vi6+HYAz3bTOi8gtilmuUOGz4KSIrkec052V6Y9pWRbWRgCyduWPfAMnDtHsnwSEb9uk
         5awy/5LVVYVaJu/mayCDE/MumZp9Yle6QTRPXbnxAYZBO61cfOWdDNpSfT6S/8P9N5dN
         /2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/uwN+RRhActg6ttNauasLhOCoeCxn4fgQUb0xHwTc0s=;
        b=FYZm6sFZpcSoKoWIp8JddastAtRfRYhdBlERnoV3kRFl0MDWXAlmVeCawxGpkuk71l
         7AAqHHfu6jg9mFP/9nqw7/u1MEpc8MVa7/j2cU5ZbLpncsKSwObm3/grq11Wv2huVrry
         00Gncn9p3bwwWJv/OvwlM8kosLKbPhzzz/jFWhUPR5BynKLKeBCORPmE+kVJUQ4ea5FH
         qgE9TRnCyeiykDxIxnje/uRqPnNWmHRGsDW3oA/kHCjf+AW7ASWgBYfHEiES5sUSMxU+
         bId8uIjkhVWIS64RJe+mn3bG/K8HP83Llpt1XVg4StR1Rv0ZqnFxQ2HigPmUHR3pjpTe
         BRRw==
X-Gm-Message-State: APjAAAXxc1TAkfyKmYWZEuGbbHY7tmdfWR5cA9DNb2kCb3sTqaFDk/C2
        lrrZ5CoR3ytOLGyd/uyX4Yi9wWqfTZdYZQ==
X-Google-Smtp-Source: APXvYqwaeGn0FY+ZKEAEU2G+YKMtCkyOL2fEFlrpUjnLrCCJHd2R1xrzWBjPICCg6QjlgFUSSZ0zMg==
X-Received: by 2002:adf:c614:: with SMTP id n20mr1698311wrg.17.1561617796743;
        Wed, 26 Jun 2019 23:43:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm3295325wra.75.2019.06.26.23.43.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 23:43:16 -0700 (PDT)
Message-ID: <5d146584.1c69fb81.d16d8.f681@mx.google.com>
Date:   Wed, 26 Jun 2019 23:43:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.131
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 68 boots: 0 failed,
 67 passed with 1 untried/unknown (v4.14.131)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 68 boots: 0 failed, 67 passed with 1 untried/unkn=
own (v4.14.131)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.131/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.131/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.131
Git Commit: f4cc0ed9b2c72687303b035379c5824a02224354
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
