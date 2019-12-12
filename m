Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B2411D064
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 16:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfLLPAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 10:00:19 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55736 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbfLLPAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 10:00:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so2704913wmj.5
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 07:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kr5NeE1DWy+yXHfRaZeM8R5lsJF1k92rjrFcM5ZvfdQ=;
        b=CU7tAZKB89c5sjKVlTKKogMAR/7RpQ1+koJqz1XhHPW3vxxN7rjCM4o0n7coH6hq0O
         RPpGEp3ioDwNNa5jInS1FRUQv9H7iEe05OWrKgKHcHWw1N1rKM213vofxUdWWuOODE7Z
         uVcqNml7CUTiJEoOhAIw0WmeBqKGUwPM0bXb+QBK2Wsuu95jKr8KjsJ1SEzEQTByz953
         FAOSXi5jIJqa9oBbCXyBjmkHAYYyf1FpkHuBk42lH9vKailMQ7UJbZkRLwTTVRweZnUJ
         uDvLNbFW3hQMM4TrNjz14yLxDpVJkAAAKOZANgHw5HhkDhSaLDM1tuoy0jMicjAJr/lY
         HxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kr5NeE1DWy+yXHfRaZeM8R5lsJF1k92rjrFcM5ZvfdQ=;
        b=hBu8Go4aZjp5NJ/E/i9Q/TE7NIRKc5lAAznmRjw5/E0GhFo0eaPTNi+a2kIMazE7rl
         e5O6pVHl9WGaPFOXmhVkVkT2YWt/JFJz4I4pV+kqZrdKFy2a+OiZiw/K8hScZ/Wt7WTx
         4RL1sJsKghE+7HW39tWPGBg9E90q3eH09WTIvY8rzlizeH1euoeJhJ/pE5FgfjNjdKO4
         Ud4THempsoi1j49caywwvf/9yEJB5G+k10RZuGGftC9dA41hAcdIJgexcmY2IKzWs564
         XrMfA4uDPHBWvq0kxrWJZeKTVwOqmDUXoVWv0hdBmB7Vt9WvnIDvk2C9Ac81PK0Ne+QA
         JZSA==
X-Gm-Message-State: APjAAAXNy3pBNWfGfcRg8TuQO17cxNX9BUzV1TlAe7FpVPCtb+T+VFkv
        uya4MEtQqq0TIBBWGOYzMrkEH+0Y7oT/Zg==
X-Google-Smtp-Source: APXvYqy5Mo4kZfVxR94j04fDw3+SzBsiTebMBVhMlqonMkS6pXitN4aJs34zMHSLWvWAL2TaYv9C5Q==
X-Received: by 2002:a1c:f601:: with SMTP id w1mr2539436wmc.129.1576162817035;
        Thu, 12 Dec 2019 07:00:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j130sm1563819wmb.18.2019.12.12.07.00.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 07:00:16 -0800 (PST)
Message-ID: <5df25600.1c69fb81.e2d9.868e@mx.google.com>
Date:   Thu, 12 Dec 2019 07:00:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88-255-gb71ac9dfc6f0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 93 boots: 2 failed,
 90 passed with 1 untried/unknown (v4.19.88-255-gb71ac9dfc6f0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 93 boots: 2 failed, 90 passed with 1 untried/u=
nknown (v4.19.88-255-gb71ac9dfc6f0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.88-255-gb71ac9dfc6f0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88-255-gb71ac9dfc6f0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88-255-gb71ac9dfc6f0
Git Commit: b71ac9dfc6f0f5ef4a9dfa80113bea22cd8b8167
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 15 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.88-244-g62dbca095=
9b3)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.88-244-g62dbca095=
9b3)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

---
For more info write to <info@kernelci.org>
