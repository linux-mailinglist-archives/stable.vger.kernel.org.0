Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1584F453
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 12:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfD3Kin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 06:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfD3Kin (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 06:38:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC8B2075E;
        Tue, 30 Apr 2019 10:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556620723;
        bh=6Ib7R+4+pUuUf64xAfk/WLCRX2nHXBsYiE2bzPNh5qE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2niCqAHdSmnHMPzJrguyjpBwn81KPQ2rwlrjiKDmrlQlxV3vygz7JAoc9pbSMy+D4
         of7NyH00qTNkzEpBfB8JbJRAAceKuURRfByU0Sws0inDYMhgP8lgxKZfpEhHbalck6
         71Eetdx5yy55lBtvRtKDJd9p5Nt6t5rI/96SOiSo=
Date:   Tue, 30 Apr 2019 12:38:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diana Craciun <diana.craciun@nxp.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@ozlabs.org, mpe@ellerman.id.au
Subject: Re: [PATCH stable v4.4 8/8] Documentation: Add nospectre_v1 parameter
Message-ID: <20190430103840.GB10539@kroah.com>
References: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
 <1556552948-24957-9-git-send-email-diana.craciun@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556552948-24957-9-git-send-email-diana.craciun@nxp.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 06:49:08PM +0300, Diana Craciun wrote:
> Currently only supported on powerpc.

No upstream git commit id for this one?

thanks,

greg k-h
