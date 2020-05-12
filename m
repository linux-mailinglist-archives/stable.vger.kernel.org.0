Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3360C1CFA57
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgELQPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 12:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgELQPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 12:15:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45FE7206B7;
        Tue, 12 May 2020 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589300112;
        bh=R28qCJs9sngYkbd2X2itboMkmEzGTtAiJcOV+NLeUkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EU89zcxeVHirRVhsViccssGEee9i7tMrDskPgq+sQ9hYrI8RjAYrMtGMn6idU1Gl1
         cZnSAi+UlgECj8iaIrZ5VTf2nV9JjKdnL62+wZOTqf4ORs4Vcnq3jbHi0MuIi15ciT
         jOlX84twDzT27sJJKIdtZM+9Zs7LnHAAFu1N4Czg=
Date:   Tue, 12 May 2020 18:15:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.14-stable] Security fixes
Message-ID: <20200512161510.GA697590@kroah.com>
References: <5b5c9da70a78bd84900199153a417dba43ba3c32.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b5c9da70a78bd84900199153a417dba43ba3c32.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 03:26:00PM +0100, Ben Hutchings wrote:
> Here are some fixes that required backporting for 4.14.  All of them
> are already present in later stable branches.

Thanks for these, all now queued up.

greg k-h
