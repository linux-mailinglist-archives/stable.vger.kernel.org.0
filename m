Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D006B3C1924
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhGHS0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHS0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 14:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6783E61457;
        Thu,  8 Jul 2021 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625768645;
        bh=wVSMXgCAddlcFWlthMed0wyaVXaLBucYMeSGQlKKweQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sesUfnUccFSSNtByeURzJrSJ/AxMgznigyTnQHqC6tCHtpm905+KKSRxKqItDWg9S
         96qPwsA/3/ysr6dKpfIlMwAD3dPYgnTTWTWQYtto3uvkYZrdHS//STkjzjARIjgLIu
         vavafHq9krHloQ8OmvNXioLe2OY1vAiB93LLRnwM=
Date:   Thu, 8 Jul 2021 20:24:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     gor@linux.ibm.com, stable@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/stack: fix possible register
 corruption with stack" failed to apply to 5.4-stable tree
Message-ID: <YOdCw4TAbCcDO1Yd@kroah.com>
References: <16248036362480@kroah.com>
 <YORT2ADgY32NITmo@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YORT2ADgY32NITmo@osiris>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 06, 2021 at 03:00:08PM +0200, Heiko Carstens wrote:
> On Sun, Jun 27, 2021 at 04:20:36PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Please find below the backported patch which applies to 5.4-stable:

THanks, now queued up.

greg k-h
