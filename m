Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1FF1A07B0
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGGwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 02:52:20 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45565 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgDGGwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 02:52:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 45FDE6A3;
        Tue,  7 Apr 2020 02:52:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 07 Apr 2020 02:52:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=VnZixAcAV+VvdCuDr09IqmEOF+J
        YKHYuBulHUlCgYuk=; b=TaIMA9ZQgg/1AK728uU80EWY0Dzy/7NdX4fFQ8Ep0LA
        ZAB0fmL+QqCgUoiQkRPAUNt3noL9PV7j0A2PDHHJPX+OV3ZiljBrZsrZK6t6BEP1
        lZb/MknPowHEpc2m8GFiwSv+uzIsLlJ6jvW8Ga6O3OQ7CUZE+5M+JFgnEtawB2IJ
        IRxiAoNS2JzTilWYVSaO0yug78Zz6vqkm+uEFqUJOq3zHR7bqszKIiCg8jalAHjl
        TCs7Ms4vqdObeokHk1sBcud5N3LV37zWLrYNf7I0ijLMxipc+kBBY8a2pYOUPL7h
        GCQJNQovuRRy5ydldgYBSEsQuhX/JUBKMTC1gxskuoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VnZixA
        cAV+VvdCuDr09IqmEOF+JYKHYuBulHUlCgYuk=; b=q6QAn03e0wbs4PwIN0sUj1
        UiWWbWlm5ns3yYXKUi8jbFpsQDl2lumg319cpXyTVoqKdC+0kiLz3UeeJCiET7bE
        JuxNGXHPHz9z7TQCzX6CJ2D8vKVh74oZGn8w3ln/AdokD6q+UdFU9SWbc2Eo8qPF
        JRwBShWv7dYTwzFXckkHT7dQ/EzKSUxJJJ1b+azOCzwPmtNMbPuKamxvzkhLmsTt
        l1PXiZORD99aowdQeDd8BAJlhSIl8M/wWLJ2fQNlzH3Jj3HOn2W9vpwU4nRd2wmL
        RKV7OiwF+h0gDS7sidtb1nBEmJsTYkLWZKkGVBieBQ7mIHDFIus8fbchLlVPwutw
        ==
X-ME-Sender: <xms:ICOMXoB_jVTWE7wA_abyXwAN-_c3rC3qUZN0Fore_Q0G1Ls4uwgcew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ICOMXlqsNjKOd7pwu7022yxd7YpfBhq6hjale40JGRRhQ7O5kBAjRQ>
    <xmx:ICOMXq-C8cMLrB0hNIBDXLKzYbe-3b-GJ99lFDt6AENgHcvHMfECKA>
    <xmx:ICOMXuDMI5uIl8XLVFQYthPLiN0jCprgDCiTCHDqm6I1JQLJGkhQ5w>
    <xmx:ISOMXkQtLndXvwjQVKC2VWc4F-t5aVW1oF7HXaBLmmRSxKocCGK6rQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 933BF306C4E3;
        Tue,  7 Apr 2020 02:52:15 -0400 (EDT)
Date:   Tue, 7 Apr 2020 08:52:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/1] drm/i915: Fix a deadlock that only affects 5.4
Message-ID: <20200407065210.GA263852@kroah.com>
References: <20200407062622.6443-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407062622.6443-1-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 11:26:21PM -0700, Sultan Alsawaf wrote:
> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> Hi,
> 
> There's a mutex lock deadlock in i915 that only affects 5.4, but was fixed in
> 5.5. Normally, I would send a backport of the fix from 5.5, but the patch set
> that fixes the deadlock involves massive changes that are neither feasible nor
> desirable for backporting [1][2][3]. Therefore, I've made a small patch that
> only addresses the deadlock specifically for 5.4.

This paragraph needs to go into the patch itself, otherwise just looking
at that doesn't make any sense.

And you do not need a cover letter for a single patch.

Please fix up and resend.

thanks,

greg k-h
