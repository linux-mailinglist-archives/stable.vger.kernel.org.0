Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D9C83DA0
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 01:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHFXOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 19:14:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53542 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfHFXOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 19:14:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id 10so713783wmp.3
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 16:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tqMEpMMCz2AXEHACpZwnMrSX/TnL2o3DpzD4JiJpInc=;
        b=KK+d10q0wKuz4P/XZjwWLp9eijkC6zjCeL4DOXvo7frZ5jNRrj5aeu1aH3lNK4+Lol
         CFaDM82HTU/pZrHjBI1BtvywpqzcS3hZvDwNhhBSJL+wB/1mO+txPOWzR/tf2iHak0Gq
         1q0IcnJmRwars6ThkBm6m18Vcqp7AJVWZgcTwaKvWXiplt3Ckf9LnTaMID8TG0J3GdOz
         CxRpeplvyNTJ/UsM3waEQOSgCxiB7qFfwRUMOD+X6oY2J9o6phtyqe3VkvA0WhCPiBWE
         vmKjmm6kImc2kr9ydA8NlFObWn2ScHgzPC/YmzalM8EsfqWe9LoYL0GPnLRVQS3dynYQ
         z1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tqMEpMMCz2AXEHACpZwnMrSX/TnL2o3DpzD4JiJpInc=;
        b=nsNx+RqtV0sWh6nV/UdTvvCqLoAZx0nzI1880GS04SU6M5LLGarrPaX7jxOFnm5ylS
         iK8hfurE1nEbr48KNh80O1WzamAdcr9CqVip7yH3TQpJ9YMVpwR8q6F8+4qGozTPf/YG
         YOKfF5Tb4ROPB90cVC6I4Xi5k5F29jgf+50Lgof0W8FwC8Gu4MMv/zVWGddX4eAN8M5w
         Z6iA9DYrd5tV2EE8pfr0DQU7fHfgzh6LirkDtnK5mKpK8tjtsTFZOyDMbvUiE2vQVT9E
         g+1sWs7bDDuEoHMuMFMg6n4kJMDzG1Eg3lEjZj1kCyTsNSHAxuQv7rV0CB8tvKACDvDu
         sqUg==
X-Gm-Message-State: APjAAAU92yyQCLRmCECy7QyxDCbavIVRRTXyg8xq+WyUv5Oi190NspV9
        +beh7ZdlJY05DMSws9YK4B28hCHGdi6wKg==
X-Google-Smtp-Source: APXvYqzi63dSRCHjm3gzis9kwA/5RT0BnWisPHBK25WlZ9e26C7r3S3EjF/qerR7fcNfqx0nPcrNWQ==
X-Received: by 2002:a1c:b706:: with SMTP id h6mr6381133wmf.119.1565133248833;
        Tue, 06 Aug 2019 16:14:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c4sm71538692wrt.86.2019.08.06.16.14.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 16:14:08 -0700 (PDT)
Message-ID: <5d4a09c0.1c69fb81.c3714.4e25@mx.google.com>
Date:   Tue, 06 Aug 2019 16:14:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.188
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 50 boots: 0 failed,
 49 passed with 1 untried/unknown (v4.9.188)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 50 boots: 0 failed, 49 passed with 1 untried/unkno=
wn (v4.9.188)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.188/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.188/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.188
Git Commit: fa897d17313ce94d8d368d29900455e2ce941106
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 21 unique boards, 12 SoC families, 9 builds out of 196

---
For more info write to <info@kernelci.org>
