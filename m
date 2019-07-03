Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA05E2C7
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 13:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGCLZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 07:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfGCLZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 07:25:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF134218A4;
        Wed,  3 Jul 2019 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562153123;
        bh=EIT0LojCR0hbkiCO+xYlqG8Ex0KRw/GU/YQXf6+ddr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QSAKMny+iHnRfFrmUt0WUS7suyVCg/9TJwMhy9voTcq6rYGgQ9WAhnB+0N/6TeWIb
         sG8Y86f+2wzOzLMluflZi+tyEmOvZ8Uvepa0FyH8OHwTz8aj/8tOC3AZH5p1ZYDupH
         377s4EDeL4zwYPjPglZQxP9ex3S8L+OA8e67jeGo=
Date:   Wed, 3 Jul 2019 13:25:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190703112520.GA20712@kroah.com>
References: <cki.3BCD9A354F.JWPY9HGRUT@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.3BCD9A354F.JWPY9HGRUT@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 07:16:58AM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 8584aaf1c326 - Linux 5.1.16
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: FAILED

Guys, this is getting annoying, this is your test systems, the queue is
empty :)

thanks,

greg k-h

