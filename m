Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE26ACAE0C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 20:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbfJCSTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 14:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387866AbfJCSTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 14:19:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7A32133F;
        Thu,  3 Oct 2019 18:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570126780;
        bh=zbj1ZLtsX6CCQqumum9b70SmuYxgm1ogsv5Y+/BHswM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=okCmgu3Orocz3Ua/9OzDyEvJJK/K8IhGAbKg2fVJmnVQevUujH0Txhx9wQXidF1Bi
         07A3SEGzV8gBCg7zQFMAUqq1PiBGMygO8T01vyqvxkUjZda6t4SF9KLOZg/kh7Vl1u
         bvS9pQKmrIshroie4WhlM0J1fTC+ZhT1jJYIoah4=
Date:   Thu, 3 Oct 2019 20:19:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Libin Yang <libin.yang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.3 039/344] ASoC: SOF: Intel: hda: Make hdac_device
 device-managed
Message-ID: <20191003181937.GC3457141@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191003154543.920067214@linuxfoundation.org>
 <20191003172617.GA6090@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003172617.GA6090@sirena.co.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:17PM +0100, Mark Brown wrote:
> On Thu, Oct 03, 2019 at 05:50:04PM +0200, Greg Kroah-Hartman wrote:
> 
> > 
> > Signed-off-by: Libin Yang <libin.yang@intel.com>
> > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Reviewed-by: Takashi Iwai <tiwai@suse.de>
> > Link: https://lore.kernel.org/r/20190626070450.7229-1-ranjani.sridharan@linux.intel.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> Looks like you're missing your own signoff on this (and quite a few of
> the others)?

Sasha signs off on these, I didn't, as he is the one that queues them
up.

thanks,

greg k-h
