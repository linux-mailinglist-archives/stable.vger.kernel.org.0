Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC018CEC7
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 14:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCTNZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 09:25:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40794 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgCTNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 09:25:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id h11so2485414plk.7
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 06:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dkWIu/O14Dlhd85j0htfBLanQJIr5DNNKGbl6lEcaq8=;
        b=WM0qB3tzlxmq8GdjMcDzJ2H7FnfXQN+Pj6Ss/x2ySlA/AVEYhbITZCHnR+BGlhI8S8
         OTdiNGuhARUqILnMYqj5FsgiZZfsBOU61uBvbP4wcb7pEajn8XoQt8x+K0hMVTV9ZJRt
         /4d2QDF4sakiVdAc3Be6BBNQAYlbklwfj0i9UcVTfY0E99XTkijpA5C3hsmBDRh5tY//
         Z6JVvq0bhXU72yhV6NZ3xALT3+u1L9pZLFsLpvaLC+FeI4LwbIaC9Nb6oAy4bVOGaLzi
         9vCmBuH47+H9KRhpE88rN4DMVRA/3TCGrL3vvSK6UXgQIPnQffZzAj/Cj5SR8KQw8x+U
         EdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dkWIu/O14Dlhd85j0htfBLanQJIr5DNNKGbl6lEcaq8=;
        b=H7mPptexyBcw/i3b2GI32UJsHDTJUP0DVsNIBO0QHbuhL7V9NaUewNR+4+hdaae97N
         RvIZu/beiZqRAAbuw+LaVaqV/UB7G2edz2FXmf2EjwmHg59fuKuedtf4Ph4UOt7skeQ9
         7FORpR7j37pdNjD+P3zIKwg28QvBVYRtggfm81lrD2N6ZcNZuEC4OfsIT7JIF9wKcEIn
         yr/FkNUdEYCUr4h/Vq8rGsHTPr1nEU6WBfcOZzg2LeZBq7zGGwqCOn6R7w8NU/zDL8IR
         fDDITos9MiuDQbnPyMwzndUFPonpPO6+ET7TfhcgqY7t4zQSHytsQ4Vomnxm7UynscNr
         P5QQ==
X-Gm-Message-State: ANhLgQ3S3BpO1LuoFf1hXWfQBdOQlpBeQg83XkUevpZgtqDojmmKk9gV
        eE+FDQW/6TjjNc5fxPAjRmcI9d2QsFk=
X-Google-Smtp-Source: ADFU+vuiYOQJiOSKsnzkoiSmBkB6rw9lq3MXzcFLeu5QvFcsBkB3QcL8LBjUL+6xx0BiqzG+6eW/8g==
X-Received: by 2002:a17:90b:3645:: with SMTP id nh5mr9700754pjb.150.1584710714996;
        Fri, 20 Mar 2020 06:25:14 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm4916081pjy.41.2020.03.20.06.25.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 06:25:14 -0700 (PDT)
Message-ID: <5e74c43a.1c69fb81.4f1ff.0c92@mx.google.com>
Date:   Fri, 20 Mar 2020 06:25:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.217
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 66 boots: 1 failed,
 60 passed with 5 untried/unknown (v4.9.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 66 boots: 1 failed, 60 passed with 5 untried/unkno=
wn (v4.9.217)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.217/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.217/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.217
Git Commit: 10a20903d7ac2be29e0e13d66ad0d74e637b8343
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 15 SoC families, 16 builds out of 197

Boot Regressions Detected:

arm:

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.9.216)
              lab-baylibre: new failure (last pass: v4.9.216)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.9.216)
              lab-baylibre: new failure (last pass: v4.9.216)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
