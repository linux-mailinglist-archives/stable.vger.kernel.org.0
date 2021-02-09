Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B02314E12
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 12:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBILPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 06:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhBILNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 06:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5376B64E40;
        Tue,  9 Feb 2021 11:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612869159;
        bh=Ph1Qa9pT03RauygTnNT/+m1n9D6jb1k3gdJXUz2rV7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uKXVZSAychn3RwRQsLg5HhrPcBwt3+mM5YDAWrLPnf6GJN2aWn86Wb4kGcqERq3yR
         TOeQUJfXN8oOAN0aqX6Emw64W7BtZaEgMfZTLmX8qtLKtJBxOyWwJOVwnjPtVZhkns
         /FWyYwErYzw+6t/P7Ss22tljt5VbRe/D+0SnIUuI=
Date:   Tue, 9 Feb 2021 12:12:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     richard.gong@linux.intel.com
Cc:     mdf@kernel.org, trix@redhat.com, linux-kernel@vger.kernel.org,
        Richard Gong <richard.gong@intel.com>,
        "# 5 . 9+" <stable@vger.kernel.org>
Subject: Re: [PATCHv2] firmware: stratix10-svc: reset
 COMMAND_RECONFIG_FLAG_PARTIAL to 0
Message-ID: <YCJuJJcT56lEPvDn@kroah.com>
References: <1611848292-17882-1-git-send-email-richard.gong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611848292-17882-1-git-send-email-richard.gong@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 09:38:12AM -0600, richard.gong@linux.intel.com wrote:
> From: Richard Gong <richard.gong@intel.com>
> 
> Clean up COMMAND_RECONFIG_FLAG_PARTIAL flag by resetting it to 0, which
> aligns with the firmware settings.
> 
> Cc: <stable@vger.kernel.org> # 5.9+
> Fixes: 36847f9e3e56 ("firmware: correct reconfig flag and timeout values")

This is not the subject line of this git commit id, and linux-next would
complain if I let this into my tree.

Please fix up and resend.

thnaks,

greg k-h
