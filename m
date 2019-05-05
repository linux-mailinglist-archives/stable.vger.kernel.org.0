Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19430141BE
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEESMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 14:12:22 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:55034 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEESMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 14:12:22 -0400
Received: by mail-wm1-f47.google.com with SMTP id b10so13082773wmj.4
        for <stable@vger.kernel.org>; Sun, 05 May 2019 11:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h77N5x6UfdlWEKFXPE9Mm2inoQ2Go2aVX6KEqLJhT+Y=;
        b=GyEKtU5+kJrAXodolXmywBvtD6ZYteO/d3ozO01Wh4W/HC/1BnM9MMG9MFMpyERItR
         1O4MiBAixNVA6fV04Ww9BKb9Kl9phrrsrClUBJvBwLVvnEDL09ohMDTTmhO6y/tVsgLu
         LgNGuKh1TINRVem2nou8Yybqytp82aBQxH9j/V/B23LgEh8nXCs9yweHAU9XOyVHssS3
         l+/eijKEHdjf6om2seov9AVo2wsANuSIV1XOtypnvM6+Qr2jcp5ZbeWEZkPsHVSbZYlM
         UjIN7OrvsNh/yc0c2OWvjZE5Nxuhyc3e3TGxM18kyYC8jnTmovTtKPTect01EoD+3O1y
         vnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h77N5x6UfdlWEKFXPE9Mm2inoQ2Go2aVX6KEqLJhT+Y=;
        b=I0+lqg1V+50Q6iu+NtXagSeZ7NGR6G1F0jtVA1Bfc6X+Jvx+vS1AltKhq63pqbgTg1
         C18TJgguKkIDUbu5wfwucK6UpHzeTeaKTeV1KKGftn9ST8hvZLsoPUY84HoY9nUyzYZs
         MMQpRSarAXbyVrxgbYuAFNSPbp/A1rPKiYS+go9jeJFBJrkigbxFutonXluEciLPob+h
         KR87oVnr8f89Vlc3J5BALKAUkGWDQOyFFj1YO4CMhHXVz/PALQICaCTPdbNRS0pFUEmT
         TCtQJZtJmFk5YSKYWWfgU8gGVuIPmecp+19ckWynOqnQQ8H36dgq1CFBEaYeqM7t2OM/
         tr6w==
X-Gm-Message-State: APjAAAU28w/oLAOe+5Se5Qm3LvY/s558NEV/XeQauIWk10QmZYtSDtzK
        LJrJ/OmQcMSbCuTqaA8HFfXsOOCMSNU=
X-Google-Smtp-Source: APXvYqx7cbYxlxr1mwS0oz1P+3agFxDBW8nOQ6VehxKbEa8aEgQvRMuUY+XxuiZxcvF2KuBK6J5xYQ==
X-Received: by 2002:a1c:cc10:: with SMTP id h16mr14309406wmb.39.1557079940137;
        Sun, 05 May 2019 11:12:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v5sm8601846wra.83.2019.05.05.11.12.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 11:12:19 -0700 (PDT)
Message-ID: <5ccf2783.1c69fb81.5cc6e.e0e3@mx.google.com>
Date:   Sun, 05 May 2019 11:12:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.0.13
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 135 boots: 0 failed,
 131 passed with 1 offline, 3 untried/unknown (v5.0.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 135 boots: 0 failed, 131 passed with 1 offline,=
 3 untried/unknown (v5.0.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.13/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.13/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.13
Git Commit: e5b9547b1aa39164a8df1d01f2996391c0356d71
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 14 builds out of 208

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
