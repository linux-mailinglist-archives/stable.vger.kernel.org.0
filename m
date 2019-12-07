Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C76115E68
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLGUKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 15:10:02 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:35487 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLGUKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 15:10:02 -0500
Received: by mail-wr1-f52.google.com with SMTP id g17so11663196wro.2
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 12:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dIL3w8k2JNGwc0CAkqCIwj3t0C2ySsyO3qzxCYcD+RE=;
        b=Txe8Rv6D9Ccu3KZrKgfz0FU4RDb8+c4wjUhs802PWGblqlljulDXzb6PZvuu4HN4K/
         r6F/sIF33vbiLYqKkjhxRPNwuUYLglM04uBXyCIo4Xz9ep9kNj3K7QmraOGdKMTgtF0Z
         Hbs5mACoxdl6kCfaMwOiX1uJTwjvMOv9aySQ84ykZm9Zy+uguYJBZACYZFVMEGU0AcMd
         nzWOw0+Y9SoLW70oYXlI8myiQTg2f9WcYwAhAw5BSVIJAKndc1Yq78NixNXaW7oVCoe9
         NV8ng8B8hCDBPrbN2hXxCmVbjBQj65if3SifzJUBIgT2xFDds9Ftn84hGxdQf6VK1WDJ
         UQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dIL3w8k2JNGwc0CAkqCIwj3t0C2ySsyO3qzxCYcD+RE=;
        b=frPp+dSO+GV/uQCtXlMd/KpXqQU+WjzJ08B5O0hpXqEnGhUGNmo2FKgnPzMkGIkQRT
         ns5TywcifAb/7QPExKFrgQLIqM7eaM8eLQfPfg3Xm8eFerHzRQwdpzGfN8MMwLCfWUEo
         lAFzHSkytIIXARDBIPqKhFjSGlVP8cBcf9bZ5yEQvMjUWuWfE+7YLSKjL41oD7CUz2ne
         kEB+gcdkUKCSFKrxQyfqYAS+53UHls38uLmG+QyxPgBmbGFzx0apLjCF2IUyRQvx7wxm
         DtAMvUoIWSl8P1uGC+ur3nl95S1vAgc56AeZLlGeAOSZvKlKhwzendEU/Wz7fZLgL629
         klQA==
X-Gm-Message-State: APjAAAVA4YtYADRUaeJ+rH7P62V1dEhrEIKph42qbktnlduqN0Z3Zeh0
        XmeNURgwJv8sAFVWUiJeQ4LYp3tghQ4=
X-Google-Smtp-Source: APXvYqyTEVOYGFaAf/VsB+y4mo6Qs4I+1hWAO2nycbwc/3Ycl8wXBtjZQyezITKPyet8phM762gtJw==
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr21656902wro.209.1575749400342;
        Sat, 07 Dec 2019 12:10:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v188sm8053081wma.10.2019.12.07.12.09.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 12:09:59 -0800 (PST)
Message-ID: <5dec0717.1c69fb81.e14bf.1657@mx.google.com>
Date:   Sat, 07 Dec 2019 12:09:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88-209-g5944fcdd7eb0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 39 boots: 0 failed,
 38 passed with 1 untried/unknown (v4.19.88-209-g5944fcdd7eb0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 39 boots: 0 failed, 38 passed with 1 untried/u=
nknown (v4.19.88-209-g5944fcdd7eb0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.88-209-g5944fcdd7eb0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88-209-g5944fcdd7eb0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88-209-g5944fcdd7eb0
Git Commit: 5944fcdd7eb0add713dd4b614377cb3ad97309b3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 10 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
