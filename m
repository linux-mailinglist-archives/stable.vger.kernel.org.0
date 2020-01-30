Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF614D489
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 01:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgA3AQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 19:16:16 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:55197 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgA3AQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 19:16:15 -0500
Received: by mail-wm1-f44.google.com with SMTP id g1so1766938wmh.4
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 16:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zC4QaQ1QGbkT8Q404GO7YY1uRRWEzhbKWq4Dk7m349I=;
        b=1ZtEk01q4Wb6qQgV6/N3tKOyR8ueqPU6Perk2a201O66ML/p3PUoyg6NU/xkyh8OJf
         1uxsHUBvsOzInFPbW8aQwGL7GhmaLk70CU/FhEWL6zxsxkncyKAIeGqrvkNHCLoc6vOH
         dXUBkPpUuMsms2PVaJ9u56DnRP+bvawmXYDczsIv5uuVlaVnkPXDQyCwIcXdH6oe4KAk
         LFGE6LFNgy4mdEuvW1pCHTaLFhqJXtfFA5K72Yrcr/4zfVV3kcsoOIV4jgLGdBtD57va
         Vf3AuuNcwW1cLQQprgJxjM0RExbKy+sJk++ACvAIxlSX2uPstrrs5GMzACi4VcTQA/Pe
         f3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zC4QaQ1QGbkT8Q404GO7YY1uRRWEzhbKWq4Dk7m349I=;
        b=XLSDwejmMdjKr3YV/NGgmQyYklFgwESMmhQ13rtxCQ+bja7Q7iEk1OA1XgmQvcs1KC
         S8BjrfzIuw7YnmkJqA6QJIyV9HfABTy5JZ1t8ELgH9prAAxBDhhittZYxtMjgnDZXI/s
         lkoeYdqAazzmxIbxcUvL3VGsYAslMHr8cWeXvIIXrkmddk1qWLYCtxJkvSbN4Yd/swsA
         vnw+JR/KG2KadpOA0+S4lnNDsAlnC0zQU3qJIVrCh/jpxgx/i1VnE8esrp/vtDbAbPhp
         EteGwcq9MIJwSecngqdzZkJ+m3yVgnxzTlpNiJV8J2mBkl2G4pMP9ybpgBdJuswmjli5
         q5dQ==
X-Gm-Message-State: APjAAAVFwRu1M3QTZOKKy3KGBp1MR0G7mKyv5LNvpeJILDJlPyCuuEnX
        WSjUx2dqvZGuh2hqR9IoOBD/kqORTXaeag==
X-Google-Smtp-Source: APXvYqwbAxqTc/kDFUDcp53/IVjHnQdIbyjWGyrADHQGZimGUhM2JAgua4CyZR03LTpAjj1mTYH5Pg==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr1847997wmg.13.1580343373474;
        Wed, 29 Jan 2020 16:16:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w1sm2217699wro.72.2020.01.29.16.16.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 16:16:13 -0800 (PST)
Message-ID: <5e32204d.1c69fb81.ca48a.aa82@mx.google.com>
Date:   Wed, 29 Jan 2020 16:16:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.169
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 28 boots: 1 failed, 27 passed (v4.14.169)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 28 boots: 1 failed, 27 passed (v4.14.169)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.169/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.169/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.169
Git Commit: 9fa690a2a016e1b55356835f047b952e67d3d73a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 24 unique boards, 9 SoC families, 6 builds out of 174

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
