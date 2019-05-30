Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905402F484
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbfE3EjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:39:12 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39409 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbfE3DMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 23:12:40 -0400
Received: by mail-wr1-f48.google.com with SMTP id x4so3110647wrt.6
        for <stable@vger.kernel.org>; Wed, 29 May 2019 20:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ezFKBtHFgKGXSZUK4cVxLQECXJJM7wlZK4eVu1flLd0=;
        b=WI9v5jbXrHEPdIVWLxv94FyDilzgn3A1+4IePTXmMhUURNI0mGJp3ByYOeRqMuuFQZ
         bs+JVWaJqZtllsyv//o0d/Nfxef1cfWf6rrFhcm3i5ZJmjmRLf5NTUrkxLGorFv7c7pB
         mMR9tm2FWCpsMlfPLkIKCTHnfS3NF+ErIn9lLiIVZwQNcVML8ZcUy0FHmsOpqOg/MRAt
         ajgvkwrUthYzIlw1hmUZS6zK8yDSEpEnR61+oeu1EAc8JHTNzBZGdnvqZMIXMiQuwrhl
         UQ5Upb6KELmfLT6NqUvlzzECK92IP4zALWNYrmvuLT+3OEuG9QkMEA8qsFGoLlXULEHg
         kbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ezFKBtHFgKGXSZUK4cVxLQECXJJM7wlZK4eVu1flLd0=;
        b=gNQXWi4cNkrzfbjTUZlEe/yL03Ud6Mltco/Q1V1NeQ9FEz7GXVQdIVtSmiojZD2bn9
         UpEGmqsI7m7LqAnyApZxPnJqeXag+4YYhvcSigxhIuj8QmZs8I3omzzoZtBGMslfa46l
         n1iksZQeE2uBnjug9j5blFe2KyQhwDr370BVkyh0veE0op1ZS0a1QEwgOYhT246+7a2b
         +BHdFVIJf8ZCvV+xkBir/3hKae3w+jw3Eri39a95oxLmDLKm95Glwrp4lgsgKX8gprUo
         QbvI1FFVbbh/Ap7/HeRDFU623lHuPftAyzZfJhkzjSs18QOUySWECnmxmsAQJ5Tp6ILT
         0fiw==
X-Gm-Message-State: APjAAAWauEwPR4/KL6fXnVD41vdRlnioOxOtZPnAH6ftD6oQIYW/wNzx
        YUqKqEPjfIxJwbyNTS+hYqBIhlF3eGCTpQ==
X-Google-Smtp-Source: APXvYqxlTer6OJZdWNvm1rrVhPaRcexE9JsH1GN4V63ipqS7dxn9HEn2hW9EZ9EfH4fGsheIIkshEg==
X-Received: by 2002:adf:ab45:: with SMTP id r5mr785958wrc.100.1559185958494;
        Wed, 29 May 2019 20:12:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l190sm1660047wml.16.2019.05.29.20.12.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 20:12:37 -0700 (PDT)
Message-ID: <5cef4a25.1c69fb81.3e1f5.8e3a@mx.google.com>
Date:   Wed, 29 May 2019 20:12:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.19-42-gc53cc2c82fb5
Subject: stable-rc/linux-5.0.y boot: 127 boots: 0 failed,
 126 passed with 1 untried/unknown (v5.0.19-42-gc53cc2c82fb5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 127 boots: 0 failed, 126 passed with 1 untried/=
unknown (v5.0.19-42-gc53cc2c82fb5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.19-42-gc53cc2c82fb5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.19-42-gc53cc2c82fb5/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.19-42-gc53cc2c82fb5
Git Commit: c53cc2c82fb5e676ff71bc2e9fe577c092b4cd8e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 22 SoC families, 14 builds out of 208

---
For more info write to <info@kernelci.org>
