Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD4209D78
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 13:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404273AbgFYLaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 07:30:18 -0400
Received: from gofer.mess.org ([88.97.38.141]:56613 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404267AbgFYLaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 07:30:17 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id DBCF7C6383; Thu, 25 Jun 2020 12:30:14 +0100 (BST)
Date:   Thu, 25 Jun 2020 12:30:14 +0100
From:   Sean Young <sean@mess.org>
To:     Greg KH <greg@kroah.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
Message-ID: <20200625113014.GA24273@gofer.mess.org>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
 <20200623191334.GA279616@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623191334.GA279616@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 09:13:34PM +0200, Greg KH wrote:
> On Fri, Jun 05, 2020 at 09:24:57AM -0700, Florian Fainelli wrote:
> > Hi all,
> > 
> > This long patch series was motivated by backporting Jaedon's changes
> > which add a proper ioctl compatibility layer for 32-bit applications
> > running on 64-bit kernels. We have a number of Android TV-based products
> > currently running on the 4.9 kernel and this was broken for them.
> > 
> > Thanks to Robert McConnell for identifying and providing the patches in
> > their initial format.
> > 
> > In order for Jaedon's patches to apply cleanly a number of changes were
> > applied to support those changes. If you deem the patch series too big
> > please let me know.
> 
> Now queued up,t hanks.

Sorry about the delay getting this reviewed. I've spent the morning going
through them and it looks good. Of the all the dvb ioctl, only the
FE_SET_PROPERTY and FE_GET_PROPERTY ioctls need special handling and this
series fixes that.

Belated,

Reviewed-by: Sean Young <sean@mess.org>


Sean
