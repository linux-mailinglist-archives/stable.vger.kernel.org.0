Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C122F14CDAA
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 16:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgA2Pjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 10:39:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33915 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgA2Pjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 10:39:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so20717718wrr.1
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 07:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QZax47iI8k6ChHm9BEXYEDFmWMZm5/4TkaQDuglHGf4=;
        b=W7PQ3zZ3U7T/ncBE63gL/o0WacEUuIGMgV55tIjUvc5wvzZM10tY7A2WkkuicV9k2H
         gFyO0R5+tCjIRCFd1ZYGQrG61M40chGPz9MKOtFEdQYeLavndrswT7gosTfqIQ7+aCsh
         rat138KXIXgTEVXuAREFLh1tffJDln+B9xE4Y2hcOkTSpqxmd1HgaVqt8an5NxmUMmuq
         7uFmYjUqxprX51fL/ZqWkBRN5WuroxeovnihCf36WKjgg2YqRrNAzQ3US2gz5dOUTH4B
         NeWby0zAsp8R+6XvykOJ/QBxICQDVXDkUY9j2ARDXJfQ0Cr3Pe7KxO7XeZSmbL0uO3dz
         wNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QZax47iI8k6ChHm9BEXYEDFmWMZm5/4TkaQDuglHGf4=;
        b=Hiz1zl027dQG8dVrYpk1szgZcyeYWZVmoen1rnpIbRPWOV0NfT1CpRvYo0UKO9hqs0
         o6PaWM0ScxDaMwlaPBrrSQ8nJ/jz2bDN8GqCobaU/RV5C+AxmYwF0ceiYeLhp3lwGUIz
         mZFDMwbemQtildsTXIJ8xPK59orxGzDrJGIkIrZyDJk7tHpA6oQ8YDj4JutN1SpzM77A
         0/OXyoqC0EqPTwfkYINWBja1LKCDvgZXi6na+7qKB62VwcOXUv1sd15EVSEjFIHqfXwi
         OHReyeO3tHsSE45deq6gpcvsSrU3UYuTBi8X7KTXMinZSOQBA6z0UzREAT4+7WyJZ/HW
         orfg==
X-Gm-Message-State: APjAAAXZmGq/7qbK1Ggr0egqMj7ucPJL5B7Ap9i/ml26c0bDE9KTQ8dl
        KVACkdlsEseO6qRVHdlXXbTzzbMHNc7tBg==
X-Google-Smtp-Source: APXvYqwAoatVmS+0Odnx7zkM5Le0r0S7qi8mjO3giNuk11XyS59tzr7F7PRZuVCnZujfguQ+BqqdKg==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr36089159wrp.19.1580312377344;
        Wed, 29 Jan 2020 07:39:37 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f127sm2720143wma.4.2020.01.29.07.39.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 07:39:36 -0800 (PST)
Message-ID: <5e31a738.1c69fb81.89256.c9b3@mx.google.com>
Date:   Wed, 29 Jan 2020 07:39:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.99
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 63 boots: 0 failed,
 62 passed with 1 untried/unknown (v4.19.99)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 63 boots: 0 failed, 62 passed with 1 untried/unkn=
own (v4.19.99)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.99/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.99/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.99
Git Commit: 88d6de67e390b6093f2c11189ad022988a9e2961
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 14 SoC families, 12 builds out of 192

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.98)

---
For more info write to <info@kernelci.org>
