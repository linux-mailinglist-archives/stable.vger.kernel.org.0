Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6423FD6C1
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243314AbhIAJae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242787AbhIAJae (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D026109E;
        Wed,  1 Sep 2021 09:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630488577;
        bh=1HEr3MtmfcyesC1bKSaStXnVvp1yrHXcF9aKoqpCLkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/VwsPyzrzNFVMdRI4ouOf5erH/xUB8mfPoLkvNgWLtBtLj4UQZpsXd9v8XTwBb06
         ujPmSebYMW/PJ/oIrsmpg+TuympED0cTBShE0emtTEj/FZ4YYmfUaR/Z0KvtKNMsSN
         v3tPTUU/azmekq1b3NkrHWFw4k4oKJBIVIWU2vb4=
Date:   Wed, 1 Sep 2021 11:29:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     keescook@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lkdtm: Enable DOUBLE_FAULT on all
 architectures" failed to apply to 5.10-stable tree
Message-ID: <YS9H//fB7AwSPpxX@kroah.com>
References: <162635641192154@kroah.com>
 <YSQAU7wKRAFv2yET@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSQAU7wKRAFv2yET@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 23, 2021 at 09:08:51PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Jul 15, 2021 at 03:40:11PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Now queued up, thanks.

greg k-h
