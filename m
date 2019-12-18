Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76E8123DD0
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 04:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLRDW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 22:22:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53982 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfLRDW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 22:22:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id m24so270496wmc.3
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 19:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ueM137+OvTsSzORQCYDsJoGMh+bIRX/OhHSFBqiovLA=;
        b=a3cm+S7O+a9pCjzm2oCNAjv7tGw/B70wb6pby93+Tt+GtZstRc6RsD4J3N7EDL7OU/
         ikZ7ywpBTmRL9KuR0xBdMzyeeaqki9aHhelaCcDnPu27+EbLP2zHDOT7a9Pn1KP5HqzA
         SjF3G/G3xFbznzhBud5uXIPBNsvxMOnO/SQvOOixuTYiQptxEmGcEoQZqCQRulI9u71I
         u/15gouNG65q70LlhWevJcHRHkLZyrMir9V6p6z+rNJ9qjnKTR1BcqmmYSIo64HnRQLu
         wlzPR/BMh+FDl8L5qD7nkARGrOmocH0RutLPdcUzCn+Mu3Y9SrHMb7Gmf/ggfu2ynBW9
         LpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ueM137+OvTsSzORQCYDsJoGMh+bIRX/OhHSFBqiovLA=;
        b=t+OGKstDl0bTGtt6IWfLSeTz28hQVtOFmaDL35bLIwjpv+h2gvnQ+dtf3B228b5FDe
         WZu4jwAV/qS2x6DExg3rApFLzNyaL+KNKTRAYykij5K16WHS20STiv/rpBoaxfm/rcML
         WxSPW5NaXvdL/pn1/ZzNg0urN9G9IlCwj1q9eTVcepAdVp0+mlPBJ+mq2xN6YO1A8XxB
         M7cFyGWaPpqSqQnYVtfy2zpq/UROm/znPxHdIqZz3ZHsQAhIm5HaHGX2rG8WrL4C8dWO
         N5REtyhBJMhxcjUMP2qSAohB1FJO/w2IBlcBf6oKAo2MdzXcN0glew1ucrQKyw43N2Yo
         hOgQ==
X-Gm-Message-State: APjAAAXro3dFAnWNQCN2WPR9oCPNzcZdJy1+gVcJbuLbi13g80HMaOwr
        zx5rriQe5To3XPigvLEjAGn6Ph92Qv9Hsw==
X-Google-Smtp-Source: APXvYqzws9EwBhDfOybPI6rOy5vbxOOYctYt1negxiHpAVrBkgCTjjJUpeHfENSS6wfrokva0q22iQ==
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr234777wmb.91.1576639364181;
        Tue, 17 Dec 2019 19:22:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a14sm943290wrx.81.2019.12.17.19.22.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:22:43 -0800 (PST)
Message-ID: <5df99b83.1c69fb81.687ae.3c1e@mx.google.com>
Date:   Tue, 17 Dec 2019 19:22:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.90
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 61 boots: 0 failed,
 60 passed with 1 untried/unknown (v4.19.90)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 61 boots: 0 failed, 60 passed with 1 untried/unkn=
own (v4.19.90)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.90/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.90/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.90
Git Commit: 7d120bf21c05cbe30a679f0feeca884eeaceb069
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 43 unique boards, 14 SoC families, 12 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.89)

---
For more info write to <info@kernelci.org>
