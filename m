Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5468C2003F5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgFSIbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731502AbgFSIbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:31:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC0020776;
        Fri, 19 Jun 2020 08:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592555474;
        bh=8b+F2qz2lQigLcx2Jh+LtvcWbw/Bpdd1Ks+911pAKNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VbJR8iFL/rDCPnGNK0hr2fGVN8ddrl/sw26r9erzJUheKgaCd7xzlbkC7+kgO2FGo
         wjgoF5PWRbFJ1Xaks4HgTBij3FTSnGzhcysdL2xjNJRj9h5CJHBdaUpEm0hJQAYaR1
         754GIp7AkpatIDm1gmA99jDBt5E9Z/y+qcMehMk8=
Date:   Fri, 19 Jun 2020 10:18:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: Please apply commit 9453264ef586 ("media: go7007: fix a miss of
 snd_card_free") to v4.9.y up to v5.4.y
Message-ID: <20200619081827.GB73176@kroah.com>
References: <20200606135720.GA1832951@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606135720.GA1832951@eldamar.local>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 06, 2020 at 03:57:20PM +0200, Salvatore Bonaccorso wrote:
> Hi
> 
> Could you please apply 9453264ef586 ("media: go7007: fix a miss of
> snd_card_free") to v4.9.y up to v5.4.y stable series? The fix is
> related to CVE-2019-20810.

cves for memory leaks on error cleanup paths that no one has ever been
able to trigger?  Hah, yet another reason to hate cves...

I'll go queue this up now, thanks.

greg k-h
