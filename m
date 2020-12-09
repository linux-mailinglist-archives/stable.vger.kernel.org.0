Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB592D405C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgLIKyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbgLIKyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 05:54:18 -0500
Date:   Wed, 9 Dec 2020 11:54:54 +0100
From:   Greg KH <greg@kroah.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH for 4.19] speakup: Reject setting the speakup line
 discipline outside of speakup
Message-ID: <X9Cs/hMXQ4grRDql@kroah.com>
References: <20201209102640.yn7mdn52sm7bfbgm@function>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209102640.yn7mdn52sm7bfbgm@function>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 11:26:40AM +0100, Samuel Thibault wrote:
> [backport of 5.10 commit f0992098cadb4c9c6a00703b66cafe604e178fea]
> 
> Speakup exposing a line discipline allows userland to try to use it,
> while it is deemed to be useless, and thus uselessly exposes potential
> bugs. One of them is simply that in such a case if the line sends data,
> spk_ttyio_receive_buf2 is called and crashes since spk_ttyio_synth
> is NULL.
> 
> This change restricts the use of the speakup line discipline to
> speakup drivers, thus avoiding such kind of issues altogether.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Shisong Qin <qinshisong1205@gmail.com>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Tested-by: Shisong Qin <qinshisong1205@gmail.com>
> Link: https://lore.kernel.org/r/20201129193523.hm3f6n5xrn6fiyyc@function
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This, and the 4.14.y backport, fail to apply:

patching file drivers/staging/speakup/spk_ttyio.c
Hunk #1 FAILED at 47.
Hunk #2 succeeded at 187 (offset -4 lines).
1 out of 2 hunks FAILED -- rejects in file drivers/staging/speakup/spk_ttyio.c

What tree(s) did you make the patch against?

thanks,

greg k-h
