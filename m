Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5081715CEB6
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 00:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBMXjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 18:39:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50577 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbgBMXjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 18:39:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so8147974wmb.0
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 15:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N5ejjssYaaOm7WsLqm6CaNGwd+XDRdu580FBXHkKdR0=;
        b=Cq8iiicn81FX93WBYRfS8SppbWZbTyjQ1B4Zi+AMO0hfrVATgxD8A1gR5CM2dzuDXp
         K5gCIxwedutPY9R3NTEsWqQME6yS58uWWQ6P5gDVt0XM4lWETn0pyYbJ1wWAkm7lRghI
         tgtcXgWrifZa3rxEXN0DjRtikUGRy53kZfvxJnuTG69PIqBZNyHRLKjGllaeUsfpm0lS
         qsQ7joK31mZl32jE6/oK3X4yCUgMFIFkToODwn6DddgYYx81qDN3+aTTv+Km4AOM6kYu
         iamFYIMTRqck89/ty2nXCC31zm6XFSccBNc0WUy2V281Q1DMtHCCvL2vQNE8cqprbF/T
         n5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N5ejjssYaaOm7WsLqm6CaNGwd+XDRdu580FBXHkKdR0=;
        b=tKdpMhKWCnj3kxxP/diG0TtnFCdXWLTd/LnNfmM3d6WDDNfUFNSmgvDerPikb9/OwW
         kFwiEUipY2AFUAMFPPXKYiVAuAiYj/qNZZU3yo4eL4WF/Hl6m+tCY0aVU8+lQLMTfeyJ
         MeF4sQaDi4XjAM5hCM8cryUNMQU+1ClLdmmn5wuH4e8RvvlqQy5yiLpiwGeia03UNNfj
         CLhLQw+FfFKgwgTShlpCXRnH63pQA+ZdWN85qoX9hS+BhaL97phZNxOqaos2JkzFZSx2
         3x0CqJu/DOT9XNyr7F27XRJ/Gn0Z6rOxqEgFVvusEWgfidHtvKvKpLD4vhwerUBKH27D
         s8Fg==
X-Gm-Message-State: APjAAAUhR8tlI6mraXVzJO8g2JGuqoBPR/qeoY+qVuuGnuI4ZTUMH9X/
        MAz6kooCwNjVhb+98b6ZLJyMBjSU3XIilQ==
X-Google-Smtp-Source: APXvYqyeSWscRZ4r17JpEdzDQIVV7OjuqGD6RGOVDrnCB07dlYn83Qist3qS/K+FoJDSbRw6OYZMmg==
X-Received: by 2002:a1c:a947:: with SMTP id s68mr484176wme.61.1581637162049;
        Thu, 13 Feb 2020 15:39:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a62sm5014150wmh.33.2020.02.13.15.39.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 15:39:21 -0800 (PST)
Message-ID: <5e45de29.1c69fb81.f82c6.6af7@mx.google.com>
Date:   Thu, 13 Feb 2020 15:39:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.170-174-g2874fe097995
Subject: stable-rc/linux-4.14.y boot: 37 boots: 1 failed,
 36 passed (v4.14.170-174-g2874fe097995)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 37 boots: 1 failed, 36 passed (v4.14.170-174-g=
2874fe097995)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170-174-g2874fe097995/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170-174-g2874fe097995/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170-174-g2874fe097995
Git Commit: 2874fe09799571ffc1e2e075c38a1c128fc11cae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 11 SoC families, 6 builds out of 140

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
