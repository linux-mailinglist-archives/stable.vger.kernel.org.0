Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0600D3CB76D
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 14:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhGPMmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 08:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232554AbhGPMmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 08:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37469613DF;
        Fri, 16 Jul 2021 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626439159;
        bh=sf7LWRgVPm5dnVMRrnEm4AVC13smq5Y8WZ1Y4D4mg0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsHZrR3Rmz3Xzatv+ZkHBiGqKP2S/tCZHX1aEQ/m8ZjN4PGExm4hWUm2FgfDEeRxz
         BwtuXhzaURDWgSZrE+vPkGTomlwDkKxtwc8JlSpOssXZ/f+ODeF2egWRpOhg8GBAZ9
         Xa0zkDscFQDeyl8qqGXvP/fMunWkdnYxVlXvhaZw=
Date:   Fri, 16 Jul 2021 14:39:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 5.10 140/215] mm,hwpoison: return -EBUSY when migration
 fails
Message-ID: <YPF99NfnI39AMjn6@kroah.com>
References: <20210715182558.381078833@linuxfoundation.org>
 <20210715182624.294004469@linuxfoundation.org>
 <20210716095243.GA12505@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716095243.GA12505@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 11:52:43AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Oscar Salvador <osalvador@suse.de>
> > 
> > commit 3f4b815a439adfb8f238335612c4b28bc10084d8
> 
> Another format of marking upstream commits. How are this is number 8
> or so. I have scripts trying to parse this, and I don't believe I'm
> the only one.

You aren't just searching for the full sha1?  Anyway, added back the
"upstream" word...
