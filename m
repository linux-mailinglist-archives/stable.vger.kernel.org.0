Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E096A19C900
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 20:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbgDBSpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 14:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389488AbgDBSpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 14:45:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F16206E9;
        Thu,  2 Apr 2020 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585853147;
        bh=25PZuHcQOM/khfH6hQ4zWQhPeXPFzFQZrnW7/IS6Ma0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dP8H4NOI22QV8A47s3Ibx8gyKAp9PSRZ/w5R9vnvnjCOnmzIuGmFnBrE1zK+PDqMA
         ohy8xRvHGk5mQfg85c3PIa00Zed9byc8Is0ZFPyjKNI2kOXQufLF96VJnec2bBrzWi
         8XRovQfEAugPUgXByFwbTQ6zBL2EhWlwThk7HFGw=
Date:   Thu, 2 Apr 2020 20:45:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr
Subject: Re: [PATCH 0/2] [backports] l2tp use-after-free fixes for 4.9 stable
Message-ID: <20200402184535.GB3235262@kroah.com>
References: <20200402173158.7798-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402173158.7798-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 06:31:56PM +0100, Will Deacon wrote:
> Hi Greg,
> 
> Syzbot has been complaining about KASAN splats due to use-after-free
> issues in the l2tp code on 4.9 Android kernels (although I reproduced
> with latest 4.9 stable on my laptop):
> 
> https://syzkaller.appspot.com/bug?id=3c27eae7bdba97293b68e79c9700ac110f977eed
> 
> These have been fixed upstream, but for some reason didn't get picked up
> for stable. This series applies to 4.9.y and I'll send patches for 4.4.y
> separately as there are a few dependencies to deal with over there.

Thanks, both now queued up.

greg k-h
