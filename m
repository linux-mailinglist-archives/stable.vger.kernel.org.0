Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735383EA578
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 15:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhHLNWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 09:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237613AbhHLNVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 09:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AF7560FC3;
        Thu, 12 Aug 2021 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628774437;
        bh=a2kONITSoUR5cfltGu0NgKRYxMaQ63C0lIBcPlMM3bU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gU+rS22ISUNJbojQkq5Vz804zLT3x6nDw9uMvSl/Eol15Nwo+XLRMu54Nih0hY7GV
         vyzUXOb2J1g+3XxfbmrkZ2xGGjmaPyjVNKWEOXrs5WG5GOGyKpO2zly3mDHoeegbcv
         6Hj/KZsY55g5vSx3GNV54RtNpxOPeGmkMG/m2InQ=
Date:   Thu, 12 Aug 2021 15:20:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc:     stable@vger.kernel.org, yj.chiang@mediatek.com
Subject: Re: Request patch to -stable 4.4+ "media: v4l2-mem2mem: always
 consider OUTPUT queue during poll"
Message-ID: <YRUgI7GFRBfbWoy1@kroah.com>
References: <20210812115822.5411-1-lecopzer.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812115822.5411-1-lecopzer.chen@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 12, 2021 at 07:58:22PM +0800, Lecopzer Chen wrote:
> Hi Greg
> 
> Reason:
> 
> We found without this, Poll() infinitely wait because OUTPUT queue
> will never signaled after last CAPTURE queue is de-queued.
> And some buffer can't be popped as expected.
> 
> 
> commit id: 566463afdbc43c7744c5a1b89250fc808df03833
> subject: "media: v4l2-mem2mem: always consider OUTPUT queue during poll"
> 
> This should be applied to 4.4+ without conflict after 
> (f1a81afc98e315f4bf600d28f8a19a5655f7cfe0 "[media] m2m: fix bad unlock balance")

Applied to 5.4.y, but if you want it to go older, we need backported
versions as it did not apply cleanly.

thanks,

greg k-h
