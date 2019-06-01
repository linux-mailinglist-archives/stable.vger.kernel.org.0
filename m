Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BE31891
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 02:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFAAEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 20:04:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41756 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfFAAEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 20:04:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so7542637wrm.8
        for <stable@vger.kernel.org>; Fri, 31 May 2019 17:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xg6bCkUEIvx4mLZSRyaOHFrUk3bc068ftfR8n0kMrEY=;
        b=OJdckJ35lBEbFyOOfuOTn0qeJv/fGtpsa5i4TNBf71lHrnZzp5KOiLi8ah69CbKA0r
         6Yhibp7Fyt0noyWeBqDaBtaVMcRWQ0AW90RNys/r+3lXTvG9MOAyqIi6Yt02iJSSMPeX
         e6dgjtbqdY92gZqG30veDLqjQNlER8dT+k9OczVjaHjWM00WNWyd1MooWuNETD4hMUSx
         666j7iheQY7c1T7DRwMF43m+BK/oEj1LCEz1KroBEeMiQk5xR2hAQFuIFl0XBssh/nhy
         q4jRqLwaidpzrUnhdc3ZRnIobKDaxmlXZ2RdMTH/qw4mTVo7lf8RNaCT/IzSHuW6S5Kk
         /CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xg6bCkUEIvx4mLZSRyaOHFrUk3bc068ftfR8n0kMrEY=;
        b=Kq6zo/YX5JwwMaAwKlha6dnfzE4ukcDx4SGu8xk5/qPd5hjWldSVK3EKOGsYKo9J5u
         iDlEhBnyhJVenEripOd545Jkyrc98Wzywt/ZqhXTHPKThU6OxsawSH9ZOoaghXdENUP1
         yKWezn0N5NwUfXyf3Cs/4G2Qjeq3GVDTgHVcteqwIoZp5oSAcnE2xvL5MUgeZb98N085
         8U+9hrnLHqxqjkh1PAV09Y2NID8PYODNoHK7ap1ehGuQiS4rzFTxRMCSlJQKlI5AMNtX
         VAouPjqX4n4NGkGX5u/JSjeTe8WS2Kdbg2FM7E8nvFkWxobmk0fGUQZAGDj7p3cewadJ
         orDQ==
X-Gm-Message-State: APjAAAWL+KveQA0YnzrTyEkh+zJYfvqSQyZ1ARKMEQaEf9WbIp33bo2Q
        YOsf+IGpqhxgqL+5E5srLAvNtf8ozYkfNQ==
X-Google-Smtp-Source: APXvYqycS9IlpCVVe4svU5+0hOPNvru6IomfHCXV1hyjfV9jl85E/ICPqm8cggJMNz+IySulcKYl/w==
X-Received: by 2002:adf:e301:: with SMTP id b1mr8458589wrj.304.1559347459455;
        Fri, 31 May 2019 17:04:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z4sm4552422wrm.12.2019.05.31.17.04.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 17:04:18 -0700 (PDT)
Message-ID: <5cf1c102.1c69fb81.b54c5.a124@mx.google.com>
Date:   Fri, 31 May 2019 17:04:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.20
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.0.y boot: 59 boots: 1 failed, 58 passed (v5.0.20)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 59 boots: 1 failed, 58 passed (v5.0.20)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.20/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.20/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.20
Git Commit: 227ab209e9be6821bfb3360c4111dbed1598715c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 16 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.0.19)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
