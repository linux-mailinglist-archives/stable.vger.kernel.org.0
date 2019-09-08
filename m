Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9A9ACFDC
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 18:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfIHQyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 12:54:14 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:34998 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730015AbfIHQyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 12:54:14 -0400
Received: by mail-wm1-f48.google.com with SMTP id n10so12035151wmj.0
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5cxYzNBRMBcx8NZ7jDdRQwdLkktnjDO1pmwjV4xyOFQ=;
        b=eooxbmLBluZYEaAlodq6wLBPdWWg1r3jus2wi3YWzenl/YgOYsvbyNNkihebO97wuU
         itBx3nmpczF97Sqxoi83eqg/pPRNtHY2m4Rv0aMwlxTSS/R91k2TxnDiHnkq8QOXcC3p
         UAN+grnVYw11iNpmfhJlNba5W7xCEv2dnZyTsjJLWLk2QH/enEAUWqDtNIPk2KEo9nEG
         JL3GrAXKP+J5lsK+j68NfOKCiop8NAmGS7yV5AbC3C+5AFkx9PWMZn7u0cKwKFt8liV0
         5v1Iy6In4KlEcO+yLyBB0wbzbz8obOCjVQF2drtf7aUkt/nlWAdh+/fuvzGWp4qizbyk
         sYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5cxYzNBRMBcx8NZ7jDdRQwdLkktnjDO1pmwjV4xyOFQ=;
        b=L1WE4zaSR/8JcC4oC+wRPB8sq6art/5EfLWKkaG597ANwQcnGNzxham9axvX6SOxcG
         HzVx/pXf3ISiJuqkJx1/0IABZNGDlRCUOiuhK4VZTIthfnl5GzuTW8fEnL7bfM5YC1C8
         BvwKLbV2B+TgqisIJglEDItHoUCGhmwJbFLHRhLTxlt3vOc33lCBanPaIbdmMF1xinXK
         n/aqf5wKDy/TvNOnR1qkxzl2dwpULo4xSzfhdargfWcUHbqkQvnVK+uuCdrT4dxpmJxC
         z32JHPRjWVff5xEbJ5u6utkDaaWvRXpht3RIUlAqcdL2CqEp5vweIKjiAdLdr4npK/6T
         JZNg==
X-Gm-Message-State: APjAAAWI/eSbtzd1OUHIZEU6I5zFk5GoQ5jJGN7dATTrDQmeCzFlGtJS
        U+w1QEYl/BCw0wFhW5shHN7vNULGjOY=
X-Google-Smtp-Source: APXvYqxrXbqM24PaoKV2V13LEK7Ew9TZWHeNWekmkhcmCOnRzzdOWukUM4EKCJgQmXYt1DRhu0nhZQ==
X-Received: by 2002:a1c:a558:: with SMTP id o85mr15437690wme.30.1567961652229;
        Sun, 08 Sep 2019 09:54:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g73sm20164864wme.10.2019.09.08.09.54.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 09:54:11 -0700 (PDT)
Message-ID: <5d753233.1c69fb81.e9c25.e262@mx.google.com>
Date:   Sun, 08 Sep 2019 09:54:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142-40-g6b6c4e3151f3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 80 boots: 0 failed,
 80 passed (v4.14.142-40-g6b6c4e3151f3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 80 boots: 0 failed, 80 passed (v4.14.142-40-g6=
b6c4e3151f3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.142-40-g6b6c4e3151f3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.142-40-g6b6c4e3151f3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.142-40-g6b6c4e3151f3
Git Commit: 6b6c4e3151f31a94bec9c9c14906b1fd3cef2d87
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 37 unique boards, 16 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
