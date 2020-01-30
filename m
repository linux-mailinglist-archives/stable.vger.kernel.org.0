Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CB314DEDC
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgA3QSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:18:07 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:51243 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3QSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:18:06 -0500
Received: by mail-wm1-f45.google.com with SMTP id t23so4425875wmi.1
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 08:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P6rlnalIdj++Si3XX4MvDVABpRiIJ8tgIKQfMm3wPr0=;
        b=SHjZzqIFehleaMD7dleGBTPFnOcgfFJ9hBmvYPUYTt8/iJLTWfu1VgB3Ya+7lfWInT
         rcdI4+XMwudFCKGG71IAeaKUtgE4BXDwGOuC6A3wGmM4A3S9e2K7OoFDaaVlAAjX4mXn
         Vw2J87NSfuxlMxf3OeMYroDP5S8f5cgg/Hl6LKuvlfLGSyqF8Mo7jN9SmDcflBIA2X3P
         g+EyCRXUUz+uPgEO4KFN0g4ifYOcM2BCstNohRCcy0w4zSe6dqNf79MAYWJ06n+BUWEc
         hFC9r3hjAOJgDbMc8PcRa/7ie2+Nmj9B+KSBZm1Mh1ipm+EGPrM2LluvmbKEuuEWzFLO
         uXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P6rlnalIdj++Si3XX4MvDVABpRiIJ8tgIKQfMm3wPr0=;
        b=MzAsta+RGrDRHHrbwJe60sEkoBr/wjpZAmHQS44zg7dHODUmCaItgpwWu4Kv8EBkjZ
         iMPCp6VKbXIrkM05Ing+wKFegx2kZxRnUkKgWI/WuhIfN/LrVQO3onI92bnSSozYgt1U
         EK5n7L2Dz46b8OpXKsNj8Sk/AMA/ioSTE5kF+/mOtrYLbRvyZeQcW8lfbqBeZR/w0ZEC
         FItxA0icauqgFiUd/kOS27CPDetQGQC79I0Ew+KoIhIEzK9XbY0L5bboTrRUTbhQM/If
         RtP251324iXPVDR1IdZOGdu5jW1F1RjQTOrvvHHojGWR+MTgqAMRA8LJeIIcNguzD8RD
         ogow==
X-Gm-Message-State: APjAAAUHy5yXnjosyheehL6DQdYgOXIqB9ZiVU7QyPvH2Mk8AzHHsmWZ
        rm458+eZx2/l3DjE61A6qhxlcUadkS2Vmw==
X-Google-Smtp-Source: APXvYqwzLlj+VZb+ECoAUF4ItVkA/hAgBLlH0/UUIDcPVcOy3uFpBwsr6+Ssw4LQqF83UdR6pmmqdQ==
X-Received: by 2002:a1c:62c1:: with SMTP id w184mr6514275wmb.150.1580401085253;
        Thu, 30 Jan 2020 08:18:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j12sm8541314wrw.54.2020.01.30.08.18.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 08:18:04 -0800 (PST)
Message-ID: <5e3301bc.1c69fb81.883f3.7020@mx.google.com>
Date:   Thu, 30 Jan 2020 08:18:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.212
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 29 boots: 1 failed, 28 passed (v4.9.212)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 29 boots: 1 failed, 28 passed (v4.9.212)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.212/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.212/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.212
Git Commit: 6f8dc95670980e30a1de22c75999d61fd143b693
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 6 SoC families, 8 builds out of 178

Boot Regressions Detected:

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.9.211-272-g91ff8226a=
074)

Boot Failure Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
