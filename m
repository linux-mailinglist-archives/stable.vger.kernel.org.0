Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A571086F1
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 05:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfKYEB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 23:01:56 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53789 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfKYEBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 23:01:55 -0500
Received: by mail-wm1-f45.google.com with SMTP id u18so13888754wmc.3
        for <stable@vger.kernel.org>; Sun, 24 Nov 2019 20:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ujvEFupGj/nvvZJQOdT85pBNtaTfJBkPgxpgEx70hUU=;
        b=ySGemzkUa7MdyLCplmE5wgt/l/aZ7Fk4vXCdwBBomHtBj9Si56QKZ9aYNmEmOzTGNq
         SQIMq/qwzuyzEQuwuXg2SWzdRCSr3ekFiFCPVHC1l3H6FI9tE47x+SEUxP7IBewHkrrQ
         aigtND7J8XlUvA7KekOs58TpuhA1x4QP1BdzbcuVxunTfjL5J2iQCilcNHS1AWNBkBQ8
         h+4sTmj11dZa7nGhDfZ7tugkDzpAlBCRSkh5DyTN+y7o7I0+p0Nj9BCkdwaBlwELBzBU
         zt6Fz/80t0eKcgYmPOGoJ00zdtGg3ALGFsxYYYaJBNzPZfzHrC/KJc30IE9kvQrF/7ma
         H4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ujvEFupGj/nvvZJQOdT85pBNtaTfJBkPgxpgEx70hUU=;
        b=ft67nybFxz2RLqQmj2V1P7u8j6ZRZZMzd1kEWXRupjjDcc1pfCplCT+0Ek+WwOwhup
         en3bsY9NWPkN59B+g//zWs6UwZsJmDPgEEffgNAwXhY/wAijKKi4yoviKhOp2vmLHX3Q
         EpUEAUviB/jjIMH4zYC3ALI0XcC6IBv5mt7Ud2xN8Wj4z+HjcCRvtn5cehh19RwX+BKg
         VY8P5Fipk3isij2CHdWW5R6sjKJeYXcj0FStD7J8y1Qj9/5RRrE/OJIiPcG8KvVcgMtC
         RhkiFnzEJ1yG208iKIRA/sH0QB9GahQmIpAZuVvLkJ7UgxjRUCH0ppbjmd4mQ5cRBOzI
         peIQ==
X-Gm-Message-State: APjAAAUpgaruKB2dtPrZcp95i8NY74UxJGp1MJn0xSn6SY683w0RpaF8
        yjWvnICT0/pKXNYk+vpov3AjyuqpJ9zwsQ==
X-Google-Smtp-Source: APXvYqyOuS0c7WZ9yWQUs7Tnpb/DR/jmAIOEVJ2ugDpWW+bPLrIOMZ4KNYpiKfNYZIxHtAuAJ9COxg==
X-Received: by 2002:a7b:c34a:: with SMTP id l10mr23257583wmj.66.1574654513536;
        Sun, 24 Nov 2019 20:01:53 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k14sm8978837wrw.46.2019.11.24.20.01.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 20:01:52 -0800 (PST)
Message-ID: <5ddb5230.1c69fb81.5c718.a90c@mx.google.com>
Date:   Sun, 24 Nov 2019 20:01:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.86
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 74 boots: 0 failed, 74 passed (v4.19.86)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 74 boots: 0 failed, 74 passed (v4.19.86)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.86/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.86/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.86
Git Commit: 14260788bbb9c94b0e36abc17294266b69dd46e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 47 unique boards, 17 SoC families, 13 builds out of 206

---
For more info write to <info@kernelci.org>
