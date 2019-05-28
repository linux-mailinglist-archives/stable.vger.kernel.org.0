Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676A32D101
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 23:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfE1Vbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 17:31:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43981 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfE1Vbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 17:31:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id l17so157093wrm.10
        for <stable@vger.kernel.org>; Tue, 28 May 2019 14:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C1MLF0Qm25rp0hMLW+swBPplg7lIgWg8XRy8YEgMkbc=;
        b=cJgoQWJQXupSeHX5jPbm6YBkYD51vIy7i4EBDFMC4V6TvF0kMqfcXLxX/t/Crd7O6b
         mKL+qVjNWUM7ZGxKhdB4KSZUMeFTF3LADlz2SnA9xAUj3YJ10SOf44AKN9lTX3i+EC1P
         9gZkMcsqxWpnMkX7xOZJd7g8fL5i3WxM4KMeXxLVOhP/UGW4BnMJY1dn0VOrDw1s+79u
         ydta840YF7LmhaYHr9VD7z1ELpp2JWTBVThn15klKcX4l9AlZ/pHpxy1P9U7HEXyCbtt
         uR3PJlezgCpbs4N7YMPhjvo0r7W/Kz8tqDjAvBnP/ZVadSbWHEvM/Bze59K66nTrooPQ
         T3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C1MLF0Qm25rp0hMLW+swBPplg7lIgWg8XRy8YEgMkbc=;
        b=dQFNOfm23eF5EwnXqPmYtiVtp7ypnZheUNHBmOdDQc/DFmHhLF9Kv/aYhgEGRUslqc
         pgB5gmtIXiPk7+kkAr+BaxWc5KkPtmX8vO6eWnd+mBvbhT3NHWXQA9i6g5j9RBTLQ94Q
         LHuxAO6vxhJKHs92eY8QhqLwUl+hr0mM9OU6t3W3tSl4kxNABANOllsCDb5htDMhNDa9
         4QVseCcSsIhmwYVLYfxcclvhmF8QLHK0erBUKIHb82WHkavQNE+XyPjxUllxIOE+9g77
         IWv6kN6/cNnPYCW+0fmnoUXGf1JJ3b3RF1+Cmes0aKEg1A/SnZV35iD98fkjw+YtUsHQ
         +z7g==
X-Gm-Message-State: APjAAAUT6r7zAAOZ+77H0QgI8YDktiNDNRQZDWSl6NWmGAooPQVMwUEz
        EVxPRi3p0Nqwf2ob6fMO0QqnpSwpyEPzgg==
X-Google-Smtp-Source: APXvYqzi7mPR6WrfBIs1IDqBEztl6+qnkq7vpi1QI5+dAxYYtlZkuQAeh9RCCrEOkklXcI60C5Qd4g==
X-Received: by 2002:adf:8307:: with SMTP id 7mr67997833wrd.86.1559079105606;
        Tue, 28 May 2019 14:31:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm13113837wrt.66.2019.05.28.14.31.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 14:31:44 -0700 (PDT)
Message-ID: <5ceda8c0.1c69fb81.69a39.746e@mx.google.com>
Date:   Tue, 28 May 2019 14:31:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.5-32-g447135891ad7
Subject: stable-rc/linux-5.1.y boot: 129 boots: 1 failed,
 127 passed with 1 offline (v5.1.5-32-g447135891ad7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 129 boots: 1 failed, 127 passed with 1 offline =
(v5.1.5-32-g447135891ad7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.5-32-g447135891ad7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.5-32-g447135891ad7/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.5-32-g447135891ad7
Git Commit: 447135891ad7d57839d67805d3262690f94cd56c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 24 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
