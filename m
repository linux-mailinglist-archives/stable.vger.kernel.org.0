Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F505372EC9
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhEDRTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232392AbhEDRTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 13:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C8BB613B4;
        Tue,  4 May 2021 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620148710;
        bh=0/P7iJ9M3Dtw7zwFLApPq3sdtKoK5yS4Yt93EBxLsT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QHy/tDbIhlVp1UGPr5rDyjgNtrNhV4pBpw4akdJZ2R/4A8gQyRTREEKaDY5c0aBaQ
         r4tyY8F4W3vSky/t28i0dWhHS5h1f7bJMedwc1OIEYmGyKlc2VMOood5JndhnHtWTd
         E7312+6hdWlybOY3vxrJtJ20iXhot5Tt40NnVlno=
Date:   Tue, 4 May 2021 19:18:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YJGB468r3LPWnRIv@kroah.com>
References: <20210430141910.521897363@linuxfoundation.org>
 <608CFF6A.4BC054A3@users.sourceforge.net>
 <YI6HFNNvzuHnv5VU@kroah.com>
 <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com>
 <YJD2uTdQonXymbn6@kroah.com>
 <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com>
 <YJFNyOGrF8RcTTlc@kroah.com>
 <g5YP678olZEf3yQNX2ptK3X6DceFoemqwzEgSJclx_dHFAJfbJBWznYtB74u5g69Onx_6QZkLF-K2muYLa3qsotkPpxbHYuz4Hrs94olZ7c=@protonmail.com>
 <YJFpxY6iFHMiPHFE@kroah.com>
 <lKQ4w6tXpon1sVWKDLQXCcZLzvchbrKBCQPO83v1wu9e-Ewul20hGjbfcOX1GeqFYhQGWpBV7GiyPM13lnU0BE3A9D11OEYt-_g_HwcCyQI=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lKQ4w6tXpon1sVWKDLQXCcZLzvchbrKBCQPO83v1wu9e-Ewul20hGjbfcOX1GeqFYhQGWpBV7GiyPM13lnU0BE3A9D11OEYt-_g_HwcCyQI=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 05:02:21PM +0000, Jari Ruusu wrote:
> On Tuesday, May 4, 2021 6:35 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > Can you resend your backports here now, and properly let us know what
> > kernel they belong into (again, the subject line is very confusing.)
> 
> iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
> upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e,
> backport for linux-5.4.y and linux-4.19.y (booted and ping tested)

Why does the subject still say 5.10?

Please fix up both of these and resend.

thanks,

greg k-h
