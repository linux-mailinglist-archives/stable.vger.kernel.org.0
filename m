Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5472CAD043
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 19:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbfIHRwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 13:52:40 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50332 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfIHRwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 13:52:40 -0400
Received: by mail-wm1-f50.google.com with SMTP id c10so11340220wmc.0
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 10:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LaQwezZbelgFw6PT7poxV06YAxO3gYxc+lk0L9JTxcE=;
        b=GM+QY9npZS2c8miEkD+wUiYfKgd2Il/lKgehstQryLy5SLfNKqRcW6KaVy9bh+ge3v
         mDUC3IfgYSkRLKQTesdj7VgASWQnj1NO+ONQUcx75SnAnUqahblm0SRztmza+wAdHDVg
         CVRH0qzbEofZhKtTORDkihzyeP4VS1a6D6e6Je3glwAjUCbBZZqlR8rn48D1NLvhku+e
         rT4R5G1gYZX36ZWB1AwBpB+2SJFgjf4qsjw4oVhKfVnOnLfBgjgVZPvToQhbvValSeJ/
         O8bxvNAI1d5uprgevhUmNuRHblFrxKe0Ki5QiMqajQqDoLHPjDo1JGkSLFzh9X/1ZlPl
         JZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LaQwezZbelgFw6PT7poxV06YAxO3gYxc+lk0L9JTxcE=;
        b=SCJAZJxB13gbe8CiqmEOT2Oj7xsAyATC3+LrEmjzEQycNiBrm0q45t2aNSjFbp9t30
         T+a6QS3SCJzD+gwFpOrmskFogdQB68snaUCUu8F/RdKYGqFyMU2cryhWHLymXgqQ2dP+
         WnLByhaQA8jeE5qXBK0rNWF7KMrcQSqK5fegsihbWAJF0ujsO8t4xQpZGm6cLuaXtiF8
         jGuh1igfGT5N1jP5TgNcsoEzVesM/RTGfbBHJSOX9b4qGknfERWiUogYNHgmwj/fydMT
         pUh/IkhNMVNLqG5oKQqYv7b6i1hAl3M2YXoDWijeu1vAgBRuXkoPTGFcoqqnhWGBBBT8
         Vj8Q==
X-Gm-Message-State: APjAAAWpRGUT/hoqiqK9cWS/O7dzvQ50spjmPuWZtW5mAvVL+ZSfinO/
        j587N/GiGSAEKBQkIP83E6Pn82S86J0=
X-Google-Smtp-Source: APXvYqzBcnXH1Y9/+2S4v0WtaxMTfHi1oCiHOd1QhdHrBkQ76KKw53grT0M4ek8x4/uPu6S82KWmOw==
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr13921076wme.83.1567965156594;
        Sun, 08 Sep 2019 10:52:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f24sm3836686wmb.16.2019.09.08.10.52.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 10:52:36 -0700 (PDT)
Message-ID: <5d753fe4.1c69fb81.b6b8a.fc60@mx.google.com>
Date:   Sun, 08 Sep 2019 10:52:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.12-97-g562387856c86
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 90 boots: 0 failed,
 90 passed (v5.2.12-97-g562387856c86)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 90 boots: 0 failed, 90 passed (v5.2.12-97-g5623=
87856c86)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.12-97-g562387856c86/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.12-97-g562387856c86/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.12-97-g562387856c86
Git Commit: 562387856c86ea4a3aa5ba333cb9806f8065b6ab
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 18 SoC families, 12 builds out of 209

---
For more info write to <info@kernelci.org>
