Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2C10444E
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 20:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfKTT2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 14:28:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbfKTT2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 14:28:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE41D2071F;
        Wed, 20 Nov 2019 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574278093;
        bh=ufThiCpz1aGjCoQiqthrOUy4HlnE81B/da3Ij3o+1Oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsfZH9Pur6ZJA+0dtO+ct46Go5M4ymMlDq2bn47BfKA+6IdHUcTnzsv85c5HRJ9kM
         bknu/wNf5rT87FvVvO92Zwd+dja/O6AHZh9ww24vyqqwDPsq5eLJJUQ7Ao2o+I/2ym
         bohWIJ9KXtEuz1TujE2c9H9mrJfVhFUfsqEF8J0I=
Date:   Wed, 20 Nov 2019 20:28:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>, stable@vger.kernel.org,
        mchehab@kernel.org, tony.luck@intel.com, james.morse@arm.com,
        rrichter@marvell.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Li <Meng.Li@windriver.com>
Subject: Re: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs
Message-ID: <20191120192810.GB3086925@kroah.com>
References: <1574271481-9310-1-git-send-email-thor.thayer@linux.intel.com>
 <20191120180733.GJ2634@zn.tnic>
 <5bfe9cc4-6cd4-7edb-9ed2-abe5fadff06d@linux.intel.com>
 <20191120191335.GL2634@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120191335.GL2634@zn.tnic>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 08:13:35PM +0100, Borislav Petkov wrote:
> On Wed, Nov 20, 2019 at 12:52:18PM -0600, Thor Thayer wrote:
> > This patch should to be applied to the stable branches to fix the issue in
> > older branches.
> 
> Do stable folks pick up stable fixes which are not upstream?

Not at all.

