Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8634C2857D
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbfEWR7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbfEWR7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 13:59:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F71E2186A;
        Thu, 23 May 2019 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558634371;
        bh=t//QswKQx08LI6iErQMr17vdiuufkpGxw6pGOI/Zvtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W2WaHp/y9qgIbP+1MnMZvh9EzeT2HlBsmPA2X70oRVuu3mDNQB9TWVgQcdS/WGgkJ
         M+A4Dn63MFPoD2J5P2evcjIyKylYnChZFz23pctEl1kJBNSj2mCgLtgQkEsu694WoW
         8d+8ql544mpPNdy+HFRPgVLuWQVlRIvLOU/oSUKg=
Date:   Thu, 23 May 2019 19:59:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: imx6q-logicpd: Reduce inrush current on start
Message-ID: <20190523175928.GI29438@kroah.com>
References: <CAHCN7xJPG_LE8JwA44WjmQi697XiMir6b5-d-du5wc-YAD-U5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xJPG_LE8JwA44WjmQi697XiMir6b5-d-du5wc-YAD-U5g@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 07:35:09AM -0500, Adam Ford wrote:
> Please apply  dbb58e291cd4 ("ARM: dts: imx6q-logicpd: Reduce inrush
> current on start") to the 5.1 stable branch.

Both patches now queued up, thanks.

greg k-h
