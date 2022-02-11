Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B854B1C13
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 03:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347203AbiBKCQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 21:16:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245077AbiBKCQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 21:16:28 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178535FB0
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 18:16:27 -0800 (PST)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 691C93F1DD
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 02:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644545785;
        bh=wr917FetGRB+Dwa6hoOdwfA0a1yOjjIVMUk1tc6Vh2Q=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=C8/cVa5w9SVikw9Nfn7+usJuXxuapWzJXddW5iUi/iRHCTYLsytwXFoMUrLYI242b
         6O2n6niaIhXOIEbm8TRMIYR5NhT8i2V3vc97prsKTb0lcbiWsdpd6U1qxaquy8poY9
         Oy2SMVsz4PHrr1aWlP/yWmxWegwbBsy18wCpLOCN66lKNKFdpBJpnW+9pAjqWZ7uVX
         IY2yGu77lnEwrpL6m4+LZslAKG5l/4+T51y6kDiQg+jBBJ1+PW9MOVHCWc4SFsJtKr
         bkBRVgGw+Q1JXN+EYg4uU2q72rXK7DWvEA1U4sYf8RKNW/97BwiU9b4JmJvjlpIpAU
         oyN7jhBKrB65g==
Received: by mail-io1-f72.google.com with SMTP id s13-20020a056602168d00b00639a3edcae8so1517306iow.15
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 18:16:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wr917FetGRB+Dwa6hoOdwfA0a1yOjjIVMUk1tc6Vh2Q=;
        b=sTZk159hS7Mps6MUxWKOKjoq5eAa3IEEuxSjsCf1T1vfLjLf9QUrhYje6Z+w+BpQf4
         XtUkuWIZDD+iXwdF+IusglfFl6J9gyr1MLyKkCijaMbz0niqq1e2nAxO+NfhVgFX7rcO
         yvJBy86qnk3rgzbzsx2qklxqbUnBKEKgdQdEJZKB2hXOKwHR6uc68VYUBfsty0yNUErX
         /YsnRSalwXpJlm66EbqRrTcj2EDoy6gnVufUCPcIFCA2zahE/3c6BoSkoXp3biJYKNm6
         ZR7K+uIaJq1cTQr+bcssqmb8h26AyKyt1WmwhUmcNSmpujmkpUP+cIfnVTgyGqnIK6YP
         hE+w==
X-Gm-Message-State: AOAM531kP4EvMLI73mUWw/HtA+CYS2srvQJeKuBn945Z13XaUBuxZVf9
        3F67AwiXhyuxTp+GpsmGJ/9QoxRvjUUc/Jyy2YdEgvC5sWGHm0QS97WIjCrt5T6dZBiZdKjXqbM
        1OWTmS9NxESTDY2fdca9thbM0oorI5iavOQ==
X-Received: by 2002:a02:c8c8:: with SMTP id q8mr5221360jao.243.1644545783560;
        Thu, 10 Feb 2022 18:16:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMHhPZZCj8/aMYnFzDF+/epemaAS8yzBkanyfCuHI/zd+71O1cwnboJ+jJrLUY3cVTfwXTzA==
X-Received: by 2002:a02:c8c8:: with SMTP id q8mr5221351jao.243.1644545783301;
        Thu, 10 Feb 2022 18:16:23 -0800 (PST)
Received: from xps13.dannf (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id d2sm4867105iog.42.2022.02.10.18.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 18:16:22 -0800 (PST)
Date:   Thu, 10 Feb 2022 19:16:19 -0700
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
Message-ID: <YgXG838iMrS1l8SC@xps13.dannf>
References: <20211129173637.303201-1-robh@kernel.org>
 <Yf2wTLjmcRj+AbDv@xps13.dannf>
 <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com>
 <CALdTtnuK+D7gNbEDgHbrc29pFFCR3XYAHqrK3=X_hQxUx-Seow@mail.gmail.com>
 <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com>
 <YgHFFIRT6E0j9TlX@xps13.dannf>
 <CAL_JsqJLTkDm_ZbFWSKwKvVAh0KpxiS9y6LEwmhQ-kejTcLq7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJLTkDm_ZbFWSKwKvVAh0KpxiS9y6LEwmhQ-kejTcLq7A@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 08:34:45AM -0600, Rob Herring wrote:
> On Mon, Feb 7, 2022 at 7:19 PM dann frazier <dann.frazier@canonical.com> wrote:
> >
> > On Mon, Feb 07, 2022 at 10:09:31AM -0600, Rob Herring wrote:
> > > On Sat, Feb 5, 2022 at 3:13 PM dann frazier <dann.frazier@canonical.com> wrote:
> > > >
> > > > On Sat, Feb 5, 2022 at 9:05 AM Rob Herring <robh@kernel.org> wrote:
> > > > >
> > > > > On Fri, Feb 4, 2022 at 5:01 PM dann frazier <dann.frazier@canonical.com> wrote:
> > > > > >
> > > > > > On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
> > > > > > > Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> > > > > > > broke PCI support on XGene. The cause is the IB resources are now sorted
> > > > > > > in address order instead of being in DT dma-ranges order. The result is
> > > > > > > which inbound registers are used for each region are swapped. I don't
> > > > > > > know the details about this h/w, but it appears that IB region 0
> > > > > > > registers can't handle a size greater than 4GB. In any case, limiting
> > > > > > > the size for region 0 is enough to get back to the original assignment
> > > > > > > of dma-ranges to regions.
> > > > > >
> > > > > > hey Rob!
> > > > > >
> > > > > > I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1) -
> > > > > > only during network installs - that I also bisected down to commit
> > > > > > 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I was
> > > > > > hoping that this patch that fixed the issue on Stéphane's X-Gene2
> > > > > > system would also fix my issue, but no luck. In fact, it seems to just
> > > > > > makes it fail differently. Reverting both patches is required to get a
> > > > > > v5.17-rc kernel to boot.
> > > > > >
> > > > > > I've collected the following logs - let me know if anything else would
> > > > > > be useful.
> > > > > >
> > > > > > 1) v5.17-rc2+ (unmodified):
> > > > > >    http://dannf.org/bugs/m400-no-reverts.log
> > > > > >    Note that the mlx4 driver fails initialization.
> > > > > >
> > > > > > 2) v5.17-rc2+, w/o the commit that fixed Stéphane's system:
> > > > > >    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
> > > > > >    Note the mlx4 MSI-X timeout, and later panic.
> > > > > >
> > > > > > 3) v5.17-rc2+, w/ both commits reverted (works)
> > > > > >    http://dannf.org/bugs/m400-both-reverted.log
> > > > >
> > > > > The ranges and dma-ranges addresses don't appear to match up with any
> > > > > upstream dts files. Can you send me the DT?
> > > >
> > > > Sure: http://dannf.org/bugs/fdt
> > >
> > > The first fix certainly is a problem. It's going to need something
> > > besides size to key off of (originally it was dependent on order of
> > > dma-ranges entries).
> > >
> > > The 2nd issue is the 'dma-ranges' has a second entry that is now ignored:
> > >
> > > dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00>, <0x00
> > > 0x79000000 0x00 0x79000000 0x00 0x800000>;
> > >
> > > Based on the flags (3rd addr cell: 0x0), we have an inbound config
> > > space which the kernel now ignores because inbound config space
> > > accesses make no sense. But clearly some setup is needed. Upstream, in
> > > contrast, sets up a memory range that includes this region, so the
> > > setup does happen:
> > >
> > > <0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>
> > >
> > > Minimally, I suspect it will work if you change dma-ranges 2nd entry to:
> > >
> > > <0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>
> >
> > Thanks for looking into this Rob. I tried to test that theory, but it
> > didn't seem to work. This is what I tried:
> >
> > --- m400.dts    2022-02-07 20:16:44.840475323 +0000
> > +++ m400.dts.dmaonly    2022-02-08 00:17:54.097132000 +0000
> > @@ -446,7 +446,7 @@
> >                         reg = <0x00 0x1f2b0000 0x00 0x10000 0xe0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
> >                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
> >                         ranges = <0x1000000 0x00 0x00 0xe0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xe1 0x30000000 0x00 0x80000000>;
> > -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> > +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
> >                         interrupts = <0x00 0x10 0x04>;
> > @@ -471,7 +471,7 @@
> >                         reg = <0x00 0x1f2c0000 0x00 0x10000 0xd0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
> >                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
> >                         ranges = <0x1000000 0x00 0x00 0xd0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xd1 0x30000000 0x00 0x80000000>;
> > -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> > +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
> >                         interrupts = <0x00 0x10 0x04>;
> > @@ -496,7 +496,7 @@
> >                         reg = <0x00 0x1f2d0000 0x00 0x10000 0x90 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
> >                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
> >                         ranges = <0x1000000 0x00 0x00 0x90 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0x91 0x30000000 0x00 0x80000000>;
> > -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> > +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
> >                         interrupts = <0x00 0x10 0x04>;
> > @@ -522,7 +522,7 @@
> >                         reg = <0x00 0x1f500000 0x00 0x10000 0xa0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
> >                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
> >                         ranges = <0x2000000 0x00 0x30000000 0xa1 0x30000000 0x00 0x80000000>;
> > -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> > +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
> >                         interrupts = <0x00 0x10 0x04>;
> > @@ -547,7 +547,7 @@
> >                         reg = <0x00 0x1f510000 0x00 0x10000 0xc0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
> >                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
> >                         ranges = <0x1000000 0x00 0x00 0xc0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xc1 0x30000000 0x00 0x80000000>;
> > -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> > +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
> >                         interrupts = <0x00 0x10 0x04>;
> >
> > And that failed to boot with a 5.17-rc3. Since dma-ranges was
> > previously identical to ib-ranges, I also tried making the same change
> > to ib-ranges, but with no success.
> 
> Failed to boot at all or just PCIe still didn't work causing boot to
> eventually fail?

Sorry, I mean PCIe still didn't work, here's the log:
 http://dannf.org/bugs/m400-tweaked_dtb.log
(unmodified kernel source w/ above dtb change)

> 'ib-ranges' is unknown to the kernel, so the firmware
> is using it somehow?
> 
> You also need to revert the first fix for PCIe to work.

Oh, OK. I misunderstood. I tried reverting commit 6dce5aa59e0b "PCI:
xgene: Use inbound resources for setup" along with a dtb with the
dma-ranges change in the diff above, but PCIe still didn't
work. Here's the log:

http://dannf.org/bugs/m400-6dce5aa5_reverted+tweaked_dtb.log

  -dann
  
> 
> > > While we shouldn't break existing DTs, the moonshot DT doesn't use
> > > what's documented upstream. There are multiple differences compared to
> > > what's documented. Is upstream supposed to support upstream DTs,
> > > downstream DTs, and ACPI for XGene which is an abandoned platform with
> > > only a handful of users?
> >
> > That's a fair question, though it's one of a policy, and I feel I'd be
> > overstepping by weighing in. I suppose one option I have is to try
> > and create and upstream a dts for these systems and modify our
> > boot.scr to always load that over the one provided by firmware. While
> > we do have some of these systems in production, they are being retired
> > and replaced with newer kit over time, and it's possible we'll never
> > need to upgrade them to a modern kernel.
> >
> >   -dann
