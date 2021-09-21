Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E509413681
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhIUPvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:51:24 -0400
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:48688 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234182AbhIUPvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 11:51:24 -0400
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 96DEA18029597;
        Tue, 21 Sep 2021 15:49:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 7AD5B20D778;
        Tue, 21 Sep 2021 15:49:53 +0000 (UTC)
Message-ID: <0a25e9c5ff70899369134be4fdd609d2ee21baed.camel@perches.com>
Subject: Re: [PATCH 5.10 116/122] bnxt_en: Convert to use netif_level()
 helpers.
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Date:   Tue, 21 Sep 2021 08:49:52 -0700
In-Reply-To: <YUn0iDB21QnjtXaX@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
         <20210920163919.617145875@linuxfoundation.org>
         <5662a5175932e46febd024cadc4bece443aa92c0.camel@perches.com>
         <YUn0iDB21QnjtXaX@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 7AD5B20D778
X-Spam-Status: No, score=-0.50
X-Stat-Signature: 9mjfdtoyfq4g5rndkp4wxkdo85b7pinm
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX184PP2mWXNt7D6RFW2niPo1SVtSfonZprs=
X-HE-Tag: 1632239393-264887
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-09-21 at 17:04 +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 21, 2021 at 07:30:42AM -0700, Joe Perches wrote:
> > On Mon, 2021-09-20 at 18:44 +0200, Greg Kroah-Hartman wrote:
> > > From: Michael Chan <michael.chan@broadcom.com>
> > > 
> > > [ Upstream commit 871127e6ab0d6abb904cec81fc022baf6953be1f ]
> > > 
> > > Use the various netif_level() helpers to simplify the C code.  This was
> > > suggested by Joe Perches.
> > 
> > There isn't an actual change here.
> > 
> > Unless this is a precursor to another patch, this isn't anything
> > that should go into stable.
> > 
> It is a dependancy for other fixes.

Then it's useful/necessary to mark it as such when applying it.

