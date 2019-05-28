Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7031C2C755
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 15:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfE1NGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 09:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbfE1NGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 09:06:51 -0400
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9882C20989;
        Tue, 28 May 2019 13:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559048810;
        bh=/+477RcgvKmGEn2k0v36nD0XwxBdPxQufcHloS9zcdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2QerHxwwP9JsNDeu2Bjb+5tEsse3oxAzQneqr+GVvUsbFoJYdtV3CPcpMK67E60Cy
         PtYLCY7m+AsjJjrHVIUKqNIYqQczfc/WPqmRgX6JyXpvNp4mg1Baaok2jaYkTmawNM
         yXvK15zfxo3gZhXTyZPwU1otEMGCPQGEf7T8Xtdc=
Date:   Tue, 28 May 2019 15:06:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH for v5.0.x] btrfs: honor path->skip_locking in backref
 code
Message-ID: <20190528130636.GC6104@kroah.com>
References: <20190528102353.23714-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528102353.23714-1-wqu@suse.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 06:23:53PM +0800, Qu Wenruo wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Commit 38e3eebff643db725633657d1d87a3be019d1018.

Thanks for the backports, now queued up.

greg k-h
