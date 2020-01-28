Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6F14BD1B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 16:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgA1Pkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 10:40:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgA1Pks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 10:40:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id a6so1941586wrx.12
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 07:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wcEdwOy0+wvVvActrLL669obqI4ijBE49cFoadeKcmc=;
        b=DaacZlUghUK0vFJCisLtf8BPNLUom6ibIAE7fP2EXYl+MolsRYnahmH/mpmayEz/ex
         z6G85+5rYaMQngmsSmOeAW3UN0FBfBVo+3IKUxovhq6qdOhFbxJT5pTbjk/LZJPpCsp9
         jxBBF595IIeGlJTFWg5fs8ZB/GcuqRSJ5rfIhLqBzLKS5DjSfKfV5YXpwsszjB1OvKmw
         iBFbjMPFT3DYU/anlRntA1+l+uUQpcqcQDPeDcY030ZLlmTyDRi+/rwllx409egv7Mx+
         YB17TtbKJLemv2vVXyly1zR4CxZyx3S40ozHKsvCkrRtXJMJdax/IF2CoyAQhSFcbMGD
         Yh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wcEdwOy0+wvVvActrLL669obqI4ijBE49cFoadeKcmc=;
        b=EnrlwQy4D3gvgzW5gGio+KInZt9iYUzOXwjzqxDl8x5/IvKl82sWX4IH0xZNzeIFFl
         MZDqn6U7R7hfhszFW8l4PQQVd0jET2sZ6bY/USPzedhIKqdpWblIXBMBzi9uOxQhEKX+
         /FZ0zg1umbYzZVyuXxKu3UOCKrPyn0xt3CVe7yu6vZDEz4fGMuTapZ2g3cuzRL5X7jm6
         bhSmd4IFZ28P/rtX+fh8ao5uI910lbExxEgKxaxUoa5yGDZz0pOTjkz89fDPLpTr59NM
         iZQTZddrNkL2u5N0x/wJejYqcAhnftgDPYJ9ZPXkRUaKsSfc7seYodOnwDjDBgtJ+Gvu
         S6TA==
X-Gm-Message-State: APjAAAX1EwKAhzxZ58uyW4rNx/OxYlfxdBZBykC4hpGhnIfMLWD2K6VI
        D0TPczpbwh/g08lWxRtwxoTybrt3FRngeA==
X-Google-Smtp-Source: APXvYqxxa+BR/atebytdlSGo7jInxG7kI24PDOHzWSyuXCyEChqpObMOuAmWnPinziCpTlodKECCQw==
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr29060141wrt.70.1580226047406;
        Tue, 28 Jan 2020 07:40:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o15sm26107684wra.83.2020.01.28.07.40.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 07:40:46 -0800 (PST)
Message-ID: <5e3055fe.1c69fb81.8edb5.b933@mx.google.com>
Date:   Tue, 28 Jan 2020 07:40:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.99-41-ga59ea6d9c99b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 78 boots: 0 failed,
 76 passed with 2 untried/unknown (v4.19.99-41-ga59ea6d9c99b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 78 boots: 0 failed, 76 passed with 2 untried/u=
nknown (v4.19.99-41-ga59ea6d9c99b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.99-41-ga59ea6d9c99b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.99-41-ga59ea6d9c99b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.99-41-ga59ea6d9c99b
Git Commit: a59ea6d9c99b754709de86bc36c698cdd90aea40
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 14 SoC families, 12 builds out of 195

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.98-638-g48b1f0e79=
f38)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 3 days (last pass: v4.19.98-640-g=
d521598bed24 - first fail: v4.19.98-638-g48b1f0e79f38)

---
For more info write to <info@kernelci.org>
