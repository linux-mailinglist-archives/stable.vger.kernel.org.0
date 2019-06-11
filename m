Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580F03C9DB
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 13:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbfFKLSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 07:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388969AbfFKLSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 07:18:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9858E2080A;
        Tue, 11 Jun 2019 11:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560251900;
        bh=phM6+TBeeBniXxE1ov6BwxUWFA/cunGAbnxaCLfz124=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PgjYKCA+w1l68LAKwBj6UjDiRIkuuuRsvM4wA631DaZ9Cmk94j5z60jtLGmI5N8jW
         cPe6IenMqtaXLiadWU1eFCgzsvruhJUkTMx+qzJIhP/YOwYI5qbUN2uLHf3tI3b8qn
         5XyQ90CtbAu/2Ia+AT3VGbxNQ95awx1+PYzdamWM=
Date:   Tue, 11 Jun 2019 13:18:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport commit ("739f79fc9db1 mm: memcontrol: fix NULL pointer
 crash in test_clear_page_writeback()") to linux-4.9-stable
Message-ID: <20190611111817.GA12260@kroah.com>
References: <1560243467.26425.8.camel@mtkswgap22>
 <20190611103407.GA3486@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611103407.GA3486@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 12:34:07PM +0200, Greg KH wrote:
> On Tue, Jun 11, 2019 at 04:57:47PM +0800, Miles Chen wrote:
> > Hi reviewers,
> > 
> > I suggest to backport commit "739f79fc9db1 mm: memcontrol: fix NULL
> > pointer crash in test_clear_page_writeback()" to linux-4.9 stable tree.
> > 
> > This email reports a NULL pointer crash in test_clear_page_writeback()
> > in android common kernel-4.9. There is a fix ("739f79fc9db1 mm:
> > memcontrol: fix NULL pointer crash in test_clear_page_writeback()") in
> > kernel-4.13.
> > 
> > 
> > commit: 739f79fc9db1b38f96b5a5109b247a650fbebf6d
> > subject: mm: memcontrol: fix NULL pointer crash in
> > test_clear_page_writeback()
> > kernel version to apply to: Linux-4.9
> 
> It does not apply cleanly to the 4.9.y tree, can you provide a working
> backport of it that I can apply?

Also be sure to cc: all of the people involved in that patch (the author
and the cc and signed-off-by list) so they can weigh in if they do not
feel that this patch should be backported to the older kernel.

thanks,

greg k-h
