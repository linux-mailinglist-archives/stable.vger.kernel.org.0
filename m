Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2735FA1A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 15:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfD3N1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 09:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbfD3N1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 09:27:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3552075E;
        Tue, 30 Apr 2019 13:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556630822;
        bh=4XdzAcRsDKkW7ykl2QVhnp1muxwN5c29ClMoyZNsEyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NA+02PKU1WhmSTkI2sWjWXaaS8VGAffUyMIWQSu62tFyq9jQ48zM/6jAuvY/9nB8p
         cTskXlSZdinVA2JR0reMJ5kL/+dzWGwUf597LbZxRS0ntsi4DywyfZdCFre41Aa89t
         T1wf5ZvGDPogc2eAszNm6gH7Bi2QaI6XIBrTjl/U=
Date:   Tue, 30 Apr 2019 15:27:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Major Hayden <major@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190430132700.GA12407@kroah.com>
References: <cki.6C208109D9.WGQF5P41NS@redhat.com>
 <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
 <20190430130331.GA6937@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430130331.GA6937@sasha-vm>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 09:03:31AM -0400, Sasha Levin wrote:
> Hello CKI folks,
> 
> A minor nit: the icon added before the subject text gets filtered out on
> the textual email clients most of us use, and ends up appearing (at
> least for me) as 3 spaces that cause much annoyance since it gets
> confused with mail threading.


Really?  It's just a "normal" emoji character, perhaps you need a better
email client or terminal window?  :)

What are you using that you can't see this in a terminal?
