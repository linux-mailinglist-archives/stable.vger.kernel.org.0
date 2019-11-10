Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24039F6A1B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKJQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:29:00 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:54409 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfKJQ3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 11:29:00 -0500
Received: by mail-wm1-f48.google.com with SMTP id z26so10854513wmi.4
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 08:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sc5luqqeZ3UC0RDbz/rsD2C9HvzAvjMichTCVY7+oPE=;
        b=yVkJ3WbCUoXFI+AGoOHvOhSxKIvWehMn682cEPi7K+TJXqcFVYDyiWSrUsLUqrA7O1
         NQ4IJg7sTHfMnzSNT7e36siyIsNomKIHzdSKtYmkJCaxH/JpFJi6k4v9uVrCnhwvP46G
         gs4OKnW+F2MWdc4sBst79sHkwV5NTUSN1eNhNYgf2kxsEfkbEeihgo6qPXvdoZn3krtW
         Y+I68Rjxh1EP9ou6USbcvRVYvC0j46ubtZcp+t35U/i/vlcfwQqRvrBHEwbSecFINiXJ
         KvT26Re+uWk70d2mFpWKxYGNJf4bz3OkIjEvGA/+w5HX7jOcuRpCzo3KEund7S3UKN3j
         s3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sc5luqqeZ3UC0RDbz/rsD2C9HvzAvjMichTCVY7+oPE=;
        b=lW+dtKvX2ywyULyn0foX9fp5Kt4+AApgskv8GXmhJOp87cwrjug4YEZV+bbem46Wsd
         rt2RZalj5XlIzIB2l/yRuBvjFFNa/DMZ2ttgBC/siQ5aAiMPxdfAUwp7yk623csN1fW9
         T8jEvn0eI8RlawHHRQ/WZeMSSFA5f/ExdrEyG9u8ier3fReDbZK6rroP9/JDevZoNOYM
         airsLQgjpYdFqWgmlFS4//7h8Arqd4Zm35f98lOtz0GEc6cBqA7KgyN8zdPQNkdkK/t9
         1iOXF/NjsObycXhk8AalruARJqY7sbBZ7Tkrnf2EGxVX2Bkpg+ezHu32tn5ytyolyhrM
         gpPg==
X-Gm-Message-State: APjAAAVwviUshk3bD1KUoW6Qxu50GClPYQvZJjVYF1CMw/FPQxA1Bfis
        c5btPX58Wq/LWobENQJOcptciWHpRVU=
X-Google-Smtp-Source: APXvYqyhB4IW7yYxH7JOlLDBuyCcZy2rdfjoExAkgUFt5Ds88kmEyhjFGd/Gs8RKxQmmvAgvvT4Zqw==
X-Received: by 2002:a05:600c:218e:: with SMTP id e14mr15755084wme.22.1573403337738;
        Sun, 10 Nov 2019 08:28:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g184sm19754521wma.8.2019.11.10.08.28.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 08:28:57 -0800 (PST)
Message-ID: <5dc83ac9.1c69fb81.4cc5.dc95@mx.google.com>
Date:   Sun, 10 Nov 2019 08:28:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83
Subject: stable/linux-4.19.y boot: 62 boots: 0 failed, 62 passed (v4.19.83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 62 boots: 0 failed, 62 passed (v4.19.83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.83/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.83/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.83
Git Commit: 7d8dbefc22ff71c12c5f63ab0c6de7f70d1f044a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 15 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
