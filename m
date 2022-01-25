Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D7149AF9B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454231AbiAYJMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454515AbiAYI7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:59:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D721C0613E8;
        Tue, 25 Jan 2022 00:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A724B8105C;
        Tue, 25 Jan 2022 08:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAF6C340E0;
        Tue, 25 Jan 2022 08:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643099278;
        bh=xw1QE15+0S8j/XaNcx1Ogqunn1Ho4bz8P34h+mouc9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tEeyBrRXu1vG2/j1Y37YPds3ekrnZI6gCg08I28PQqKeW3XJK0pR38Etu0YHn1fQ3
         i5mFZ5czCIk2W4HhHw1BNUWoYxX/5sx/hX1cCtJ0UO3xAgxfFAEf5i1/U1hXTBO4Lz
         KxXDQHTU34FSDubi+Jlg3NyKZZU68d7VHyNlZJ1k=
Date:   Tue, 25 Jan 2022 09:27:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Akira Yokosawa <akiyks@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.16 0728/1039] scripts: sphinx-pre-install: Fix ctex
 support on Debian
Message-ID: <Ye+0jERrG9b27oha@kroah.com>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184149.801920838@linuxfoundation.org>
 <ba541d48-826c-3d39-b3e1-05642fa6edd6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba541d48-826c-3d39-b3e1-05642fa6edd6@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 07:48:39AM +0900, Akira Yokosawa wrote:
> Hi Greg,
> 
> On Mon, 24 Jan 2022 19:41:57 +0100,
> Greg Kroah-Hartman wrote:
> > From: Mauro Carvalho Chehab <mchehab@kernel.org>
> > 
> > [ Upstream commit 87d6576ddf8ac25f36597bc93ca17f6628289c16 ]
> > 
> > The name of the package with ctexhook.sty is different on
> > Debian/Ubuntu.
> > 
> > Reported-by: Akira Yokosawa <akiyks@gmail.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Tested-by: Akira Yokosawa <akiyks@gmail.com>
> > Link: https://lore.kernel.org/r/63882425609a2820fac78f5e94620abeb7ed5f6f.1641429634.git.mchehab@kernel.org
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This "Fix" is against upstream commit 7baab965896e ("scripts:
> sphinx-pre-install: add required ctex dependency") which is
> also new to v5.17-rc1.
> 
> So I don't think this is worth backporting to stable branches.

Now dropped from all trees, thanks!

greg k-h
