Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC32207A10
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405379AbgFXRSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 13:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405280AbgFXRSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 13:18:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381EC20823;
        Wed, 24 Jun 2020 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593019084;
        bh=Ax//fcbSMExN48RiBbLK9kMUO6mOr+UknHU5vMnnEDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MtcOQsQraL/GlJoxoBSJ/LGVTeUc3+lyvVW2f1wiZ+mcdCjCWrqvcwfKXKnTTkTNn
         Wg8X07QtSeMw8anf2RAhndoSSH3iBxVxb//glhLJr8US14nS8fFnxSBmnBXDVSItco
         EVCLbHW8QuganTYi4EIqJOE6sRRiD6lLA6sIa3E4=
Date:   Wed, 24 Jun 2020 19:18:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: v4.4.y.queue build failure (powerpc:defconfig)
Message-ID: <20200624171801.GA2175151@kroah.com>
References: <20200624170618.GA217333@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200624170618.GA217333@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 10:06:18AM -0700, Guenter Roeck wrote:
> powerpc:defconfig:
> 
> arch/powerpc/platforms/pseries/mobility.c: In function ‘post_mobility_fixup’:
> arch/powerpc/platforms/pseries/mobility.c:330:2: error: implicit declaration of function ‘read_24x7_sys_info’

Found the offending patch and dropped it, thanks!

greg k-h
