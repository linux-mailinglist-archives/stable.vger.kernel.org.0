Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5CE39F753
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhFHNJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhFHNJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 09:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 311F46128A;
        Tue,  8 Jun 2021 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623157666;
        bh=M+l3QLOYYyYzZKhZE+k/ls5us0dENsfyAN6s4LhdcGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GZ+D0Wzox99ljkSwSNQvzCTk5E43y4VSzBsTLV4herjdsyidGcsEIQYSEyVdvJTDO
         IDPsUBNRhvspcZQBkxejTVsZ10bXaBOAuCMNtutmUqSb2nF4gR7h4R0xC0ObAIjAsF
         kQtqOjjSnfQKuizs4NF3eqe/44pAzxLMpm3bmYew=
Date:   Tue, 8 Jun 2021 15:07:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Fix build in periphal-only mode
Message-ID: <YL9roIyufhiX/nBn@kroah.com>
References: <20210608120049.1393123-1-phil@raspberrypi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608120049.1393123-1-phil@raspberrypi.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 01:00:49PM +0100, Phil Elwell wrote:
> In branches to which [1] has been back-ported, the bus_suspended member
> of struct dwc2_hsotg is only present in builds that support host-mode.
> To avoid having to pull in several more non-Fix commits in order to
> get it to compile, wrap the usage of the member in a macro conditional.
> 
> Fixes: 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes.")
> Signed-off-by: Phil Elwell <phil@raspberrypi.com>
> [1] 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes.")
> ---
>  drivers/usb/dwc2/core_intr.c | 4 ++++
>  1 file changed, 4 insertions(+)

Now queued up everywhere, thanks.

greg k-h
