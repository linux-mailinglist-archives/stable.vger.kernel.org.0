Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E4366CC3
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240953AbhDUN1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:27:19 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59713 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238455AbhDUN1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:27:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 51DD51E43;
        Wed, 21 Apr 2021 09:26:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 21 Apr 2021 09:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Uirgx6kYJJn5vp34mmlGXzN32U/
        aQTUucg5cNo0J12Y=; b=c+uPXeostgEKeXKK5o7zLqIdqPlMCD3kDr/zVPK4/LV
        z06losLpgcmqQFcG11ZQ4dh+dvWDq/NYJqdFIFCCjWEJQnevyGPY7PtcGb9UrtkN
        qryyNbIc37hxPkHXFBTMe6wYRvSMeP1PehyBL5miqQTyKPKrwB4H7oTi+4NRgwLa
        NHyUmyMj0uRunMCcaPx+qYaR+xwn2QpZV/kcojetM1jT9JqKp8j5MKc7MNp9Nx1b
        ptZnQWVReA3cHdbxSkLBBMoS8JWfjbA1/f79U5S4gYyRpzBZcKFITfa3MJK2nKec
        fY6nKih5rRtgnzgsdjZN05dv9ZfzZ7KbnUHFz06Rt9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Uirgx6
        kYJJn5vp34mmlGXzN32U/aQTUucg5cNo0J12Y=; b=C5p6nvSsy3K1yRwcZic/N/
        FH3oo8Ak/Qi50YR3fAJ+1KJP0dfhHCvLMdM+44wgxWMpy1WR+Vl28mfxxayWB8l4
        uuxlSebubuJVaee42Xa4S/st33uFuqhlBTCcmS5JKYwSjQcGDVOThgg6NkIVCIWN
        pQpUF331ljzalbH8K3/XvPMkRGJyIgzNB2LClWn2wAeYMb/meQNPzrdb7GPkf/3N
        ohTZGlxfJGAZHBscQBQftp1ewX4qzRJ97NTqrzfRVUflxLzgs3R8onee5mCOFIYx
        p/ijZSSCtredAfyAs8CLBZBaHHp5m4IQXcXCJBC5Pw2oiKq4cP7Qhzqu4VTOo/Mg
        ==
X-ME-Sender: <xms:FSiAYNsweoZ_gJCOE9VYmTJvpwd8VNi63ykiZiiCyC5DmQFCvplPng>
    <xme:FSiAYGerxUVckOBY0lno4QrdQdOURwRb-vTdwbSdaSwLtCaDtt8_MwUT7OkuvpwQq
    -BhPo7-OaSsLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:FSiAYAzdfJmlxaUoCPEuVTn4POjrRAJcvso9OTopzot6OObI4EXfGg>
    <xmx:FSiAYENStvzTYokdQNpJrBKXzivi5m3OMjyXNWmuJlEoiVra2eBVCg>
    <xmx:FSiAYN_8kJPeOS-pyAPGqsM4P5vMmg7HdnuvPpWxT4ciMcz01TcLXA>
    <xmx:FSiAYCJEl_Ld1OZWq-ZKZZZuhD_ODPETBlHUqa9_qQuR_3FvyvYk4A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6AA60108005B;
        Wed, 21 Apr 2021 09:26:45 -0400 (EDT)
Date:   Wed, 21 Apr 2021 15:26:43 +0200
From:   Greg KH <greg@kroah.com>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/2] fix userspace access on arm64 for linux 5.4
Message-ID: <YIAoE9fDfw18Z1oQ@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <YHGMWBj+DEW+EiQE@kroah.com>
 <e99e851a-07c3-ab83-0d10-fa2bb87a516d@amazon.com>
 <YHVH2uNBTVDsJ66m@kroah.com>
 <66f9c439-13d1-1392-0d20-0c48fb9fdd60@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66f9c439-13d1-1392-0d20-0c48fb9fdd60@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 04:04:12PM +0300, Zidenberg, Tsahi wrote:
> 
> 
> On 13/04/2021 10:27, Greg KH wrote:
> > On Mon, Apr 12, 2021 at 10:46:41PM +0300, Zidenberg, Tsahi wrote:
> >> The original bug that I was working on: command line parameters don't
> >> appear when snooping execve using bpf on arm64.
> > Has this ever worked?  If not, it's not really a regression that needs
> > to be fixed, just use a newer kernel version, right?
> It's not so much a regression between old and new kernels, as it is
> a regression when changing architectures. The same API works on x86,
> but not on arm64 (in x86 - you can access userspace with a kernelspace
> access).

What API are you talking about here?

Different CPU architectures support different things.  Some do not
support ebpf at all, is that a regression?  No.

> Multiple Linux distributions support both x86 and arm64, and some of
> these choose to keep with 5.4 LTS Linux kernel. I think these
> distributions should expect the same experience across architectures.

Since when has that ever been a requirement of Linux?

That is not a requirement of the stable kernel trees either, please see
our very simple set of rules.

still confused as to what you are trying to do here,

greg k-h
