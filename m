Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8C2101251
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 05:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKSEAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 23:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfKSEAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 23:00:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5597C222DD;
        Tue, 19 Nov 2019 04:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574136007;
        bh=XOQs9ta5TxZwJ5dIi/FfReFIvk/BCYdbBHqI+NdCsy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w1iC/DrKlMF9uRE+pAYttXB9ALq77DUfKp9NxLKMxVE8TbzPELoZLZgvR6SZBfIb3
         +0BdEotMfOGZB0X7rCpZdR9/JNNr+ojIhYWKA+r7+77fo0rJ6klHhWNzaLUXx7uxru
         Ne7TL2w0vxd99mxvaR9xG3NPTCH3ftiLdszasurY=
Date:   Tue, 19 Nov 2019 05:00:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrew Norrie <andrew.norrie@cgg.com>
Cc:     jaegeuk@kernel.org, axboe@kernel.dk, bvanassche@acm.org,
        linux-block@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: loop: avoid EAGAIN, if offset or block_size are changed
Message-ID: <20191119040004.GA1445767@kroah.com>
References: <20190617210848.GB57907@jaegeuk-macbookpro.roam.corp.google.com>
 <1574102176-23804-1-git-send-email-andrew.norrie@cgg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574102176-23804-1-git-send-email-andrew.norrie@cgg.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 18, 2019 at 11:36:16AM -0700, Andrew Norrie wrote:
> This email and any accompanying attachments are confidential. If you received this email by mistake, please delete
> it from your system. Any review, disclosure, copying, distribution, or use of the email by others is strictly prohibited.

Now deleted.  This is not compatible with Linux mailing lists, sorry.
