Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C2B261141
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgIHMYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 08:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbgIHL4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 07:56:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67B72067C;
        Tue,  8 Sep 2020 11:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599566094;
        bh=MLbB+MGwr/r5a0jx3JnLPatiU4On+aPxTZ/schrAPb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAijrfA70TLd2SlHXaPJ7sJAG2b3/itt6wTJkQ9xzFwtj9xstl1hwVKhAvEnYhTXX
         nT6c2aribxoYEyWLw2ee+agJ+24B1WaYjoa7se3qUTwLH8zr9WxA6oA8Y7Vnmd5KOH
         IFHKJKT4NpDrV3A4iWY4YidN6r/Se+41BPyNMr84=
Date:   Tue, 8 Sep 2020 13:55:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Huacai Chen <chenhuacai@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: Re: [PATCH v2] Revert "ALSA: hda: Add support for Loongson 7A1000
 controller"
Message-ID: <20200908115506.GA1624115@kroah.com>
References: <1598348388-2518-1-git-send-email-yangtiezhu@loongson.cn>
 <s5hsgcb59gw.wl-tiwai@suse.de>
 <CAAhV-H5V5adhY2OjJLxW7x3zDaHGgBxxy45hjf22+qMSEBQuww@mail.gmail.com>
 <bf50515b-a018-a66d-188a-4901428e66a6@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf50515b-a018-a66d-188a-4901428e66a6@loongson.cn>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 11:09:31AM +0800, Tiezhu Yang wrote:
> On 09/08/2020 08:37 AM, Huacai Chen wrote:
> > Hi, all
> > 
> > This patch should be backported to 5.4.
> 
> Hi,
> 
> Commit 61eee4a7fc40 ("ALSA: hda: Add support for Loongson
> 7A1000 controller") has been not yet merged into 5.4, so no
> need to backport.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sound/pci/hda/hda_intel.c?h=v5.4

It showed up in 5.4.62, so yes, it does need to go there.

thanks,

greg k-h
