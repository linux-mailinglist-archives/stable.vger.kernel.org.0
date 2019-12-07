Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877AD115C21
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 13:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfLGMCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 07:02:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfLGMCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Dec 2019 07:02:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2FC1206DB;
        Sat,  7 Dec 2019 12:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575720120;
        bh=iFdYDZ/Nk2ohDtaie3LSntgHZyqrLpprZK+XpTVtZ4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xvr+279qECyH9j4fCq8D9In7KvZGsAU/VdTk8qy6YAdUYP9RG12O/95EFMIcJ7Vpv
         vJZR+uxfSUCvCjKAAHmVYZC4z/5ShaPDGNHy49nN5ayBIOFc5ubIhwwTqiEp30AbvG
         EZXWdwlUJNEoU9OPwYwfdWzzU2CAs7DBPiqMJPMk=
Date:   Sat, 7 Dec 2019 13:01:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: io_uring stable addition
Message-ID: <20191207120158.GC325082@kroah.com>
References: <a33932d5-c5ff-ff4d-2bb4-3a1c3401a850@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33932d5-c5ff-ff4d-2bb4-3a1c3401a850@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 08:53:43AM -0700, Jens Axboe wrote:
> Hi,
> 
> We have an issue with drains not working due to missing copy of some
> state, it's affecting 5.2/5.3/5.4. I'm attaching the patch for 5.4,
> however the patch should apply to 5.2 and 5.3 as well by just removing
> the last hunk. The last hunk is touching the linked code, which was
> introduced with 5.4.

Does this match up with a patch in Linus's tree anywhere?  Why is this a
stable-only thing?

thanks,

greg k-h
