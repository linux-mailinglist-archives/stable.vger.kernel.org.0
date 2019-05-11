Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC731A5C1
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 02:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfEKAXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 20:23:02 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41719 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbfEKAXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 20:23:02 -0400
Received: by mail-wr1-f46.google.com with SMTP id d12so9514787wrm.8
        for <stable@vger.kernel.org>; Fri, 10 May 2019 17:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kPDhn96i7tRpuKzIclIYv7CwFAJl18bRAPUtwMUkIWk=;
        b=ZMxHH0hW6phP0DdydmC4nqhSnUxCqQjDr9ewQCfTd+fMz9yJgHa5WqpvmGOKwcPscC
         2GAjxrJRAR6NIUPgWgZVOFG+wYMA+7xfH4ewTdSSvq5hHOZAgWzAp4e15w/SO3Igw4yz
         6m1GuwP63oVKcQUcj7NdMOwHZvIrjbkQOWR9iZxfUkeiqqu4NAsmrZb+BYSE6Dh0sMZ1
         vCi2Jj4bv34Lj89D+Qet86WhcHP6dMCDOp+0aMyibJ0tyNRrFMPDMPi6Nj058H69JzG/
         jBR4Ir1c9D8djY7sCcj/5XeIUGssqIoi4WcqIcEuO802gPRjBIGF3tIEpQ+5BJKVihgm
         zcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kPDhn96i7tRpuKzIclIYv7CwFAJl18bRAPUtwMUkIWk=;
        b=okxCQv3ZC3mSBJUDeZu4d9dP3pZ+SQK+0WlFl+VSaj9MlPjKMazQEhyv+PH37K82Cx
         nmt1qPaSxx2xfOuXHwcas5pNSIC906WPV0X5C3iSSWWTsiYyecIC/nnYV6q5MUEGnkeh
         sQ9jCuL5KcN9kXAYuh1UfwrkbI9mnHZxCWSFAAawiaSQXLGhLItbXcVUTBdVdVU6RNff
         2rDATgRgfiNlfDBlcyS5yK5pwB2VJpqM/TQITGnHmTbVDfxD0kkfOsgysKtnq1DDe/FZ
         QXh0YfAcAvY57D9Ko2fR+bdfnSm0yhdQsvc4OA8CNa8GS1jaawv960+KpHs7LqMqtN18
         RgCg==
X-Gm-Message-State: APjAAAUiGZ8wvfMdErOwxLaUzEu5B6hq/mUklGgLJiyKVlxzcF0v3Wmc
        0UEaUVrdWMkAK19XvIzlLm1NyMwmJhRCag==
X-Google-Smtp-Source: APXvYqxLhAix13Yur/fq3mWsWfMIRdMbfIEgpYuBbTFHO713SU2ivPYpUQ3lubVV2W6mhurnWOrz6A==
X-Received: by 2002:adf:edce:: with SMTP id v14mr7357726wro.94.1557534180967;
        Fri, 10 May 2019 17:23:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d14sm5254140wre.78.2019.05.10.17.23.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 17:23:00 -0700 (PDT)
Message-ID: <5cd615e4.1c69fb81.1326.bd27@mx.google.com>
Date:   Fri, 10 May 2019 17:23:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.175
Subject: stable/linux-4.9.y boot: 50 boots: 1 failed,
 48 passed with 1 untried/unknown (v4.9.175)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 50 boots: 1 failed, 48 passed with 1 untried/unkno=
wn (v4.9.175)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.175/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.175/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.175
Git Commit: bb4f008d1e075986888ad01579c21f79b62f5775
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 23 unique boards, 13 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.174)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
