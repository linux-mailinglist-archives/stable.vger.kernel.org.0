Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF6E2A761
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 01:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfEYXVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 19:21:17 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:41826 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfEYXVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 19:21:17 -0400
Received: by mail-wr1-f43.google.com with SMTP id u16so9409990wrn.8
        for <stable@vger.kernel.org>; Sat, 25 May 2019 16:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MGFNe4P8gR/a5pZISlGrCFrdmNRSRS9UHuiM3dyLslY=;
        b=Yo4HepGrOLwGPP1j8qa7hgMvKoFIT3L3U73CNzhaj4dOeITJDW0UJDkI2b9NUnQedB
         ETkQo2Pw1v3xFMfvEnf7OlQlrm17nor8kdm21Fp/gRTgmXyQUCpDFphRyZygiQaxeao5
         ajY/TtAa5NWUw4Ywma6iq664IHNUTZbYNgcjbPTTrz/zh+/9NgvQYAnl1ZQ/LtpT5X7h
         QoGAdt2kSjFtxrZy3Mf8tNboaSsBXuX488CWTRK3bFc1NTAr4uGVimgyUE9FLlGSNDew
         bnqUiUIOSQLti3OTWYJiNh5wNi+N9cdCJS1eCOgE7imTJRswK2j0iyE700X6+V5zUvne
         m+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MGFNe4P8gR/a5pZISlGrCFrdmNRSRS9UHuiM3dyLslY=;
        b=UNzljslboG/NKF59U618XiAO5A750YZwOQWYbRC1N1gfQrjthbfNSGDRL9jTU3Jtrc
         jU8TUVrSYnHxi9nOGkOLnxh/LuysMfX5PvluJKJY7Ch9Sbqy/LrAZ9evblfG36I6hb9s
         bOb6Lj+HNvmCArZ3WvQfqUCRFRCRi2PDFtFUhQz29gHhmBDNnEgp8B711/sgD8rHEiH/
         KjHE/DdQiTykk5Xdo0CHrdZxAcg4qbKCva7BNjLbtqdfUQH/hgYqPEUbehIsfT+/x2p1
         8xllBH/b9a3l8kCY5AUxJIm6ldloD3xDc7PnS7mnDGC726/aZdwcNDumcT77+sQHJ+gJ
         5ssg==
X-Gm-Message-State: APjAAAXyLMrvIdxvhElU/F3Bf8Bkcal0D5ztMfGBV/o3kgslsz5/ySwS
        vPa0gYH2EezZgUHmF0QUwLfoAd1POqo=
X-Google-Smtp-Source: APXvYqzTL+yEsBq+kv6WLezKy5qcaEwHGMp2e0MmZez/YyK81Clei0Lm89VKoQg7CKEuTaBKd+Txwg==
X-Received: by 2002:adf:e344:: with SMTP id n4mr16218130wrj.192.1558826475722;
        Sat, 25 May 2019 16:21:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z25sm2146343wmi.5.2019.05.25.16.21.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 16:21:15 -0700 (PDT)
Message-ID: <5ce9cdeb.1c69fb81.14217.adc4@mx.google.com>
Date:   Sat, 25 May 2019 16:21:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.19
Subject: stable/linux-5.0.y boot: 57 boots: 0 failed,
 54 passed with 3 untried/unknown (v5.0.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.0.y boot: 57 boots: 0 failed, 54 passed with 3 untried/unkno=
wn (v5.0.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
0.y/kernel/v5.0.19/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.0.y/ke=
rnel/v5.0.19/

Tree: stable
Branch: linux-5.0.y
Git Describe: v5.0.19
Git Commit: 3f7c1cab1a61108821cf47dda8a32ed25cc3588b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 11 builds out of 208

---
For more info write to <info@kernelci.org>
