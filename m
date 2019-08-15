Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF48E724
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 10:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbfHOInB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 04:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfHOInB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 04:43:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0DB21851;
        Thu, 15 Aug 2019 08:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565858580;
        bh=pJwpa8mKrVWkESrU8b/NRnPjZaPR3H+xGYTBqR8Br40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tZL1bmoXJb7uNmpC9G4eonU+ukLeycvvdzdSVfYFtwwCzb5I9Q7qBQGyPWM1af7bc
         Y4onMl9sZLyvqglvmgVcEWohUsoudt12T4vWDCs0UjdOP04syE8fhBlMGm80EFridT
         ZwvErTxSbDdKHFw7AhGXRGdQgzHiERA6La/CJn0I=
Date:   Thu, 15 Aug 2019 10:42:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ALSA: hda - change the pintbl to undef tbl for Dell
 with alc289
Message-ID: <20190815084258.GB3512@kroah.com>
References: <20190815083001.3793-1-hui.wang@canonical.com>
 <20190815083001.3793-2-hui.wang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815083001.3793-2-hui.wang@canonical.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 04:30:01PM +0800, Hui Wang wrote:
> We have another Dell laptop which needs the DELL4_MIC_NO_PRESENCE,
> and this laptop has different pincfg definitions from existing
> ones in the pintbl, rather adding a new entry, let us change
> the exiting tbl to undef tbl. It will cover all Dell laptops
> with alc289 codec and the pins of 0x19 and 0x1b are undef by default.
> 
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>  sound/pci/hda/patch_realtek.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
