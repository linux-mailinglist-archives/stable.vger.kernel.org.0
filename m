Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4203F11CC20
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 12:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfLLLWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 06:22:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:47564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728857AbfLLLWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 06:22:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2C45AD6C;
        Thu, 12 Dec 2019 11:22:41 +0000 (UTC)
Date:   Thu, 12 Dec 2019 12:22:40 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from "mm/vmalloc: Sync unmappings in
 __purge_vmap_area_lazy()" in stable kernels
Message-ID: <20191212112240.GI4477@suse.de>
References: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
 <20191212111911.GH4477@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212111911.GH4477@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 12:19:11PM +0100, Joerg Roedel wrote:
> Hi,
> 
> On Thu, Dec 12, 2019 at 06:54:12PM +0800, Chen-Yu Tsai wrote:
> > I'd like to report a very severe performance regression due to
> > 
> >     mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy() in stable kernels
> 
> Yes, that is a known problem, with a couple of reports already in the
> past months. And I posted a fix from which I thought it is on its way
> upstream, but apparently its not:
> 
> 	https://lore.kernel.org/lkml/20191009124418.8286-1-joro@8bytes.org/

Ah, I missed that it is in linux-next already. Sorry for the noise.


	Joerg
