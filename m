Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B591713D138
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 01:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgAPAm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 19:42:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36953 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729112AbgAPAm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 19:42:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so1979409wmf.2
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 16:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4/jstXZmrITObPhJbH2rh8I9wEDPhZEPe6GyHJoj8hY=;
        b=pWd6LMWcUXUU/aOkgo2eH4PxGxpVX5NtqdukUt9ro263EB9OOuGmll/0qRpOFpSa70
         qorvd59T6rDnNHSeL0MPb2d2hwOZl+FcYv3PlXvHaig9SPlBvMiezPPY+lmufe1IegL+
         RLPgY/pnyl8u4v+xsQ7oTijA9YL4OzZCnjs1qSLs4rIib0DvuRbbb1VSmNsXJiFNLTs4
         UPOkm+2gjmOOPV7FIklgcGIUmU4CZbukjsThPrJjw5T4C40DR7ewr3in9NlEcuAN6tr2
         +ojVfHBri4bTwjgOdccu/t4djwSOqQ5OYNBFrvuB9VHlMunwrGlNNhwBdGN0sjf4N1/A
         A8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4/jstXZmrITObPhJbH2rh8I9wEDPhZEPe6GyHJoj8hY=;
        b=FPMMfzLAWjGT3h2EnqwbrzxsQ4aa+VV5qvpZnW4iwXYP3b79PapkeuJLajqNDflgor
         ZxbqSSXMOtYHjO+uxP1ECgiHEiX5UCH7bnKPqUEBUqK9zkfBTEsCXCVaqUQpbXoY9jFd
         Hy1dXzvFWdQRBXs0GRm9ZRddIm2MMz1I+aY347xNhN/4xBq+5UaaI07xn5kgkBJzi89T
         vmvJSZ99w/juGV7zyU3Lkr8cIsqc/bD8fAuVJDSdwt2PyIDYi6H6ej19hqFx6IjBSzLg
         tAFwfhRdkbE7+LAaiAjCKDYTB95WAct3C8J41qJYRbSXgXz7JrWYPmEfnYHzaopnRlLd
         /pUg==
X-Gm-Message-State: APjAAAWUFaeD3jEUURNEUt/0QTvP1vR1tUbniXWlLWskon2BApA7wOyu
        Se37fSp4gnTrMOn5n5lj8drjREyyFTdi3Q==
X-Google-Smtp-Source: APXvYqxf+k9Yn4Hq53Xakiszxk+g2QNCH9GDxJ5/pPaJHk2ZkJlNdU3k0uh4BeWR3IHD4YXooo8XGw==
X-Received: by 2002:a1c:44d5:: with SMTP id r204mr3018028wma.122.1579135346317;
        Wed, 15 Jan 2020 16:42:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c15sm26638868wrt.1.2020.01.15.16.42.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 16:42:25 -0800 (PST)
Message-ID: <5e1fb171.1c69fb81.b90be.fb64@mx.google.com>
Date:   Wed, 15 Jan 2020 16:42:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.165-20-g241f53838006
Subject: stable-rc/linux-4.14.y boot: 73 boots: 0 failed,
 72 passed with 1 untried/unknown (v4.14.165-20-g241f53838006)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 73 boots: 0 failed, 72 passed with 1 untried/u=
nknown (v4.14.165-20-g241f53838006)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.165-20-g241f53838006/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.165-20-g241f53838006/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.165-20-g241f53838006
Git Commit: 241f5383800698b5f3921253c06ee80dcf4b5945
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 13 SoC families, 12 builds out of 201

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.164-41-g04f13b8f=
773f)

---
For more info write to <info@kernelci.org>
