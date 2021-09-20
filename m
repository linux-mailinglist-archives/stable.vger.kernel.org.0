Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D9A4111D5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 11:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhITJVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 05:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhITJVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 05:21:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57F860ED7;
        Mon, 20 Sep 2021 09:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632129587;
        bh=2a/STmDjJgqpopTJMjtSa5GGYye8kZCFBFWoA6EGIxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DKuiUUmuP/NmQaADk2QoArBR4Irr/lf9IW8kMeS0ULRzG9oNGfMufGUv4NoIN30Yr
         ArogFVQdmT7Y+/2tQCebeiNgR8w5p0uOQxAHVexp9EUhhpxfNv0lJ4Q5ZwlVDYwQQx
         oVIPhnO6riDqtTYrJFVTnGSK3pDdYqRHCnTBxYcQ=
Date:   Mon, 20 Sep 2021 11:19:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michel =?iso-8859-1?Q?D=E4nzer?= <mdaenzer@redhat.com>
Cc:     alexander.deucher@amd.com, lyude@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Drop inline from" failed to
 apply to 5.14-stable tree
Message-ID: <YUhSMcYDsEwvbcQQ@kroah.com>
References: <1632127974199169@kroah.com>
 <d35b1d9f-6cbf-d0d6-bb0e-0e15919eced5@redhat.com>
 <YUhOXI4VFfpvheQo@kroah.com>
 <b925253e-5893-5e13-967b-1ab2121f9c15@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b925253e-5893-5e13-967b-1ab2121f9c15@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 11:11:51AM +0200, Michel Dänzer wrote:
> On 2021-09-20 11:03, Greg KH wrote:
> > On Mon, Sep 20, 2021 at 10:57:34AM +0200, Michel Dänzer wrote:
> > > On 2021-09-20 10:52, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 5.14-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > I wrote a comment above the Fixes line:
> > > 
> > > # The function is called amdgpu_ras_eeprom_get_record_max_length on
> > > # stable branches
> > > 
> > > 
> > > Looks like that got lost somewhere along the way.
> > 
> > Can you send a working patch for these older kernels that I can queue
> > up?
> 
> Actually, it's not critical to have this on the stable branches, let's just
> drop it.

Fine with me, thanks!

greg k-h
