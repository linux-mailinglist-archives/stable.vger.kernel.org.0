Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E741A148F5C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 21:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbgAXU3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 15:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387548AbgAXU3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 15:29:19 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D7D2072C;
        Fri, 24 Jan 2020 20:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579897759;
        bh=F90xNfUKvOUf2TUGknbgCQUyvynq64EpI75k+l0dmfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yI/jzlDhjyDiy+RVAtgnDZBV+QQG7xN523HkaCfjRn/esAhwjMsYmny4VGRPuJJnH
         FCupkgTKE5EWoMbbta1nqGJ4EDxd3/Oud4h9zPl9tj5gAz/ZP0vlKW8owqg5ZjPahS
         3jEuqgDRFBjJyAdXsJ8wE6TyJOoLeka9N7XUB1QI=
Date:   Fri, 24 Jan 2020 15:29:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Subject: Re: [PATCH AUTOSEL 4.19 05/11] ARM: config: aspeed-g5: Enable
 8250_DW quirks
Message-ID: <20200124202917.GI1706@sasha-vm>
References: <20200124011747.18575-1-sashal@kernel.org>
 <20200124011747.18575-5-sashal@kernel.org>
 <CACPK8XeGLW6cm9UV7gqrOF18BzsRBppzLQLY6G=Y2MDj2Yrnhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACPK8XeGLW6cm9UV7gqrOF18BzsRBppzLQLY6G=Y2MDj2Yrnhw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 01:21:40AM +0000, Joel Stanley wrote:
>HI Sasha,
>
>On Fri, 24 Jan 2020 at 01:17, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Joel Stanley <joel@jms.id.au>
>>
>> [ Upstream commit a5331a7a87ec81d5228b7421acf831b2d0c0de26 ]
>>
>> This driver option is used by the AST2600 A0 boards to work around a
>> hardware issue.
>
>This hardware was only supported from 5.4+, so I think we can drop this patch.

I'll drop it for 4.19 and older, thanks!

-- 
Thanks,
Sasha
