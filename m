Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5819413B744
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 02:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgAOBxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 20:53:03 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44943 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgAOBxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 20:53:03 -0500
Received: by mail-wr1-f49.google.com with SMTP id q10so14174065wrm.11
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 17:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RhhyYCU1O88X3q1/l9jsUVW7N3n9wf9bY1nHHZpG670=;
        b=SfQB79zjMqjpMbN2ZRDk6cLsNTqv7dN5QZ/2ewGr3qzJ+zkoW96ye45vxBkklX9cj8
         15gnsFrjwF6UcuRopCKgyJDU4sLAED2M4K7EfWIhSiERr5NUG8ufFXPZafluZE9Um0P+
         HzsJzDKcEUpbZZop4h2fOFlqWxFdYJ/izZNXOQFBAX2kcdzNpUhMG6yNgc11Z0m+SCnQ
         mTjWzCG+81ULVykWKj74UkK7HNPBBFzyRtcnQQ4DPXQiA7GNecBFGtKsmTOhNF0TVq6q
         tosa15cIouI9dhgbNPHhcEd+D5JBUmm4vBPFhgq02GMKXzQH7ILvxFUiYSwAUZyq5+sb
         t0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RhhyYCU1O88X3q1/l9jsUVW7N3n9wf9bY1nHHZpG670=;
        b=SYV8zqeYbIYWhFINYErf8Usl9n7vK2R9sxklpA+km8qvXp2NqjyWZaqVUaArkhl2XA
         tfSUeWPRofpH5fQgQAeP4T9hikRcbC3rais3YtGUmkuOFI8eCgWuqzqaNaViN2cUcaJL
         zr7V7SDGHb5bQOExQIdgFRIYQ+WyLKaw2GAvLNTIjYtRdPbQNOTvGMiHuKJx9kbZtm25
         gwimHwN3VWW8maPRcA7cuFSUTHRl1GDR7b9EqOyvf/CGJwALEarvGHpZBgOGXBK23ziX
         AzczRIq5dagYSoHKl0U9axYQl6NB46PetZPs9mWUdLzFr2jAT1sAvh2Ih24zJHpltAaq
         1EDQ==
X-Gm-Message-State: APjAAAW4MshH7iwWifvGkgOxA7dBibJskr+/ni+fpeX98DiMQ5LGNRtq
        TlbpJFPha/Fzm6ou3IbbfJf57onBOv1MmQ==
X-Google-Smtp-Source: APXvYqyaRUYvdl8ApELmzigsTx7M6xcMKmAaNT3GMQTU95hn5+DZf2eNv9g+2xxizRBmCXlypcS7ZA==
X-Received: by 2002:adf:9104:: with SMTP id j4mr229269wrj.221.1579053180870;
        Tue, 14 Jan 2020 17:53:00 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k11sm20318748wmc.20.2020.01.14.17.53.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 17:53:00 -0800 (PST)
Message-ID: <5e1e707c.1c69fb81.89099.6784@mx.google.com>
Date:   Tue, 14 Jan 2020 17:53:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.209-33-g4eb860da7917
Subject: stable-rc/linux-4.9.y boot: 32 boots: 0 failed,
 32 passed (v4.9.209-33-g4eb860da7917)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 32 boots: 0 failed, 32 passed (v4.9.209-33-g4eb=
860da7917)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.209-33-g4eb860da7917/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.209-33-g4eb860da7917/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.209-33-g4eb860da7917
Git Commit: 4eb860da79178b12144ef8f2cade5351492c05c4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 7 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
