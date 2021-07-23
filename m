Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9C3D4150
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGWTbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:31:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D89EC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:11:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k14-20020a05600c1c8eb02901f13dd1672aso4782823wms.0
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 13:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2IG5fmfewvyHgb6x3OOg4u9aeJXPUkYJuK+oYF+gUz4=;
        b=X3AL7AZ90ZzngTIrZETBcmupIFgU81I2RtK+EwM3cRXkziC9g6x3jRnlbUqJA8T3z4
         c9St5QQ6uZfu+tN9yDrXGHwRDgznDW9EG9nO+l2swGHP2mqyfW08dxhEibsmOaBDp33H
         GrZuOgLCP2IsxWFrDJsEXat2btugj4nU0j17ux7ps/0H6RJRL9ue5v2FA6XOBoJiQmoi
         gcSEURo0jkiOer5Z+ADEOgkBKITPbZxKkryeFOFK1TDVdLc7Vx1RRrvbUkfuHLVPCML5
         HCLX8vrROwp8qxgYsku1H1ChqcBT8IMMn/0UZy3cFocvCOd03LmPmms2LmtAxrGm8qlA
         7aVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2IG5fmfewvyHgb6x3OOg4u9aeJXPUkYJuK+oYF+gUz4=;
        b=PBKSusFymnlF41t47pzEcCidWaVdHZRBkOHw8aZi/5fAt0c2BIPka8YWM6bh/3xLnB
         f8atqufcOowIOO8KUnZXIIjiDcwHqsdlIkZxoQPc5xCaMoyaQ3/Hxe3BTJmN++fUtJSd
         mjrRZOy50eTUqALjPaa4qL6JqfmzjDH4aW1d8Dm2W2uMjzfRNazPy4PmzGG+RdS84F6a
         kMNgME6QKdupM6DjA1LbM/grDnC/jvY/ILOf362uwARDoFt5IC9JdxGNAxDamu03+s6s
         xk67zk2kWTyr0lqbCQqwMo2y0Pd+ijL1+uJ4C0qjLN62RaOISV3DUbfVPXhE3Egt6AG0
         tYxw==
X-Gm-Message-State: AOAM5300setFC1kNBQl5+GfmwjyYwrAew3Sd22HoUvde2m5UvGyBpgqV
        ZRYC8A+gBhHXjLl7wfxPKMI=
X-Google-Smtp-Source: ABdhPJywACbss/UTorKx9/lV1BVbhBpM9Zupy0YDi/7rBeV6gTznKLWTfIqTDGNvD6TbWzLMybBUpw==
X-Received: by 2002:a7b:c955:: with SMTP id i21mr15562173wml.147.1627071090672;
        Fri, 23 Jul 2021 13:11:30 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id i12sm34179626wrp.57.2021.07.23.13.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 13:11:30 -0700 (PDT)
Date:   Fri, 23 Jul 2021 21:11:28 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     evan.quan@amd.com, alexander.deucher@amd.com, bhelgaas@google.com,
        kw@linux.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: Mark AMD Navi14 GPU ATS as broken"
 failed to apply to 5.10-stable tree
Message-ID: <YPsicJu7+dXobhdI@debian>
References: <1624272159224240@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T2mF6yF5tvzpSIVi"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1624272159224240@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T2mF6yF5tvzpSIVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jun 21, 2021 at 12:42:39PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will apply till 4.19-stable.

--
Regards
Sudip

--T2mF6yF5tvzpSIVi
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-PCI-Mark-AMD-Navi14-GPU-ATS-as-broken.patch"
Content-Transfer-Encoding: 8bit

From 5e27d7ce2b14ac349942b0ea1d0f5a11c180d853 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Wed, 2 Jun 2021 10:12:55 +0800
Subject: [PATCH] PCI: Mark AMD Navi14 GPU ATS as broken
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit e8946a53e2a698c148b3b3ed732f43c7747fbeb6 upstream

Observed unexpected GPU hang during runpm stress test on 0x7341 rev 0x00.
Further debugging shows broken ATS is related.

Disable ATS on this part.  Similar issues on other devices:

  a2da5d8cc0b0 ("PCI: Mark AMD Raven iGPU ATS as broken in some platforms")
  45beb31d3afb ("PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken")
  5e89cd303e3a ("PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken")

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20210602021255.939090-1-evan.quan@amd.com
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Cc: stable@vger.kernel.org
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pci/quirks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 41bcdfac03d8..bb1122e257dd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5264,7 +5264,8 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0422, quirk_no_ext_tags);
 static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 {
 	if ((pdev->device == 0x7312 && pdev->revision != 0x00) ||
-	    (pdev->device == 0x7340 && pdev->revision != 0xc5))
+	    (pdev->device == 0x7340 && pdev->revision != 0xc5) ||
+	    (pdev->device == 0x7341 && pdev->revision != 0x00))
 		return;
 
 	pci_info(pdev, "disabling ATS\n");
@@ -5279,6 +5280,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7312, quirk_amd_harvest_no_ats);
 /* AMD Navi14 dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7341, quirk_amd_harvest_no_ats);
 #endif /* CONFIG_PCI_ATS */
 
 /* Freescale PCIe doesn't support MSI in RC mode */
-- 
2.30.2


--T2mF6yF5tvzpSIVi--
