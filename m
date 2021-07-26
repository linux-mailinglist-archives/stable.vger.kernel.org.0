Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC273D56B4
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhGZIzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhGZIzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D129A60E09;
        Mon, 26 Jul 2021 09:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627292174;
        bh=MbgJMAdxEwL3vMAIqL2rHJXNBsYaFsBYunUwN/SnV0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ESxQ2h8404PK5R559RZVXnQUZWu2VkJPQ6rI5I+kIuLxL3Z3BrI6DupJcGmgV/qYf
         QeYTiXdeejN8DvaIY/MJEm8rA5nAkzGrk2/1OgrBM2VuzsLwZBL9OmrfAhi11Lvk+C
         EQ/Ajg/MtKS5vFa3F2s3PYb24cmgmurmFwcuxqUY=
Date:   Mon, 26 Jul 2021 11:35:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     christophe.jaillet@wanadoo.fr, broonie@kernel.org,
        olteanv@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix a resource leak in
 an error handling" failed to apply to 4.19-stable tree
Message-ID: <YP6B1BsnuTqNwILM@kroah.com>
References: <162238346339174@kroah.com>
 <YPsmRiIXK/Fc+hcm@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPsmRiIXK/Fc+hcm@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 09:27:50PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, May 30, 2021 at 04:04:23PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.14-stable.

Applied, thanks!

greg k-h
