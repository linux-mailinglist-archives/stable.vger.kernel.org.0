Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C001679D
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfEGQQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:16:32 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51340 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGQQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:16:31 -0400
Received: by mail-wm1-f53.google.com with SMTP id o189so10298566wmb.1
        for <stable@vger.kernel.org>; Tue, 07 May 2019 09:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+52L+u62TNY6YACkEbpqwAKBYstdSnWBCEy5H39fP9o=;
        b=W5Xl0HMHaMLpQcQbmB1uG2exqiaV/xNh+emRzWKTWnUjAZrrHGgGkPpvpUAqPZL0j2
         SuTRHkGCUWF54trD8q2l1JyQV6sK0FS9ss93TV6YzhNpMnvFOqc2e3QiAVSSabDyIDBq
         m4sC3fmIk/QD3cX7u/8vdZlTIyMDHxpgykVycu5y7Tk2vWzMmCE/gd2hhplHaeuQaC+9
         TjMjP0j5+kRnmTh1v+wZT+vwbhw+bIJnN9S+ralT2QD9XBbo3ciUCDX9HOTQdT5u+6T4
         hZegGvaXpaKGGPVB7I157gAHyOWNLICISSCSdLWz/zyw3zSbDQO/B/f4reeaCcLNK+3E
         9mHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+52L+u62TNY6YACkEbpqwAKBYstdSnWBCEy5H39fP9o=;
        b=IPINgtWXcMMvTA7opY8FO5/C+pVBiJmV1WJkXPuSuAsnrtXtcKudCLmORMFlub+t9W
         lyQ7MGreRFXtn31Lmyvqscdsgf8XhylRalf40cue82wClwXOjl5pK7hDFroiJ94dDUSO
         OOQf+egNnoEVFDgi1fkISbT8Tq0jzl1fSlB99jR3lYHkQEjVDjR8vfEUPOiG/WhXqRB1
         oZI/qBhVB9wsPPaERUhjAO0fdJzSHmwn8FY95+TGg6DPJZ8ktlNButFKFKjelt4nKo9F
         FGWnkV8wRMqnN8rq3h1oO/fbrivbp52u8UUyUexD6Izw7urQX7+GL79a/8b+mbC4FHvI
         RhBQ==
X-Gm-Message-State: APjAAAXK2fPlrG8LsPJ46rcimMRSpxelIRuTdK9tE7qLPawH7OLdTxG8
        u/VpS+tW8Zihwy1ATC28lFHBjykDVAKLFg==
X-Google-Smtp-Source: APXvYqy2/072lIRwF2MOMsPfwwr688ruuEDhGXJ5t6TTMkBZhdVTsozmsheK5IufzuatOQlU0VJhWw==
X-Received: by 2002:a7b:c454:: with SMTP id l20mr5342281wmi.115.1557245789480;
        Tue, 07 May 2019 09:16:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a4sm17078897wmf.45.2019.05.07.09.16.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 09:16:28 -0700 (PDT)
Message-ID: <5cd1af5c.1c69fb81.5b3f.af35@mx.google.com>
Date:   Tue, 07 May 2019 09:16:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.13-123-g5b4a1a11a18c
Subject: stable-rc/linux-5.0.y boot: 56 boots: 0 failed,
 56 passed (v5.0.13-123-g5b4a1a11a18c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 56 boots: 0 failed, 56 passed (v5.0.13-123-g5b4=
a1a11a18c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.13-123-g5b4a1a11a18c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.13-123-g5b4a1a11a18c/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.13-123-g5b4a1a11a18c
Git Commit: 5b4a1a11a18cf15168a00c41c55384b2558cdee0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 11 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
