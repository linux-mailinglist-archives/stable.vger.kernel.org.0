Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8300F2FCEC3
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbhATLC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387409AbhATKjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 05:39:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CED12333F;
        Wed, 20 Jan 2021 10:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611139139;
        bh=SQhjvQvD29H8WNhf+fiKcHjP7/AliNw8T9RKZXCz6E0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZjUsRCTIDmboV/qEo/c/hgDPNSBZSJEA2rm9KByabqkNi89ySYPPHFAimWEzMUMPe
         h4z0wlANM2FBEtkQltuyHH21F2AbScXVWWAl3OiSod+34IuEdJJmO6RnE9DOljZkH3
         g8wN8yMtkSe03Ldq7RF2tSwnGuSa3SHifh6XDF3o=
Date:   Wed, 20 Jan 2021 11:38:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 077/152] kconfig: remove kvmconfig and xenconfig
 shorthands
Message-ID: <YAgIQWWFuSwUn+af@kroah.com>
References: <20210118113352.764293297@linuxfoundation.org>
 <20210118113356.479183926@linuxfoundation.org>
 <20210119182837.GA18123@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119182837.GA18123@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 07:28:37PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Masahiro Yamada <masahiroy@kernel.org>
> > 
> > [ Upstream commit 9bba03d4473df0b707224d4d2067b62d1e1e2a77 ]
> > 
> > Linux 5.10 is out. Remove the 'kvmconfig' and 'xenconfig' shorthands
> > as previously announced.
> 
> I don't believe this is suitable for stable.

Yeah, this doesn't look right, I'll go revert it for the next release,
thanks.

greg k-h
