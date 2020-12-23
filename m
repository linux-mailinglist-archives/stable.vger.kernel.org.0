Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7F2E1D14
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgLWOM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbgLWOM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 09:12:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7AE72313C;
        Wed, 23 Dec 2020 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608732707;
        bh=uB10nrkeqve7Hly9rNtAzo2O1fQAFouPxvX1ah9BIc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JjvPpK8I00YA2JonE4DIXnHT6MZzAg8rmWzQ7iyUzEfmFWPN3qt7vr4eT5sOXYZTX
         Qb9Bjm/mSwEfQY/OmUkRSHdJEIDg2OzPef9OgxWXARaaLXjGQ3323YH4B1Gj1WVSwJ
         lVhWt/7N0L8q8tYKguXbNByaVYs+mOKTD7SzfOBE=
Date:   Wed, 23 Dec 2020 15:12:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ebiggers@google.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] f2fs: prevent creating duplicate
 encrypted filenames" failed to apply to 4.9-stable tree
Message-ID: <X+NQalRwl81mfnyV@kroah.com>
References: <1608732531208141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608732531208141@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 03:08:51PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Oops, got these out of order, my fault, let me try this again...
