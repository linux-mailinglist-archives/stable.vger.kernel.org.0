Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DC545B894
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 11:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbhKXKqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 05:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241607AbhKXKqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 05:46:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183F6C06173E;
        Wed, 24 Nov 2021 02:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MwOFsobIm1aC8JpnCiVwF0cKBW5+9/+z1MWNh+j3ClU=; b=uq0TtSU8nSo6eWOyMVHdGdW6Fj
        HakSmoMcyhIiSJtBX9y/nadi/ixHtJWjKuH68ov8zXFav5Iab1xVh9kN4H06uTINpWuDqgbfNRWQ1
        EPKGPiQcrPyq5KZFYi3KPb8MJjPv4Umv1b9KNHP9qQmZHAzNC+lyj9KbBtoPNJ12GBrkcttcAivnF
        SJPXFzwAaWpMtcwWjYjmwyXlS3+mSjVfnd1vS2mwbbH4FlAowgwybMxVJugVmYSSJTkDXB1qKqeNz
        +c5QsZ8yw8BeIqmWRPjj1Ob6DS/L32QUk50LdS0Ajozp4OPXHBQHkxg+kj2N9dmk3E0MMdY8kJrxm
        ssoW+IvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55834)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mppkF-0000To-W3; Wed, 24 Nov 2021 10:43:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mppkB-00018G-Px; Wed, 24 Nov 2021 10:43:15 +0000
Date:   Wed, 24 Nov 2021 10:43:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     akpm@linux-foundation.org
Cc:     ardb@kernel.org, linus.walleij@linaro.org,
        mm-commits@vger.kernel.org, quanyang.wang@windriver.com,
        stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: [merged]
 kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory.patch removed
 from -mm tree
Message-ID: <YZ4XQ/O9LZjYwL/j@shell.armlinux.org.uk>
References: <20211123224606.8VJDTHqFj%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123224606.8VJDTHqFj%akpm@linux-foundation.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 02:46:06PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: kmap_local: don't assume kmap PTEs are linear arrays in memory
> has been removed from the -mm tree.  Its filename was
>      kmap_local-dont-assume-kmap-ptes-are-linear-arrays-in-memory.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
