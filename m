Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3750116DFB
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 14:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfLINbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 08:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbfLINbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 08:31:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F7420726;
        Mon,  9 Dec 2019 13:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575898278;
        bh=6yNe4QFDPO7ikiwoYyWqKmAiI7UgZ4k9C0QEUwiDP+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EdDYyuiPyB4BL7TLH/GYRIUOVZcrI/DZoQI7ADuP9H738lTMpOW5ozr35Q1hCx7XF
         ec0p5qO+7bTb6JljMniaLHCkCf8srwhatcVpwW0rBVhxx8cA+tLv8TPuTrmzccHSXN
         HvQ37amZMRIvGe2nRuJdJw91zhKPMvAfoLwrOWFY=
Date:   Mon, 9 Dec 2019 14:31:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Latest stable-review releases?
Message-ID: <20191209133116.GA1276687@kroah.com>
References: <TYAPR01MB22853B1C228C3D7A0C35B064B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB22853B1C228C3D7A0C35B064B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 01:00:59PM +0000, Chris Paterson wrote:
> Hi Greg,
> 
> I see that you pushed 4.4.207-rc1 and 4.19.89-rc1 commits on
> linux-stable-rc at the weekend, but I haven't seen your usual "stable
> review" emails to the stable mailing list.
> 
> Am I just failing to find them or have you not got around to sending them yet?
> 
> I ask as I've seen some build issues, but didn't want to make noise in
> case the next 4.4/4.19 rc releases aren't ready yet.

I push things out to the -rc tree when I am at a stopping point, not
only when I am doing a "real" release.

So please, feel free to report errors that you see there, as it usually
means I think all is good for the moment so I generated the tree.

We are working on making the tree auto-generated, like it is in the
stable-queue branches at the moment, that will make it a bit easier to
test with instead of having to wait for me to auto-generate it.

thanks,

greg k-h
