Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30393FD6C9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243506AbhIAJcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243465AbhIAJcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6152610A2;
        Wed,  1 Sep 2021 09:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630488670;
        bh=jX09/ot8A/Th4/FZ6QioAyd36pBSfU2HyPsqexDgalY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q0KtefjMtxdGTMbCClJ5OEm1myk2uxb76HDP5CO7A443HuYACt/TfrY7gsCfO82Yu
         lKV9jbJ+eUt8iBRP2AmMNLSLiJPx1avw+h8BSSUvzNxFleiYw/Q9rmdbJhNF4QBLR6
         UqUoBqiqwtxsjbbqOdbmvXwDD1dBNUDlOBIinhDY=
Date:   Wed, 1 Sep 2021 11:31:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not
 reserved) for all !TDP" failed to apply to 4.9-stable tree
Message-ID: <YS9IW6a6OWRKe3fd@kroah.com>
References: <162600725917152@kroah.com>
 <YSQROKTiMop9t2s4@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSQROKTiMop9t2s4@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 23, 2021 at 10:20:56PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Jul 11, 2021 at 02:40:59PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

All now queued up, thanks.

greg k-h
