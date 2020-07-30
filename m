Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75156232CA8
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 09:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgG3Hh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 03:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG3Hh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 03:37:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9668822B40;
        Thu, 30 Jul 2020 07:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596094647;
        bh=Fu01MgAp+MYvvxre/G7yOLdsa44H/G30VqAD41anYVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DJhPis0nc2Zd4YzmGCSsbY+OwH0/2mO+AeKvlcQBeynI8EARMQDXeoP7Lf7GNYYqZ
         iKxcYx1n5oMF8vyYvIioSy5K6Rlc2d1OLW85twIJZi1AJyW+sAJMJVcuLmF+NAgvRj
         cogllOjgZWQY4PGBuxcI9iJ5iMscuntwnp7fFu7g=
Date:   Thu, 30 Jul 2020 09:37:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH for 4.9 0/4] tools/perf: Backport fixes for 4.9 for newer
 toolchain
Message-ID: <20200730073716.GA4169043@kroah.com>
References: <159352833055.45385.11124685086393181445.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159352833055.45385.11124685086393181445.stgit@devnote2>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 11:45:30PM +0900, Masami Hiramatsu wrote:
> Hi,
> 
> While porting failed perf-probe fix to 4.9.y (*), I found the perf
> command had build errors on Ubuntu 20.04. Fortunately all issues has
> been fixed on the upstream. Thus I ported those patches too on 4.9.y.
> 
> (*) https://lore.kernel.org/stable/159257562524637@kroah.com/
> 
> I think perf tools in other stable branch also has similar issues.
> 
> Thank you,

Sorry for the delay, this, and the 4.4.y series you sent are now queued
up.

greg k-h
