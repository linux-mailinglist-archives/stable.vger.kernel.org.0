Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E5812DFD2
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 18:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgAAR4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 12:56:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50738 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727237AbgAAR4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 12:56:36 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1imiEU-0002Hj-AR; Wed, 01 Jan 2020 19:56:35 +0200
Message-ID: <a34fa1b91f33eacc31d3e4e4782e3b62c0d89992.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Wed, 01 Jan 2020 19:56:32 +0200
In-Reply-To: <20200101170206.GC2712976@kroah.com>
References: <20191223125612.1475700-1-luca@coelho.fi>
         <20200101170206.GC2712976@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [PATCH v5.4] Revert "iwlwifi: assign directly to iwl_trans->cfg
 in QuZ detection"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-01-01 at 18:02 +0100, Greg KH wrote:
> On Mon, Dec 23, 2019 at 02:56:12PM +0200, Luca Coelho wrote:
> > From: Anders Kaseorg <andersk@mit.edu>
> > 
> > This reverts commit 968dcfb4905245dc64d65312c0d17692fa087b99.
> > 
> > Both that commit and commit 809805a820c6445f7a701ded24fdc6bbc841d1e4
> > attempted to fix the same bug (dead assignments to the local variable
> > cfg), but they did so in incompatible ways. When they were both merged,
> > independently of each other, the combination actually caused the bug to
> > reappear, leading to a firmware crash on boot for some cards.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=205719
> > 
> > Signed-off-by: Anders Kaseorg <andersk@mit.edu>
> > Acked-by: Luca Coelho <luciano.coelho@intel.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > ---
> >  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 24 +++++++++----------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> > 
> 
> Next time a hint as to what this git commit id is in Linus's tree would
> be nice :)

Oh, right.  I'm sorry, I completely forgot it...

--
Luca.

