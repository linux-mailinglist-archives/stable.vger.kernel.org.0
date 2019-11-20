Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44815104407
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 20:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfKTTNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 14:13:43 -0500
Received: from mail.skyhub.de ([5.9.137.197]:47964 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfKTTNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 14:13:42 -0500
Received: from zn.tnic (p200300EC2F0D8C00D00A088CD62A4138.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:8c00:d00a:88c:d62a:4138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 559DB1EC0CDA;
        Wed, 20 Nov 2019 20:13:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1574277221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/AxTd+hI1/m+Mguaj9eemCOOVuJm3T7njzhcce+3yJw=;
        b=ihhGNqkdiN60Bi+up1FMbk4U9I89ExIIZrEXnQTYO+LhVrCZl0miX6WtLGbk83ay8JdtdN
        Ksx/+v6NdKmtDEwq/+/ohGWeEImBXaniD7aBjiQV+Nycwx4J7M9KzVOHNDRfhsdgjK5ijy
        VUgLXNecj54OLj9s26VibTshkMkd18k=
Date:   Wed, 20 Nov 2019 20:13:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Thor Thayer <thor.thayer@linux.intel.com>
Cc:     stable@vger.kernel.org, mchehab@kernel.org, tony.luck@intel.com,
        james.morse@arm.com, rrichter@marvell.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Li <Meng.Li@windriver.com>
Subject: Re: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs
Message-ID: <20191120191335.GL2634@zn.tnic>
References: <1574271481-9310-1-git-send-email-thor.thayer@linux.intel.com>
 <20191120180733.GJ2634@zn.tnic>
 <5bfe9cc4-6cd4-7edb-9ed2-abe5fadff06d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5bfe9cc4-6cd4-7edb-9ed2-abe5fadff06d@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 12:52:18PM -0600, Thor Thayer wrote:
> This patch should to be applied to the stable branches to fix the issue in
> older branches.

Do stable folks pick up stable fixes which are not upstream?

AFAIK, a patch needs to be upstream to be backported to stable first.

> Although I knew the To: had to be to stable@vger.kernel.org,
> I wasn't sure how that worked with the EDAC reviewers. This was a weird
> situation where I couldn't fix the upstream because it had already been
> fixed a different way.

Yah.

> Meng sent me the notification and the patch with a SOB so I put Meng first
> in the order.

If he sent you the patch, then he's the author and you need to keep his

From: Meng Li <Meng.Li@windriver.com>

at the beginning of the file so that git preserves his authorship.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
