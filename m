Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783851E565
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 01:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfENXBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 19:01:31 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34786 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfENXBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 19:01:31 -0400
Received: by mail-wr1-f45.google.com with SMTP id f8so553405wrt.1
        for <stable@vger.kernel.org>; Tue, 14 May 2019 16:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DbiFlCiAZGgcyYTsKuzsxJT0uetcazClUVamOnt1pyc=;
        b=TxG0Ra5dd8EpbtkwzSROIB4RL+PUHAM0cMnU2qgUneoXXYWmqSrqirf6pV0wxjC4/d
         il1CgNUyEkrDWYWcYNINEVmBua1WMCk1FCUbQwn7NR2eLjPLOllg4zdhs7csw58i3bU+
         y4a85yozLgRGr9/P99i5VG13kOrvlSHFpxBmrtlt/GCqt7t/y/GstxnJ4vL3QeHNMRTZ
         xKO7D6F6hCzdoZxHc90Kp9F11YRLLK+5mkAXApcKKpVa3PuxehVK2I0ytT2onOuxv7qS
         9BkgySo6ik2lcV0fbDvnmpDX86SaY0ZafMXZkkqoA1VOniFBnADdxGULJ7ImwxDUl2N3
         JfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DbiFlCiAZGgcyYTsKuzsxJT0uetcazClUVamOnt1pyc=;
        b=Qytiw3kOQNFiKkl+tdIXp+kgO/c3mlUyouxT+HzQ7L2kcfPcLxaj2c7rPzMd4dQVaR
         JD5+Mwy+vET2P6Q1o+IQG2cOhK70a87z2yLLCQCTo7GBuMAL+d+FM0qr32UBZtKGlX2l
         N4ROiq8Sn+0MNmDkbdTZaW7IpLzLfMEyDbmRJbybhjkmtzI+F8hxzwj9ktwJk8IuKZaP
         CNmyg7pRyrPbxjZ4zI13zuc2eUAFWQZJYfmxmLtUms74i7A2V7+osMMeBeLHFkj+VqB3
         NOsmdlRo+ZcRH9kDi2U6E/cgyYH9oYLymHQXQtqLVP8IUy9UF9Kez1v7V7rMcUnbNkn0
         di4Q==
X-Gm-Message-State: APjAAAUcRyvXBHVfERdN0XfjCabbtQMeDBgJsJOlE7KGF+VftkUE8qZh
        0+wO8fT5ZItwzYv27aC+VuG4mPjVByKKyQ==
X-Google-Smtp-Source: APXvYqxlCc5EqvXcTg/W4DKvpnnf/9zDAGIy/Sbf3CGfk7xIpWKsrzEijpRVzuG5sGkEEiRXKRUZAg==
X-Received: by 2002:adf:e44b:: with SMTP id t11mr8239613wrm.151.1557874890184;
        Tue, 14 May 2019 16:01:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i185sm765893wmg.32.2019.05.14.16.01.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 16:01:29 -0700 (PDT)
Message-ID: <5cdb48c9.1c69fb81.97ae6.484a@mx.google.com>
Date:   Tue, 14 May 2019 16:01:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.119
Subject: stable/linux-4.14.y boot: 62 boots: 1 failed,
 59 passed with 2 untried/unknown (v4.14.119)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 62 boots: 1 failed, 59 passed with 2 untried/unkn=
own (v4.14.119)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.119/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.119/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.119
Git Commit: 2af67d29b6fec54b86bcdb3e0a616640eeea5302
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.118)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
