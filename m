Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6356321F36D
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgGNODb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgGNODb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:03:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F20F22267;
        Tue, 14 Jul 2020 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594735410;
        bh=ItaWtzeKZou397LLEwwUDYq2U/2uSJnhZHcdNJRYguA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HgNnSq2yhQ6Aj7nARD3HAxMHIxs0RdbweDZXxa0SCRfWWvFrxwWmvbTgvhBeLpJWF
         QvMCbiVQDJDbsYPaDp0CbMomVgba9w7XdhzocIK8o35ZpW0fL7WmFPM9wxoA7bDQQ+
         qR16UAwcyMXDdxOHeUD5u/vG5LR6Uz8XCIfvymG0=
Date:   Tue, 14 Jul 2020 16:03:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gordan Bobic <gordan@redsleeve.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: perf: =?utf-8?Q?util=2Fsyscalltbl=2Ec?=
 =?utf-8?B?OjQzOjM4OiBlcnJvcjog4oCYU1lTQ0FMTFRCTF9BUk02NF9NQVhfSUQ=?=
 =?utf-8?B?4oCZ?= undeclared here (not in a function)
Message-ID: <20200714140328.GC1698833@kroah.com>
References: <CAMx4oe34RcVeaA+sz6vFN-CyNtwdPxj+oTBQjWiM4C7iAqnLGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMx4oe34RcVeaA+sz6vFN-CyNtwdPxj+oTBQjWiM4C7iAqnLGw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 11, 2020 at 01:05:43AM +0100, Gordan Bobic wrote:
> I hit this FTBFS earlier today while trying to build the LT 4.19.132
> kernel from source:
> 
> https://lore.kernel.org/patchwork/patch/960281/
> 
> The "quick hack" patch mentioned at the bottom of the thread gets it
> to compile. Is this the correct solution, or is there a better fix? As
> it stands, tools/perf doesn't seem to compile on 4.19.132.

No idea, try asking the perf developers.

thanks,

greg k-h
