Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F942115DE0
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 19:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfLGSEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 13:04:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44709 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfLGSEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 13:04:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so11324750wrm.11
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 10:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vJmgXHJBjhXVZ7NPggq3R+YFIh9FVRyVzh32WVsnekA=;
        b=2IWRZDAQvC6bwUUccyYZCOrOZfhJkFU7pGUBPPzetOj5JjMFsDYqyJ9aVNH5KV1Cc7
         5BIYXUGaZkNtgvImVTkBlnAJ3s68AhmFgufxbvbgA+jpnvtkJjRVRBksqkdHNlmBs2h7
         mWNoxhXQuhEgnrecDH9RI7O0g7sOHwpQlKQRzxRmp7ulcV0VljjC26SC+tGtHIS9nMkW
         Ay7yAuHY9JD9ZVPQnnCsg9uceKBKLIBpVogTiIEIlrShxqbYXbhs4sOWChlKfQ9369ys
         KFsMZdMWqk+5vuGB6/LzwN2ZeHS294AJ+nAfgscqq/zDtIKFOi4vmjTa9yGh2558LEZO
         jVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vJmgXHJBjhXVZ7NPggq3R+YFIh9FVRyVzh32WVsnekA=;
        b=bBJ9+KUzkl4DqDwNLB0VT5b4N0Vs9npGK5rUAUW5+HMqkHsK4RsBxfZi63tL+zgg0T
         F02Hpz13Slvvl8JZJlwm6rqptsEdfDE7PFFjm4PHJXsMzm7xFVqgfHwM9D9aPEDD6RYN
         vZ2KkeN3s+JU+thfunnqJ7qJ3dwKWjrx49bkZKVLSyP6uTcnnWsTNzyg6FTZ9uaQB1Ue
         thCKVBZ2HBjJYzx5tRZNx8QTJmJHFzK2VvMqeO7iRYdeN2yrE4fNKi7o0VEowNjytCob
         8Dsy/oCxPr3K7RlcteeXibHUvMFf0hROivI+UkkdCXBPImKRMfaFGp8oJsM60tmIuBZh
         CmYw==
X-Gm-Message-State: APjAAAW/KlEPxM/Ct/j7m3XahCOYtyWqG9xhewmusLgNV5oej92akeB/
        s0t1aH5jo8bqk8BjdiqpdCAvCUnKtdw=
X-Google-Smtp-Source: APXvYqxaROuSOG9SUvUwHC6Xpa5w5FOc5BU4g5rLKNlUCmeEttMOu6vPS9NipB1E8L2WqULgvwEltQ==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr21731965wrr.98.1575741891373;
        Sat, 07 Dec 2019 10:04:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s25sm7197869wmh.4.2019.12.07.10.04.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 10:04:50 -0800 (PST)
Message-ID: <5debe9c2.1c69fb81.bcbee.87ca@mx.google.com>
Date:   Sat, 07 Dec 2019 10:04:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-56-g8dbad6fe8930
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 25 boots: 0 failed,
 23 passed with 2 conflicts (v4.4.206-56-g8dbad6fe8930)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 25 boots: 0 failed, 23 passed with 2 conflicts =
(v4.4.206-56-g8dbad6fe8930)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-56-g8dbad6fe8930/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-56-g8dbad6fe8930/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-56-g8dbad6fe8930
Git Commit: 8dbad6fe8930cd4fa7c513c41dff5fb4843929c0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 17 unique boards, 6 SoC families, 7 builds out of 190

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
