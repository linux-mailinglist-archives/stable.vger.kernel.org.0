Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC75EAEF
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfGCRyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 13:54:38 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41392 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCRyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 13:54:38 -0400
Received: by mail-wr1-f44.google.com with SMTP id c2so3795464wrm.8
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 10:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eOavSpp/3PwSxTkvsStx9oL9p6OHC6zAVM8KqhgJzDE=;
        b=u/wqgxyo3hAdCusCMUSTIlL8a33Dlen0nGzKRUGS6iTt6xCvz3aa3HA62w0eA9C/p9
         6yvVIJAP1TKzsDLE5wTe+7vwCcjyBp635+V9Yco/rsyPETmOMqtpouAl1UO74b9HDzsS
         2xRpGHgHbK0OhaJbnD59cmMl595zVBWMHQYrapi8evUBF93NMqF/YzpPIx2LLxf+srSG
         EFxTD2gMdgimYU2BAtCBZJMIQrYIe3Nzx0NDV5eabZvtogRLTTuzt2TVzw9Vo6OEGTvv
         1n0PaXrViBtAYQ/Ysq61EuAXYlU4SC9Ea2yKsIizEijg6A8JZk8Rva47WNEfe3XB+zQT
         GgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eOavSpp/3PwSxTkvsStx9oL9p6OHC6zAVM8KqhgJzDE=;
        b=KrTmK+7Ok85+ljlDk/Vzexc8zbgqiAoahS4qaP6mBkdGhRH6lqHidEkIZap/hhQ6Y7
         XUIUd4Cx3VPzEI7cgHTQdrhQlkeB9VcVDn8rheqRJJ2mJ5xAL3WmIdCm4HJOVEs3NQ50
         Fdws59JulkNL1tfGRpKU7ayuy597Sn+TpBTJVGUkZz0JU9kyrn5oXEU0qWnLgKnviHCu
         8u8VOh2tXj7Ru6JUfdIkQwF/yW1/TQEP9HbB/KUz8b+mWuR3HKFM9J6kITaruCuBYRA6
         SyFEK7wrHJmSzqKx7BOJbV+/jIpkQuqxo0qAHw0FL3H/JlTtqV6MoGqGjbltkflRMnOQ
         gtyw==
X-Gm-Message-State: APjAAAVDgZkR+3Uwpoxx9M1f8KBJJhTDka73pnhWC2y+9yEWIAM8ULBZ
        I8KIOMO5bS3Kjvrabf/ijzgUlKo0jt7fMg==
X-Google-Smtp-Source: APXvYqxUHuPLbT0tweRQG7BT3eatqovwPv2zyrpZAXlTzh8TDD5KUkdehMxAaau3da3DX40/LfaVHg==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr28920025wrn.120.1562176476625;
        Wed, 03 Jul 2019 10:54:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s10sm3757733wmf.8.2019.07.03.10.54.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 10:54:36 -0700 (PDT)
Message-ID: <5d1cebdc.1c69fb81.c8883.5c78@mx.google.com>
Date:   Wed, 03 Jul 2019 10:54:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 69 boots: 0 failed, 69 passed (v5.1.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 69 boots: 0 failed, 69 passed (v5.1.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.16/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.16/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.16
Git Commit: 8584aaf1c3262ca17d1e4a614ede9179ef462bb0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 17 SoC families, 11 builds out of 209

---
For more info write to <info@kernelci.org>
