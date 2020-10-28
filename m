Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D31A29D879
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbgJ1Wcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:32:31 -0400
Received: from verein.lst.de ([213.95.11.211]:45343 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388097AbgJ1Wc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:32:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2A32E68AFE; Wed, 28 Oct 2020 08:12:37 +0100 (CET)
Date:   Wed, 28 Oct 2020 08:12:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 228/264] PM: hibernate: remove the bogus call to
 get_gendisk() in software_resume()
Message-ID: <20201028071236.GA16112@lst.de>
References: <20201027135430.632029009@linuxfoundation.org> <20201027135441.360964081@linuxfoundation.org> <20201028071057.GC8084@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028071057.GC8084@amd>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 08:10:57AM +0100, Pavel Machek wrote:
> This does not fix anything in 4.19, and should not be there.
> 
> It will break resume for people using resumewait option and using
> numeric values, as original changelog explains. Eventually, someone
> will cry regression and we'll have to fix it in the mainline, but no
> need to bring this to -stable, too.

If this code ever gets hit this patch fixes a reference count leak.
