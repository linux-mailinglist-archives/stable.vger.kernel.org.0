Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC51B2F8F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 20:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgDUSuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 14:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgDUSuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 14:50:10 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ABDC0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 11:50:09 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h11so5586475plr.11
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 11:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dvQFN7Q3DMV1/in2hic4/hw+bGdLM/nYd7ObUK+V0uk=;
        b=VMtj0zW5VRV36WqQyHUsSsYPkGZvL6KnBXXo5Bgv43zb6SQaRfWWugTcfbobavWyqF
         nC0cGFhbH0vZoH7RWmGF31YzF7FgiBkkM0AKHij9OQkpSW1af70qnLAjmpm0+tU72Pbl
         JolWg01SJSSTQTpjNktXaO+JYbg0c10mYGT606Zkuurb5xoW/V+lY2lyLASkB0qhaDyi
         HjatAev9zMk1b+3imMnLAN0R9DbTwviSOuQEy17+u2vG+L4QBIE7fwk5YsHnDVMKOmoh
         LwqDZy2gUnfutMpjmZxbnOI55HfdqG/eU4H7l+JaQ+t0grLH/DLz+waG0qGqSDHIDD0H
         zKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dvQFN7Q3DMV1/in2hic4/hw+bGdLM/nYd7ObUK+V0uk=;
        b=B9Z4zPzsbb8rMfyDoGBLqWqRZsHG5zgS5Hb4GMyQdRK3uL381qsZmSVNabRlX44TtR
         Nnb2DG/Zf873+nsbKynWWwEn353AuUmUGdb8xfpJS15e7n1DfOw6CTspyxJ2jYjKGh6l
         afcjYlLhAX2Ebe/KAf7bHxYHEFBBhl09i2mmDITb6qNjmsOZSYmK1GH0Vlj4VzaNXtXP
         PM6SI7h1RPg21FweC9khfMgV/7cwr3nKw7s7nL0vyJBdxEU7XnUltbVkIqVTqllzlvvJ
         fJjtcAbkCkJ2wlWbz8TdjUM5PrdPvguOlwi48eeKa7wokX0Jlw1URJLFUBtTRafpKIeR
         QP9w==
X-Gm-Message-State: AGi0PuZw+roA/fXl9rGncn63iano0g65sgkR7PHf6fP5YoCw04U5EyCU
        SAKY8Ehi6PfP9n/Os8I8sV21CBE/XEU=
X-Google-Smtp-Source: APiQypKqVdtTLvUe4SjYXGo8SBhZ1Re9LcH4WEAVndGJtD7rMxaHtKLJONyRXsqizkno11m+dmajlg==
X-Received: by 2002:a17:902:82c4:: with SMTP id u4mr22127153plz.219.1587495008855;
        Tue, 21 Apr 2020 11:50:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a19sm3184151pfd.91.2020.04.21.11.50.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 11:50:08 -0700 (PDT)
Message-ID: <5e9f4060.1c69fb81.dcd02.9aea@mx.google.com>
Date:   Tue, 21 Apr 2020 11:50:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.117
Subject: stable/linux-4.19.y boot: 51 boots: 1 failed,
 47 passed with 3 untried/unknown (v4.19.117)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 51 boots: 1 failed, 47 passed with 3 untried/unkn=
own (v4.19.117)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.117/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.117/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.117
Git Commit: 8e2406c851877516f12b7ab4e975d033a6d58ebb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 13 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.19.116)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.116)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.19.116)

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

---
For more info write to <info@kernelci.org>
