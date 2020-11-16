Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7102B3EF1
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 09:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKPInK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 03:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgKPInJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 03:43:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0D58208C7;
        Mon, 16 Nov 2020 08:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605516189;
        bh=Fft2q6iLclJ07P1CeIgAp3Kd5EwYvmRdM2yvMaWgWFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gGebtH2LbVtGnQOlvNuYV7WkE2d1hvJDKYw7ZrZk2bXwB7a8V4x6qoxyarRPlrkKE
         U0gWLTVkZV0rwJ5C0Xj3MZ7GUskn3kZyNypzKa8G4whJl81EL/b7zIYbktfJT8vS8u
         2BKS3iXqkVWNkdHeAXn81P4mCfP3yM6OUy/gpZow=
Date:   Mon, 16 Nov 2020 09:44:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Martin =?iso-8859-1?Q?Hundeb=F8ll?= <martin@geanix.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: Apply bc7f2cd7559c5595dc38b909ae9a8d43e0215994 to 5.4+
Message-ID: <X7I70Iuf7inAYXkm@kroah.com>
References: <20201116021959.GA4186045@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116021959.GA4186045@ubuntu-m3-large-x86>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 15, 2020 at 07:19:59PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit bc7f2cd7559c ("spi: bcm2835: remove use of
> uninitialized gpio flags variable") as a fix to commit
> 5e31ba0c0543 ("spi: bcm2835: fix gpio cs level inversion"), which
> appears to be in 5.4 and 5.9 at the time of writing this. I did not try
> to apply it but I did not see an outstanding failure email about it. If
> it does not apply cleanly, let me know.

Now queued up, thanks.

greg k-h
