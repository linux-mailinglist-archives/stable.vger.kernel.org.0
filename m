Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE713A26D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 09:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgANIAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 03:00:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38217 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgANIAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 03:00:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so11133095wrh.5
        for <stable@vger.kernel.org>; Tue, 14 Jan 2020 00:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h3oNSyEMJ9TjHMKGpJr184fnNB8RKRqjSlYWlKf0zsg=;
        b=C4eXwK9NMt+ZlTPUOa8kVlrfmB8ymTWdp7w7YEVOlwzZLEffyQtlW3S6nWJ7VL3hOK
         uA/gtodqWzOYv+DstRT1ZIG5dHwZn3o9QHhYH8DPwbGiqsjiwzl/gIcKBIPuwTVCOmJx
         srKwVvAW3CwBS3G31/kgZ+5kzLwJpUnV9Mc0LVeEiMNrx81K8iJKW4Bg1TxgGFOm/kRf
         GYL6c+27b8rXHLg5hVGjSqs+I85C6CxpDtjRn0QxAzTOJ5iqTtCL7yna15w/9+p5Rw6u
         wAY4C+klclq8eN74NYVlfP9xBEp/A2QEpTF73H8svmJesAqLMYYOiznyCFaXWufd+kiN
         Oagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h3oNSyEMJ9TjHMKGpJr184fnNB8RKRqjSlYWlKf0zsg=;
        b=S9wvI77Z1z1+u/++7dbEvo0pIAREOkuV9DD8zQ5reJ1Pa4L33Qn+dQkoAM6OPUcCGX
         n1bRfDKdQAoFOH0oYkT1o3XrbSpd0Gi77eST8s1rFj5GzbXvYv9QIB4+9Ys9JD3ub0Iv
         eTDwC8ZFv6X2DpR+Ed4+tIW2If+cs9G0eLdfwowxEHY4+fCI50ClmGAzvdwNoJsGwbZV
         mOlNovbi4hMPV1fCRT6kkDCf8ZUWdgPyhlGmHRYxEtgaprWQbrA2gVrLQMK1h+iGF77n
         PkgceBraI5aMmgBnwAOxoe0+x1WeSodo3yKYcv4I+cXET0A7/DHLDqrqHNkdQlu7ewiu
         wlDw==
X-Gm-Message-State: APjAAAWKFpZkN8+qnFCX0vAuQpjte+JECiWzC5aI8dhrWRZB6udPOG6e
        JpDMGM+3rbqEfMkxj0UV26iiB/E8TCSmOw==
X-Google-Smtp-Source: APXvYqwrpghLlLp5uYbhwlwAjdhwgt3AndYAUO1JofrgmuTPrtzBJahRC7rWmnX1efquf63zWNoqBw==
X-Received: by 2002:adf:a746:: with SMTP id e6mr24276291wrd.329.1578988833268;
        Tue, 14 Jan 2020 00:00:33 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l6sm18267345wmf.21.2020.01.14.00.00.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 00:00:32 -0800 (PST)
Message-ID: <5e1d7520.1c69fb81.ca5a.c011@mx.google.com>
Date:   Tue, 14 Jan 2020 00:00:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.95-35-g2bdac5496636
Subject: stable-rc/linux-4.19.y boot: 79 boots: 1 failed,
 77 passed with 1 untried/unknown (v4.19.95-35-g2bdac5496636)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 79 boots: 1 failed, 77 passed with 1 untried/u=
nknown (v4.19.95-35-g2bdac5496636)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.95-35-g2bdac5496636/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.95-35-g2bdac5496636/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.95-35-g2bdac5496636
Git Commit: 2bdac549663665fe972016b13afee6db879e82da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 15 SoC families, 13 builds out of 202

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.95)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.95)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

---
For more info write to <info@kernelci.org>
