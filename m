Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE871B30B7
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDUTyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:54:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:48553 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDUTyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:54:06 -0400
IronPort-SDR: sRFZdjmZfWE7GSX/iJccG5wnFLZ7P7RogLTw2PqqGmD5QJRmfs09PcS0NBvv9u65R8zfnCZULW
 /+A0MGGDAdUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 12:54:06 -0700
IronPort-SDR: u0PucUAwlTW5D/vEtBMVccgXiyEn4WGQVAczLuFaWatEh/EbMdaAfn9ZmlhHEG39aYysNO3bSz
 gxfIScmQTOqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="247264606"
Received: from mnchalux-mobl2.gar.corp.intel.com (HELO localhost) ([10.252.44.234])
  by fmsmga008.fm.intel.com with ESMTP; 21 Apr 2020 12:54:04 -0700
Date:   Tue, 21 Apr 2020 22:54:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tpm/tpm_tis: Free IRQ if probing fails
Message-ID: <20200421195403.GA46589@linux.intel.com>
References: <20200416160751.180791-1-jarkko.sakkinen@linux.intel.com>
 <fa25cd78-2535-d26d-dd66-d64111af857a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa25cd78-2535-d26d-dd66-d64111af857a@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 03:23:19PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 4/16/20 6:07 PM, Jarkko Sakkinen wrote:
> > Call disable_interrupts() if we have to revert to polling in order not to
> > unnecessarily reserve the IRQ for the life-cycle of the driver.
> > 
> > Cc: stable@vger.kernel.org # 4.5.x
> > Reported-by: Hans de Goede <hdegoede@redhat.com>
> > Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> I can confirm that this fixes the "irq 31 nobody cared" oops for me:
> 
> Tested-by: Hans de Goede <hdegoede@redhat.com>

Hi, thanks a lot! Unfortunately I already put this out given the
criticality of the issue:

https://lkml.org/lkml/2020/4/20/1544

Sincere apologies that I couldn't include your tested-by but the most
important thing is to know that it works now.

/Jarkko
