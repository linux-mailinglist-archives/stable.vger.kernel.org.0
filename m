Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B577640
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 05:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfG0DZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 23:25:50 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:40948 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfG0DZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 23:25:49 -0400
Received: by mail-wm1-f42.google.com with SMTP id v19so49137387wmj.5
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 20:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lT0QnJND1zX/mnIIbETvUG7WKX/HP5EHKEiR3AG5M6k=;
        b=ErGS0gaetMwPbft541A+w+rBOivNa/busSUefu2wgjlIQp8sZxmKAau9FJpq2x1eUH
         j7AG/e4wBfyriUQsrcMTbM46ZXI8Zn5sxyL2FHm7mqGhbuLHfhm1vcfY2ppgz46pqfzl
         IfLdzZSeqRuzOZ6tQ+VBP48bN3dDxhKJW99sbBZ+S/HRGjuowOzdifSGlkxbDem1Qpiy
         piDprBi2D3GrqkKGJSkR1IYOe9mNi6/uVBsAWwrn8VCFUJcbWEDWRVf0gtwM1ATv2A6o
         WqMbo2j8l9KfPKtcgtciSevhx+QyJIiQqb+bnLFuQMbviL5QUxnVb9Voh4OVXOY0TLc4
         +bAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lT0QnJND1zX/mnIIbETvUG7WKX/HP5EHKEiR3AG5M6k=;
        b=uAf36ThrDK7eb9vpIUH6Pm7qktHByzTzVKgBRoH+V/kkwxC5oECbDEL6e5sBzl+x3z
         JGTQ7f/zEVVAoS2zoBxcZUi4ppymypufE3OvYQ+1VScHdkVlDdAdM39yYqQ9PSx09pDG
         khuKFq8Gqo/zC48guf+eN1lY3r/Ix+2D6ZiUFxO9tnsHRiFSagLseV0HBG8qrr1JBGtt
         o3WdSfp6+hOV4ITy80C/n8IuyzqVk2yGTDMJ4yBg2ys9Oislv2f0Z8FGK4JOylFqUgCI
         md6Z7ZTENm5ePoMfW8qGl4c6HfN+nXPzrZQRcdtG948y+9c7Adl07VXO471cyYiAtAXF
         ltYA==
X-Gm-Message-State: APjAAAUorJWVTEwoROOy1srxQnaT1rWFxbjSalQ4G+YYHt7Dx889BbMC
        PFld2TMpiA6R/GtChvUo2QksS9wno+A=
X-Google-Smtp-Source: APXvYqw2sTbuQErn6mwVBfkeAWmYOIyd4FFQ+3gPFTVvFg7Goh14xbSvuWR/M/DlAlbxQk9UIQPRKA==
X-Received: by 2002:a1c:c1c1:: with SMTP id r184mr86794360wmf.9.1564197947456;
        Fri, 26 Jul 2019 20:25:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w67sm69329936wma.24.2019.07.26.20.25.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 20:25:47 -0700 (PDT)
Message-ID: <5d3bc43b.1c69fb81.8d330.b6bc@mx.google.com>
Date:   Fri, 26 Jul 2019 20:25:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.1.20
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.1.y boot: 50 boots: 0 failed, 50 passed (v5.1.20)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 50 boots: 0 failed, 50 passed (v5.1.20)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.20/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.20/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.20
Git Commit: aac977a09eca0e62280644a2bdc3403a61892348
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 16 SoC families, 10 builds out of 209

---
For more info write to <info@kernelci.org>
