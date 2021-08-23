Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7191F3F51A2
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 22:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhHWUCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 16:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhHWUCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 16:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 756D76121E;
        Mon, 23 Aug 2021 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629748924;
        bh=0DBUJY0m/eDE9rMoQv0iZ+gEW3kHOYdjbnylDK/552I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jELp9BVI9bzfCDK5CyQbk2bzfAVwoc6ZM0hh2RX5bfx/IC176RDhTSyuwB7VwXcAy
         nJ4s94N0HkSDtesR7ssm89lA/3t8g8R3L9+PGNZS7uKGoiEPlY67q9UbGqDDu79GjM
         6u+YykzTcZE48TcbBNtmrWWYCvchUgO8AOEfHHMUR1tuqD5OuefbHm7fDOJ7ReWe5p
         H6vbATXIEhKZyJNVVRDfFdZVjJM0yr2IuWAYLwGUSFisKSVLSWTDxKpJZE+/j4JDJY
         WS5iMdLFtqDHvzJ7Ladu6MNUTU20DbDWueXXSRgsGEdz6ntJJWmHv086cvWLFNyP4T
         P1940LAyIpj/Q==
Received: by pali.im (Postfix)
        id 29861FC2; Mon, 23 Aug 2021 22:02:02 +0200 (CEST)
Date:   Mon, 23 Aug 2021 22:02:01 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>
Subject: Re: Drivers for Qualcomm wifi chips (ath*k) and security issues
Message-ID: <20210823200201.7guy4hja35hjmgyl@pali>
References: <20210823140844.q3kx6ruedho7jen5@pali>
 <18c5a8be-66d7-0dd8-b158-0931335f7ac5@candelatech.com>
 <20210823145800.4vzdgzjch77ldeku@pali>
 <CADVatmPwp9Ngexm+_JgW3vBxFo6FBq9NzLS=POxHoO-COBQ0gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADVatmPwp9Ngexm+_JgW3vBxFo6FBq9NzLS=POxHoO-COBQ0gA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 23 August 2021 20:26:37 Sudip Mukherjee wrote:
> Hi Pali,
> 
> On Mon, Aug 23, 2021 at 3:58 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Monday 23 August 2021 07:32:11 Ben Greear wrote:
> > > On 8/23/21 7:08 AM, Pali Rohár wrote:
> > > > Hello Sasha and Greg!
> > > >
> > > > Last week I sent request for backporting ath9k wifi fixes for security
> > > > issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintainers
> > > > did not it for more months... details are in email:
> > > > https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t/#u
> > >
> > > For one thing, almost everyone using these radios is using openwrt or
> > > similar which has its own patch sets.
> >
> > AFAIK, latest stable released openwrt uses ath9k from 4.19 tree and
> > AFAIK did not have above patch.
> 
> And I can see they are already in the queue for next v4.19.y release,
> so should be part of v4.19.205

Yes, I expect it. My point was that these patches were not available in
openwrt's custom patch sets about which Ben talked.
