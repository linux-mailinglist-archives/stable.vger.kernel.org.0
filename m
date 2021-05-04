Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF89372D10
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 17:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhEDPgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 11:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhEDPga (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 11:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D266117A;
        Tue,  4 May 2021 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620142535;
        bh=hhfKkwz5Ywn4nN/RmEd1cPVeO9AW02H04RPdfoM57uY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0/xyyesqv6C9gOA93UpLqGbAsNfCWiH+EhgRVB0Uj5rZZUcWWfguasiIMFrau5Xr
         uoYoDmendc/zySgD5d0o/a/ztubIm52QVyLPrCtohLpL/394YLQt9iqlwg4F4pF2SP
         WsrEl0hVSUOiBrBwEzhRC4ViBULbytil2QCYKenM=
Date:   Tue, 4 May 2021 17:35:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YJFpxY6iFHMiPHFE@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org>
 <20210430141910.521897363@linuxfoundation.org>
 <608CFF6A.4BC054A3@users.sourceforge.net>
 <YI6HFNNvzuHnv5VU@kroah.com>
 <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com>
 <YJD2uTdQonXymbn6@kroah.com>
 <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com>
 <YJFNyOGrF8RcTTlc@kroah.com>
 <g5YP678olZEf3yQNX2ptK3X6DceFoemqwzEgSJclx_dHFAJfbJBWznYtB74u5g69Onx_6QZkLF-K2muYLa3qsotkPpxbHYuz4Hrs94olZ7c=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g5YP678olZEf3yQNX2ptK3X6DceFoemqwzEgSJclx_dHFAJfbJBWznYtB74u5g69Onx_6QZkLF-K2muYLa3qsotkPpxbHYuz4Hrs94olZ7c=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 02:22:51PM +0000, Jari Ruusu wrote:
> On Tuesday, May 4, 2021 4:36 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Tue, May 04, 2021 at 01:05:56PM +0000, Jari Ruusu wrote:
> > > second patch is upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e.
> >
> > This is not in any newer stable trees, and it was not obvious what you
> > were doing here at all.
> 
> That patch is in 5.10 + 5.11 + 5.12
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=2a442f11407ec9c9bc9b84d7155484f2b60d01f9
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.11.y&id=a9315228c1d4b1ced803761e81ef761d97f3e2fa
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.12.y&id=f935c64a0c87d86730efd6e1e168555460234d04

{sigh}

It's been a long week, I forgot to update my database of what commit is
in what stable release, my fault.

Can you resend your backports here now, and properly let us know what
kernel they belong into (again, the subject line is very confusing.)

thanks,

greg k-h
