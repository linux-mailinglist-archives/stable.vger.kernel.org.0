Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172D914B0AF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgA1IJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgA1IJN (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 28 Jan 2020 03:09:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E773F2467B;
        Tue, 28 Jan 2020 08:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580198953;
        bh=MRtTYerA9uUwvkKuboyA/lXdA3FrLyASNYXklNGTZfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1VeUoquA3Mfj6yj5GFiqPortabPbGNZ6pz+smLu6r0FIpPlKup/P9WHv1zcCjoSE
         4X+RtorSt1JAdZNZ2hN0c5FOhTedCk1ZTsoFiYpqtc4bGp7u+7HqZYCJfyb4DOU4Se
         18eNvGuogWz/9BWw4Od85eqlWF2I/VcmDVlV0OAg=
Date:   Tue, 28 Jan 2020 09:09:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lars =?iso-8859-1?Q?M=F6llendorf?= <lars.moellendorf@plating.de>
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio: buffer: align the size of scan bytes
 to size of the" failed to apply to 4.4-stable tree
Message-ID: <20200128080909.GK2105706@kroah.com>
References: <157944091042104@kroah.com>
 <0af6f6ac-174e-6738-d9f7-4bb77f5f63fa@plating.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0af6f6ac-174e-6738-d9f7-4bb77f5f63fa@plating.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 11:16:06AM +0100, Lars Möllendorf wrote:
> Hi Greg,
> 
> as the author of the original patch I just mailed the backport to
> Stable@vger.kernel.org (and a lot of others as a result of
> `scripts/get_maintainer.pl` and `git send-email`).
> 
> However, I don't know if Jonathan and the other maintainers want the
> patch applied to the 4.4-stable tree or to any other stable or longterm
> tree.

Looks like it is needed to me, thanks for the backport, now queued up.

greg k-h
