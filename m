Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5A497AF
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 05:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfFRDKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 23:10:43 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40188 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRDKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 23:10:43 -0400
Received: by mail-wm1-f44.google.com with SMTP id v19so1442227wmj.5
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 20:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3NGPKXMeEuUjG6DCQL4ThpMj6sRRHh7JPF+fANIWHS8=;
        b=OboyZomORZSbNKxfOetpmpT7cmP0HRf0qD5UJD4oaXCv9sNHzKom/ayeTnxeH+Aliu
         FsYcLo3OalGepFl0Rj39TpfvOsgeR89yK91XOdVpPUVXmnkSe3Ll2iFuKSWlAzAgfDgG
         aMt+pSJGvw+FaYI8K+YlwBP351MKpwTacRMMqlka5uBoQD0yOD1K41DzUlU3nY5uLjnX
         K0y9n1RdEwN9gsXIrvmSZfgXM0B6umNauJv6u8E0X2udAEGSmzCWHt/DEjiwF80WQ6iD
         yBrMfbrlugUmB+Jtow7VrzaWtADysqhmN1NOIbwSM9M1Dmlm2Q/BjaQopGDDe4V1rHo0
         WRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3NGPKXMeEuUjG6DCQL4ThpMj6sRRHh7JPF+fANIWHS8=;
        b=n8CZgmL+EMb5jMagQ/PfJZp9ylfBUDHrDNrE5tAs2IBBKo3/FYKve4xIfyqbTbXlSq
         s0D5Zxb9FoDBj8jcX8xV+LQvAlWiwxhIBV9p028CIPgTD2+jUq8OWG4ng1cXOzR4qLbB
         MIkmCCte3eEvpChTCI/JqIgvnqSxDuegrT4VC3pLrwVFX66ulhizTstfNzxU2/av3IA9
         Z4BOl5od8VMOjdwk5a//CXSwlNZm266gAQDWNJ2ArN7/9PyGpGBRQUG4NwKoal5OCTao
         ZnoPp4glzbIma/ByUuwhQJ+ziylOKK6ShKO/tDcl2pXDwTzIqAdxpZXevXJW5lJe9LkN
         Yniw==
X-Gm-Message-State: APjAAAXMiDR+F//ToHsYhBuYKMA671b7VJA+QdtxpPD3bs3zTR8PPsVh
        8LhMETR89lXWUSoIyOtfmQ41u5c3UwIAUg==
X-Google-Smtp-Source: APXvYqy/YT0/sE+8zn4QjwFYKX8cNi3XsdKYq95mQ29OsdmZd5Maj9DysUchBsaEFFDUMeLadSEdhA==
X-Received: by 2002:a1c:a1c5:: with SMTP id k188mr1146448wme.102.1560827441151;
        Mon, 17 Jun 2019 20:10:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g19sm1109091wmg.10.2019.06.17.20.10.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 20:10:40 -0700 (PDT)
Message-ID: <5d085630.1c69fb81.6b897.61df@mx.google.com>
Date:   Mon, 17 Jun 2019 20:10:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.127-54-g16102d7ed840
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 105 boots: 0 failed,
 105 passed (v4.14.127-54-g16102d7ed840)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 105 boots: 0 failed, 105 passed (v4.14.127-54-=
g16102d7ed840)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.127-54-g16102d7ed840/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.127-54-g16102d7ed840/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.127-54-g16102d7ed840
Git Commit: 16102d7ed8409bff0d3b105d08bb2ca26343c539
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 24 SoC families, 15 builds out of 201

---
For more info write to <info@kernelci.org>
