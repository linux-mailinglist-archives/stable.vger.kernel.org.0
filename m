Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8612F48E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 07:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgACG1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 01:27:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55284 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgACG1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 01:27:05 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so7454081wmj.4
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 22:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/10iQ/Q6ZdW/dh3o01ZVtjpI7hyZRKn6kNPKYA0QSIM=;
        b=NKK3+v79CNFlC6ifHs/D5YINVjOiEbdgxw738fsS9OHdfOVBlslgacX4nLMr3+auuH
         nzO97kxCVOVIhTFGbJRVFsjLrnnKmD5+9B3BvnQCng19VQSleNbuAXGaL0VyKTR6erQy
         uilPY/UYKqWwk4VX5sa5yxs/x1eNZFDDuMbTqPRjwbXX+iVbwoui8wPTFxHLmZDxaiqP
         ZVw2tWi+G+9ZgvngViknjHWWxOLkXUHa5a+wakRm7+uhJ0TBbuzVB9Lx4j1awWpb0AS7
         UQL1p41LXXVSXCerrfGLXmzXF/z7d7fUsTHbpsTcq7R7t9nuMBqWr5gAcy3ft43D+/6t
         CyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/10iQ/Q6ZdW/dh3o01ZVtjpI7hyZRKn6kNPKYA0QSIM=;
        b=W2itL4ijljqpnR9+er8w0QlBhi39fjTJdCchooyXwituxrzpDz+85mgwrBc9deCThf
         0iL4q8/z/NjiWZ4Waf0qJ6ljhXW0pk6TVZLgEMezyQ9jYN0QHzI4qs7G+GCVlfhUWags
         7D2QCYOD2TWNfdO10MiBZd4HSRacwfTiWO4mC9XWwVkOZxi/ZvkK1KeUgVqxNben76K+
         ySNqO4GqpA4LT/jp5bmi8538D2S6oNmIOKPjPB+PP3eg5TgGJ0S01GFvCIWMFPkM4gXQ
         MBHhK2T9/s9602mkqV5dldWrppZXl9YhV3lRYP8fZxINbyX4HRVbJRSzsA81wTzeCqDu
         hmLg==
X-Gm-Message-State: APjAAAXz0ZSFJzKPtBnG3uHTqOQS7XoZLYgT7hbQtxUFD/+vGoZECjZm
        OnhwpL9YB2SKnAw+zWhsqvNB2iNDUKaplg==
X-Google-Smtp-Source: APXvYqyHpeftaF3cHsCF/ajfUe4xVn1W+GdWaUrWFkp/ciwBXK1MbYzc3bouQCvxzpq7klKbsTSN9A==
X-Received: by 2002:a05:600c:409:: with SMTP id q9mr17732592wmb.19.1578032823776;
        Thu, 02 Jan 2020 22:27:03 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm60794875wrq.31.2020.01.02.22.27.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 22:27:03 -0800 (PST)
Message-ID: <5e0edeb7.1c69fb81.1ac75.5d04@mx.google.com>
Date:   Thu, 02 Jan 2020 22:27:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-115-g0ff4783e70ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 63 boots: 0 failed,
 62 passed with 1 untried/unknown (v4.19.92-115-g0ff4783e70ef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 63 boots: 0 failed, 62 passed with 1 untried/u=
nknown (v4.19.92-115-g0ff4783e70ef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-115-g0ff4783e70ef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-115-g0ff4783e70ef/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-115-g0ff4783e70ef
Git Commit: 0ff4783e70efb1b60f2baf2d9d4fd55d2e678c36
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.92-115-g2c7ea655=
7e21)

---
For more info write to <info@kernelci.org>
