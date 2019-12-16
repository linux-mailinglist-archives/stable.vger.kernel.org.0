Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE533120548
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 13:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLPMQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 07:16:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfLPMQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 07:16:57 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A8C3206CB;
        Mon, 16 Dec 2019 12:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576498617;
        bh=y3xrqwndnHqBmt8OZzbLzXuw772VMZ49R/W5r6PEWvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w67PQUfZe3869rj6TQCOzn3NQLjLbEmBaZAB2QQgE4KmK3kzuDSuXm5bYtSRc9Dmx
         ve75LPFaZO2PfrlosWyX0XhcHp2QjPAKE2UqfLce6Pq+SfZup9QCOq8/b9vGsPd6Vl
         01ynwYiYt5S1uNtIu15+fcYr0pCfrQgJgbhv0cxc=
Date:   Mon, 16 Dec 2019 12:16:52 +0000
From:   Will Deacon <will@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreyknvl@google.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
Message-ID: <20191216121651.GA12947@willie-the-truck>
References: <20191108154838.21487-1-will@kernel.org>
 <20191108155503.GB15731@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108155503.GB15731@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Laurent,

On Fri, Nov 08, 2019 at 05:55:03PM +0200, Laurent Pinchart wrote:
> Thank you for the patch.
> 
> I'm sorry for the delay, and will have to ask you to be a bit more
> patient I'm afraid. I will leave tomorrow for a week without computer
> access and will only be able to go through my backlog when I will be
> back on the 17th.

Gentle reminder on this, now you've been back a month ;)

Will
