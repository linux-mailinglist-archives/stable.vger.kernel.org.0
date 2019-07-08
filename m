Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8DF61FED
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 15:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfGHN6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 09:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729112AbfGHN6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 09:58:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE4C21479;
        Mon,  8 Jul 2019 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562594304;
        bh=k9gzkfvTupemZe/mNLRkqdIXJkLtrLmu0ndLjZ6mjQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MsaSjzQPtG2BZ4/bFmX72iaNKbZ/Odld0jtS//r5ywbWyGZ6gyaUkxZaidBeHgoLa
         KFQt6ijnGYUe330V0uaZ2x5ScE8i0AvZPLbfgcSbB5SPkwEaTM2tGOnCuxJAy8WwS6
         Gp+H/b+v3nBm5RFGqNX4ZC4lhipYqPsgsv4D6Vwo=
Date:   Mon, 8 Jul 2019 15:58:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kaslr: keep modules inside module
 region when KASAN is" failed to apply to 4.9-stable tree
Message-ID: <20190708135821.GB2900@kroah.com>
References: <1562316860240248@kroah.com>
 <20190708132351.kxai726abg2piley@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708132351.kxai726abg2piley@willie-the-truck>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 02:23:52PM +0100, Will Deacon wrote:
> On Fri, Jul 05, 2019 at 10:54:20AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 6f496a555d93db7a11d4860b9220d904822f586a Mon Sep 17 00:00:00 2001
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Date: Tue, 25 Jun 2019 19:08:54 +0200
> > Subject: [PATCH] arm64: kaslr: keep modules inside module region when KASAN is
> >  enabled
> 
> 4.9 backport below.
> 
> Will

Now queued up, thanks!

greg k-h
