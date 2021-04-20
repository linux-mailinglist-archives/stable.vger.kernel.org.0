Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEBA36525E
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhDTGb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 02:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhDTGbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Apr 2021 02:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 660E060FE9;
        Tue, 20 Apr 2021 06:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618900254;
        bh=bNLAzuB8oghzTz0+vfdUjOTR5H53WWRBLlLPmnfJv/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YXKj8RCSA/AwHfC/CAXZJkh2G/K+N76SjqNWbgH1HTcUiQ4Z7AtD4DclnecmdesGA
         NO2xhNoFeoPT3yZRMtj5Jsk5JulwRMn/olL/kbSZG93JorpYXf13a+/+SQivQwBBsl
         C5nQh8pyJgw130Xvg0UYTWGyowr2NbXA/adFfsh9dPCZJD/UUYEw5SWxjGHuhOL35/
         kbyX2M5dg9fVvS+czW1PYUfR5rjrf3GN11fbA1+Q5SdcrnMKfUCiEzPgTvTxwivdm9
         ZgB+SfMN3ipbffCV5xjmg2S2i/5mYAgJ9cR77GzwkiN1r7gyGwoUKiDnT86LeHe3hB
         AfUKO203F7DCA==
Date:   Tue, 20 Apr 2021 08:30:50 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Samuel Holland <samuel@sholland.org>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 17/23] i2c: mv64xxx: Fix random system lock
 caused by runtime PM
Message-ID: <20210420083050.09375c3b@thinkpad>
In-Reply-To: <20210419204343.6134-17-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
        <20210419204343.6134-17-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 16:43:36 -0400
Sasha Levin <sashal@kernel.org> wrote:

> This first appeared with commit e5c02cf54154 ("i2c: mv64xxx: Add runtime
> PM support").

I forgot to add Fixes: tag to this commit. But the bug first appeared with
commit
  e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support")
which is in 5.12, but not 5.11 or any others.

So this fix is not needed for the stable releases (althogh it does not
break anything on those...).

Marek
