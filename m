Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D639F736
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 02:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfH1APC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 20:15:02 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:34981 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfH1APC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 20:15:02 -0400
Received: by mail-wr1-f48.google.com with SMTP id k2so590294wrq.2
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 17:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oKHT/Fg9qkhmwyG3sN+PLIXAfhtIFFy0wb9WNqig2Gg=;
        b=zNpKY9VdM6ezFzjSVVAhtsbFF5l10i/8d3Kky3X8ZEFIDBVo7mvpoHKir6+fNftYP8
         6NcnWOpV2TueJooitn1MIJNzMflIQ70sDnhow3pUlx1JB+MMj9+0IY0byf67aEGzsUuy
         y2X6PnVIF0cjem42suK45hYYKoO5p9B8G0vVj+bS7KRhH7n8aRNfl0QvcRRtOqvZQ3Ei
         lHjYD24AO9073rUdcgoIroJ9rXkZiAUOtANQUjQErK+U01ZnaJqCbBoZUn7EQC87FxyM
         y9lB7herxZS+sXd4Bvnw/38f0b7uq0ST0QndKgLrI3Z44xCmMKuX/WZRD3VhjnS+xQs1
         CdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oKHT/Fg9qkhmwyG3sN+PLIXAfhtIFFy0wb9WNqig2Gg=;
        b=SiQ6ti6vUjZ8zPmO71Bn30w0HbfeKMhj1PQZiyYeTAHObQ4Ml85GoiZWnipfNqUoeS
         2g/6E+xborrxMX2ipj47nfEzCMam8hZwjIi+O4MoQiJsKDeqYtJYVJkJS8zx1zNvf3UN
         P/BK6S6rNVdVs1tu3n6id5MvBXIipbPc1CY8otM250s1D/549SsFMGJgkj4zjJKA/92D
         YLFHY0EZlqkLA3BWoteYCQ2nbv8CSWPI3FyJG7EcLWLq88Zn6svCD4E7mCDAX44i5jnd
         lgUr2MADj5/bWUrKzfKe6TurJW6KfTcV4jLAaLcMjWGFiZ3L461eCWV/sAyn19hXjPMB
         bttw==
X-Gm-Message-State: APjAAAUNTfu6fuTRMEQPS0vTyhaouyqB57WCpbQA4R1uJrsKfj/w+pPv
        82X4kIRvzwdskNzTqjxZ8qEYm3ZppBoOmg==
X-Google-Smtp-Source: APXvYqxOmX+ZGU3M5rRmO6g8LcVMK0DEsr2k0bpH7qYy4bM0DCrI8YLn8ddXMrc3MFXgIc0I66uCYQ==
X-Received: by 2002:adf:fe08:: with SMTP id n8mr707729wrr.60.1566951299934;
        Tue, 27 Aug 2019 17:14:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c8sm502976wrn.50.2019.08.27.17.14.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 17:14:59 -0700 (PDT)
Message-ID: <5d65c783.1c69fb81.75eb1.2a09@mx.google.com>
Date:   Tue, 27 Aug 2019 17:14:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.190
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 63 boots: 1 failed, 62 passed (v4.9.190)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 63 boots: 1 failed, 62 passed (v4.9.190)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.190/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.190/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.190
Git Commit: 228e87c35b6c083be778d24b64c02ad05015f3d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 27 unique boards, 15 SoC families, 12 builds out of 197

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
