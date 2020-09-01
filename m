Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4716258FCE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgIAOGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 10:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgIAN6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 09:58:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C768206EF;
        Tue,  1 Sep 2020 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598968690;
        bh=PdyBXWw82Tl/HvXA2YF+ezE08ACsjgeQ1jgtiO+P8fM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kaYOL0BDsZycU8nAOvyNRp5ylZ3i9O7tLp3TNNN6qA767pwitci3qD63ic6PCOBMO
         2MUgjgPmYX4Hv+qPb5Rb5rEkfTarDDth+PtGUOsHu/zhA+Q99HDtYIImjdx/+Gl3xg
         x6gCi0SGzSTeRU6h33LsQHKxGsyS7ncv8uaqL3JU=
Date:   Tue, 1 Sep 2020 15:58:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v5.4 0/6] Build time improvements
Message-ID: <20200901135838.GC397411@kroah.com>
References: <20200826162828.3330007-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 05:28:22PM +0100, Matthias Maennich wrote:
> Hi,
> 
> please pick up the following patches for 5.4.
> 
> Those are build time optimizations for kernel/gen_kheaders.sh, and - by
> removing bashisms - dropping the dependency to /bin/bash.
> 
> In addition, this enables build time improvements across the tree by optionally
> allowing to use alternative implementations for various compression tools, e.g.
> GZIP=pigz.
> 
> The documentation-only change is not strictly necessary, but keeps
> kernel/gen_kheaders.sh in sync with mainline.

Looks good, now queued up, thanks.

greg k-h
