Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6606A2EC300
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 19:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbhAFSM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 13:12:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAFSMZ (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 6 Jan 2021 13:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08F652312A;
        Wed,  6 Jan 2021 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609956705;
        bh=OqH3pje8jguYxrGNj+XNolDADpBViapTdq3wbu40RVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCjmkGTDfyBFRwDMuf7X4Ej2Hd9KpH/Dqe8JUOnQzfUV5Fxa4Z+qR02vOvoAyzUMM
         hQ6QrnnO7iq2kN4XSk7ga3wZ1qBFRIZS0666H1tdsmMymuu8ZtiNzVJA1VacgPV03V
         0nMUVWkvo4/QNTqp0YH6jiJCegmhL3w8mlym0iZ8=
Date:   Wed, 6 Jan 2021 19:13:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:magnetometer:mag3110: Fix alignment
 and data leak issues." failed to apply to 4.4-stable tree
Message-ID: <X/X9snX68hTOUwnJ@kroah.com>
References: <16091540199679@kroah.com>
 <20210105195901.stnyoeqaytm3pyif@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105195901.stnyoeqaytm3pyif@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 07:59:01PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 12:13:39PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

All now queued up, thanks.

greg k-h
