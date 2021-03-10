Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A933462F
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhCJSB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhCJSBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 13:01:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B24664F3A;
        Wed, 10 Mar 2021 18:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615399260;
        bh=l8kPs4iqhyL1QS3Vh9N72C+xubL3d2D30IguIQxkbjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WghfUsbT38yiRp41uiZGn3Rnm1ziKc91OwuSOg7CXqKN+rMpdbMH6Vgmqcxx4PeQk
         sugn6ki/07/6QRm7HgxdlfhnAyhWprElF1gVOTfsS4NihmhGBMAF8KWvV6S1U5qto3
         kWirdYzFGAtp+t9FbObnz1XdH0GbLe8YIn8BDaZs=
Date:   Wed, 10 Mar 2021 19:00:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 14/49] net: ipa: ignore CHANNEL_NOT_RUNNING errors
Message-ID: <YEkJWuKZCDv763Gn@kroah.com>
References: <20210310132321.948258062@linuxfoundation.org>
 <20210310132322.413240905@linuxfoundation.org>
 <CA+G9fYthEr7TtFBpAXxQfDtwxCe+qg=bbE74nPQ+mpGmSSJ2dw@mail.gmail.com>
 <a1d30ddd-2c2e-325b-f401-2e8461abba25@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d30ddd-2c2e-325b-f401-2e8461abba25@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:48:03AM -0600, Alex Elder wrote:
> On 3/10/21 11:36 AM, Naresh Kamboju wrote:
> > On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
> > > 
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > From: Alex Elder <elder@linaro.org>
> > > 
> > > [ Upstream commit f849afcc8c3b27d7b50827e95b60557f24184df0 ]
> 
> Upstream commit f849afcc8c3b27d7b5 is described as:
>   v5.10-rc4-1094-gf849afcc8c3b2

$ git describe --contains f849afcc8c3b27d7b50827e95b60557f24184df0
v5.11-rc1~169^2~199^2~3

> Is this being "back-ported" to v5.10 stable?

Yes, because it showed up in 5.11 :)

thanks,

greg k-h
