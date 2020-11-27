Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73442C6895
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 16:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgK0PQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 10:16:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbgK0PQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 10:16:49 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B67206CA;
        Fri, 27 Nov 2020 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606490209;
        bh=V652BJQWh/quqWVyTEZpImS0hnOQ6STIJCpY7ur11H4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SGX2C3x34WZ4DWTSSkOKonoIzNrAaWWN4mMD0h247kg4bdkCOG9DcoLBIzdUqSbpn
         mGWnkYwDMv7YLlxpzJD7N+nYHD9/Ct/whz79+9MHVaeZ8N187Px3SV9TrVozRpyAVd
         DOOuMfWwPG0OtFVjiSKDQnUbkHhqgMPYM31NaQx4=
Date:   Fri, 27 Nov 2020 16:16:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: few missing fixes for 4.9-stable
Message-ID: <X8EYXtPPDGzp502I@kroah.com>
References: <20201127113500.5rq7ueik2k4jxtmd@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127113500.5rq7ueik2k4jxtmd@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 11:35:00AM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> These two were missing in 4.9-stable. Please apply to your queue.
> 
> 80e46cf22ba0 ("btrfs: tree-checker: Enhance chunk checker to validate chunk profile")
> 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")

This, and the 4.4 patches, now queued up, thanks.

greg k-h
