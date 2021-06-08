Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C3739FD43
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhFHRMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231577AbhFHRMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 13:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0935561354;
        Tue,  8 Jun 2021 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623172228;
        bh=xcJRyfuhSHEj30N1wxnbL/qGILXy8gKgZLTy5knWXtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R+pymMQxmuBD4clNvL5kzUaqaRdt9Zb42erE3FHmFS+UvRl6IqHpQkNT1f2KHHdOJ
         z57WVpTpiS6djxjryCwoHO3JIR8MHpkj/Ju/PUsVDlOBYtajcqkmzpVKLaZ7F0qz3t
         BhC/hNcoCAdJQEPUxAuctwxdzH0XsHkFxW5E27/k=
Date:   Tue, 8 Jun 2021 19:10:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: Patch for stable 5.4 and below
Message-ID: <YL+kgrWC6OTPxu/B@kroah.com>
References: <82837f40-130e-c6f0-58a0-c8ff1b1d06a8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82837f40-130e-c6f0-58a0-c8ff1b1d06a8@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 03:22:09PM +0200, Juergen Gross wrote:
> Hi Greg,
> 
> please add the attached patch to the stable kernels 5.4 and below.
> It is a backport of upstream commit 4ba50e7c423c29639878c005732
> which already went into 5.10 and 5.12.

Now queued up, thanks.

greg k-h
