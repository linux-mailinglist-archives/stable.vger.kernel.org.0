Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089613D92C8
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhG1QIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:08:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237554AbhG1QI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 12:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88216600D1;
        Wed, 28 Jul 2021 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627488507;
        bh=j0nwJg0D0B8vmVHrLVKfUCsxjkuuqHrqDiWDRfYG3Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMiVetokF57rI68tr0FLutw+qLxSdj58w4TJFXSiMCgX7MeokKYJ29RFEm6vzk7lC
         CG+hExzcdcyLgbRXgJrxENA5HzyWyBsK7hLyI7oMTKEPuf9x7PHg7ZdQbt68RZZIa1
         njgE6yKmcxvUmYFx0bqB7oChCUkSKperUV40XIBk=
Date:   Wed, 28 Jul 2021 18:08:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 014/167] net: Introduce preferred busy-polling
Message-ID: <YQGA+Aqh7Twuq3Wk@kroah.com>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153839.841834200@linuxfoundation.org>
 <20210728074828.GA28860@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210728074828.GA28860@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 09:48:28AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Björn Töpel <bjorn.topel@intel.com>
> > 
> > [ Upstream commit 7fd3253a7de6a317a0683f83739479fb880bffc8 ]
> > 
> > The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
> > option or system-wide using the /proc/sys/net/core/busy_read knob, is
> > an opportunistic. That means that if the NAPI context is not
> 
> Do we need this in -stable? It is rather long at 400 lines, and
> introduces new API feature, does not fix a bug.

It was needed for a patch that was dropped, so I dropped this too,
thanks.

greg k-h
