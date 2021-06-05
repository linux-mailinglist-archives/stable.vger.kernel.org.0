Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E656439CA1A
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhFERH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 13:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhFERH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 13:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51E7A61418;
        Sat,  5 Jun 2021 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622912758;
        bh=fmWyoypvW3fPUSv173csHffvcTtKlC7QUujd2CkF/MI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=He3r5GiDS9qSvf93LMekqeOM7+/g/LW3ais8ANjjjYOScPwLKzZsg/LWuvMJLb+f+
         uFZOzZZtrnyKTmE4fm6HHKDKrH2ZZxU2HznNEj9hWmKUm8XtTHXL0ujachId3dH3IS
         vbeZFBWVqrVzC/ubCYpMMe+AdbAOX7mrwGY3anzc=
Date:   Sat, 5 Jun 2021 19:05:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 235/252] ALSA: usb-audio: scarlett2:
 snd_scarlett_gen2_controls_create() can be static
Message-ID: <YLuu8eFJ7oXFHRIg@kroah.com>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130705.983881838@linuxfoundation.org>
 <20210605134222.GA28479@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605134222.GA28479@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 05, 2021 at 03:42:22PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: kernel test robot <lkp@intel.com>
> > 
> > [ Upstream commit 2b899f31f1a6db2db4608bac2ac04fe2c4ad89eb ]
> > 
> > sound/usb/mixer_scarlett_gen2.c:2000:5: warning: symbol 'snd_scarlett_gen2_controls_create' was not declared. Should it be static?
> > 
> > Fixes: 265d1a90e4fb ("ALSA: usb-audio: scarlett2: Improve driver startup messages")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/r/20210522180900.GA83915@f59a3af2f1d9
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> We normally require real, legal names for commit authors and
> signoffs. I guess it is a bit late now, but... we don't take
> pseudonyms so we should not take robots.

We have long-taken patches from the kernel test robot, this is not
something new.
