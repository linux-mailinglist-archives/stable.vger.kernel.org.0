Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC5127810
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfEWIgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWIgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 04:36:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B3B420881;
        Thu, 23 May 2019 08:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558600581;
        bh=Gs+P2mDdvFYVm1X8AqMK9YufigI1JsIaB/+9M8K1AqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hm3wrZIxuYaAuqBp8icGKdws0s+/3qGpvhjv5nf0xPRB993m434XcQdp18yp/uzg4
         vyefoD4tuUMqmrADZHFkSXiJibEnPLlOofESXsCS4scWhpY+cx4XwhVPxFJcjjOVBJ
         dTtYsqw5lOuqDAEXcZ9RZQupyjET+Rp3VOGZdgEo=
Date:   Thu, 23 May 2019 10:36:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: imx: Fix the AR803X phy-mode
Message-ID: <20190523083618.GA21574@kroah.com>
References: <CAHCN7xL9xy+kTu2hunG-cfG_-4FJ4-=BLFo1XRj5vh+8OTO7Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xL9xy+kTu2hunG-cfG_-4FJ4-=BLFo1XRj5vh+8OTO7Yg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 07:33:40AM -0500, Adam Ford wrote:
> Please apply  0672d22a1924 ("ARM: dts: imx: Fix the AR803X phy-mode)
> to 5.1 stable branch.

It's already in the 5.1.4 release, are you sure you checked that is
needed to be applied again?  :)

thanks,

greg k-h
