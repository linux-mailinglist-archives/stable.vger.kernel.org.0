Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B294F4F6B0
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFVPuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 11:50:18 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42348 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfFVPuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 11:50:18 -0400
Received: by mail-wr1-f53.google.com with SMTP id x17so9369001wrl.9
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 08:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lYK2f7hmELZ1odMDeObI1gG6lmuLBo7APSQs3ZJEzhE=;
        b=Lfgq4wodpnHzPUCxdepZ3SEN2I0iIqY7VFRbf46VGFYcCLTsDQ7VjTC4V2OZrRltjG
         zjZzozPJUT+LLsX4mEUSgFA2Lb++kuepr614oeCnINEOqMThke+ZByqqtF5P/qlh7yR/
         IidwnWgzstp1pNJj67LpVixWosETgagkgTvH6rW1F6qbmrqiZ0m1inPOoBcZFy+FyiKj
         0lyAmBXOvGD8TX0mLBCKqDMw1B6cMeE0zrbiOxjN9sGmMWReV1DMWslsxj1ud+XfMkLt
         bmIqW632zGhhcaaU4PKZxLF/6mDnVZY5xTlLfrhkoLCK/h5hlEjg/PN6aQQJb/t1GZOI
         7a8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lYK2f7hmELZ1odMDeObI1gG6lmuLBo7APSQs3ZJEzhE=;
        b=sdtWDjsK2iMyHKxaTqbFD6FK7+ows77a34mzcb1/IbzMjjMkrhthU++kQEnJuGI5OK
         601Q9xRKHnJ5UEQIav0etKLzk6n/dIPVWG6wI5ozG7a3aPZCsgmI1M5WG6+Dz0Rkq8gz
         AgZ2CGz5NUZ/CS8lEniNativWLc3/CTWC3E6oUiuXw2wEPegThqSzcwd78RW9mLeoGQv
         g0FCK59qhrD1rcRd0knKZyrjxCrw4EW2L/KUQ5P/kKUK0rBGrDSh42bvb4fZbZJ0qXih
         XnNHzNdnDqA6PQQnQlAbhx2S0ACaqroYycQnFopRjyO4NC73WkjohNlJCaOPEdJeQRDu
         EfVg==
X-Gm-Message-State: APjAAAWeq6mdJuWPjYqZeG/eUoITmryupI9OofQ2nEsYdf0dplIE+p6B
        cwDvq1zQaFPw7KHW8YSqZQbAmZtJNwtC/Q==
X-Google-Smtp-Source: APXvYqxiB/QVzM6hXE+Zi/mlPKAu2QcPdtEQ780JdbWchdD6mqe/xKfxC5dn4Pi+/0jBQtuYrOOTVQ==
X-Received: by 2002:adf:c506:: with SMTP id q6mr86237382wrf.219.1561218615873;
        Sat, 22 Jun 2019 08:50:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t14sm4310700wrr.33.2019.06.22.08.50.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 08:50:15 -0700 (PDT)
Message-ID: <5d0e4e37.1c69fb81.52fd6.68e8@mx.google.com>
Date:   Sat, 22 Jun 2019 08:50:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 79 boots: 0 failed, 79 passed (v5.1.14)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 79 boots: 0 failed, 79 passed (v5.1.14)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.14/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.14/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.14
Git Commit: 5f0a74b4685567c2416d7bba1b5bc9d32f598fc3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 40 unique boards, 17 SoC families, 12 builds out of 209

---
For more info write to <info@kernelci.org>
