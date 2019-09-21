Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DE6B9D7C
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407510AbfIUK5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 06:57:11 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35468 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407437AbfIUK5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 06:57:10 -0400
Received: by mail-wm1-f50.google.com with SMTP id y21so4581206wmi.0
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 03:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bHbeG5wVuOQc/AmrDdSTZayyCfft5GmO/ICW+jXpC7A=;
        b=LAGXfedP/EYYGL65z26avdsVcY91yRRfUTKpS/CaRENbsBAsYiLzBZPLwMLrTP/4B/
         fgmA+ffiPcaRZbANohcM1ghbLwusbb9NRBq/Go22UCEjgL5d4f8cKcFc1c+352hF9LQP
         7fzBb2cEKUq+LdOQX7Jl26rQ7o/mvM8m1zOochh+2yXkhDyCqB5gaFwlyLYNlxhfsrmp
         JUAO0AfuGqZRCOU77vj+jykbNgFIQkZrFtV4nPcuOib9Ru9oMW228GBGc40y/eeE6hSs
         uQewfvNI/MihmcaDKN5b6kHNPsWzemzyMTK3lMNUf0Vyh4J6ch/Qmk86L77uW/rY/RuH
         QE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bHbeG5wVuOQc/AmrDdSTZayyCfft5GmO/ICW+jXpC7A=;
        b=gz5ViMRewDhH+TgDiPe5OfpT6iSrE+St0JteCQG6pZpOHzMF1DMLGavCkHj28iowKX
         lp+xN9AjLSUMf0q6XEOHBQwY7K51ygc+YsxCZjNYX18FEC/dQQOmCTFf4gTQB5ZrOof1
         YVvhGsM9N2bX9rVY9eEbXPeL1ktQEzFDgpMq0zdKvDt5oEA10cj+xoJSK8ttnBkAuwQW
         g264q8J3AfOAwg/2klN42KjqquHnq2cSZ8eL4z5DsGImn7cMTAXtsDc1QlFRZCeozXw9
         P4UUGeF/948oiYk35uZFCEIdt7yW+MX/A7tZsywcXPBHrYy/fSXctSI2iIi7J3WQaHU9
         R16Q==
X-Gm-Message-State: APjAAAVKfmTwgdrwIG9xyRac/6L5BPjO0ajvrV+t0LrPbG3Oxq9dv957
        r1UDoQHQxUGfko1JF6BQGSiWhZGO89bjKQ==
X-Google-Smtp-Source: APXvYqzGHMNvGI4tsboHuPru4CbP+pgSntv9ORq3w9dSjFCKk0lMASmKTc0wrDzwoscUKfpmtymyAw==
X-Received: by 2002:a1c:2d11:: with SMTP id t17mr6970964wmt.147.1569063428505;
        Sat, 21 Sep 2019 03:57:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v8sm6939858wra.79.2019.09.21.03.57.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 03:57:07 -0700 (PDT)
Message-ID: <5d860203.1c69fb81.8be3.5450@mx.google.com>
Date:   Sat, 21 Sep 2019 03:57:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.75
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 80 boots: 0 failed, 80 passed (v4.19.75)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 80 boots: 0 failed, 80 passed (v4.19.75)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.75/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.75/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.75
Git Commit: d573e8a79f70404ba08623d1de7ea617d55092ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 45 unique boards, 17 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
