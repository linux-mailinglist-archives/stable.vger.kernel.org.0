Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC90E16AF7
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfEGTNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 15:13:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33810 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEGTNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 15:13:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id f7so13524581wrq.1
        for <stable@vger.kernel.org>; Tue, 07 May 2019 12:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Snv7TyoiGAcKNv0tuFYq8gStYoAzEsMX1pXAbixEywg=;
        b=iz711VDvlODNbNaTj3xHxsCwEB3dTVovcGyEZHSQE5JXdNCP9OpzOLBingG7g727+8
         kYhUGeA+DCqPRdpEhr5SyJvBgHdKG4sPBb/ypwi3nbYtNfG/Banijr/O9y7cdUz/wmzi
         J2Aw/MxvYpkrAcZLuzkovGjpJdVE7kl7gZkF4ViI73FPsjT0nBo2altkkQzuuSFGM/v6
         AcuMwa3Or5esh9eTlQ8r9HVBUcIJ4eP61KEf87+v9sHE0STQYA/wst1N8WRWw23XlJ85
         c/B18+uLof8BjSrok99nkoqMvxWhsBITEfUo8I1MLLJn7QqCtYtCU9zNUfkzF2FApcpv
         jtog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Snv7TyoiGAcKNv0tuFYq8gStYoAzEsMX1pXAbixEywg=;
        b=aAaZUbcBZ6NvJnFQhbmSp/iq2gzz7kUhRaTBGfAMTFmnbLKj3fOmlc4PygMFA6NygH
         fYz7kf8DN/D8HQsRw7WDCB6oRXKLyoU+HmRwKCW5t++Jhptfx0iYL7MpQRozmwZtplpj
         SZlVqs11RC+oicuCjsuHxo62aQuOLCkvp91q4shPDR0pV9LeeOIH7grHSdXlHL2QWkIy
         NRx4a2vNuHq0plO5tfcqfGffezulVq9hHvJ0CyIoeu2MJJlauIcAcOyhaO0WDDc6UVlJ
         NSe31tPteewDyHylK9HedCzj2PU7rMikjVWbKmcIpVxN0XyKj0qleqwtAjs5piKaoHAp
         z9IQ==
X-Gm-Message-State: APjAAAWUV0PMIE+CTIDm3jK7D9PihlgLNapZ/1pD5A1Twrbno3bVjmTN
        PyYNIDh1zVgza0JZlrSXLrCqDAx5cRQnTA==
X-Google-Smtp-Source: APXvYqxhXU4kGfFif+X3kjcfRyxg6Abxh938E+7L3Q/JrWvZCnEB8BOefeuwwoxOgk83VxuiAXQlng==
X-Received: by 2002:adf:83c6:: with SMTP id 64mr22525279wre.81.1557256432829;
        Tue, 07 May 2019 12:13:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a125sm2862206wmc.47.2019.05.07.12.13.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 12:13:52 -0700 (PDT)
Message-ID: <5cd1d8f0.1c69fb81.68a40.fc3d@mx.google.com>
Date:   Tue, 07 May 2019 12:13:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.40-100-gf897c76a347c
Subject: stable-rc/linux-4.19.y boot: 54 boots: 0 failed,
 53 passed with 1 untried/unknown (v4.19.40-100-gf897c76a347c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 54 boots: 0 failed, 53 passed with 1 untried/u=
nknown (v4.19.40-100-gf897c76a347c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.40-100-gf897c76a347c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.40-100-gf897c76a347c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.40-100-gf897c76a347c
Git Commit: f897c76a347c330cca7fc03afaa64164eda545f7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 11 SoC families, 10 builds out of 206

---
For more info write to <info@kernelci.org>
