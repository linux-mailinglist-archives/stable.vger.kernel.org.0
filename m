Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0142C998C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgLAIcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:32:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgLAIcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:32:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57D120659;
        Tue,  1 Dec 2020 08:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606811515;
        bh=u/ml9V6i+CYqQZIGDcomh+UUsEBn1X6fslNie7QVxLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1+XCq+6UNhd7Jf5B2kTrJ/NnK0MttJp787elvg4mgKD33DU8DFNuWkSvv2NKM4SB
         IbKd7koJlzQSoHa1x/bFkfe3Fqg03njm6wioH754mQMYD2k7Pq4XrVCFy1Y0YNSCQh
         QYdEm8akvAS/vZ5Bxg0snXscwaOV3UlPu94abvW0=
Date:   Tue, 1 Dec 2020 09:33:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     fdmanana@suse.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix lockdep splat when reading
 qgroup config on mount" failed to apply to 4.4-stable tree
Message-ID: <X8X/w27tJFrWMbhW@kroah.com>
References: <16065665063666@kroah.com>
 <20201130170230.qqlrytbd6yfsxukw@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130170230.qqlrytbd6yfsxukw@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 05:02:30PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sat, Nov 28, 2020 at 01:28:26PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Applied, thanks.

greg k-h
