Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758C65D153
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfGBOQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 10:16:47 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:55724 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfGBOQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 10:16:47 -0400
Received: by mail-wm1-f53.google.com with SMTP id a15so1016233wmj.5
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 07:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KlrTOljgFfZM9XHrtScqR+S+9MEAsvI1ZRedwPqdZeE=;
        b=B3kf4aFCQHVuqlEUuviNbWus8GzVK1Fs4atjmISvztjmdvWFoa9WNwRXChSa2Wb//J
         PsWZJ7n1yjWz1Cz3AgfoWFraSzWx5HmO1uUQAoV1YVMgJ9aojcYAOX0rP+H+0tDlDu/G
         Yty0IsVKrtaMhFFYOglJPluKysDmV4RiTZBQbz7+WxFcCY1UB27ubrGpfzqu0MXZTRd6
         p80eSBnu8+YPFitpYRcN3Rlcu/Z0PLhO82L0C7NveCfaucF6De7yS58Oa+jPsCNfFYg+
         mGzrRZJipm23472dmNyO8p/SzEjd3tyyEDntlq5y2+01ni+qCJ8IEwVECuCrQEeDqMwz
         cx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KlrTOljgFfZM9XHrtScqR+S+9MEAsvI1ZRedwPqdZeE=;
        b=hhilixk4cxnuMEaC3U/eeToePctY1xJMWT414pPqgyv4eFa33WP71rQXRejbXzlBcy
         YZQYZC4JnYztS9orIgEMtrVtuS9w5AGcYBp9tHZSIxBMgVjpVlHltrpdJrPCjEgTFNpe
         vKIvCVdoSlFkUcFJKNlCvIKFeSjZaOQ/tQQnA5r7JtKIfUSPn6c8gOSueTWMH0Tx2Tp5
         6r80kuJodnV01KzvUWI6sWD8mtJUDCscm7sWLh7ucUKP9roPQF4LVilz4kWznTFYuVxy
         nkUrcTu/DXDtljFz0aP1KViandDXcKiNcRlqNis6jS3/kgikG8hOvi2ONGWBy2UV0LtY
         vpsA==
X-Gm-Message-State: APjAAAUiPY4jXNGGwwj0Csbthy1DhIXc8Ka9qxoqm+EIhB5vpyrvK7IF
        LDHsfDxgjvh6zmta08q0m/8Sqp057BGhqQ==
X-Google-Smtp-Source: APXvYqy/Lmww4VqQguIZqslUZfHjpvChXDrDiSw5XaW3tuK+GlTgjFJF2FRhhQobbq7QqbSNtAba3w==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr3822317wmc.89.1562077005158;
        Tue, 02 Jul 2019 07:16:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 5sm2636600wmg.42.2019.07.02.07.16.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 07:16:44 -0700 (PDT)
Message-ID: <5d1b674c.1c69fb81.a7420.f86f@mx.google.com>
Date:   Tue, 02 Jul 2019 07:16:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-65-ga9678fbccb5b
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 107 boots: 3 failed,
 104 passed (v4.9.184-65-ga9678fbccb5b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 107 boots: 3 failed, 104 passed (v4.9.184-65-ga=
9678fbccb5b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-65-ga9678fbccb5b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-65-ga9678fbccb5b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-65-ga9678fbccb5b
Git Commit: a9678fbccb5b2c4fb36f8de03434947d26a87de5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 23 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
