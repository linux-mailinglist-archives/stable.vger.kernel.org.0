Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B22A3FD3BC
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 08:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242294AbhIAGVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 02:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235134AbhIAGVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 02:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D731261008;
        Wed,  1 Sep 2021 06:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630477246;
        bh=kWmHyLU4qcGSCR98vcoNHWELOYWCLOSiJC4NPfJ7Guo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chvT+lRi+fLxFwvNqJvU1tWSHo4/yXfln0BHzifayJg4GzJbogSeQaYh5gfY4LHWl
         7HjJUOT2wNHGd2/mqBLE+1P7zefI/ed9+IJyqizP/I3nJFkLDrk2UpWO3RmABfGJHQ
         jjRAixmHVBKP5kVrZ3S/IttsSQ8WoTGV97DEDD0U=
Date:   Wed, 1 Sep 2021 08:20:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Linux kernel 4.19 and below misses the patch - "fbmem: add
 margin check to fb_check_caps()"
Message-ID: <YS8bvAc4XbaxSssu@kroah.com>
References: <CAD-N9QUhebBrJ1fZG-i09PSKjC9Vat3Ym5VHoOrXGAO_tKQdpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QUhebBrJ1fZG-i09PSKjC9Vat3Ym5VHoOrXGAO_tKQdpQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 31, 2021 at 02:47:22PM +0800, Dongliang Mu wrote:
> Hi stable maintainers,
> 
> It seems that Linux kernel 4.19 and below miss the patch - "fbmem: add
> margin check to fb_check_caps()" [1]. Linux kernel 5.4 and up is
> already merged this patch[2].
> 
> Are there any special issues about this patch? Why do maintainers miss
> such a patch?

Because it does not apply to those older kernels.  If you feel it should
be included there, can you please provide a working backport of the
patch so that we can apply it?

thanks,

greg k-h
