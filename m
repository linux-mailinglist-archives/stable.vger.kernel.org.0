Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF36CD95F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 23:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfJFVzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 17:55:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40717 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJFVzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 17:55:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so4195876wrv.7
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 14:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lzMlngrxyOgBgekZe6ZU38+RTHvQ6fdS3AQU4vPHtLI=;
        b=BPJeJcntm/rHpJpU4UYYMOlcXkRlVnoPGT54U83oUFWLb9goiz1koho5VcxEjwnqtZ
         8BGhIZFuOBtDAq0qFawY/9WDiZHB9KDTk3B34tvfVXhOXDUC4GJ/n1UGZMfF6NOLKZRK
         63nzH0GOYjBzWjcJblRHRJ9wN5ZZwtrH2H5RmRvI5DiN6A3gZz4Pa/XpbFm7iq2jg4zR
         CRtsDv163jjeqFB7C7oeP5Z5aLmaO4BFZzbCb8a582ocuuhiylJqT+ttptDyVsdOWSRF
         yX2YcHlfJhtobJrZtBCS+qK2+Orvxv3d8AR1x1lp6Q3F2trZYCo/Vp6XBHWx/W9ZVxTh
         5tdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lzMlngrxyOgBgekZe6ZU38+RTHvQ6fdS3AQU4vPHtLI=;
        b=kD9BpIaAlPhrrzTiXoWr09zb6l7/iHMqiwIbQrJCjpdmyXeKCl6QyUeuRs3E95SPrH
         B9mjnNRggFWpCZYNZX55hemWYsXLRvX23otgkZ5mX2pVzVY8+feNIgHcvh0MFIGFPily
         IMQwOxvFoZtjUvQ6GbYksHq7CkmeOgjfcll7BsLLCL9hlY50AZRpz42VPcmRBUYsd7Yj
         ztndMA07WirFAVE7x/ejFTSQIqJ6CQS8CDgn696H9rqnd9IdyfOYf+HvaXed+2vsgtVv
         AnMiLnxIljxZ/STHqbijLhqJDzSauvpPRabmDKepJdGK/fgX7zlyitXHIoc45PotHf9o
         48ew==
X-Gm-Message-State: APjAAAWCk3ZZAM9y5xYV9tH+m5Y3kDc05SeMibT3tW4AaZo828BztQQx
        earf96ENAVVl8m3IM5g5Vpe8uZa/haU=
X-Google-Smtp-Source: APXvYqxo/GMHKbGgSYEPz9uPiyywU5IqIKmVxS3q/ofMCG4/rzbvi/khE5p+gAfnIrYsd6XwZo4Pew==
X-Received: by 2002:adf:804d:: with SMTP id 71mr19363498wrk.3.1570398906125;
        Sun, 06 Oct 2019 14:55:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n15sm604648wrw.47.2019.10.06.14.55.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 14:55:05 -0700 (PDT)
Message-ID: <5d9a62b9.1c69fb81.24471.3025@mx.google.com>
Date:   Sun, 06 Oct 2019 14:55:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.195-37-g13cac61d31df
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 38 boots: 1 failed,
 35 passed with 2 conflicts (v4.4.195-37-g13cac61d31df)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 38 boots: 1 failed, 35 passed with 2 conflicts =
(v4.4.195-37-g13cac61d31df)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.195-37-g13cac61d31df/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.195-37-g13cac61d31df/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.195-37-g13cac61d31df
Git Commit: 13cac61d31df3572c7a2c88f2f40c59e0a92baf2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 21 unique boards, 10 SoC families, 8 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
