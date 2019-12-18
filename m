Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CB512536B
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 21:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLRUY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 15:24:58 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42615 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfLRUY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 15:24:58 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so3662913wro.9
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 12:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TUu1n7oz8A1MaUlruldcI612UKCdF5EO9j2NFVR7QYc=;
        b=xR0e8VuL6EtdchtvIvNs8bj/0WgsCCfn81GsnTf/XuF4HQhTUaBW8bGH4Q/7MyPQ/Q
         c56hlHi4yNwBT+p5AVT1gWtP8t23ut1hcufdzFdIG5rW5KtDlr5UbS8UYmVR70oabd2m
         L7ipYiNKLg3WSLSz5Ha9kMvjoix9MAIbU0nDlrcnQM/hmvdiUP9sUC490KKBFXydNziP
         5pztXMbvMFLBPv6+rNZpyUiqqOA+MeJzs7fMpreso6AZVb/3ugdrAqKBzoy5kA0++9zi
         xS9P4lJ0uAmWPPARSfY96SoJZnzLM7kQzQAAqg7wCtRzGQs/GmAl2z1U5Fl1oDCwMrG5
         sv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TUu1n7oz8A1MaUlruldcI612UKCdF5EO9j2NFVR7QYc=;
        b=BrfWXZ1SDJIUt6xltKj/yZgkiGYiWpBxnk9UFd0m0ujaKxQDmdJuoiJ2l+sKkONagV
         Pz9L/R9bKvPFK1Uo2AZ10pKrnBUtUdY8ivxhg0Mwi9Ovt8kTBW7hOBMBLQSQp7hAp8AV
         KOeNNQGzZmJtYZSQMx39xbh2HTtr2GzxmQuOS2EJ5M1TkO18UfX44CgZFASTDhim1Qvo
         W6uLXWblyPCLrrGZ7jaU/aWatsYKVdljUeKoYeYtjBcTfFFSDmQAbiMR7cHCw3R++p8U
         19g3z+BADIWZYsHWzjuVunZYEuAvBcNNvcRKP/6QnhI53epXkAZdUSeQqEOr6kP2DViP
         UHzg==
X-Gm-Message-State: APjAAAU8qesOyLPgUeb4J4/dQPOFLT442OrVKLt1LLY0oPTlbsUtHal5
        EoEQMwyWe8rRpo+arlpA2GyOR7Y4MgBAYg==
X-Google-Smtp-Source: APXvYqyJdho4kL42PqBD63HOGGrv6CYoS+2JeYtWLeIUVl0ijB4T1X7J1GLz2XPvM89knY1QGBv/jA==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr4893539wrt.362.1576700696540;
        Wed, 18 Dec 2019 12:24:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s1sm3714439wmc.23.2019.12.18.12.24.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:24:56 -0800 (PST)
Message-ID: <5dfa8b18.1c69fb81.c5088.397c@mx.google.com>
Date:   Wed, 18 Dec 2019 12:24:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.18
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 44 boots: 0 failed,
 43 passed with 1 untried/unknown (v5.3.18)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 44 boots: 0 failed, 43 passed with 1 untried/unkno=
wn (v5.3.18)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.18/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.18/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.18
Git Commit: d4f3318ed8fab6316cb7a269b8f42306632a3876
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 12 SoC families, 11 builds out of 208

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: failing since 1 day (last pass: v5.3.16 - firs=
t fail: v5.3.17)

---
For more info write to <info@kernelci.org>
