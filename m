Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0420EC13A
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 11:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfKAKWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 06:22:47 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:36062 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729557AbfKAKWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 06:22:47 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 3E6713C0585;
        Fri,  1 Nov 2019 11:22:45 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jn2UY-F7928q; Fri,  1 Nov 2019 11:22:38 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id B343F3C004C;
        Fri,  1 Nov 2019 11:22:38 +0100 (CET)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Fri, 1 Nov 2019
 11:22:38 +0100
Date:   Fri, 1 Nov 2019 11:22:35 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
CC:     <marek.vasut+renesas@gmail.com>, <linux-pci@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <stable@vger.kernel.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH v2 2/2] PCI: rcar: Fix missing MACCTLR register setting
 in initialize sequence
Message-ID: <20191101102018.GA21205@vmlxhi-102.adit-jv.com>
References: <1572589890-8903-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572589890-8903-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1572589890-8903-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.12.1+40 (7f8642d4ee82) (2019-06-28)
X-Originating-IP: [10.72.93.184]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Fri, Nov 01, 2019 at 03:31:30PM +0900, Yoshihiro Shimoda wrote:
> According to the R-Car Gen2/3 manual, "Be sure to write the initial
> value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
> To avoid unexpected behaviors, this patch fixes it. Note that
> the SPCHG bit of MACCTLR register description said "Only writing 1
> is valid and writing 0 is invalid" but this "invalid" means
> "ignored", not "prohibited". So, any documentation conflict doesn't
> exist about writing the MACCTLR register.
> 
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Many thanks!

-- 
Best Regards,
Eugeniu
