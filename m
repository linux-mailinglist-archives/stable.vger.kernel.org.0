Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BE41F6660
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgFKLPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgFKLPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:15:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 171342063A;
        Thu, 11 Jun 2020 11:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874148;
        bh=fOA1yxDnKEBeqncib/cVhkxuG/KfEeVCzWAAiHxrsyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E7DG2kuPtc9BoYE7fjaFZGEF4E+xtNJ/FcaS8gmUj2GIJ0X55GTJM6bmpmh7Qpcr3
         d28k6gvXmV4qgvzZjtDs8Ie4yQaLbIh0xwuC22Sd6P5JoWTKcJp2GhOLHYolhXcXUy
         4bNojsTzMZrtbETLtE19pGPGD95CgXURd9rqtAXA=
Date:   Thu, 11 Jun 2020 13:15:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian Cai <jiancai@google.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>
Subject: Re: Cherry pick 51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b
Message-ID: <20200611111542.GF3802953@kroah.com>
References: <CA+SOCL+ntBRGoA2qttMo=bt_VVKJMm8GEq+bfEoVvgq-j-Y1KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+SOCL+ntBRGoA2qttMo=bt_VVKJMm8GEq+bfEoVvgq-j-Y1KA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 01:41:59PM -0700, Jian Cai wrote:
> Hello,
> 
> @Nick Desaulniers <ndesaulniers@google.com>  made a patch
> (51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b) and it was accepted to mainline
> as part of ClangBuiltLinux project to make the kernel compatible with
> Clang's integrated assembler. Please consider cherry picking it back to 5.4
> so that we can use Clang's integrated assembler to assemble ChromeOS' Linux
> kernels.
> 
> 
> commit 51da9dfb7f20911ae4e79e9b412a9c2d4c373d4b
> Author: Nick Desaulniers <ndesaulniers@google.com>
> Date:   Thu Jun 4 16:50:49 2020 -0700
> 
>     elfnote: mark all .note sections SHF_ALLOC
> 

Now queued up,t hanks.

greg k-h
