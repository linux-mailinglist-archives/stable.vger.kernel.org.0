Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E467BCF2
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfGaJYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbfGaJYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:24:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C9C206A3;
        Wed, 31 Jul 2019 09:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564565056;
        bh=5EeU6yaCY5Pmojy+xtFPPArQoum3TTnMCINory5oUww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zJrg+1GXsvyOoZOhQpFzj222hDAE0d4DPJv7ctckxPOSEfEAj6Qlw3plsDtP+4CgT
         8yyenN5711bFzS0E9ceCpGZNDWz+nQEUzCwJrVkbfpzJZSnVnBjkSvCyStPbJ31eVn
         w4OAjIYQm+Gam4qMnbQCG4oDxUGPO/0JOpsTFaBc=
Date:   Wed, 31 Jul 2019 11:24:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Request vsock and hv_sock patches to be backported for
 linux-5.2.y, linux-4.19.y and linux-4.14.y
Message-ID: <20190731092413.GA18269@kroah.com>
References: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 06:41:10AM +0000, Dexuan Cui wrote:
> For linux-4.19.y (currently it's v4.19.62), 3 patches are missing.
> The mainline commit IDs are:
>         cb359b604167 ("hvsock: fix epollout hang from race condition")

This commit is already in 4.19.63 and 4.14.135 :)

