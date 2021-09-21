Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DB54136F1
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 18:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhIUQGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 12:06:52 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:45390 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229804AbhIUQGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 12:06:51 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 995D2181EBA21;
        Tue, 21 Sep 2021 16:05:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 8BF172EBFBD;
        Tue, 21 Sep 2021 16:05:21 +0000 (UTC)
Message-ID: <92f0b360da8483f9ec904aedd188d2ef55e95c34.camel@perches.com>
Subject: Re: [PATCH 5.10 116/122] bnxt_en: Convert to use netif_level()
 helpers.
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Date:   Tue, 21 Sep 2021 09:05:20 -0700
In-Reply-To: <YUn/5hEyI9//stlU@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
         <20210920163919.617145875@linuxfoundation.org>
         <5662a5175932e46febd024cadc4bece443aa92c0.camel@perches.com>
         <YUn0iDB21QnjtXaX@kroah.com>
         <0a25e9c5ff70899369134be4fdd609d2ee21baed.camel@perches.com>
         <YUn/5hEyI9//stlU@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.06
X-Stat-Signature: k8gzaw7m3nqcfcixiedqjxb4q77oosg9
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 8BF172EBFBD
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18QkzUf7YNI+LFm8oyk90YZh9/dfdHqom0=
X-HE-Tag: 1632240321-556633
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-09-21 at 17:53 +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 21, 2021 at 08:49:52AM -0700, Joe Perches wrote:
> > On Tue, 2021-09-21 at 17:04 +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Sep 21, 2021 at 07:30:42AM -0700, Joe Perches wrote:
> > > > On Mon, 2021-09-20 at 18:44 +0200, Greg Kroah-Hartman wrote:
> > > > > From: Michael Chan <michael.chan@broadcom.com>
> > > > > 
> > > > > [ Upstream commit 871127e6ab0d6abb904cec81fc022baf6953be1f ]
> > > > > 
> > > > > Use the various netif_level() helpers to simplify the C code.  This was
> > > > > suggested by Joe Perches.
> > > > 
> > > > There isn't an actual change here.
> > > > 
> > > > Unless this is a precursor to another patch, this isn't anything
> > > > that should go into stable.
> > > > 
> > > It is a dependancy for other fixes.
> > 
> > Then it's useful/necessary to mark it as such when applying it.
> > 
> 
> That's hard/difficult/messy to do :)

Smiley faces don't make the work you do any easier.

Nor better.

You are specifically pulling dependencies.
It doesn't seem particularly difficult to script.

