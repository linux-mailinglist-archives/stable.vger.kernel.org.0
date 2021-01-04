Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B929B2E9926
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbhADPth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727407AbhADPth (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E11020735;
        Mon,  4 Jan 2021 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609775336;
        bh=2UPFSSz01mtLFHkWSgmkhwscDXomVQpB0Wr7wPaP8JQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ttuFyWwnxa+CcJ6bXXG+xlt/jc0S7SfkftB4QHj10I+JSFjV0zwYxtc/PelfeYQUM
         HcCG/87RGbkI17QjoNE26eg5osSJr+gesl5LMdlbBmGUum3tCEWm8LHtR+iHndEiyW
         8aSyGq0De/vwh17dW0LRwUZJfSydeBaK5m44gXDsyrl0tVeP3vIXcgDtW3yYCiNEDX
         JnX3eRydr62yxls8uBtjzOo8zP1GAe27cgPqVwVD9N+PbU/wrV/yjLuLjioOCRuHg6
         g5rK0kJz7VNUiW3P3FVwLmdS4sRfpN5K9yDdCbA4xxgt6UOHjlBmXV2gI7aH9yGqIV
         fZUfZ5aFroVHQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwS6H-0002Z5-Qa; Mon, 04 Jan 2021 16:48:53 +0100
Date:   Mon, 4 Jan 2021 16:48:53 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Michael Sweet <msweet@msweet.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: usblp: fix DMA to stack
Message-ID: <X/M45d6Cc3cEurQt@hovoldconsulting.com>
References: <20210104145302.2087-1-johan@kernel.org>
 <X/MtNtTd96S39HQL@kroah.com>
 <X/MwBCt0Z/B1D7vw@hovoldconsulting.com>
 <15AB8EFA-A534-40D8-95D2-7DCE1E46D431@msweet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15AB8EFA-A534-40D8-95D2-7DCE1E46D431@msweet.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 10:33:34AM -0500, Michael Sweet wrote:
> Johan/Greg,
> 
> Since CUPS uses libusb to communicate with printers these days (well,
> for over a decade now) so that printing and scanning can coexist, the
> usblp driver really doesn't get any usage anymore.

Ah, ok. I still seem to be using usblp.ko for my printer with CUPS,
though.

Johan
