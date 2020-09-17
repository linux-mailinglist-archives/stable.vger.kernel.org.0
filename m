Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DF626DF0E
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgIQPFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 11:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgIQPFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 11:05:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE225206D4;
        Thu, 17 Sep 2020 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353393;
        bh=5WTcwdT/V9f36FLffxTWE402q7fJtou3VFL2OjTsbtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KgYGG0YOcVZYqSAvGEvxIkBZv+lYa0RfCKYS4uY7LuxKxrr2WsGOTyEb7BJtKBySl
         eBwjh9FhdAfPBH7ag5XVMt5FW3AOwBV6y/60zjLM9bSwZtEpm11KBAzEKkewuoLAEC
         XVN9lcglp+UzQGtkLIr9J6TyLSEoYL1SfgPXRV5w=
Date:   Thu, 17 Sep 2020 16:37:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: Please apply commit 1ed9ec9b08ad ("dsa: Allow forwarding of
 redirected IGMP traffic") to stable
Message-ID: <20200917143705.GI3941575@kroah.com>
References: <CALW65jb8xv2tZPiimQcLHmpzcyhZG3t1HAZG_wdjE9sdXsQxPg@mail.gmail.com>
 <20200916093839.GB739330@kroah.com>
 <CALW65jZvq7_KggV4tOEi9=xFRjid1j+gfCSH7T3T_RSJCky_3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jZvq7_KggV4tOEi9=xFRjid1j+gfCSH7T3T_RSJCky_3g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 11:19:44PM +0800, DENG Qingfang wrote:
> On Wed, Sep 16, 2020 at 5:38 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > What stable tree(s) do you wish to see this applied to?
> 
> 5.4.y and 4.19.y

Now queued up, thanks.

greg k-h
