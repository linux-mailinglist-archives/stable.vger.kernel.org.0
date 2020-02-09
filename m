Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657F8156CC1
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 22:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgBIVd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 16:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgBIVd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 16:33:26 -0500
Received: from localhost (unknown [38.98.37.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2E720726;
        Sun,  9 Feb 2020 21:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581284006;
        bh=gNhiN1TYJV8Z2RPWTla09+0vYfcdmkahombuy/n7Klw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TWNY6BM71FfsNK8v7Wpjkl4ZU63yXChvk4iUdpaqhm5sggF0Cv5Cv1FN5S0uQHRw8
         zfb6cjdVXiNjKeUJYeIAAhIFYHWEkeyvDG5//61I7p2rJCBVMq8fFz9idL9QcLV64O
         Y9UyqqxdofX0gavY0rLV79z/06fp4SFWesIwEqgM=
Date:   Sun, 9 Feb 2020 22:15:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     stable kernel team <stable@vger.kernel.org>
Subject: Re: [tip-bot2@linutronix.de: [tip: x86/urgent] x86/timer: Don't skip
 PIT setup when APIC is disabled or in legacy mode]
Message-ID: <20200209211538.GA55369@kroah.com>
References: <20200201093001.GB71555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201093001.GB71555@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 01, 2020 at 10:30:01AM +0100, Ingo Molnar wrote:
> 
> hi Greg,
> 
> Wondering whether you could include 979923871f69a4 in -stable once it 
> hits upstream - we forgot to tag it. Or should I track it myself and 
> notify you once that happens?

Now queued up, thanks.

greg k-h
