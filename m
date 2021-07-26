Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3343D56B2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhGZIzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhGZIzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43CFE60238;
        Mon, 26 Jul 2021 09:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627292169;
        bh=M7B3RRaIZgT2LQdco2zvFJSdG+1p9c09VzBoTaB9fIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGTTaa7rIcuM8dsGOcBhQ3XX8OHIYyMbjO6EHJpaPIk2e+t2oem5iaEXdePY6U3HD
         Y1It8espZy1izPzJ3mr8vr65lpJ+XaH5dNwF90mLln6Oi3x8T8mwnZufGaCorYeyAt
         +7xekoWpNtZFKN+qKkuNCg1gdAl34zwzzyifwiFA=
Date:   Mon, 26 Jul 2021 11:33:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: compression: don't try to compress
 if we don't have" failed to apply to 4.9-stable tree
Message-ID: <YP6BgKeQt5UHGSGu@kroah.com>
References: <162600608216394@kroah.com>
 <YPngtpwRabvjaoR1@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPngtpwRabvjaoR1@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 10:18:46PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Jul 11, 2021 at 02:21:22PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.4-stable.

All now applied, thanks.

greg k-h
