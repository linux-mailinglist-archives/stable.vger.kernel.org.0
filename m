Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3BA413356
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 14:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhIUMaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 08:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232525AbhIUMaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 08:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0CC610CA;
        Tue, 21 Sep 2021 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632227333;
        bh=UDN0f/j+84jiywrvGwgee7F4aZZ3IednTOwnw/zrcj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KJmjnXi6q0zCPdxdDB+F4K42PUSO5dM0LXZvIsFgGQXTw2ZCadSp+ZJ1C+ZlVLE0F
         areU6mHecusu52EYXT42ZRWFS3TqORI0i17hTRGRLJurU1Yd/LfICtoD0VYjKfiDyo
         K1wrtFs0bvan6WKvxYYzjTS63/SM6tFMCLNmT+TE=
Date:   Tue, 21 Sep 2021 14:28:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: 5.13,5.14 | ath11k/mhi regression: Wifi stops working
Message-ID: <YUnQAvKKI7d8escn@kroah.com>
References: <f759ec8e-cfcc-7f78-65c5-97ecc24aad17@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f759ec8e-cfcc-7f78-65c5-97ecc24aad17@manjaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 02:02:20PM +0200, Philip Müller wrote:
> Hi Sasha, hi Greg,
> 
> may you guys take a look at this?
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=214455

Please do not point to random links, send us the needed information in
email please.

thanks,

greg k-h
