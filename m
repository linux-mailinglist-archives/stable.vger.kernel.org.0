Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1165F6C9ED
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 09:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfGRH2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 03:28:25 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44504 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfGRH2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 03:28:25 -0400
Received: by mail-wr1-f46.google.com with SMTP id p17so27427947wrf.11
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 00:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1FvNEKtS8XUFhNrzpNnVepQzKVjJRHhKmZb07KcMWQ4=;
        b=1pdrgg48WKY+XfYahnUMYpVd0+3ME1CcyCu7JOy1dPCpwrIv6A5ORtC2kQdFHUqs/H
         C8nSxIectCgAt+Pt5AlE1RrjvP0LdqWbvaslG4nC8vD/tcG4HZxRBfkjRbncwinJvKAZ
         /4OB2zEIY0cBbIVUt7YpRPkk5o8RR+zRwD1ZXJ3hQWZSLruKH6wBm07+wK+e/ed07lwu
         zNbl0Ce6TWIdaStndfKAjSFex2XefO2BiFT+D0/qTyQ1Io1GM35z2D7VkxhZOfUoQz+x
         9PfpsBXqKmXCOHSQPXDJ2NGa2nONeash31NuVvbnkVuxiaJC/DaR225w903ZGfrWerGc
         C3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1FvNEKtS8XUFhNrzpNnVepQzKVjJRHhKmZb07KcMWQ4=;
        b=QeqaU95uct6WzZFkYnbKnsZuvCrqJ58u9+lQATgnrtSS4AIjJRGJx9mN7Kvr96bIhI
         FYnuLlMU1SQsQz9/yUQxac9dbILoqE+b58tvqIOtD4ifvvKIp6bd2ClKPnL96MdLu9hX
         uWncrUgMppwPlhS1o5yVARrnoroGlUtCKft40qYfaX2mLAdMPwMR0v057loORWZpzcFo
         BJyHfFBwA61fK1HutpwfgfoKDcrQAQMlzm4IGCCTcVQf7s69RAUZMfBxP/6HdrgOGcOh
         ynh3tEI1a8k0yNJXGxk19Cd53lruavgr+l9yqXB5RTeuSk1Cwzc9jf7xfQi9aFCzHJu2
         D0jw==
X-Gm-Message-State: APjAAAVSwP9amAIilfT6I6aP8ETtpfIcSzAfYXyEz4kVmWVkBA+2IVLw
        Am2bofI4a+2sES1uqoPM163UST7hER0=
X-Google-Smtp-Source: APXvYqy5LLqBSlencv/oOLPtbGklzTHAn7Cn4uyJ7VUAr8fHIim0+Ybx6byL2TxoRD9Hby9pad79dA==
X-Received: by 2002:a5d:6508:: with SMTP id x8mr19273250wru.310.1563434902506;
        Thu, 18 Jul 2019 00:28:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n9sm49021808wrp.54.2019.07.18.00.28.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:28:21 -0700 (PDT)
Message-ID: <5d301f95.1c69fb81.948b2.4cd9@mx.google.com>
Date:   Thu, 18 Jul 2019 00:28:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.185-41-g15ef347732a9
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 2 failed,
 96 passed (v4.4.185-41-g15ef347732a9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 2 failed, 96 passed (v4.4.185-41-g15e=
f347732a9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.185-41-g15ef347732a9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.185-41-g15ef347732a9/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.185-41-g15ef347732a9
Git Commit: 15ef347732a9cb126d0626155a1b1fc1dc15545e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
