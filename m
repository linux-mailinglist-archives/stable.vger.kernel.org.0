Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C8425BE68
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgICJZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 05:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgICJZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 05:25:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28BA3206C0;
        Thu,  3 Sep 2020 09:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599125157;
        bh=1qLuh4C0lY1AtWSacfumdAnrXtxtJ3GknJ6aSYAaKdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSJQTasMRckHmzdu8nh3w5f525dMvfZDoPDh0NxJ8Kcv2MXugwPez/60NyBIWd4uk
         LG59DeR31S64XHJFu25CuSIgRSFZzo9RLyo8jnDH7ktBWqzEi1KP/gs3bkKzh7MR1A
         HmcFDvqzcrtpH0mN+1HXQCFt6H0dbIEsA/qWe+Uo=
Date:   Thu, 3 Sep 2020 11:26:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Burton <paul.burton@mips.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 4.19 66/81] MIPS: Disable Loongson MMI instructions for
 kernel build
Message-ID: <20200903092621.GB2220117@kroah.com>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214845.344235056@linuxfoundation.org>
 <20200826210628.GA173536@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200826210628.GA173536@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 02:06:28PM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Wed, Oct 16, 2019 at 02:51:17PM -0700, Greg Kroah-Hartman wrote:
> > From: Paul Burton <paul.burton@mips.com>
> > 
> > commit 2f2b4fd674cadd8c6b40eb629e140a14db4068fd upstream.
> > 
> > GCC 9.x automatically enables support for Loongson MMI instructions when
> > using some -march= flags, and then errors out when -msoft-float is
> > specified with:
> > 
> >   cc1: error: ‘-mloongson-mmi’ must be used with ‘-mhard-float’
> > 
> > The kernel shouldn't be using these MMI instructions anyway, just as it
> > doesn't use floating point instructions. Explicitly disable them in
> > order to fix the build with GCC 9.x.
> > 
> 
> I still see this problem when trying to compile fuloong2e_defconfig with
> gcc 9.x or later. Reason seems to be that the patch was applied to
> arch/mips/loongson64/Platform, but fuloong2e_defconfig uses
> arch/mips/loongson2ef/Platform.
> 
> Am I missing something ?

I don't know, sorry, that would be something that Paul understands.

Paul?


