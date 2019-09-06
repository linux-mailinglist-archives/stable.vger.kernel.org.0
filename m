Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D9BABF7E
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 20:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404838AbfIFSi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 14:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404675AbfIFSi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 14:38:27 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 491F4208C3;
        Fri,  6 Sep 2019 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567795106;
        bh=hVhoaUaPmOU1ZOElqiu41uA2bABUvrV5xk96hEWFkvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OeqCGGKHQzQ4cT1+IU4+3do1YgTnwRgr3pls3NNNAzDXzd4hqR04yONuMCJVsUTgq
         6cm1k3dNYPZGb3GuKQDgVD0u49h4oTyUAVAnnsEuKzItW5Tv8ZBje6YeuYaiIcBQh5
         Y3u0wU/CTejLYAgo74+wghU5b+lpN/yLuGAtAIjw=
Date:   Fri, 6 Sep 2019 14:38:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Ricard Wanderlof <ricard.wanderlof@axis.com>,
        stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: revert: ASoC: Fail card instantiation if DAI format setup fails
Message-ID: <20190906183824.GB1528@sasha-vm>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-40-sashal@kernel.org>
 <20190814092213.GC4640@sirena.co.uk>
 <20190826013515.GG5281@sasha-vm>
 <20190827110014.GD23391@sirena.co.uk>
 <20190828021311.GV5281@sasha-vm>
 <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
 <alpine.DEB.2.20.1909061031200.3985@lnxricardw1.se.axis.com>
 <20190906105824.GS23391@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190906105824.GS23391@sirena.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 06, 2019 at 11:58:24AM +0100, Mark Brown wrote:
>On Fri, Sep 06, 2019 at 10:40:01AM +0200, Ricard Wanderlof wrote:
>
>> But is this being dropped from the master branch as well? To me it makes
>> the kernel behave in an inconsistent way, first reporting a failure to
>> instantiate a specific sound card in the kernel log, but then seemingly
>> bringing it up anyway.
>
>No, this is absolutely a good and positive change to have in
>master and I'm not suggesting that we should drop it there -
>sorry if I sounded like that.  I just want to be conservative for
>stable so that we don't have anyone updating their stable kernel
>and having their audio blow up on them, we don't want to do
>anything that'd discourage people from taking stable updates and
>hence missing out on security or critical stability updates.

Hi Mark,

I'm sorry for not dropping this to begin with: I saw your nack and the
patch ended up still being released because of my fuck up rather than
me purposefuly ignoring your ack, sorry.

However, I'd like to say that I don't agree with it. I understand your
reasoning about keeping the stable trees conservative, but I feel that
going to the extreme with it will just encourage folks to not upgrade
between major versions.

I'd like to think that upgrading major versions should be the same as
upgrading minor ones (because numbers don't matter here). If that's not
the case, let's fix it!

--
Thanks,
Sasha
