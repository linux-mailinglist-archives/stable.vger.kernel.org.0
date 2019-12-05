Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF221139E1
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 03:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfLEC1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 21:27:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46060 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbfLEC1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 21:27:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so1533368wrj.12
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 18:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MD3nlZE1nYLaEHYwC+EVSLsnFQ0K2FMgt2+eNMJ5eiY=;
        b=2P2QYwj4+8W5IuDBgFhe0ssExF7ntOylkSZk/eZ28ZfRO42pDzvNNsmkfi/x04Z8nl
         5m+jThFoONkJlSieUz7bXH2brlPh7qEXv2EZWsRegy0V5r2xUXzwuMroipUkdW5akUts
         EuyDT7+oKnCwFozJpA3LvyWYs2TcUdITZHzSEbrXN59fGTDlKgBN2lnKJy8PPYGIhUUA
         XMilBDMKA5vWHFWcZbJVadMJeA8qilKyrDfG1BOW/G1jtetEO59c30KhjdqUnEV84DQz
         VRTY3pzjmEikJoEfkFvUUtS852+KfGM6ihxhcnspjrMkG+fpG7qDRPKMyQwEwPRyD+GG
         3UXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MD3nlZE1nYLaEHYwC+EVSLsnFQ0K2FMgt2+eNMJ5eiY=;
        b=eBRQsjOL9deIkODSfAhEtSNWwRszCvyHAVWayfBDep+MwFmi1Zn8LqUwfFMTk9HAz3
         Bhyks/D8lLjqIySbkRTAT4Dq7Y4aI0QQ549R1xxwvZvt5qtgEEuHBbZVboCjHGHmKKt8
         EL+rjQv4iB8sDybMflqW01VECTtN/7R97/dkieRosvaQLeEpfyMgiUw6Ffke8+Vjt6lR
         VfH9Uhqg3rZM4DQ0eHsTs9RnBHxE8JUMjSleybWl8bGCHzneRJ5ND0iYV04aELXYCRmE
         yoOHLIJScAO858TP+kgCGsc9MTP+cpS1vOHbqQDLTRkaRBiw8c2sq3IULImvHROh8Jhw
         6rrQ==
X-Gm-Message-State: APjAAAV7a3+5FC6dpr/rTg46wMNFA+YAoJKwu5J+JP2Jc5NV5R9Hr90b
        jEGVEaOeVTFCNH8Qq68EWR8MDM6O0jw=
X-Google-Smtp-Source: APXvYqxVWtbX25VqGCqvWKew/k2vy3DDvKrbU9NijsxpP13ei1oePArVNbaKwoLHUxCeKwXf1JgEMQ==
X-Received: by 2002:adf:90e7:: with SMTP id i94mr6994877wri.47.1575512859023;
        Wed, 04 Dec 2019 18:27:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm10363346wrw.52.2019.12.04.18.27.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 18:27:38 -0800 (PST)
Message-ID: <5de86b1a.1c69fb81.df4e6.4cab@mx.google.com>
Date:   Wed, 04 Dec 2019 18:27:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.15
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 97 boots: 1 failed,
 95 passed with 1 untried/unknown (v5.3.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 97 boots: 1 failed, 95 passed with 1 untried/unkno=
wn (v5.3.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.15/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.15/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.15
Git Commit: 8539dfa4fcbcf58c3c2f92ac57b964add884d12b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 60 unique boards, 17 SoC families, 15 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          apq8096-db820c:
              lab-bjorn: new failure (last pass: v5.3.14)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab

---
For more info write to <info@kernelci.org>
