Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 323DDCD98D
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJFWuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 18:50:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39858 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfJFWuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 18:50:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so10495122wml.4
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 15:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5FhZ36jnVtPYp2moexL6x7c0xT4VPQ85lGFj06T19kk=;
        b=gkwpiexgKqL0Pim1m6W86mDfXKYH2SjAnKeql5TCkFWkg1DUDAjBxU+mQUh9YjqlzS
         m5sMiJUOZDFeoS6jZFOn3pENNgsfroroRDZ5uOal/9r3lVYk75Zx3QcnuCAtMuaEwL9J
         B4oLCzJcMCj1GGdAKaERSgk8oXD5LqQUHpqcJ7h3pficrnfBNaMDCTONfH6bh7PjhpEO
         NVR9y3lCeKZz5h+8si2n35NhBKX1qdKDdQwpAhJhn7wv6KAM0IgtS/u5Nox23cxzBKis
         3Emtky2JaVfwm+xYhJZ8FrJ/lXqBn8TU8OBMIP4NBazvJdoewXgBf9cRbfpD/U+TaXd8
         tbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5FhZ36jnVtPYp2moexL6x7c0xT4VPQ85lGFj06T19kk=;
        b=FzLwoBh0bwpgoZKGDfezSUK3vUEAkdoBs+6FHv2TQ9bUmpBp+wph/N1tnrA8ppv0S3
         buLWx5b2EbuAb0CAxrkxdqqUNPQfBskfvtJ53DzICuy9ZChN6VRnticYx1QTcAVeM0Os
         bD71sDUAriTa/rE4zPgCUm4+xiOnPJYV/NEQ8qejiS3Cq7Xu0WSGipM4aOjB96vW0UGB
         PL3J/SE/+TdNKHeaiMctlaouwPIPa2RTqu20n6k9dM+6TfslkWckvKK+pMb2McYvlk5N
         UMp2/EOjHEy3zNhQqcnXa1t8YNT35LiNJrps2ceVnslBNgGNrus2rmV58TD9K0e7CS/x
         c4lQ==
X-Gm-Message-State: APjAAAWnbUIYbqAL+igSrA3OEsBqoWPK5UZ2zG1ixg/+lpahsLJ9rxE+
        2G5C75hqfv92LzPZlXido3EycZYAshI=
X-Google-Smtp-Source: APXvYqyYpEqtfxTWeAwZISKGqEKEMRmLtCG+N0C6RHP9cK7/skoL052EPZABElvjtJutqblJzveKuA==
X-Received: by 2002:a05:600c:2291:: with SMTP id 17mr10333985wmf.58.1570402237216;
        Sun, 06 Oct 2019 15:50:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y18sm34048725wro.36.2019.10.06.15.50.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 15:50:36 -0700 (PDT)
Message-ID: <5d9a6fbc.1c69fb81.6f4ff.b67f@mx.google.com>
Date:   Sun, 06 Oct 2019 15:50:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.147-69-gb970b501da0b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 54 boots: 0 failed,
 54 passed (v4.14.147-69-gb970b501da0b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 54 boots: 0 failed, 54 passed (v4.14.147-69-gb=
970b501da0b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.147-69-gb970b501da0b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.147-69-gb970b501da0b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.147-69-gb970b501da0b
Git Commit: b970b501da0bee5eba4e61ea7d424adab428a165
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
