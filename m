Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED34F6188
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 21:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfKIUwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 15:52:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:37362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfKIUwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 15:52:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76C56AE82;
        Sat,  9 Nov 2019 20:52:11 +0000 (UTC)
Date:   Sat, 9 Nov 2019 21:52:09 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Fix backport of f18ddc13af981ce3c7b7f26925f099e7c6929aba
Message-ID: <20191109205209.GA11798@x230>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20191108155316.13109-1-pvorel@suse.cz>
 <20191108160812.GA991932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108160812.GA991932@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> It's a bit hard to go back in time and modify a patch that is already in
> the main linux-stable.git tree like this :)

> If we messed up the backport, great, please send a patch I can apply to
> the 4.9.y kernel tree with the information in it that I can accept to
> resolve this issue.
Thanks for info :). I wasn't sure what is role of stable-queue git, that's why I
also prepared fix stable-queue.

> thanks,

> greg k-h

Kind regards,
Petr
