Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5281DC6B6
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 07:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEUFvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 01:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgEUFvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 01:51:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E95332070A;
        Thu, 21 May 2020 05:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590040297;
        bh=Rtkz2ylQVv6h6oBytaVU2Lhg5ManWTW+r0G1k4QNU+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/8WE8/sCetP9At5nHVGa5rViTycuE26l8J/iqRgmhE6SYcR8pefI/5GHHKdSmQOk
         hiBZTgpc6sB8j/ycpbTkBAMJk8R+9qMQwQpa/kMJ93r+af+wvbufrWZP21VA0M49C5
         UcXpp/7aHl8MpDycMpDOy4mCoCMJL9B/D7xOQSYQ=
Date:   Thu, 21 May 2020 07:51:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Vincent Chen <vincent.chen@sifive.com>, stable@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Yash Shah <yash.shah@sifive.com>
Subject: Re: [PATCH 4.19.y] riscv: set max_pfn to the PFN of the last page
Message-ID: <20200521055135.GC2330588@kroah.com>
References: <20200520223843.236080-1-palmerdabbelt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520223843.236080-1-palmerdabbelt@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 03:38:44PM -0700, Palmer Dabbelt wrote:
> From: Vincent Chen <vincent.chen@sifive.com>
> 
> commit c749bb2d554825e007cbc43b791f54e124dadfce upstream.
> 

<snip>

Now queued up, thanks.

greg k-h
