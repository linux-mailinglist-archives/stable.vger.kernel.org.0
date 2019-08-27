Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BB69F716
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 01:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfH0Xz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 19:55:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36307 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfH0Xz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 19:55:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id p13so616150wmh.1
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 16:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SBVY3o9Q8+Tl5pb+JEMwUjxNDC94JGMAEozAKsRm4do=;
        b=y53H2EPis3smP4dW//6flA+VAR5kdXxFxniWRWJynBXvo19Yysv0oZGHaX5atn6xQy
         fx+qZAQbaWr2m64jkKq0+fgpwa8JX/atJOPbl70DE+Czn7FNvFqAWtOXKD0v6Nqxt8Xy
         1bq3virYIbDQqvbXVdPVrIdzAjUC3af29EHm4QCu4YfbhKp8CY1X0zkiECtRwQjMJOZU
         0SjubHLQuhNkCrad/GoMXlt5rKxfLBENAaA5ew/O/xXMQILEsdCKKlnLkX1yMT0PgTyb
         KcYLxYFGTHhDH0syGTO2o2M3z1oTTxMpCfdtdQX1qcoXifF/9FmIFHDKs6QVROXU49r9
         mOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SBVY3o9Q8+Tl5pb+JEMwUjxNDC94JGMAEozAKsRm4do=;
        b=pn+AUi9j1O5JBlVLYVcdJfNf5gwIIPM3pSd9VD9avEC+Jnfnvea335gWlKpDLXwtf5
         OSR9OxDY617Elu9UXtN4ROZ0wp/c3s78KJESB5epemFU3ElVSJdjG7XzAf45z0dLJ/D/
         FM2D2I8v3Pz1DNwcjo0LctZkyVn3CNco2FVmmPGSAFAt1UIAIB0t7XCYe0fdqSw+6zMS
         gCugqjftrB+ymZmxu9Y4IPEuTr6BG12AiPJ5s2wBRED3fsj9HyxE8q/m8GDwVg0jswin
         lpLPxkiV+CXCE9IF8mHymUBXqOH/cZa4t6y+WosWZLObrKPCx8fGniECGClTsM7Fcvpk
         jo2Q==
X-Gm-Message-State: APjAAAVyA1Ke+RY5OiEchhhSdB3Q+B8Rdp/97/OZcnzy+2VVa9gGV7zQ
        9GQiMFNJHjCh2rkDmrLSOFIozKC6eODy1Q==
X-Google-Smtp-Source: APXvYqzBF3nQWPb1cx6YIbraZ+LgiQOISku28s5TbTePb8TJEl/rXEV3/35suzZuFOGCLczdh2NjQw==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr937874wmi.91.1566950126089;
        Tue, 27 Aug 2019 16:55:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g26sm543107wmh.32.2019.08.27.16.55.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 16:55:25 -0700 (PDT)
Message-ID: <5d65c2ed.1c69fb81.276f5.2ec0@mx.google.com>
Date:   Tue, 27 Aug 2019 16:55:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.68
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 81 boots: 1 failed, 80 passed (v4.19.68)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 81 boots: 1 failed, 80 passed (v4.19.68)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.68/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.68/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.68
Git Commit: def4c11b31312777a8db1f1083e0d4bc6c9bbef0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 42 unique boards, 18 SoC families, 14 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
