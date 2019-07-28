Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242FD77F55
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 13:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfG1L7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 07:59:33 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:52951 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfG1L7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 07:59:33 -0400
Received: by mail-wm1-f43.google.com with SMTP id s3so51442888wms.2
        for <stable@vger.kernel.org>; Sun, 28 Jul 2019 04:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2t6ZjMABXm0R86TL2TApX+hQFeXi9Hk0K6i1jcBBAM0=;
        b=uGMeLBempuJNdlQhCULqFrqWotubxwm/fLUrhtorFRGpq1lLqT3rTYdrOiuVuY5t6v
         KwqYX0YC0C1OJifuo19kgRgdauF1QP3zwhngvV3pxx911Wbwejunkl1FJlaacG94gzsE
         mbKQC79iMAvpZonV77VnzGWavEYcrZS5u4CEnHfSeEqmenMVWHaJmA2X8uTB98bCCVL+
         tghs6nagl2PQaA9LePk6PrQcSP76aMFnCeZdFWngMDSHnjT3Xc2owTduff9jIJHAYNEs
         bEtmSOnd/AoOrl4DZjpn0Hgbj+5xiwUoROfLBRE9KtQHiIvHAnrkP500URxaQcOvCF98
         jKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2t6ZjMABXm0R86TL2TApX+hQFeXi9Hk0K6i1jcBBAM0=;
        b=QQKyAl0q52BJcmgN9xUh0KyVqYXEeyBAFvjgFrvn3m4KrN0WtAuUk+udIgGnGL4+I6
         y6jWwCrQR5HefbJwhX8ohnzAJCaIlgW+73JotU6zhpGzliouIsAnOL1c7Zzf5Uru2muA
         iCJ0o0KH51b/EtZnz5PkC4M2Aopw+PXlpZBvTvuwhcbDfm+t+33jN1EwIJYK/2wZrcUL
         F6c0V6NEpKBrAEBGr5NhroqYzBZSsP848GWx15Xj0NfgeF1Cs2AYroqca8GwuFGy3VgY
         FmpN8267ogm0LVZs6Fc97CT5en3GV5CM422cHwrX3fn2KLHapD06C4Bsaz4ER7nTtatx
         jvdQ==
X-Gm-Message-State: APjAAAWz8eWgLp+wVB4FvwDKOM93Xb9oWeHHSfKh+79pwiArS0C76Eq8
        AUN4HZG6QayKkWHF1TYTklEBSyqD
X-Google-Smtp-Source: APXvYqwwI1Fh71bj8VUCoLvH3egl5JNjmmQ4bDueHBHu8XfhPLB7D0w1ax3xHqy3QFSbv3Q6JObtIA==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr96932998wmh.55.1564315170838;
        Sun, 28 Jul 2019 04:59:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 91sm128464199wrp.3.2019.07.28.04.59.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 04:59:30 -0700 (PDT)
Message-ID: <5d3d8e22.1c69fb81.f0936.63d8@mx.google.com>
Date:   Sun, 28 Jul 2019 04:59:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.1.21
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.1.y boot: 35 boots: 0 failed, 35 passed (v5.1.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 35 boots: 0 failed, 35 passed (v5.1.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.21/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.21/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.21
Git Commit: 4a9b1eb8bc3ba4ad8b3b1aa3317cf8d4a3aaad83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 19 unique boards, 12 SoC families, 7 builds out of 209

---
For more info write to <info@kernelci.org>
