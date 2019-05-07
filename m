Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA63F16AA5
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfEGSrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:47:09 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35137 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfEGSrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:47:08 -0400
Received: by mail-wm1-f50.google.com with SMTP id y197so21356659wmd.0
        for <stable@vger.kernel.org>; Tue, 07 May 2019 11:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EicP5+7NLxItUWuGl11cRsPa8v9OrlBqaeDFbba/kHE=;
        b=TXWrdAoz6r60njWUnlKK+ZrkzNK8u02VJMJtuM+ESuV/ks/Sp0h+pDMe+hE7b4TeMh
         1JeDTxdy+W0pm5B8DGe4fx6ZYCk31qB5S6jOfwM4pLAez7O7Qpy1m0xqeqXL+6NZ1PO5
         cNeIbrP8lGGFcmZS9j/rKau3io2VkrgGDShaHvkSQ1b+mzcKyLHrOmWqMTPU/bjLSfx+
         pyQxEHpjU8RsdgKtbQ1E3FWGcO5TUwezK6O+gUVLBlM9iXjzz8L59HsJHvFWYoZ8OeEs
         wZ7h9zJzVivUKa2Vn3snSZl6PR3JkWNzvms3PUfOcOz6pExFeXuBvL5PAAQ85PB6Vl0A
         z4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EicP5+7NLxItUWuGl11cRsPa8v9OrlBqaeDFbba/kHE=;
        b=dmf1O5CPAjNONcbBI/aRbKqZYGIfnQ9a6IguAdHW3zc4xHdZ0f4g7MX4/l3k+9WonS
         Z6sCI7dzaPK5MtsbDNwLEZn0jXlGHj19FmjEL9Ity66RPchI6oTGWX8QLXHPSQn/GX4K
         qQ0DFXFlIRBa+zz6DHmK0Q9mRivUf4nc7+94RjkdEh21oqf39ia7MyGWSLfJxqeUo3VN
         zJ/OchZn7N/UHAdnwON0dsJZMAXsOQ5l5jCaVkPny8wO/lQy2KZ8uHyLRSC+r5MegsI8
         HEqCNU+R4FKPwFK7R/Qi63jdqIySnZO8AMEAeXxTsNp0krHHnQ8xV85k7kyQgbUCJEDP
         k+qw==
X-Gm-Message-State: APjAAAXOUhTBgUhJnbl8V+fXRv/XxVx1PkUwDd/YhTyU7dKQtOJPAJkq
        OvYBV1PDIHw/wpb9AVt8GTrxrFyuJY3t4A==
X-Google-Smtp-Source: APXvYqzJlCxErYeE7NBiRsjsiJZY/58uctIhUUOb6CzZCYjr7ZIS5afbCzno+fwcvZJJNznF+cr8Ew==
X-Received: by 2002:a7b:ce06:: with SMTP id m6mr21312582wmc.62.1557254826854;
        Tue, 07 May 2019 11:47:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w2sm10322003wrm.74.2019.05.07.11.47.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 11:47:06 -0700 (PDT)
Message-ID: <5cd1d2aa.1c69fb81.de161.46cd@mx.google.com>
Date:   Tue, 07 May 2019 11:47:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.139-52-gf85e9af98591
Subject: stable-rc/linux-3.18.y boot: 29 boots: 5 failed,
 24 passed (v3.18.139-52-gf85e9af98591)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 29 boots: 5 failed, 24 passed (v3.18.139-52-gf=
85e9af98591)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-52-gf85e9af98591/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-52-gf85e9af98591/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-52-gf85e9af98591
Git Commit: f85e9af985911d96cee73289542433c5ef892f82
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 10 unique boards, 6 SoC families, 8 builds out of 189

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 4 failed labs

---
For more info write to <info@kernelci.org>
