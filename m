Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C939014D4DC
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 01:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgA3Avs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 19:51:48 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:53467 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgA3Avs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 19:51:48 -0500
Received: by mail-wm1-f52.google.com with SMTP id s10so1838670wmh.3
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 16:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nwJdmx/7Of+aQb5xDcw30FzGPrVczLGD4vcPn1L7aik=;
        b=RSZ/elAw6cIqgANVi9gwwZ46p4xQ+BoRsGvVhSxLOPZtQy+3SgBG996OpuB6JhySah
         TZNchqtGVxnEhfhIQpqst8MAUFFdletjh3z1SCaInGfSxwFvb8e/b7Ujds7v1onE33tX
         U1HVHrdz5MXUzsakCBTHPB0JI+Ue/hZ0j+QZniq0iJ4ydP7OsASTjJG4jjA0ycCLx+j5
         byicujyKw5qPu0rKs2SFi3agxxayOK4CDBwjVedYk4zhPFiO9oYTZuEJM1TXFrFVcc8l
         bO1iSMYltmLo8ARknY6IcBsxc54Xzs+zVJCNw57g/QrjMm10My5mtTx5R7aIg4T+11yF
         IZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nwJdmx/7Of+aQb5xDcw30FzGPrVczLGD4vcPn1L7aik=;
        b=M1tMWqDP9IMVTvwa5s4N0ngiFnhqMAbX6jjEFUpVnWXjs+GAjjfq/84/idoaz2cg8G
         RiAHJLrz7AfCVNsUHC7yQOMVzStJWtiFAF9cWkkyEM6pkDfN9LskKS/doTef56CVaHqb
         FQ7vZPTNMV/avUgfwrwpjQDh0Yv2m/NkKK1n/HIR71fIJfNc36KjGUkAx/v1UzpHQFS7
         dY1z75nCgIAfStXrZ2jTCHy1nvIV1ZBjM5zwiiiIVfeGKHVmH0JAWEhblDGqi3YLxhMT
         xslj19uwzzCGTHSJzhoeg7w7M/VqKuybmw+l6zjLa892hmv7jTY+UCEn5NX2cH/FRT6Z
         TYdA==
X-Gm-Message-State: APjAAAXhCebqfloE/3imYNvoAgeK8DzqzsDKnqAlri4nlkKRvVH/kiMX
        cw6mofq6xZ0VIo5oeegPMoid3W2yEtbBxw==
X-Google-Smtp-Source: APXvYqyHv0dBp6WGNlu3NEY6yUmOlQ+0XVQpZfDC1YLe1kP0Auycn9CcoACqUWUQU0c7LbJNNqEn7w==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr1899327wme.90.1580345505659;
        Wed, 29 Jan 2020 16:51:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b16sm4116404wmj.39.2020.01.29.16.51.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 16:51:45 -0800 (PST)
Message-ID: <5e3228a1.1c69fb81.6093e.4232@mx.google.com>
Date:   Wed, 29 Jan 2020 16:51:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.212
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 16 boots: 0 failed, 16 passed (v4.4.212)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 16 boots: 0 failed, 16 passed (v4.4.212)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.212/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.212/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.212
Git Commit: 475d90ca735ce524de49d9fbe3f1a3fd5655caeb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 14 unique boards, 6 SoC families, 5 builds out of 163

---
For more info write to <info@kernelci.org>
