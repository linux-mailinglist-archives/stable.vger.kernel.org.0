Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E237A14F2BC
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 20:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgAaT1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 14:27:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43168 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgAaT1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 14:27:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so9966965wre.10
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 11:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C+r78ZwShZaPS3oQ/wc5YwaI5jv8jPMgKWwG4w4wuEM=;
        b=diOxmt2A5bVCr36lEMmTT0lki+QutTTQ+xPaKfW8zF8OEGKnU+0/yBadPW3uxUcqw1
         Kd9opX/cvb1av3bP0oh16Hf6s9C1QnzmkdAFVOq+G9wQ+mndIzpgcPXHo3vfivadSnZa
         HmL16RyCq9dtDvmCceRHSrgbCW/WsYVFdi/zy1aFAYx4jLUDg8HIzHgHZbOk4ixVe5B+
         FbVPytkI4yzcHI8w2XJPt51NbV1ME/cRTC4xCxXYyB6a+YltAYgI/lYbDD66CDcuSmB2
         1+uhb6+LgQgnIiyUSTgBmLNuMUpUDRR8kyZIZNQe6aYfbWWnFeOv2a4oxc0OxUDCKTIe
         8bFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C+r78ZwShZaPS3oQ/wc5YwaI5jv8jPMgKWwG4w4wuEM=;
        b=Gv/j5j2kY3MJXfmWODVCVwfRZQ/oIEjHZCqjA/2f3PrPYZkM8Q7R4dOYEsu6ygfvUa
         kp0IwppB7nT4X4AQD3kltJLIRU/2Thr/4GsDch07aRGZ3mW5XYWl+X8pBGGq28f30aVM
         mkwDjF5+tFogQXDevb+F2iPLxpZ7BZqLGf0Nlk5YjVEdaI2zCE1WG0pcGjf26xjSZjCj
         CazncibwoMDr5OphxtcG3djyl+U+VC/b8b1bKJ6s9Cc8uscL9tPSw74K0KeDfipyxSij
         H7fggsJkZPz68eibjctUdsO4PcJWms0jAqvbPk9XIzmWyA0j0B5Ay0OjzmWKX6Dx/et1
         z7fg==
X-Gm-Message-State: APjAAAVKf/EeCYOTWUz9THfPQFULQkoI+MLhUWTmOGhl91VwaOKMi44+
        C+UJSnrdtvnk08FtsbaFMid5OlgKDgzrxg==
X-Google-Smtp-Source: APXvYqzA6JP5xPOuUHfSJhX5Oo88r11r6KZCNG0iDUbHagIlCVMGRXAoQONwyAaCTu0n8nP/wX1jcg==
X-Received: by 2002:a5d:678e:: with SMTP id v14mr14100338wru.101.1580498857342;
        Fri, 31 Jan 2020 11:27:37 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w22sm11707934wmk.34.2020.01.31.11.27.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 11:27:36 -0800 (PST)
Message-ID: <5e347fa8.1c69fb81.9802.57a4@mx.google.com>
Date:   Fri, 31 Jan 2020 11:27:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.100
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 53 boots: 0 failed,
 51 passed with 2 untried/unknown (v4.19.100)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 53 boots: 0 failed, 51 passed with 2 untried/unkn=
own (v4.19.100)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.100/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.100/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.100
Git Commit: 7cdefde351b6911ec5ef39322980296c091f6c52
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 14 SoC families, 13 builds out of 203

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.99)

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.99)

---
For more info write to <info@kernelci.org>
