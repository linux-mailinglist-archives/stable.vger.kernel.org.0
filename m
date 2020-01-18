Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851D31416CE
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 10:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgARJea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 04:34:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41925 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbgARJea (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 04:34:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so24874856wrw.8
        for <stable@vger.kernel.org>; Sat, 18 Jan 2020 01:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G2cu0KnP10M+seHjt8YquQW8i8JfbKDRWaM4l1fID8c=;
        b=GOq/zx02zlzP2MliB7Tuljm1VFmrmlRiXsG6utSCSQZC5LBhwphnocTeixMF99rEOZ
         uW9iPsmb78sPkfHZB1yFikdPK6HbS7QTtT+irQJ7T3RbNJ/7sqj1APNbmKxyufSyV0CB
         SaCQ3oeDNc0pCWrhpZIzlPRqFqcupyKbAGMlPQMm6UQfllXyuWahvebLJTVxfVnr4tnt
         K0CP1M7bpfND6QsXXB1yo/9eSbyRN9UyeKDu/jYERZ0PNRlUB6TiCbmxsPmT+qzlIoru
         g8y2/duyMleytDm180UW0vwWQkLEr4LSbO9ZI3oMrXoFHITYXtSsMokyV+L+U1IYnMCU
         awvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G2cu0KnP10M+seHjt8YquQW8i8JfbKDRWaM4l1fID8c=;
        b=DYI8k/0x8b++s4WTtIIo9ytU2GGSsXemluWG5LHNRq6LpvG9kZDhDPNSNKje9PeHKL
         2sqHGo1tfo23w8cThqtD97zXsLZoR+jamKu1Wv8OzyyiO9kmCJhwIU57OPN8SWqf4Za2
         P1WAtKG7K6i3vjpcW2UHIsn26cBAmsecHzW0u8U7rMkXhsOjDeDQaLwKXGt8k6IOmvNa
         DT/krzcDw1qN5r5i8OKjMwlHhTvqLJX1HQsDWYjwCtHlhGVyTuqn1E+Fu60j8wKTQApq
         xJGFtNu1+0w608xlddeVG5udgY3s2ok9yZNN/BsYILPkwluKEk8sTbFCo2nm807ixBxH
         mkQA==
X-Gm-Message-State: APjAAAUvW8sOgtlQyGsRKZQyow8kAKaHWi5u9Pm9jFr4ayYQanoCHsKd
        DkBuga9li5uDPXC3JSW990goGeJcBTcsNg==
X-Google-Smtp-Source: APXvYqxUe58v7cHnt/Bo4stpmxqiGRISeJZfU4e5Bm6Lyluq2lVFW8Nbcqlro2a5RAdD8Pl2d+Nbvw==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr7305189wrp.238.1579340068839;
        Sat, 18 Jan 2020 01:34:28 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r62sm15209747wma.32.2020.01.18.01.34.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 01:34:27 -0800 (PST)
Message-ID: <5e22d123.1c69fb81.5b576.9ff4@mx.google.com>
Date:   Sat, 18 Jan 2020 01:34:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210
Subject: stable-rc/linux-4.4.y boot: 85 boots: 2 failed,
 78 passed with 5 offline (v4.4.210)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 85 boots: 2 failed, 78 passed with 5 offline (v=
4.4.210)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210
Git Commit: 05bbb560f4f40fef38df338f87a17852a308d9dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 17 SoC families, 15 builds out of 184

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
