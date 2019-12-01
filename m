Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433FB10E20F
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 14:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLANif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 08:38:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40669 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfLANif (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Dec 2019 08:38:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so16173834wrn.7
        for <stable@vger.kernel.org>; Sun, 01 Dec 2019 05:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N0C7SK612kKGxXi7nHNsxRiRgQuPGebkIbmyy1uazag=;
        b=sz52Q9ch9ahBrTB5VWiR/SfwDb0GpD3LWElWJrImYRLTVh2GxiNkR3PnQyIsXPlaza
         yflS4uVk5JjQ7wcDIdfdeLDnAzmvD+ajeIcWjitoais6CpUS/UBO/MnNNj5+0CTWTZYw
         TKDVHbiWpVD9kLLE4Gz+hsacNVCzTL6iM+lQFfNIyZGqYqZ4mha/XOk9F56Z0R+2seOf
         bjvvu4WB7nb7/+NEgHbi465tWWwgwFq065oQ43svbd9QAmtmKkX2GLzlu7nqWOWH+IyC
         rhczZ761T9t2Rad6iIuQLCEabuT99ibvPuZfJBqsYHRzrq5uK0Wemj6H5e58+3fPGFET
         dEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N0C7SK612kKGxXi7nHNsxRiRgQuPGebkIbmyy1uazag=;
        b=mBVebvN6Bj4prJ6QyvSMLkEhBuzeSHAfg5ZvG0sl34PmAxiOcSrMDt3yO/KVOmQQA9
         TSZpW+6QURgxtytoi3xy9M16jxTs7GBB0LNTSeWhouP+6qa+EUmYoTF7z+E/WqSyGAe/
         iTjAiD0prw5UfqwvHPstfHwj8K+GUVRCC+9nKkGv6jIoeCrucR6azYw60SjJ/cRxSNzt
         zf4BrC/2VAT4N+H95APKKduTEvp5LPOdzNdRfXUe7cEuFVrk2vh9SFORxo7MFAJOedgc
         xlQCSp5XyUl4645HgRZ1YKwyMSpPRtLcClSzr2i64TovnRbhpOn91jGH9LndPEMgXB/H
         nkHQ==
X-Gm-Message-State: APjAAAVe5I87TIKBcLKRUz1IWnMq7hcm746H1g5MsVgb+tLukOHm/sBI
        HBSmxsIPWQfQ7fpdKd8jZCvjUsZvVYI=
X-Google-Smtp-Source: APXvYqwQ/KleQ2v5UztFmr5JGeNoxxMnW7R2CqHSZVi65J/9BxfUpzk5+WukI0hkffMR/F3Ki6SdQw==
X-Received: by 2002:adf:9c81:: with SMTP id d1mr63142304wre.144.1575207511437;
        Sun, 01 Dec 2019 05:38:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y20sm11908603wmi.25.2019.12.01.05.38.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 05:38:30 -0800 (PST)
Message-ID: <5de3c256.1c69fb81.b754.ce95@mx.google.com>
Date:   Sun, 01 Dec 2019 05:38:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.157
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 67 boots: 1 failed, 66 passed (v4.14.157)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 67 boots: 1 failed, 66 passed (v4.14.157)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.157/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.157/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.157
Git Commit: fbc5fe7a54d02e11972e3b2a5ddb6ffc88162c8f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 15 SoC families, 10 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
