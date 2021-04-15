Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AE63605C0
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 11:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhDOJc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 05:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhDOJc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 05:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D007D6113B;
        Thu, 15 Apr 2021 09:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618479124;
        bh=QPgl2wkPL+NLeKql82EajvGXtSdHd/lWS4263YXlYtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSOjD04Y7tyiGxQHDVvNbHhEai08sIes9Ov/vA3kkg26RB13Y0CaQBJjlCRnNciip
         PykyldNWqQSBjp77rvL7oQo+6qEdboYv/ZSNfaSqICaHLXb3R9gx6+053u5WQhkoka
         8mutUgQFZjtn8qAovHcAihOFbZXVn4Xwnac0yHeQ=
Date:   Thu, 15 Apr 2021 11:32:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        NeilBrown <neil@brown.name>,
        George Hilliard <thirtythreeforty@gmail.com>,
        Christian =?iso-8859-1?Q?L=FCtke-Stetzkamp?= <christian@lkamp.de>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Sergej Perschin <ser.perschin@gmail.com>,
        John Crispin <blogic@openwrt.org>
Subject: Re: "Backport" of 441bf7332d55 ("staging: m57621-mmc: delete driver
 from the tree.") as well for older stable series still supported?
Message-ID: <YHgIEbn1UqhXHdzr@kroah.com>
References: <YHdGBm2WHb5I8FFW@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHdGBm2WHb5I8FFW@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 14, 2021 at 09:44:06PM +0200, Salvatore Bonaccorso wrote:
> Hi Greg, Sasha, all,
> 
> Prompted by https://bugs.debian.org/986949 it looks that files with
> prolematic license are present in stable series in
> drivers/staging/mt7621-mmc/ prior to 441bf7332d55 ("staging:
> m57621-mmc: delete driver from the tree.") where those were removed in
> 5.2-rc1.
> 
> As the license text at it is presented is problematic at best, would
> this removal make sense as well in the current other stable series
> which contain it? The files goes back to it's addition in 4.17-rc1.
> 
> So it would remain v4.19.y where the files should/can be removed as
> well from the staging area?

Yeah, it is odd, and we probably should not continue to distribute new
updates with it in the tree.

As the commit does not backport cleanly, can you provide a working
backport that I can apply?

thanks,

greg k-h
