Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582041935F6
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 03:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgCZCbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 22:31:55 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51088 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbgCZCbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 22:31:55 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so1854228pjb.0
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 19:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qa0A7fcrRCAWwmzVChH6xcZpuQ720dniR/67A3XmMmY=;
        b=HHI7YAtVElqRVj7+XObcLfwbFlFeBXVM2iOebWwYgVR1D0RqfYukGid7kOF1UQ9uJG
         bRUIwyzRZtdp6SO98J7TpEUeSwZk517Uwqq0XtekivWnw4wMyihbuMLDo0OCMFRLeaVM
         h3jLjKo4TmJaf7VrVE9HlQgolbYePYHCbpuIvd4PShhPaEgmKxX6c2KprWozNIDCVML4
         RmNVTgHb5S9mlfVYhNgeYGmUx3x8MDXCrQ7pBZWzSwk4V0e7/opucjKDHRZkR92Yzj2L
         80ob6seLD2fglQekSRCaPGQPjw2Ip32p2jBuT+XiH8b6miqs9oXdyehvGWnhYXEdU5Oq
         kPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qa0A7fcrRCAWwmzVChH6xcZpuQ720dniR/67A3XmMmY=;
        b=arepNjKdkExy0bB0EYIpdFRA5Oae0UTRweb1DaPGhEgKE1szYk+x3a53nguDHPKUK7
         m9nIAsExt6lrCkHdp7OARlR0IaSOEZ7eKI8JmO2tihtwNwgEav5RrqgXrg7M1PpjXQjP
         2gvDF0VcNWJFATCDdruAiz7cHLvGqlIJG5o/WAwENKYfy6PgvDpl9IQN6v2YmoD3iind
         g9GTkV246aiUexJRaVy9un5GWkzZVx1c/Qwg3lJxJptstvY3Uh736jJ6j7p1OCfIHl2q
         PSGwgt7lI6IlHJBtLQC/hUKpN3MRwxX/nvLaPr52cYiOVn/+LJWfpng6pw1lVeP6/BbL
         Iuig==
X-Gm-Message-State: ANhLgQ2/HBZ6CqArIHLFcCxnhZOti9/DLOe7bKjpytdzwXmxGqdEZcpb
        nzTqO4BO7ZPwuZ+XmSln200gkmcDZxE=
X-Google-Smtp-Source: ADFU+vvnwdA8zCyoVxWA34rjE8+lHZmPUcmdIJeHXWe2w6bNmQT7W5IrHQDTCngpW68QVQICwxauZw==
X-Received: by 2002:a17:90a:c715:: with SMTP id o21mr635183pjt.160.1585189913726;
        Wed, 25 Mar 2020 19:31:53 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm401038pfz.91.2020.03.25.19.31.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 19:31:52 -0700 (PDT)
Message-ID: <5e7c1418.1c69fb81.56770.2261@mx.google.com>
Date:   Wed, 25 Mar 2020 19:31:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y build: 197 builds: 1 failed,
 196 passed (v4.9.217)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 197 builds: 1 failed, 196 passed (v4.9.217)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217
Git Commit: 10a20903d7ac2be29e0e13d66ad0d74e637b8343
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failure Detected:

mips:
    32r2el_defconfig: (gcc-8) FAIL

---
For more info write to <info@kernelci.org>
