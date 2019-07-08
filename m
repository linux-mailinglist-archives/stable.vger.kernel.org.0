Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000F96293C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfGHTXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:23:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46093 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbfGHTXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:23:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so13743813wru.13
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bSvLMIBH1Y48taxCRuzAlDFjKHedGJ0Sa5daCvwKPv4=;
        b=x6x4ZAwy2y2dBEJayNp4rGiU2lsX+H54flwYFDAxTj0/yPSyPIUwObgD26AyvBnlUa
         7Pc/iAtKzbk/XBxxbE/M+ugljBQLAsCLwOvhrGmJMhNUjk4P1Q8y5Q8oaYCKvRTqdV8R
         ZasWcrAjWeneFv2qmhd5su7vl/kCGLVhOBLOfTfOJvJJpyabMXOTrvE7FxG9gQXlGUyp
         zrloKp1/HASC2Bmbk19sC+SQFmikAYNzZcoHiHQ6qFJY0GdLG//yADf9w04EokMz06HJ
         hEZ6ianJS2Pn01R6lcrznXTlkM15hAYx6AlrO0jKM8+pDt6g/JyxtdepOpKgrSmtEo/h
         uBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bSvLMIBH1Y48taxCRuzAlDFjKHedGJ0Sa5daCvwKPv4=;
        b=n+fBUnUYqy+XOWBHe1ovDFaJKg9mTDyV/vnW4Nzjc71vxHuFGmzhICxpE6nPxiDG+X
         3hKLoZOa/fwdgPfuBhClduIVOKKLdiBB/i/blV2Wsqjp55qAtFkNX8XZfGL+w2up+O9p
         ccwogT/mr7vnqrVFjoTTmkXVazmmSHdGH+j2PYMqTTFnkAEVqEtptkTVkDnpdX+7HpBi
         zaf5enBL2JKRD4wX8dFHnkLynDkSJIHEY4cOG0m/zswxNmgINZ/gbcuTNiHaIPyTY8WO
         x6vvq85O1dv0Ba+2ztVatfVB2k6ZE6Ro31S0TJGxl7ynR3d4QD/L+mVcGZSaJhDOWuMS
         YhkQ==
X-Gm-Message-State: APjAAAUqWoaqhD0PmtUIIyR3K/AZe4hczgbDoVHfrIX1RPRXJQbiha1w
        OCIDROxsEo6HTwpoubIKi2x/Ah1lBPF5Mw==
X-Google-Smtp-Source: APXvYqx1zJLipcG8ukadYfxXdl/kVN5fokSj99KrXEj1jrG1zc3N4pQx520d+RIAkJG6e0ywZDNJcA==
X-Received: by 2002:adf:df0f:: with SMTP id y15mr20228367wrl.155.1562613825807;
        Mon, 08 Jul 2019 12:23:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g17sm13069467wrm.7.2019.07.08.12.23.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:23:45 -0700 (PDT)
Message-ID: <5d239841.1c69fb81.fafd3.71ef@mx.google.com>
Date:   Mon, 08 Jul 2019 12:23:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.132-57-gb33dcbc2d8e5
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 105 boots: 3 failed,
 101 passed with 1 untried/unknown (v4.14.132-57-gb33dcbc2d8e5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 105 boots: 3 failed, 101 passed with 1 untried=
/unknown (v4.14.132-57-gb33dcbc2d8e5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.132-57-gb33dcbc2d8e5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.132-57-gb33dcbc2d8e5/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.132-57-gb33dcbc2d8e5
Git Commit: b33dcbc2d8e56734ead69d9d6808090159b19dab
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 24 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
