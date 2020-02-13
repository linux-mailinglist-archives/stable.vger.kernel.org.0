Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241AE15CE70
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBMXBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 18:01:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46772 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMXBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 18:01:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so8747482wrl.13
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 15:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=95Po0oKpku27T9o1cB/li6lUhMoPZa5wJDlK8/lwwIU=;
        b=ZaSsR9xICRMqGtewQ7U8jd4KuOzkE1klUYiufPwAnxewWiKd7k721rxLOKeG52M91C
         zelWy1tyPSzSatPdKLDGrpS98kChVr5NFn91/JhCLxI38BxALYuIQgZzggFGNSNISKPr
         JeNzS0RZVMoJ/gg7TC6I5t6QhDgb4T3mudnWNBv3ypBV2IlsteWUA29LY4zniF+9MN7q
         q+zS3qbUc3lsGQrqvFRqJxz/4fUgvpSVy/aJiQFAb8v2svBovJyncI9/vuNMPvWPodlR
         3y2ITGuvwh+GEQD/d4FEIw7M+bJFg0s5fwqVUlRNtkdmXIIcKUDCzhJRK3x8cBZ/OWsY
         +P3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=95Po0oKpku27T9o1cB/li6lUhMoPZa5wJDlK8/lwwIU=;
        b=IHQcQMQ+TPUQbvalrKo7jTvsonaJIwMTZnKvtUwgpuRRhA5GLATkvV0hN2kV0vNNsC
         U/OZwrzds5io+f+tjxb33h4Vvt/PZweIZWHVAIkmThi7ff7yjSmDfHNH9LLMbtN1i6bc
         JBXn6r5N2Qfh4hHQ3ACfpPKS9OUsPRKXrYtJEfK8un19aT0gLpvK2HMxjmsh/MMj6X6O
         WK5+2Re3NQH2DrMSDRvHK1Rrx86+W0A3oDZW5Fdsq12Ho3Do3Zo7R0ZjflDvHYNVuiD3
         ZYQDaJOv7y44sykS8/nw5CP0X/gwVQCNdR1/00jlC4gwpPomn+uGOcJqO8VHAC0xU0AQ
         FpKg==
X-Gm-Message-State: APjAAAUl3GxqFI9nEZeF7K7A5sjtlFD4wJPxkzfaX6dZPZugXWCgnOzo
        +YvyXVWvWt+tX0QYf68fBgvzQ/samQxwnQ==
X-Google-Smtp-Source: APXvYqxD+Ri8IdzaX6SF+GxmScWFc6vkK7flmoMPWnPRrLyC+FnA0tCcV29oMrh2LCxCMEFbTq4w9Q==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr23293200wrq.51.1581634875923;
        Thu, 13 Feb 2020 15:01:15 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s8sm4789933wmf.45.2020.02.13.15.01.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 15:01:15 -0800 (PST)
Message-ID: <5e45d53b.1c69fb81.28227.5749@mx.google.com>
Date:   Thu, 13 Feb 2020 15:01:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.213-92-ga4539ca32651
Subject: stable-rc/linux-4.4.y boot: 13 boots: 2 failed,
 11 passed (v4.4.213-92-ga4539ca32651)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 13 boots: 2 failed, 11 passed (v4.4.213-92-ga45=
39ca32651)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213-92-ga4539ca32651/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213-92-ga4539ca32651/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213-92-ga4539ca32651
Git Commit: a4539ca32651f32bc7c45d0f09be1fb9fca3ec71
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 10 unique boards, 6 SoC families, 6 builds out of 112

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.4.2=
13-80-g5eb5593c7143 - first fail: v4.4.213-80-gc93242186b91)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
