Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF14ACDEF
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 02:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbiBHBXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 20:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbiBHBXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 20:23:02 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D494DC0401D9
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 17:19:23 -0800 (PST)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 669A73F22B
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 01:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644283161;
        bh=bR+KnBD3V9VfQQwZt2Z/wkPMJzyvsWJ3UhlANeJa8dA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=uMu0Bvxpmjtsln/lLda5EdcQg84JkvbPZDGyHAKi5XrLu47Sc7BqHJsZ0tZNEIQKg
         p/4y26MC8NhI/D1OgUPuRpln9/tGoCUHT8XUK2c8z+WgCWFWm3AU5zEm6HlPKGIDHX
         uuYL/RIgDmNZn1XE5oWcV/oTgdrsO3m2sWz1z5z/bmsXvDRCaTBUHCsPZ/2A18jP95
         Fj5ZsGT94iik8jKTF5o3p0HawYyHFXt04wXxGwmw8j8rn8SQP5kaapkYb9rtrtDRF7
         ptlydOxoZPDYwY4ekwGVsUdbXVwQhRn1QfG6t6lS+6SIp/hCkolaNg74UZxwLbfrmU
         aUVBzaYkMPR8g==
Received: by mail-io1-f70.google.com with SMTP id q7-20020a6bf207000000b006129589cb60so10397490ioh.4
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 17:19:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bR+KnBD3V9VfQQwZt2Z/wkPMJzyvsWJ3UhlANeJa8dA=;
        b=kWdkL/kmOX/XTAUD5Mhqn4C3Mh37sw3fH8Hku1v3dr6dB7pMRaB0H9JT7SlAzaqAFh
         Xoskg3WcWexUBIZ7dNxMJgSOKVTYsra+GexgG3oi201cecemcQw1Es41krJsdC/n8s28
         dsmUNIqopOBcGK7dWoydrMBBL35Wtmm+bISP2Q4ouddr4dtvwHGwo8m/Uvu3DRIVmAa7
         8ercmA9IsHZJtvn8Q1sn7AgZQaBlBqtMgnIsmSKzV7IuK9aXYRu5rlMF/TwcJ0ubp2J5
         Tls+0whNCJbc1w9GBPi7aNIEBAUzMSzdMpk8N/Xpx/lKWhX/ggl/7IfyW+FbmtIf5S2p
         /EYw==
X-Gm-Message-State: AOAM5313h86NRT/4PMOr7uvd5fb69YR3fysWo8Awcx47HsdEHyTClIng
        Te8cykypq9/ZA8dLvBITs2ygSVsisQzMkpPovsy2hInoq7MU2ohezg06Ka0TOWOPNxffs0FOHlX
        moIsW9STkJHl6jtOds5mqjgRW4lrlCbSRNQ==
X-Received: by 2002:a05:6638:10ea:: with SMTP id g10mr1085379jae.79.1644283159934;
        Mon, 07 Feb 2022 17:19:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgE+zqaGNjhqInu2uD4JORuhXtZ5+ThLHHgAdHtKjBMTdOQNSqcTIspI6mC//tHBlpexBZmA==
X-Received: by 2002:a05:6638:10ea:: with SMTP id g10mr1085369jae.79.1644283159579;
        Mon, 07 Feb 2022 17:19:19 -0800 (PST)
Received: from xps13.dannf (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id ay35sm7126949iob.3.2022.02.07.17.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 17:19:18 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:19:16 -0700
From:   dann frazier <dann.frazier@canonical.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        stable <stable@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
Message-ID: <YgHFFIRT6E0j9TlX@xps13.dannf>
References: <20211129173637.303201-1-robh@kernel.org>
 <Yf2wTLjmcRj+AbDv@xps13.dannf>
 <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com>
 <CALdTtnuK+D7gNbEDgHbrc29pFFCR3XYAHqrK3=X_hQxUx-Seow@mail.gmail.com>
 <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 10:09:31AM -0600, Rob Herring wrote:
> On Sat, Feb 5, 2022 at 3:13 PM dann frazier <dann.frazier@canonical.com> wrote:
> >
> > On Sat, Feb 5, 2022 at 9:05 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Fri, Feb 4, 2022 at 5:01 PM dann frazier <dann.frazier@canonical.com> wrote:
> > > >
> > > > On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
> > > > > Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> > > > > broke PCI support on XGene. The cause is the IB resources are now sorted
> > > > > in address order instead of being in DT dma-ranges order. The result is
> > > > > which inbound registers are used for each region are swapped. I don't
> > > > > know the details about this h/w, but it appears that IB region 0
> > > > > registers can't handle a size greater than 4GB. In any case, limiting
> > > > > the size for region 0 is enough to get back to the original assignment
> > > > > of dma-ranges to regions.
> > > >
> > > > hey Rob!
> > > >
> > > > I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1) -
> > > > only during network installs - that I also bisected down to commit
> > > > 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I was
> > > > hoping that this patch that fixed the issue on Stéphane's X-Gene2
> > > > system would also fix my issue, but no luck. In fact, it seems to just
> > > > makes it fail differently. Reverting both patches is required to get a
> > > > v5.17-rc kernel to boot.
> > > >
> > > > I've collected the following logs - let me know if anything else would
> > > > be useful.
> > > >
> > > > 1) v5.17-rc2+ (unmodified):
> > > >    http://dannf.org/bugs/m400-no-reverts.log
> > > >    Note that the mlx4 driver fails initialization.
> > > >
> > > > 2) v5.17-rc2+, w/o the commit that fixed Stéphane's system:
> > > >    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
> > > >    Note the mlx4 MSI-X timeout, and later panic.
> > > >
> > > > 3) v5.17-rc2+, w/ both commits reverted (works)
> > > >    http://dannf.org/bugs/m400-both-reverted.log
> > >
> > > The ranges and dma-ranges addresses don't appear to match up with any
> > > upstream dts files. Can you send me the DT?
> >
> > Sure: http://dannf.org/bugs/fdt
> 
> The first fix certainly is a problem. It's going to need something
> besides size to key off of (originally it was dependent on order of
> dma-ranges entries).
> 
> The 2nd issue is the 'dma-ranges' has a second entry that is now ignored:
> 
> dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00>, <0x00
> 0x79000000 0x00 0x79000000 0x00 0x800000>;
> 
> Based on the flags (3rd addr cell: 0x0), we have an inbound config
> space which the kernel now ignores because inbound config space
> accesses make no sense. But clearly some setup is needed. Upstream, in
> contrast, sets up a memory range that includes this region, so the
> setup does happen:
> 
> <0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>
> 
> Minimally, I suspect it will work if you change dma-ranges 2nd entry to:
> 
> <0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>

Thanks for looking into this Rob. I tried to test that theory, but it
didn't seem to work. This is what I tried:

--- m400.dts	2022-02-07 20:16:44.840475323 +0000
+++ m400.dts.dmaonly	2022-02-08 00:17:54.097132000 +0000
@@ -446,7 +446,7 @@
 			reg = <0x00 0x1f2b0000 0x00 0x10000 0xe0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
 			reg-names = "csr\0cfg\0msi_gen\0msi_term";
 			ranges = <0x1000000 0x00 0x00 0xe0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xe1 0x30000000 0x00 0x80000000>;
-			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
+			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
 			interrupts = <0x00 0x10 0x04>;
@@ -471,7 +471,7 @@
 			reg = <0x00 0x1f2c0000 0x00 0x10000 0xd0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
 			reg-names = "csr\0cfg\0msi_gen\0msi_term";
 			ranges = <0x1000000 0x00 0x00 0xd0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xd1 0x30000000 0x00 0x80000000>;
-			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
+			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
 			interrupts = <0x00 0x10 0x04>;
@@ -496,7 +496,7 @@
 			reg = <0x00 0x1f2d0000 0x00 0x10000 0x90 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
 			reg-names = "csr\0cfg\0msi_gen\0msi_term";
 			ranges = <0x1000000 0x00 0x00 0x90 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0x91 0x30000000 0x00 0x80000000>;
-			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
+			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
 			interrupts = <0x00 0x10 0x04>;
@@ -522,7 +522,7 @@
 			reg = <0x00 0x1f500000 0x00 0x10000 0xa0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
 			reg-names = "csr\0cfg\0msi_gen\0msi_term";
 			ranges = <0x2000000 0x00 0x30000000 0xa1 0x30000000 0x00 0x80000000>;
-			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
+			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
 			interrupts = <0x00 0x10 0x04>;
@@ -547,7 +547,7 @@
 			reg = <0x00 0x1f510000 0x00 0x10000 0xc0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
 			reg-names = "csr\0cfg\0msi_gen\0msi_term";
 			ranges = <0x1000000 0x00 0x00 0xc0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xc1 0x30000000 0x00 0x80000000>;
-			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
+			dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
 			ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
 			interrupts = <0x00 0x10 0x04>;

And that failed to boot with a 5.17-rc3. Since dma-ranges was
previously identical to ib-ranges, I also tried making the same change
to ib-ranges, but with no success.

> While we shouldn't break existing DTs, the moonshot DT doesn't use
> what's documented upstream. There are multiple differences compared to
> what's documented. Is upstream supposed to support upstream DTs,
> downstream DTs, and ACPI for XGene which is an abandoned platform with
> only a handful of users?

That's a fair question, though it's one of a policy, and I feel I'd be
overstepping by weighing in. I suppose one option I have is to try
and create and upstream a dts for these systems and modify our
boot.scr to always load that over the one provided by firmware. While
we do have some of these systems in production, they are being retired
and replaced with newer kit over time, and it's possible we'll never
need to upgrade them to a modern kernel.

  -dann
