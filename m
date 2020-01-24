Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5497C149222
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAXXrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:47:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36045 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAXXrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 18:47:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so4072223wru.3
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 15:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cq1bw0aAgOrdxj+sc6TsNW4ro0aorWzlMRlQudqnuQM=;
        b=wKsQhOGU6rgpGQjXSOC1HEdvBrIvJB3xpEekw0atbI7GsgOqFJEgPfk/0eT7TdHUIE
         7BqY1OACfWHC/juhd9vyHv2xJPYPQibz2pX2zIytHXVgKTQpt2aTB+Q1qEDnwFHUX3Al
         hzc2pX3YE/BGXo2cr9tkHQqw/BV1UXZL8A9vt48AOxvOAMopX2u8UMN242nd7+ttYlH4
         BuUmWEXPn3HkDBeGejgFLlagVlAsY6HPqJftDvPVdwvD2wkOqm1R7JVsarzhqzZS0osX
         oA9NX7J0hKNNCcWqirV/rXpsGDzzhHlP5zGjRA7XXgiBsOw9FH8IMGyhvqsbDKZQEPw5
         IXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cq1bw0aAgOrdxj+sc6TsNW4ro0aorWzlMRlQudqnuQM=;
        b=pCsrJJxKhVcI/XjvqvqfQU0GRtA1YC1+5HoTzQvFa4Vx+SL7B2q5RUvNAIad9iU7Mn
         y3bAXRaJ6kn1QBFGgSO1YV7eOOlsgfz69q+VeTExc7GqVpfelXGnWo0iJSrL8x9RgB3B
         u6KDyuXRuKiDXLeLqYEpR2Z6XCA9EclIic9Y/nT36Xe79GguVZVu5Cd9YlxCm0wlNIGU
         24Jpz2RPv3gxTeivKJ/RYJ4v48xVZ3SP03u0Z4SIXC4HBKXtpn6xlfeSxtxxieqVeQmI
         uBfViwP4i8fMfAQulV3h2ZwNGd2qcQ7kVmAkO0TNq6t6sUebCi8Rti5BOnRAM9qttTZv
         /pUQ==
X-Gm-Message-State: APjAAAXhaKgMCcWTvoD1PiT4j8e+OfnDghvUYMwslGPXLhEmkGjzAY3y
        wV6l2HxdhWy5Lg6O9flsvTFqR2HuTg+a3w==
X-Google-Smtp-Source: APXvYqyxGp8gAsma3js/GMO5UEEryqyCiRLXlRGOwsM4b4qNg6m1Mpj9Alp2QMUHbHBOK2Qyoj+FUQ==
X-Received: by 2002:adf:f847:: with SMTP id d7mr6865885wrq.35.1579909631636;
        Fri, 24 Jan 2020 15:47:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b17sm9562889wrp.49.2020.01.24.15.47.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 15:47:11 -0800 (PST)
Message-ID: <5e2b81ff.1c69fb81.8e843.9046@mx.google.com>
Date:   Fri, 24 Jan 2020 15:47:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.167-342-gc38faa17d730
Subject: stable-rc/linux-4.14.y boot: 51 boots: 1 failed,
 49 passed with 1 untried/unknown (v4.14.167-342-gc38faa17d730)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 51 boots: 1 failed, 49 passed with 1 untried/u=
nknown (v4.14.167-342-gc38faa17d730)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.167-342-gc38faa17d730/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.167-342-gc38faa17d730/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.167-342-gc38faa17d730
Git Commit: c38faa17d730463d9e2fc30abee20b0667a4d089
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 13 SoC families, 9 builds out of 184

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
