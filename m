Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3160E1288F0
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 13:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfLUMDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 07:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfLUMDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 07:03:19 -0500
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E45022070C;
        Sat, 21 Dec 2019 12:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576929799;
        bh=Vj6hqpjP3GeNLyV10OZpide3mDmoUIaZnAD1e5nRDS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q6sTAxGtpKjjTwfkyOFXeAi5okUXqUAOJG+BwhQcVzM8x6Bjb9PvwQGr9oGB3nEV4
         87cFLZENICEI/pQIeRLJOc1xtFExB9OFOnyL+11tFUtfb/AFZJTRxNo7QAvtaU/JSv
         /vBF6pxXrlyYocSiN67ZGnz/alvhYgJg9TPVXs6w=
Date:   Sat, 21 Dec 2019 13:03:09 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Mr. FRANQUET" <franquet@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH] Add RANDOM_TRUST_CPU to linux-stable.
Message-ID: <20191221120309.GA70102@kroah.com>
References: <RznihSm8WDp89qhAMg_uwqq6C8hl8uMyjaEWW3riCvy0bbah4mFE2qcM-ha-qZdsRm6jrgct7DAqU5Dr6ziYrsI23la6Bu-YaIf1JmZOmq4=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <RznihSm8WDp89qhAMg_uwqq6C8hl8uMyjaEWW3riCvy0bbah4mFE2qcM-ha-qZdsRm6jrgct7DAqU5Dr6ziYrsI23la6Bu-YaIf1JmZOmq4=@protonmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 21, 2019 at 11:57:59AM +0000, Mr. FRANQUET wrote:
> Hi,
> 
> After reading a blog post[1], I have a great trust interest in seeing you take two upstream commits in stable, so:
> 
> 39a8883a2b989d1d21bd8dd99f5557f0c5e89694 (random: add a config option to trust the CPU's hwrng)
> 9b25436662d5fb4c66eb527ead53cab15f596ee0 (random: make CPU trust a boot parameter)
> 
> I have just successfully tested this into linux 4.14.159.

If you wish to use this new feature, please just use the 4.19 or newer
kernel, no need to stick to 4.14.y.  Remember, stable kernels are for
bugfixes, not new features.

thanks,

greg k-h
