Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81A71303E4
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 19:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgADSii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 13:38:38 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:36829 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADSih (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 13:38:37 -0500
Received: by mail-wm1-f53.google.com with SMTP id p17so11316475wma.1
        for <stable@vger.kernel.org>; Sat, 04 Jan 2020 10:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mJAsGNM27F5W4EwZFiqoCTIZjojHJqtaoDKPEQ7kMNI=;
        b=E4egbaU6sT7j63i2k2n6q9ODikwj8fASalOHKLuh5t4A5W83Dk+uK/ak6Ry2KB19OH
         o/8WHRK90OxCgotYwhJzzOBsaabsg6ejlr9RpOReqmrixfJXjkzKvy4rp7DwqjMUMmKU
         XCjpDNk5mnHbqpTmXJ5DZ8tHh/+/1shc4lwYN54isF7urB2BPjm3b11IKeoMreO/bx4C
         S4WHti7yiUeXNLIQeQTaCO3hgBgzbPbU/5HjL8eXX1nGd1n2NGNSpXXPQ9dt+btPYiAp
         xZb+Zvn119z3VXtszLEjEW1fcfviKJYzdyEi8nl3qVG7SlJDMgTD95jfGpOegXJF/XIV
         ItZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mJAsGNM27F5W4EwZFiqoCTIZjojHJqtaoDKPEQ7kMNI=;
        b=lZ92i4eBRMy6pCA05y17BK5QgrryoR1t0DIAXJG3MpwFRuKQxdVZE2aUIPBTFapxGZ
         IinpUvCjk043yjOmj5wovB0P8NqzB6REk6jeyneNjxSRCTFz9uPfbSHlce+aAm98JbDP
         SbkBEEIYaP+ok1xiERf6vIcFkfXT0Sw515TMVAiFbTsMIjDAuQ4FakTxY0jcXjs4ZVEo
         8fm4RQWltCMaoRTlPJe9YuQeg8AbgK5witEmMNB5tDf7JzGCk+4s3cFNHZDDyJ94aYjN
         lvpbTyh9e3e5T/xooHI+Q3qfPS4OhApGaFuwEjgevsnu/Rs80rlNjRC4PJLsZPk5c2Ax
         4r0A==
X-Gm-Message-State: APjAAAUEGqVr8QLQ+g5/j5RqoxGQMox0g+668VpjT2wT5uUtebdLs2/4
        FUMuJiYwrVtfLPJF+k21yh3BFKEIAy0=
X-Google-Smtp-Source: APXvYqwF4w1bs3e2hjkQq6aYFsK7i44SVcCZba83sgHdq5DwSSTXm9a4rYNACz1FoSMTmzHqG1h34Q==
X-Received: by 2002:a7b:c246:: with SMTP id b6mr25463775wmj.75.1578163115827;
        Sat, 04 Jan 2020 10:38:35 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z3sm65261190wrs.94.2020.01.04.10.38.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 10:38:35 -0800 (PST)
Message-ID: <5e10dbab.1c69fb81.224cf.a4be@mx.google.com>
Date:   Sat, 04 Jan 2020 10:38:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.208
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 26 boots: 0 failed, 26 passed (v4.9.208)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 26 boots: 0 failed, 26 passed (v4.9.208)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.208/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.208/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.208
Git Commit: e77ff35fa79353a8bd85a33b83609bd3add65e4b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 21 unique boards, 8 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
