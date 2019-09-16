Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623DCB3A4E
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 14:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbfIPM0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 08:26:31 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:55041 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfIPM0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 08:26:31 -0400
Received: by mail-wm1-f48.google.com with SMTP id p7so9911766wmp.4
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 05:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wxfwE0GnJhLEZntMRx1Jvt8a7MHAIJYqB45lmqOds0g=;
        b=fEUaKtlL+TEIC/Nj1OjT606VCEqZkyCHOyrb1CX7IFJSkpHaxbJOSwqyica9QJ/Sdy
         B1w0tYZJ7lSQ9lETK4Pejj4TvrAn4Uiaz3c08a/85vrhdtAErVYXKmDKEnZ3c874/3l+
         rfMzsvg18DbEO6IaMBIcx0OHgZTdTkf6hFwi//0GcjTnQy4/VwF2BxfDTOBH1+SrhDWT
         QYbZclxqE+PbTSqLFKaTjm8Rk0jHzLZ3ZVGBrg+wKk12P+UHtrXULhtkj3vxW1AdwzSt
         UcvuOUcrwyU8DxuqPIpMZqjVKU+Tf/yHHct8WHH1CTAhu/Vw81iWHBgyWAJz3xvEcZQG
         V4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wxfwE0GnJhLEZntMRx1Jvt8a7MHAIJYqB45lmqOds0g=;
        b=NW1YMfbUoTSJ6YrvHYKfwzzvroOn80bGS7bisbMq4GhcF6TnFVzLzQNgjvli2KNyX1
         QWeGWjQVBYgJcoxG6rVXWxLyVjXxWXQkpeJk0AQVlOSuQ98BwBo4OwGP2AFMPAmwl3Ir
         Eta5tVJelST7RjFA/Cb8BZXRotI5uol+mT7wFPve9tYC0aP/9/RbEQB9cHaxrH7/KW9Y
         cVvRtoLMxAgn+ThBK0TZPmcKjWQiqava1Bm3bbnXE2j+5b/H+7gEkoFNHif4rECNDvhP
         wqyC4uODyWbDwoFnMbV5ltrG6epB72IZRiXpXS8UAfFXjl/4U0lJWgYUQvCHUJoJPvRV
         GBYw==
X-Gm-Message-State: APjAAAXxzhpwMdF/KEcW3Td1Yu+tKdIFQMp/vPXY7ni3vYwUdLx2moQ2
        tCkDD0OBkuJVQHBgM4SRbBXXdAqXEhk=
X-Google-Smtp-Source: APXvYqxjGIAuHRTbOgn1VBB+C1utYTjll71Y9Y3uUYdfvul4dbsgVKqVV40BzLwaa0ar0Fjp+AfsNg==
X-Received: by 2002:a1c:ca0f:: with SMTP id a15mr13869358wmg.102.1568636789060;
        Mon, 16 Sep 2019 05:26:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q19sm55230467wra.89.2019.09.16.05.26.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 05:26:28 -0700 (PDT)
Message-ID: <5d7f7f74.1c69fb81.b6462.1761@mx.google.com>
Date:   Mon, 16 Sep 2019 05:26:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.15
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable/linux-5.2.y boot: 96 boots: 0 failed, 96 passed (v5.2.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.2.y boot: 96 boots: 0 failed, 96 passed (v5.2.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
2.y/kernel/v5.2.15/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.2.y/ke=
rnel/v5.2.15/

Tree: stable
Branch: linux-5.2.y
Git Describe: v5.2.15
Git Commit: 6e282ba6ff6bb52afa545d4a29a45bd2eb8a7f4c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 53 unique boards, 18 SoC families, 14 builds out of 209

---
For more info write to <info@kernelci.org>
