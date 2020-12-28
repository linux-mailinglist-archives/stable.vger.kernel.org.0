Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3571C2E34F9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgL1IPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:15:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgL1IPz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 03:15:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD62221F9;
        Mon, 28 Dec 2020 08:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609143314;
        bh=SzxpCJe3dJ2gvyU6Bjf/H31xrEhH9DsIVzPJCQp0hwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XGY89Y6EGwjFBIaqrzHZXgef99z6GVygYNOyVGoUxNSaEk7Ue4Vydpc34TX/joaIx
         Lf2ygoLTY7pnn7WUNhcx/5RdBC+wcNG/rBfD8GPmTQp6STC0ydMRfWsGle41ze2V9v
         tbhAS54Kbx7seZx74XpSxLmPX6L1Ti2J4yO6Yhhg=
Date:   Mon, 28 Dec 2020 09:16:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     sakari.ailus@linux.intel.com, andy.shevchenko@gmail.com,
        bingbu.cao@intel.com, laurent.pinchart@ideasonboard.com,
        mchehab+huawei@kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: ipu3-cio2: Make the field on
 subdev format" failed to apply to 5.10-stable tree
Message-ID: <X+mUZFVu/88dOxKH@kroah.com>
References: <160914293422255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160914293422255@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 09:08:54AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Nevermind, I got this, and the other one to work, sorry for the noise.

greg k-h
