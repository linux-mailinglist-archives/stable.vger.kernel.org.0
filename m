Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E7013884A
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 21:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgALU5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 15:57:34 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:34485 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732825AbgALU5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jan 2020 15:57:34 -0500
Received: by mail-wm1-f46.google.com with SMTP id w5so8373486wmi.1
        for <stable@vger.kernel.org>; Sun, 12 Jan 2020 12:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fNbASUCTpqzhWw7+agXw7YKSXVOIoRSM/DEqhJTuBfc=;
        b=xsuBLUh/pFMLmU+DuBZCD8YteH1ThuDukzBVcriWVQ4pdJokTJhFoXoAQ2YJWcO5bn
         q5q0oDM7O4sk2XE4c66k+Iye+tFwpvEwl66mazFOdvQUX/5xRKx/nZzZdc+RAokrvC/3
         O8v3nAfazN2XgEMmASbCILBf6B1PKON9qSugJ5vihNDWInr8PNb9W8SV47D/m6WppALa
         LDTurCl/IX42MFvmbCxsZ/sqlgoXvZD1LpoC+4JTD4hlzjzZ+aO3JjEP8xJG59f/mBww
         Tm1JwYpX8J8Y8OcU4DghExqaH+qzfuhz75dFIjZcj6qHKf2mUYyA9qvknx5cbJwa1owE
         sK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fNbASUCTpqzhWw7+agXw7YKSXVOIoRSM/DEqhJTuBfc=;
        b=BDb1TrTIdmfT+CG7C8jZYL6WNa5FnxNJEWK8cLIgO5MbE6YYM4eMzNfd7tstijSBNr
         i4SrvWLFQWiH8gZw1bLoKNQL8o9aLudQIi07pcL3qKGzuvszMsYp/7dM1DYew40mf0yK
         itNUJq/w1zfOzIQ/r9M2MSke7GqctRaOGorfGx5bTK4p5CJDmC3hhLfYw2fHmvQnKRv2
         JmeU/N5HlmcULtSfE+I4avCnHt9BKORSkSDv2rk+iWvLF4qrC1/QFjrTFswnRiWemNDt
         wtnRTUo0xT4zoQb7cZmKB3DzILu2FCDPW2IrqRt7d8/Qb6nUTAJpedtXZT78NSKOITRJ
         kKeQ==
X-Gm-Message-State: APjAAAWqzjUiGVhG1fM5g5BbZgRIadzX94rUq+QquDWrrtFJetWlHQih
        FM6kjAVv+47mMFl5FFLS5J8ZEG6C4vXZAQ==
X-Google-Smtp-Source: APXvYqxDlf17vYcnkFkN5N/m/YFByeN35FqgPlEkJGrb7zAr4/sATgIDM8PsW4N2H3uxOGZGUljr/g==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr15597048wmk.131.1578862651744;
        Sun, 12 Jan 2020 12:57:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c9sm11410724wmc.47.2020.01.12.12.57.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 12:57:31 -0800 (PST)
Message-ID: <5e1b883b.1c69fb81.bb630.f445@mx.google.com>
Date:   Sun, 12 Jan 2020 12:57:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.95
Subject: stable/linux-4.19.y boot: 77 boots: 0 failed,
 76 passed with 1 untried/unknown (v4.19.95)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 77 boots: 0 failed, 76 passed with 1 untried/unkn=
own (v4.19.95)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.95/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.95/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.95
Git Commit: dcd888983542055210f5e68f1b1f1f8fe11a369a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 15 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
