Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8B157C90
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBJNnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgBJNni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 08:43:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36ECE2070A;
        Mon, 10 Feb 2020 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581342218;
        bh=Hquanu6Wy26mnQgUxpH/1ep5O2rHYKiKniqQZps8nnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cClBx3Leb9P8qQChaWcVMqSJcd1q6imDi6n/67rpvTC5IIHefy7A3EwSDmnxt78cM
         7FxcH0fOcPL+WKF9l6Yw2RRazz5yA8XdDxN7LsR0Gwu1z+3Cf+1q+FWQxxTIFh5Hlb
         JdX8qSjOWvfZcR3xpOiORqxariYidls1Snxa3zSE=
Date:   Mon, 10 Feb 2020 05:43:37 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Enderborg <peter.enderborg@sony.com>
Cc:     Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] HID: Extend report buffer size
Message-ID: <20200210134337.GA532350@kroah.com>
References: <20200210122147.GA413013@kroah.com>
 <20200210124054.1257-1-peter.enderborg@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210124054.1257-1-peter.enderborg@sony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 01:40:54PM +0100, Peter Enderborg wrote:
> In the patch "HID: Fix slab-out-of-bounds read in hid_field_extract"
> there added a check for buffer overruns. This made Elgato StreamDeck
> to fail. This patch extend the buffer to 8192 to solve this. It also
> adds a print of the requested length if it fails on this test.
> 
> Fixes: 8ec321e96e05 ("HID: Fix slab-out-of-bounds read in hid_field_extract")
> Signed-off-by: Peter Enderborg <peter.enderborg@sony.com>
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
