Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D770816F60A
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 04:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgBZDTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 22:19:22 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51985 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729226AbgBZDTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 22:19:21 -0500
Received: by mail-pj1-f68.google.com with SMTP id fa20so648787pjb.1
        for <stable@vger.kernel.org>; Tue, 25 Feb 2020 19:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AN7xXr+iqq409M6etWtHInZZ/FP98zY+rl3I/ZknXr4=;
        b=Tw591YS2/Iojlfqg0FiDJzxZeL0DtD5jChlrl+VGOIg2v90Awpohq1pZXr+82l0PV0
         bY2UkuQ5RF7NrEXxi+rc7njWk6wpYkoJoTAJleNbB4ZDYZsFK/G8TCY1KvcQGEs5SR0G
         Pn7U4rh7ewrHDK6kK3dBQ11dkoo4Qw41QZq+LjKYvPMXkR/99QX7eRx8ZYA903kOX+rt
         BYUdgFIHcHe/lbDtPSl4OEjCvaDhhIYEFvn4LVqtLMXomSoUtgM4gvlc0+Sksa2/MhAE
         f2iAQmCE4P3jnd15AM0cOymSknuiz7iZ3Bz1E6ZtXxxrl3A7OyCWrmXBtTCoaFGOIsDp
         QVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AN7xXr+iqq409M6etWtHInZZ/FP98zY+rl3I/ZknXr4=;
        b=UseCwAeUI2O+iD32bE0r+aynYoyzj6dKRP2/jgqVbAoTCtQGFaWD7YlXcoIE5Xhx8G
         MwMnfZNws2/zlm51Bl8XnlB6ydiVj6xwzX6YWL0N3bmr1EVomsTatfBYg6UPXio7Zx6R
         HYVZrmK12PNvLOMsqwXRLNUDhQ62rDnBYWGZl40vl5Y1QACbyRI2+Fa0x4fgn1VlbpC7
         d/UqsdD/UnQT/efUqvfs5JTJNsi9NasIsa+ClCaN8FNb+gH7hbsJpBrZCmAU6H3t225E
         OTTFl7ANMgDsn3y5MkD/P9MFw6bpRHXHM8WP/Sot5Wq0BQaYyubA6+0pR6N3AVw2pR9t
         H46Q==
X-Gm-Message-State: APjAAAVbIE6SpJVZ6vJPqd0yF9l2ayZBNvzcZsIyZr3w6d5+kQ0g0RVW
        GrYt5z5gyTq/V2/cGB73yIH1DZLJZvc=
X-Google-Smtp-Source: APXvYqwRsFUvVUNn6U2ZVMfFSXLfbmlJVN1NWPvKe+cvyDSpqoyOns+XRISrHoS5OAYVKmjfm+hj/w==
X-Received: by 2002:a17:90a:ba91:: with SMTP id t17mr2707225pjr.74.1582687160339;
        Tue, 25 Feb 2020 19:19:20 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q66sm386663pgq.50.2020.02.25.19.19.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 19:19:19 -0800 (PST)
Message-ID: <5e55e3b7.1c69fb81.64bdb.21f3@mx.google.com>
Date:   Tue, 25 Feb 2020 19:19:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.22
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y boot: 101 boots: 2 failed,
 98 passed with 1 untried/unknown (v5.4.22)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 101 boots: 2 failed, 98 passed with 1 untried/unkn=
own (v5.4.22)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.22/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.22/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.22
Git Commit: f22dcb31727e3cf31a9143437f134ea133021982
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 66 unique boards, 20 SoC families, 17 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.21)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
