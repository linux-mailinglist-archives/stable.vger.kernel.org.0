Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5D372B26
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhEDNhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 09:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhEDNhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 09:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4BB610A7;
        Tue,  4 May 2021 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620135376;
        bh=6JVwzPg7Oh4/skKECJNiwc8FB23jmHUMJ1vrH05yaPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJC3NJ939nqRxSSESJC58P8aRkXCXThLstAde+3MjRtMdMFutORkdqmnGTS7buRIj
         zS1//awCr3kLDkdZOeNPxY8G7kfLl2MKIafoMl7+tIQlmRRnDjVpptXNQXG7r9fo9t
         bvSPNdNB2aHYPbEuXrvU0t074e6dkqOtgjmys3to=
Date:   Tue, 4 May 2021 15:36:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YJFNyOGrF8RcTTlc@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org>
 <20210430141910.521897363@linuxfoundation.org>
 <608CFF6A.4BC054A3@users.sourceforge.net>
 <YI6HFNNvzuHnv5VU@kroah.com>
 <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com>
 <YJD2uTdQonXymbn6@kroah.com>
 <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 01:05:56PM +0000, Jari Ruusu wrote:
> On Tuesday, May 4, 2021 10:24 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > All now queued up, thanks.
> 
> For 5.4 and 4.19 and 4.14 kernels there were 2 patches,
> first patch is upstream commit 2800aadc18a64c96b051bcb7da8a7df7d505db3f,

That one is queued up, thanks.

> second patch is upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e.

This is not in any newer stable trees, and it was not obvious what you
were doing here at all.

> First patch modifies iwlwifi/pcie/tx.c  (older models use this)
> Second patch modifies iwlwifi/pcie/tx-gen2.c  (for newer models)
> 
> I see you queued only the "tx.c" patches, not the "tx-gen2.c" ones.

That is because it is not in 5.12.y yet either, right?

If it needs to be there, please let us know.  Having a subject line that
said "5.10" for all of these was impossible to determine...

So, for e7020bb068d8 ("iwlwifi: Fix softirq/hardirq disabling in
iwl_pcie_gen2_enqueue_hcmd()") what tree(s) do you need it in exactly?

thanks,

greg k-h
