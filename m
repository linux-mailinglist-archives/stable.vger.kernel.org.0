Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B74372687
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 09:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhEDHZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 03:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhEDHZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 03:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA2B1611AD;
        Tue,  4 May 2021 07:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620113084;
        bh=+PhNuSZLMjrB2Xee53utVbBCJ/x1qE6Pvl9ZxiVp2H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cuNtEppOGcBfaMo+M2lkG7CbAwJ6aXrCmkBxzPyng3Xi0vxMrFea3AF0NNpEeVTgR
         0gvdr+kaKfeeqwKX/jz0G7gt98Q/dL9xvPblbFa0ExuzSQ3B42tPMsSTI9/PgWFZuz
         HbdJGxE0jZfjxgohy/IAe4YI7beg7ykj9drkHNmo=
Date:   Tue, 4 May 2021 09:24:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YJD2uTdQonXymbn6@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org>
 <20210430141910.521897363@linuxfoundation.org>
 <608CFF6A.4BC054A3@users.sourceforge.net>
 <YI6HFNNvzuHnv5VU@kroah.com>
 <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 11:27:07AM +0000, Jari Ruusu wrote:
> On Sunday, May 2, 2021 2:03 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > If you could provide backported patches to those kernels you think this
> > is needed to, I can take them directly. Otherwise running sed isn't
> > always the easiest thing to do on my end :)
> 
> iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()
> upstream commit 2800aadc18a64c96b051bcb7da8a7df7d505db3f,
> backport for linux-4.4.y (compile tested only)
> Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>

All now queued up, thanks.

greg k-h
