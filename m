Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058AB14C742
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 09:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgA2INa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 03:13:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33756 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2IN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 03:13:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so19073091wrq.0
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 00:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R749Dp+EyBAbjBdAGiaKvNtfh2JG/Tb47jmdFQrwpEE=;
        b=VvcOUw1+5LwU8dnBaGC07HyP6lPLj4SPoNKSL6hcAp+B8Poe2gcPZpyyJm/stLPBwP
         VkitFUl2pCZ07DsnVNoOkanLvLb2GiGn/k+M4BzZLdt3zCB3zYwM4sRknoBxuixFQUcu
         iLLRUrYi1h1FaikUAUXfnnJvFlIxLw+/vgoYtmN7c2B7n6t/rQ2XfBOPaNxzaaGunHD1
         JoO9R3ui8h9E3V45L602AKYTcFWc7HNn/f0agklc7Dl20ZMubH7lCISuoqaBeu4LBfLY
         vtLzyQmrTKlLKwLaIPCRZ6NfkL/phLI/rM5wCwon4mLQkg1Y7Ny1B2K7v5O7oPryE4fo
         JbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R749Dp+EyBAbjBdAGiaKvNtfh2JG/Tb47jmdFQrwpEE=;
        b=rm0pm7IStBE/4koFaCi7XyiIhEXArR+GrwbmvJq/vbK8sirFK0TtEcC4xfC9AQ9iSA
         DvE89czAVUx0G71wglzRNfAjWtvtpwMvTViAMyIJEzg7loW9OtE1fp9WWAHumy6uBBs4
         WGbcvJnq6+KXB2d1AgLIl+k0dxOh8FiCd4VzDONsEowzEuHAR1+LyNcI3p/hmewHqVj5
         6y5ueEsOj6s0gDm67ocQYCbSkOAjMxEYNR39Alx2+UGNhOEWJMFCjHSRfyUEXs4cgpA8
         VUU6T9J9YASoYm+MtEQ3ZnoFXkdyZN2IKXc4sUbuCjRTyMGBkuZ5MifVomty7kJZv76E
         K3jA==
X-Gm-Message-State: APjAAAXYS0jnyhaaqjDdjXaavj7Og06fSZbHj4oMsOr21FnU2mmPVSyr
        IoiF92ZYSfFzZ3qCd5sRZLRJaCsJ+fJhzg==
X-Google-Smtp-Source: APXvYqyE6Cavx3XFopzVJF6fAUwEanLAHlJE1GVsQMBTRy9l2z2t7oh7EHW9Q3aCp8f+bZM7r5HdXg==
X-Received: by 2002:adf:a1d9:: with SMTP id v25mr6994131wrv.160.1580285607596;
        Wed, 29 Jan 2020 00:13:27 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b17sm1810872wrp.49.2020.01.29.00.13.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 00:13:27 -0800 (PST)
Message-ID: <5e313ea7.1c69fb81.43a73.6a23@mx.google.com>
Date:   Wed, 29 Jan 2020 00:13:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.99-93-g26d743063ae6
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 66 boots: 0 failed,
 65 passed with 1 untried/unknown (v4.19.99-93-g26d743063ae6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 66 boots: 0 failed, 65 passed with 1 untried/u=
nknown (v4.19.99-93-g26d743063ae6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.99-93-g26d743063ae6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.99-93-g26d743063ae6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.99-93-g26d743063ae6
Git Commit: 26d743063ae6ea030faef12264de0a0156d5452d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 14 SoC families, 10 builds out of 199

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.99-41-ga59ea6d9c=
99b)

---
For more info write to <info@kernelci.org>
