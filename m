Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8EBF506C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfKHP7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 10:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfKHP7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 10:59:25 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB01215EA;
        Fri,  8 Nov 2019 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573228764;
        bh=rqwT9BQ1DVff39lbNrzTZleYAcmxMaVgwzFVC5pLXV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QUaNgS0S9E70lxzjDwlRg72D9zNDhn+HbuG6roCKuNR2qLw2l77CZ81hdlDgm3qLy
         ltqLwGb2t3Smh4hBsV9hG20C7aSgO6UCAEXhsvnWlO53fixj4o+L7k91e4RiRwLvLN
         Tf7GeXaRllOD7It17rsQPVPaJmz/BpikCOoMcbvI=
Date:   Fri, 8 Nov 2019 15:59:19 +0000
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
Message-ID: <20191108155918.GA20866@willie-the-truck>
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
> I'm sorry for the delay, and will have to ask you to be a bit more
> patient I'm afraid. I will leave tomorrow for a week without computer
> access and will only be able to go through my backlog when I will be
> back on the 17th.

Ok, thanks for letting me know. I'll poke you again when you're back if
I don't hear anything -- I haven't actually changed the patch for ages,
since I don't think it needs further work [1].

Will

[1] https://lore.kernel.org/linux-media/20191007162709.3vrtbcpoymmnqikl@willie-the-truck/
