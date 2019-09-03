Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D1FA7147
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 19:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfICRDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 13:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfICRDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 13:03:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5D420870;
        Tue,  3 Sep 2019 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567530229;
        bh=bUxrgGlb8IHuXCYAMMq77/WS81cga4wFl4/4NHV4vUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OHKxoV8KAhi5j/+jXWiyEvFrA4baZFbh5q/p80iksz40TIwAQH7c/RXWhKo52vBlJ
         896IW37U3vdTzP4AddqJjMiST0edVTl3lJX1xhlGZi0AtwvLaNZE3PbT2TwVVgP6sH
         U74lxkE6ropWeeWaoWiaRHE3jgt9Sub63wsQyZAg=
Date:   Tue, 3 Sep 2019 19:03:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH AUTOSEL 4.19 044/167] drm/amdgpu: validate user pitch
 alignment
Message-ID: <20190903170347.GA24357@kroah.com>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-44-sashal@kernel.org>
 <7957107d-634f-4771-327e-99fdd5e6474e@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7957107d-634f-4771-327e-99fdd5e6474e@daenzer.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 06:40:43PM +0200, Michel Dänzer wrote:
> On 2019-09-03 6:23 p.m., Sasha Levin wrote:
> > From: Yu Zhao <yuzhao@google.com>
> > 
> > [ Upstream commit 89f23b6efef554766177bf51aa754bce14c3e7da ]
> 
> Hold your horses!
> 
> This commit and c4a32b266da7bb702e60381ca0c35eaddbc89a6c had to be
> reverted, as they caused regressions. See commits
> 25ec429e86bb790e40387a550f0501d0ac55a47c &
> 92b0730eaf2d549fdfb10ecc8b71f34b9f472c12 .
> 
> 
> This isn't bolstering confidence in how these patches are selected...

The patch _itself_ said to be backported to the stable trees from 4.2
and newer.  Why wouldn't we be confident in doing this?

If the patch doesn't want to be backported, then do not add the cc:
stable line to it...

greg k-h
