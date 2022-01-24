Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E34982B2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiAXOuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiAXOuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0CCC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 06:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8973B61388
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8ECC340E8;
        Mon, 24 Jan 2022 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643035810;
        bh=Wr2DbBY/UaZYgrth7oRUc0g3WWDKb57ADWn3ehfCTUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVsd6hT65qDpgHNaW2Bz+I9C9bnp3pHm994rNGfnOYa8IBTQNqXxpTULcW+4DUT2i
         AU3UfttInCmuiPs9UehKB20C3fGRmLBVZ51yMJnJiULL9tvT7v+QnQJ3MCujSqxuoh
         qnH+7lZtPtyYPPGCXCT6tNA705W8NR1HjhgA0kCg=
Date:   Mon, 24 Jan 2022 15:50:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     broonie@kernel.org, kai.vehmanen@linux.intel.com,
        ranjani.sridharan@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: sof-audio: setup sched widgets
 during pipeline" failed to apply to 5.16-stable tree
Message-ID: <Ye68n3TJEfqieJS8@kroah.com>
References: <16430327951439@kroah.com>
 <306d7c1b-32e9-7078-cdb9-191165d394b4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <306d7c1b-32e9-7078-cdb9-191165d394b4@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 08:32:26AM -0600, Pierre-Louis Bossart wrote:
> 
> 
> On 1/24/22 07:59, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.16-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Yes, it looks like we've missing two dependencies. the following
> sequence applies on top of v5.16.2
> 
> git cherry-pick 7cc7b9ba21d4978d19f0e3edc2b00d44c9d66ff6
> git cherry-pick b2ebcf42a48f4560862bb811f3268767d17ebdcd
> 
> and then this commit
> git cherry-pick 01429183f479c54c1b5d15453a8ce574ea43e525
> 
> I would recommend adding these three patches to avoid issues with
> dynamic pipelines.

Thanks, all now queued up.

greg k-h
