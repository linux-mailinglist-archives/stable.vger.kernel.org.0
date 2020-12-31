Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A472E7EB8
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 09:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgLaIeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 03:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgLaIeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Dec 2020 03:34:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08CFE20799;
        Thu, 31 Dec 2020 08:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609403600;
        bh=wX/RsiFeUVeSh0tHWgPKKXjTLLEPPei2KROl3gzR2zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0S+xgYzt/vo2uIJ+7LYC4Q7AnrWE3nS3cs9TZ5ZEOFMaxZ50JsU/F7WxxvTmwrAX
         2rAdTU560HfCRP88aNpkPCJR7h+0VMJmNWebhkU2Y4UjAH6IbDIs1NhTX6FjpL53z7
         cd7gHKi8DCD6IeoZYeZ32s/C1aI7dpGARrn7i7pI=
Date:   Thu, 31 Dec 2020 09:33:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Labisch <clnetbox@gmail.com>
Cc:     Greg Kroah-Hartman <stable@vger.kernel.org>,
        Greg Kroah-Hartman <linux-kernel@vger.kernel.org>,
        Akemi Yagi <toracat@elrepo.org>,
        Justin Forbes <jforbes@redhat.com>
Subject: Re: sound
Message-ID: <X+2MzJ7bKCQTRCd/@kroah.com>
References: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
 <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 07:10:16PM +0100, Christian Labisch wrote:
> Update :
> 
> I've just tested the kernel 5.10.4 from ELRepo.
> Unfortunately nothing changed - still no sound.

Ah, sad.  Can you run 'git bisect' between 5.9 and 5.10 to determine the
commit that caused the problem?

thanks,

greg k-h
