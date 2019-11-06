Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFEBF1933
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKFO4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 09:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbfKFO4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 09:56:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B0D217F4;
        Wed,  6 Nov 2019 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573052192;
        bh=f0FWnDoR3oQZauXjJoIsHH8LL28P4DgdG+eGrNGMomI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xuG0xpGhQPsZSPj5qrOlHWpJrKJWTif+3uMJGq+YGhr6Ys/BhjZPrgHD0wXqG4uNY
         GVt7SE5qtGTJEEb4JkFx4nVT02l3Tn78AFyMJMvbibF+9f/3Tg/61JPScSAltxfEuc
         xvHI23SHvQwWfcx/oMpBAjB/qAIF0PE5pWMW6lXA=
Date:   Wed, 6 Nov 2019 15:56:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "net: bcmgenet: soft reset 40nm EPHYs before MAC init" has
 been added to the 5.3-stable tree
Message-ID: <20191106145629.GA3730817@kroah.com>
References: <157305078718623@kroah.com>
 <CA+PBWz0ukwrZw6hmjeJ4xDgPZ0=YaCaVYTAXdUcXqfnpsTrjjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+PBWz0ukwrZw6hmjeJ4xDgPZ0=YaCaVYTAXdUcXqfnpsTrjjw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 06:43:37AM -0800, Doug Berger wrote:
> Please do not apply this patch to the stable trees. It has been superceded
> by a recent patch set and reverted upstream.

So drop this and keep the one after this?  That would be 25382b991d25
("net: bcmgenet: reset 40nm EPHY on energy detect")


thanks,

greg k-h
