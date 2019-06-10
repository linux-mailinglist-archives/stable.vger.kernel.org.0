Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83A3B6B1
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390550AbfFJOFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390384AbfFJOFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:05:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA33F20679;
        Mon, 10 Jun 2019 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560175531;
        bh=KuTJDH4VWuHHa/K+CZFl0/sgbE8rc4TyaQuaGIu3Fuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IhozKF5dba+wL/G1hpjTdsu2oWPVZgI2havyA7AWQWCPv1VXTXjjPKf2c1cncO8Rg
         q6f8R4BRb38BdlRsGHOKhHfnKTMP/nI4tLbXepRzHz9ochTaNwiYyccgdiBY21POqH
         18vaa0c5R2bVH+2sPANL4IuV7zIOEntlJwfhGWcs=
Date:   Mon, 10 Jun 2019 16:05:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 56/85] doc: Cope with the deprecation of AutoReporter
Message-ID: <20190610140528.GA18627@kroah.com>
References: <20190607153849.101321647@linuxfoundation.org>
 <20190607153855.717899507@linuxfoundation.org>
 <1fbb40df-d420-9f10-34a9-340b3156eb7c@suse.cz>
 <20190610073119.GB20470@kroah.com>
 <f20b3005-53f8-607a-e995-741836b3f5f0@suse.cz>
 <20190610074840.GB24746@kroah.com>
 <20190610063340.051ee13b@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610063340.051ee13b@lwn.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 06:33:40AM -0600, Jonathan Corbet wrote:
> On Mon, 10 Jun 2019 09:48:40 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > Hm, 2.1 here:
> > 	Running Sphinx v2.1.0
> > perhaps Tumbleweed needs to update?  :)
> 
> Heh...trying 2.1 is still on my list of things to do ... :)
> 
> > Anyway, this should not be breaking, if Jon doesn't have any ideas, I'll
> > just drop these changes.
> 
> The fix for that is 551bd3368a7b (drm/i915: Maintain consistent
> documentation subsection ordering) which was also marked for stable.  Jiri,
> do you somehow not have that one?

It's part of this series, which is probably why it works for me.  Don't
know why it doesn't work for Jiri, unless he is cherry-picking things?

thanks,

greg k-h
