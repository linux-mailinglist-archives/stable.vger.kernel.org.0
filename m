Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C5F2C9983
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgLAIbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgLAIbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:31:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F2F20659;
        Tue,  1 Dec 2020 08:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606811443;
        bh=2sTmWV7FXKHzhqiGIPvKphZc9RCVXLLwtVsKyZhedwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tdsWpqKK/1NPcIknA6oC0J3Z1vJliA+HNbkAQ/dbjArofYXNj/MaSvIPvGjORR5mi
         E9u+IvZQdKKaIGRV7JxPY8RmOzTCxichn+/OHVIoRoNIRbF/QwjdvoajMl/71B+3LH
         uuWbA7sE6aWK/5AIcuOkXSVuKxQmAQhBR6l18Kh4=
Date:   Tue, 1 Dec 2020 09:31:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stern@rowland.harvard.edu, bugzilla.kernel.org@mrtoasted.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: core: Fix regression in Hercules
 audio card" failed to apply to 4.14-stable tree
Message-ID: <X8X/ezZr4IzG77AE@kroah.com>
References: <160672516553144@kroah.com>
 <20201130183935.jekxnuugxntadd6n@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130183935.jekxnuugxntadd6n@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 06:39:35PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Nov 30, 2020 at 09:32:45AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport which will also need:
> 73f8bda9b5dc ("USB: core: add endpoint-blacklist quirk") and that backport
> also attached.

All now queued up, thanks!

greg k-h
