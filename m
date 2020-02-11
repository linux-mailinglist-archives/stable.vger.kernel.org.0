Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF00C158A01
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 07:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgBKGVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 01:21:55 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:33669 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgBKGVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 01:21:55 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Ludovic.Desroches@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Ludovic.Desroches@microchip.com";
  x-sender="Ludovic.Desroches@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Ludovic.Desroches@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Ludovic.Desroches@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: wG36oiB/OxVFObksGXivIw08QOwDsF+gJPYSS/Cu06WeeOcAXoMazAd+BR9zIfhGhUhJFzckMN
 Hvi55kE9PAYirPEZ2nXcr1M/PNBxSSyBXp6a877Yj2T03HcjPHsFWqm9dxYEBNj2QXYXKQ5qeE
 XOHvCdNa8VeuzLC4AEblqRO1bFdyueweVtTsji7+maStfsjOdETsQQWpbhpPARVd+0J3WIEHA/
 lNmuPeddyCFgjw9l/geZHrbhhXHl15Gsda18PlK+CGkhz9Bd1zcL5H22n8e0EQXLMQG8vKB1Y6
 BkQ=
X-IronPort-AV: E=Sophos;i="5.70,427,1574146800"; 
   d="scan'208";a="67997978"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2020 23:21:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Feb 2020 23:21:53 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 10 Feb 2020 23:21:51 -0700
Date:   Tue, 11 Feb 2020 07:21:20 +0100
From:   Ludovic Desroches <ludovic.desroches@microchip.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <mirq-linux@rere.qmqm.pl>,
        <adrian.hunter@intel.com>, <stable@vger.kernel.org>,
        <ulf.hansson@linaro.org>
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci-of-at91: fix memleak on
 clk_get failure" failed to apply to 5.5-stable tree
Message-ID: <20200211062120.nbjph2nsfknzbuld@M43218.corp.atmel.com>
References: <1581016127158142@kroah.com>
 <20200207010950.GQ31482@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200207010950.GQ31482@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 08:09:50PM -0500, Sasha Levin wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Thu, Feb 06, 2020 at 08:08:47PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.5-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From a04184ce777b46e92c2b3c93c6dcb2754cb005e1 Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
> > Date: Thu, 2 Jan 2020 11:42:16 +0100
> > Subject: [PATCH] mmc: sdhci-of-at91: fix memleak on clk_get failure
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > sdhci_alloc_host() does its work not using managed infrastructure, so
> > needs explicit free on error path. Add it where needed.
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: bb5f8ea4d514 ("mmc: sdhci-of-at91: introduce driver for the Atmel SDMMC")
> > Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> > Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
> > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> > Link: https://lore.kernel.org/r/b2a44d5be2e06ff075f32477e466598bb0f07b36.1577961679.git.mirq-linux@rere.qmqm.pl
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> We're missing 3976656d67c1 ("mmc: sdhci-of-at91: rework clocks
> management to support SAM9x60 device") on older kernels. I've fixed it
> up and queued for 5.5-4.14. I don't think it applies to older kernels,
> but happy to be proven otherwise.

Thanks Sasha for taking care of this.

Regards

Ludovic

> 
> --
> Thanks,
> Sasha
