Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8073DD478
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 13:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhHBLHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 07:07:24 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:57096 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhHBLHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 07:07:22 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 07:07:21 EDT
Received: from tarshish (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id D557044062B;
        Mon,  2 Aug 2021 13:59:41 +0300 (IDT)
User-agent: mu4e 1.4.15; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     stable@vger.kernel.org
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        "Oli Z." <olze@trustserv.de>
Subject: Backport "PCI: mvebu: Setup BAR0 in order to fix MSI" to v5.4.x
Date:   Mon, 02 Aug 2021 13:59:58 +0300
Message-ID: <8735rsyuvl.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi -stable kernel team,

Commit 216f8e95aacc8e ("PCI: mvebu: Setup BAR0 in order to fix MSI")
fixes ath10k_pci devices on Armada 385 systems, and probably also others
using similar PCI hosts. Can you consider applying it to v5.4.x? The
commit should apply cleanly to current v5.4.

Technically this bug is not a regression. MSI only worked with vendor
provided U-Boot. So I'm not sure it is eligible for -stable. But still,
this bug bites users of latest OpenWrt release that is based on kernel
v5.4. Oli (on Cc) verified that this commit fixes the issue on OpenWrt
with kernel v5.4.

I put PCI/mvebu maintainers to Cc so they can provide their input.

Thanks,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
