Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6B305513
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 08:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhA0Hya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 02:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234193AbhA0HrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 02:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B3820724;
        Wed, 27 Jan 2021 07:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611733572;
        bh=uCaLoTM3lDJhCWPDJk982fmCBCdiw+WrVEej0zl+pco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJMRocVtFJbqrKK8yv0QtGVUEZfYT5HEgtc9/4y9xJ8rH1h59MwIVkspzadEgh44f
         qftvsEOxuBplYUNMhBMXKBjRDk5lvJTGDze4H0I3VHBpADESw5rX8O0Mr9+gIPo6mg
         q1XOR46gjaPbf2dh1TULBPlDhVbIixo5bW3H9cb8=
Date:   Wed, 27 Jan 2021 08:46:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Duncan <leeman.duncan@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] fnic: fixup patch to resolve stack frame issues
Message-ID: <YBEaQEs6gvrSm6dA@kroah.com>
References: <20210127012124.22241-1-leeman.duncan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127012124.22241-1-leeman.duncan@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 05:21:24PM -0800, Lee Duncan wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Commit 42ec15ceaea7 fixed a gcc issue with unused variables, but
> introduced errors since it allocated an array of two u64-s but
> then used more than that. Set the arrays to the proper size.
> 
> Fixes: 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf

Please use the documented way to show sha1 commit ids to make it easier
to understand:

	42ec15ceaea7 ("scsi: fnic: fix invalid stack access")

thanks,

greg k-h
