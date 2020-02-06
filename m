Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA023153F51
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgBFHlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:41:10 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40148 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgBFHlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:41:10 -0500
Received: by mail-wr1-f50.google.com with SMTP id t3so5856771wru.7
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 23:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XgTLhOUWY3DQc1AckA6j5FpZ2ji5j4H0js1d9960RG8=;
        b=q0LiXV/wYrHJMG1TeFoatbWRYG6WChw6ecGMy2AW40bumMXclcAZmApN9kAOQ/sD3n
         efhfTvOUWlJMVOLPYH1pJBbkJ+3HbgDM7vRcGHmMkD5H1hLwLpx4qAGbxmqPJf8JYj3+
         PBAKKFKN4PzIzQ7xlDO+Z/oDYBTBanCUXFxfu09BtzffJGO/U/sb2pl6bBDql5WNw49a
         yEte7QVGlzytYXLvnkuCFoD52BYkk/dhVCeMjkLp+cfGaMR+HJ1ER7h3aXg8lWdKuxX5
         YV4nNw+eHFGNM9Umeuhub7OyiSgqBfADw080e3+YR+LgwzvOUbv4Z3MeUgHHL0EsO6Ed
         zQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XgTLhOUWY3DQc1AckA6j5FpZ2ji5j4H0js1d9960RG8=;
        b=bBrJ3glWg4hA34FMY9lgTfm4R/SeqTaQFS+UeNjDb8mEyOtAhAndDQvsTsu7RDlpYK
         uKpzkUJsho6txeupKAE0MRB/2k+zCoKSlF179FIe+RDjMS+O3bIEu3aF7lNhIHnuIbxL
         lCd6MwgBKvWGYLb8sxvRaaqEl/HpC+MHWPxcl7rp+ai9s6zNOrrcb8KSES9PTiilDl3E
         dbK0+7qN86dnjdrROVN42eTVCYKWbkI6uWbKk6IWl3apM1GcBdVG3bJ0cPoPtQuahKJM
         YEcKkarhCIjI/czfi9Eog/BNbzXGajjXWO6aHjE8gbzWtHfjzMdRe7vVqbzcgWgq5UI8
         lhtQ==
X-Gm-Message-State: APjAAAWyURf7Q2e1DAjve6SBj5vkD00rUbTvzSGohK2HWYjsvCgbZrIr
        0Otrdk+jlBIkjqXbRmdnfQ47bIFLQfZXcA==
X-Google-Smtp-Source: APXvYqxqWxKzwzGrHBp081QISjLITo8ircB78zDzBwCiyy0SV4Eieg1UUL+BzYPJWJuOFbeyKIKnKg==
X-Received: by 2002:adf:dfcc:: with SMTP id q12mr2172442wrn.171.1580974868649;
        Wed, 05 Feb 2020 23:41:08 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h2sm3282582wrt.45.2020.02.05.23.41.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 23:41:08 -0800 (PST)
Message-ID: <5e3bc314.1c69fb81.2f767.d96c@mx.google.com>
Date:   Wed, 05 Feb 2020 23:41:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.213
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.4.y boot: 8 boots: 0 failed, 8 passed (v4.4.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 8 boots: 0 failed, 8 passed (v4.4.213)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.213/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.213/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.213
Git Commit: d6ccbff9be43dbb6113a6a3f107c3d066052097e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 7 unique boards, 4 SoC families, 3 builds out of 28

---
For more info write to <info@kernelci.org>
