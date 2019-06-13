Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5BC43986
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbfFMPON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:14:13 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:54905 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732255AbfFMNaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 09:30:03 -0400
Received: by mail-wm1-f51.google.com with SMTP id g135so10224089wme.4
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 06:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fG7zTrGYhrTn2R8dicpGyyCWK8SjK6usqkrzLPnkewQ=;
        b=RnJCagEFhvpv65C6VDEJb9hZoF/ofT9Sz58pgE6Qu+j7onFuxHsmXOFMDr9HmvKOLl
         uPqz2Kz3Sh+zHwiDdgumNYoeiemo6VqpTTvsJom0JVGOZ1uQAk5o+FNl++mCU9JNQIEh
         +L8bco2CNUTVTAY8Vb3jDTAIfU9ruPDFWj/WvI3/w8hM1nWCXahCfl3zo4XrosnLU1RM
         LfNgMYfWscDYN2rStrec50fdmSmhrZm7zFlmT/8is6etqtDOhjkgtNCJqg0FD0oIyLrb
         tq+BPw3ISTPBnYpf8gdrpnQsalS5d+R7ZSeFPj4jLGxO0V4iuz1I4G1LReTQWgfQmOQV
         qwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fG7zTrGYhrTn2R8dicpGyyCWK8SjK6usqkrzLPnkewQ=;
        b=roCx7l63Kl16aAnzJ3EirrEGb6nA/kT74CUybJp8/bxLx/jL/ZcVxbydLeD2x/3Qae
         I2c5HxHmSV1fUsIrOlg0PhuQHrrlTlrsnLRKezgyJXn0kSuY/wbRZfx7Hys9OgUNd/aA
         ZyxeM+FqgIAP5EvKjP9WosnUflsGOsqXso4exqMnuBj+qcvkHUT1uxAR5BvAoePqwC/c
         YzYdpZoveOzdxuLdUEhMjR4Q4Bkd+KM5Wb/ZeDHiCtAt0X4TyLa4qJVGpvYc93mZqsYo
         fB1nzlcQX8ltUKM8Dl9VBRqJJkY46cZDZETM2c1okZiQ0Lwax/PYhue7HuCKw/pl2HOd
         j8HQ==
X-Gm-Message-State: APjAAAWvNO+a3911c6RO+23Ijf5HvgdgTBf0gd6xVy4RPaDyCaF97tg/
        5KpTnWLnHn6ULgPA0/ULQ1sPoItLvf9sag==
X-Google-Smtp-Source: APXvYqx//iNPdGcIFj2aiZId9H/o2N8Fj35aEuBp6DKwnbK/NDmb/PdVdiNj8LjSniWeGnj1Fn3i7w==
X-Received: by 2002:a1c:8a:: with SMTP id 132mr3841128wma.44.1560432600824;
        Thu, 13 Jun 2019 06:30:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w5sm3810494wrr.86.2019.06.13.06.30.00
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 06:30:00 -0700 (PDT)
Message-ID: <5d024fd8.1c69fb81.bcf82.4cc2@mx.google.com>
Date:   Thu, 13 Jun 2019 06:30:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.50-119-g94ea812871ce
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 123 boots: 0 failed,
 122 passed with 1 untried/unknown (v4.19.50-119-g94ea812871ce)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 0 failed, 122 passed with 1 untried=
/unknown (v4.19.50-119-g94ea812871ce)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.50-119-g94ea812871ce/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.50-119-g94ea812871ce/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.50-119-g94ea812871ce
Git Commit: 94ea812871ceac0a190ded80c3272a779dfb101e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 15 builds out of 206

---
For more info write to <info@kernelci.org>
