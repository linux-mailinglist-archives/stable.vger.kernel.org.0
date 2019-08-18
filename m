Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F6B918E3
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 20:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfHRSdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 14:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfHRSdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 14:33:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD0232086C;
        Sun, 18 Aug 2019 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566153188;
        bh=Gqov0ByldLScgcrqzd/H8gBTaJeTe4Uu8ql0g/Y44TY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZMq9w3enldGraaysVpNPovwHqa1IbCnT9dvyjZ0YkNJczIWGixIqn9pmKArODJdd
         QJoS1XQNYUhWfE6LNEK/CD1wKX+K+vGNp4x+cvGoI0U3O9IkQJUIPXb2+poTMtbweZ
         Qj+/yw51IEzUH/m81azXCBIu+27oFaT23trsMnog=
Date:   Sun, 18 Aug 2019 20:33:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>
Subject: Re: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Message-ID: <20190818183305.GA1181@kroah.com>
References: <20190818155941.GA26766@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818155941.GA26766@eldamar.local>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 05:59:41PM +0200, Salvatore Bonaccorso wrote:
> Hi
> 
> In Debian bug https://bugs.debian.org/934331 ran into issues which
> match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
> underlying storage no longer supports it").
> 
> This commit was CC'ed to stable, but only got applied in v5.0.8 (and
> later on backported by Ben Hutchings to v3.16.72).
> 
> Mike, I have not checked how easily that would be for older stable
> versions, but can the backport be considered for versions down to 4.9?
> Apparently Ben did succeed with some changes needed. To 4.19 it should
> apply with a small conflict in drivers/md/dm-core.h AFAICS.

If someone sends the backports to the list, I will be glad to queue them
up.

thanks,

greg k-h
