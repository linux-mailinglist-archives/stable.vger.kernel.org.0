Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE43362237
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhDPO3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 10:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbhDPO3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 10:29:15 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74F53C061574;
        Fri, 16 Apr 2021 07:28:50 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id E038592009C; Fri, 16 Apr 2021 16:28:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id D923292009B;
        Fri, 16 Apr 2021 16:28:47 +0200 (CEST)
Date:   Fri, 16 Apr 2021 16:28:47 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Joe Perches <joe@perches.com>
cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
In-Reply-To: <86c10671ff86f96004a6d6c3c08aed3e27d58d0a.camel@perches.com>
Message-ID: <alpine.DEB.2.21.2104161627130.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>  <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>  <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>  <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
 <86c10671ff86f96004a6d6c3c08aed3e27d58d0a.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Apr 2021, Joe Perches wrote:

> > I'm not sure if that complex message 
> > routing via `blogic_msg' is worth having even, rather than calling 
> > `printk' or suitable variants directly.
> 
> It's to allow the message content to be added to the internal
> 	&adapter->msgbuf[adapter->msgbuflen]
> with strcpy for later use with blogic_show_info()/seq_write.

 I know, but it's not clear to me if it's worth it (a potential buffer 
overrun there too, BTW).

  Maciej
