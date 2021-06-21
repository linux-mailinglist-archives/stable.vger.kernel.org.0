Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D873AF44E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 20:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhFUSIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 14:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhFUSGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 14:06:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039FF61026;
        Mon, 21 Jun 2021 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298630;
        bh=9UmRKuIrKLD7pyb8e44hkKOHX2PG55IouaELL+bZ5+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eiOjGrw//nB9LWVr1JO+6r3gwgLJ7S3P/WnWTa6AeE5PGYnc2bWiZpY7/G79BjnhO
         RgjPMyEu5Tvs1Ujtea0r1Ny1Vmz1LE8zka32D6P/EseIHUrunQ2Svp/D7K4vMd62N7
         9zob/WfMgtSbbS4rzeZb1TxnzMOMo9yNdQd+tO+QzgnD4tyzOucz5w/tsjtU/r1XR7
         atG96rWNgfUC63oQjIgf+uFh7J3xRQ7/AV98tktu8fYQFfjgqM+//alhFjde6j/LAu
         v6xnFP1acXml0QSlsfCNuVKahpln7nc7jEGDVHquqT8lG2dsOfT6WQ4ujszao4LH+x
         VLom0W/D6COFQ==
Date:   Mon, 21 Jun 2021 14:03:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 02/33] regulator: max77620: Silence deferred
 probe error
Message-ID: <YNDUhXWIgtOjf/8M@sashalap>
References: <20210615154824.62044-1-sashal@kernel.org>
 <20210615154824.62044-2-sashal@kernel.org>
 <20210615155436.GM5149@sirena.org.uk>
 <YM8633R356GXEwoR@sashalap>
 <20210621104042.GB4094@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210621104042.GB4094@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 11:40:42AM +0100, Mark Brown wrote:
>On Sun, Jun 20, 2021 at 08:55:59AM -0400, Sasha Levin wrote:
>> On Tue, Jun 15, 2021 at 04:54:36PM +0100, Mark Brown wrote:
>> > On Tue, Jun 15, 2021 at 11:47:53AM -0400, Sasha Levin wrote:
>> > > From: Dmitry Osipenko <digetx@gmail.com>
>
>> > > One of previous changes to regulator core causes PMIC regulators to
>> > > re-probe until supply regulator is registered. Silence noisy error
>> > > message about the deferred probe.
>
>> > This really doesn't look like stable material...
>
>> Not strictly, but we usually take fixes to issues that can confuse users
>> or spam logs.
>
>I really don't think this is appropriate (and don't know that it's even
>relevant without the core change mentioned in the commit log).

Oh, I misunderstood your previous mail. Now dropped, thanks!

-- 
Thanks,
Sasha
