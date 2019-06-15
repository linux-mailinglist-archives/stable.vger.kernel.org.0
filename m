Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE5470C1
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfFOPR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:17:26 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35444 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOPRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:17:25 -0400
Received: by mail-wm1-f47.google.com with SMTP id c6so5005205wml.0
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 08:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gWQR9kht80hzT1bwTKTo8aNFa3llMI2xnzEyFq7bfDA=;
        b=sTRJ9cQFwEEzwgc36p7ov9qw4y7HmfB8WkwZnYGoySHvlTuYw5KLuI7UdxBy3z8FkG
         ttSzQ+t8CrJORbaNh1lbWj28gVSNjsl/lMfHHVqOEw+ZJGIE1FF5GujF+49mBTZHk3KL
         NMUvtqg8UxsBOm4QF7q5Ksydnx3OOgJiaifv5vtTbq8c8rjvjK/yoXXDNG5KOytKBInq
         LZgKQh5s0fWTlYXQt1e5s9HwHx6CA+f55eS+QXNamTjk7hBFImOEJL0sHi6A85aNEwm5
         905WryTGmm29WhRg3y2okcyB7oBdHc6Jo/bee/tPMrxOO7Bsr9YXGCe7hf+oRBSXDQom
         gI/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gWQR9kht80hzT1bwTKTo8aNFa3llMI2xnzEyFq7bfDA=;
        b=JS6q677lS/6MVK+PzeIxSMxs8m6mTARf6TRFnLANgbRVkIcHAz4NnWNPHDnylCNR3F
         3SWhnIxl0AI9d0qRdfNhxr10WSNeFYMQK5KyG7JNgloPtBdOdhDwjcTk/jsEG12P2nEL
         FbPG6ivx3MIA90vBGkYvmcqKacN16QaU2ylEvH2wRfrczwsebLRJNlvGbKosoH5X2QAe
         b5ggMtLfjw+fgYE2ZxGzMG1qx28IMjB1sct7zYfxkuG7UtKEqkNcLT0K5XQqV2tFW29S
         +a6rYkXPEFDArq/gdDA/M9DYbUqael6IJJXlTGRjerY90PIeFalgmHV1UYprfNYYQ5oO
         kL0w==
X-Gm-Message-State: APjAAAXEvbZCUdmM2NbT7ksKCkwYe+8jKf2z70H0Y5ZXPb+DszPTE1PF
        JxLYtOLPiCJeEcdNVpFpevhsdjZeger3MA==
X-Google-Smtp-Source: APXvYqz2LPyDpaN9+kYCfxUXe8uqAxAMnFjG2L73F9XaZrppienOYK8rd5CNMlRPLr11DJCHFa6PMg==
X-Received: by 2002:a1c:a019:: with SMTP id j25mr12355116wme.95.1560611843580;
        Sat, 15 Jun 2019 08:17:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a81sm10642345wmh.3.2019.06.15.08.17.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 08:17:23 -0700 (PDT)
Message-ID: <5d050c03.1c69fb81.51b2d.ab56@mx.google.com>
Date:   Sat, 15 Jun 2019 08:17:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.10
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 55 boots: 0 failed, 55 passed (v5.1.10)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 55 boots: 0 failed, 55 passed (v5.1.10)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.10/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.10/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.10
Git Commit: 7e1bdd68ffeecb9ef476f87b791b61910e8c853c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 15 SoC families, 10 builds out of 209

---
For more info write to <info@kernelci.org>
