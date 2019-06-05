Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A2E362FF
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFERvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 13:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfFERvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 13:51:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C024E20717;
        Wed,  5 Jun 2019 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559757062;
        bh=f6+bM2MN+4MCVnTXg3nyxbPjYb1No6OAastbIO06ads=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ub/ZuwPKTKIaDesa4nI/+W0sf/aW3gUm24BLvXs/uYcxVJq5A9D3UVq4zoYKuetqG
         l6HH/C7vNsHr9VlgN8SZNowxLH2qs6fM16Ztvc9nt7Dj+KVijyqJ+Cm9jwi04hJ3TR
         O0Xg/YfCFlYRbkrNeWjI0R8FJTM3LU/qsISfaXRk=
Date:   Wed, 5 Jun 2019 19:50:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Phil Elwell <phil@raspberrypi.org>
Cc:     stable@vger.kernel.org
Subject: Re: Dynamic overlay failure in 4.19 & 4.20
Message-ID: <20190605175059.GA29747@kroah.com>
References: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
 <2da582d1-11eb-3680-33f2-3a5c139613a8@raspberrypi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da582d1-11eb-3680-33f2-3a5c139613a8@raspberrypi.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 01:02:18PM +0100, Phil Elwell wrote:
> Hi,
> 
> I think patch f96278810150 ("of: overlay: set node fields from
> properties when add new overlay node") should be back-ported to 4.19,
> for the reasons outlined below (briefly: without it, overlay fragments
> that define phandles will appear to merged successfully, but they do
> so without those phandles, causing any references to them to break).

That patch does not properly apply to the 4.19.y tree.  Can you provide
a working backport that I can queue up to resolve this?

thanks,

greg k-h
