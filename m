Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D064121B02
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 21:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLPUnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 15:43:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55684 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfLPUnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 15:43:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so717678wmj.5
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 12:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sGC+PoSMihzjX5NalR7l/xuKWU5/RxrPAf5BdJeB/+o=;
        b=hXqitFKJXsc7StDg9ELHMhxKVcov6XNbQhw8P3g1qlzptiPxLhjxhfi8DR65pww+lC
         xORPJ41GkHbkpK1h9hjvx90BNI4lTfXUIg1YKWSQF8zolsBCmrPDenD6jsBOgWeRVDGI
         UYTERaw4UaueKakvV8jchkiJFR+2AP9Dxiug6I0mV0iqaSNx4+rMzTzidMoAIcPmZClh
         0POROdqfZqIBu1LvjBCe+dun3iQxheoFWpPjXVweh0/Ie28Lilakc96tSVkE9uoWUoJs
         5Q8pzy5RYxSjwoWrWgjehuygGMYRu265gGMjAHwFec62LfTJ0w1PqtOc7qCmbpDIbrqr
         h5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sGC+PoSMihzjX5NalR7l/xuKWU5/RxrPAf5BdJeB/+o=;
        b=i/W1AV4Mw1fEamyklA8KWAHBbKHngu+u/YXUPw2bGmuXFougvkYwwuRXv9gFVyja+u
         8EDVDG9bYLXULZER6BmDFkRIvKjqWS8/KxiTJm5CHUpG+Vl/oDFxQxZJ4wmjXJ8T5osK
         6NkybYLCR1zclrGqHUUVOzOQNYeWGMJUN7cwZdY8hV+GPTBEtqVmCKEqzNrzvy7KvuFQ
         jPNbfBsMJ3vpqtIk+q8/0Vt8K/JSKT8GesKrtMSaUvsaDnUK3M1/bKN1yKCiI/3zRulr
         YcVunEzlNCMbiArxAEbPSs/tIW5ssUf+66jpGezsMEoE2Q1lRgIcB2+51mPPYFX6Pnxk
         c3SA==
X-Gm-Message-State: APjAAAUGBP3AYVHZh27h60oWj9dzZFq0rCXE66HlBu3VgOE2YJChsqoM
        VFOwWktmkQ58VoHpNGXMGabIjPnafJE=
X-Google-Smtp-Source: APXvYqwWwT2k4xXbpUNNOoH+LrsNU6ZZeb8bPSFQmXsue8goW4G4r24AyD759Np/S78KFhdGVPgb/Q==
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr991109wmi.146.1576528989619;
        Mon, 16 Dec 2019 12:43:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x1sm22813803wru.50.2019.12.16.12.43.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 12:43:09 -0800 (PST)
Message-ID: <5df7ec5d.1c69fb81.1b918.6e7f@mx.google.com>
Date:   Mon, 16 Dec 2019 12:43:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.89-138-g7825029ce41a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 71 boots: 1 failed,
 69 passed with 1 untried/unknown (v4.19.89-138-g7825029ce41a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 71 boots: 1 failed, 69 passed with 1 untried/u=
nknown (v4.19.89-138-g7825029ce41a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.89-138-g7825029ce41a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.89-138-g7825029ce41a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.89-138-g7825029ce41a
Git Commit: 7825029ce41a3e3ee4dfaf133f13c03c8b4a13ef
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.89)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
