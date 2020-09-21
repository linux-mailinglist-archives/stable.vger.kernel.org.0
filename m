Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FE6272B57
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgIUQNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgIUQNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:13:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F94206FB;
        Mon, 21 Sep 2020 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600704789;
        bh=SyOBGRRsEJIy/iG5Ru9Ljmr5yF6UNlVZHHHNw5T7bzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RwGAA+3p+AelYMV5NUOMwLMOMSiM9M11pVOCKKjc6SZdzVepmCg/5RZElW5NtJIws
         6evFNx2ZR8IVG08KFHRTqBj00KgzMBB/9K8G4Wfoih32fYZljFxju4rP72p9YC2FXj
         nBxJodfNhnyroYWKNx6TDSbYMZWolumHQpTPb5ao=
Date:   Mon, 21 Sep 2020 18:13:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Yi Zhang <yi.zhang@redhat.com>, stable@vger.kernel.org,
        chaitanya.kulkarni@wdc.com, sashal@kernel.org
Subject: Re: Please apply commit "64d452b3560b nvme-loop: set ctrl state
 connecting after init" to 5.8.9+
Message-ID: <20200921161331.GD1096614@kroah.com>
References: <16579579.1342431.1600270596173.JavaMail.zimbra@redhat.com>
 <1955465429.1342553.1600270677594.JavaMail.zimbra@redhat.com>
 <20200917143425.GF3941575@kroah.com>
 <32a2f419-d29d-4835-3eb4-34c9b01191c1@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a2f419-d29d-4835-3eb4-34c9b01191c1@grimberg.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 11:50:27AM -0700, Sagi Grimberg wrote:
> 
> > > Hi,
> > > 
> > > Please apply [1] to stable 5.8.9+, as it fixed nvme-loop connecting failure issue[2].
> > > 
> > > [1]
> > > 64d452b3560b nvme-loop: set ctrl state connecting after init
> > > 
> > > [2]
> > > https://lists.linaro.org/pipermail/linux-stable-mirror/2020-September/216482.html
> > 
> > So the "Fixes:" tag in the commit lies?
> > 
> > I would like to get an ack from the maintainers/developers on that patch
> > before I queue it up.
> 
> Acked-by: Sagi Grimberg <sagi@grimberg.me>
> 
> This went in citing the wrong git hash, our mistake.
> 
> Actually, the cited offending commit had a fixes tag itself that
> goes back further[1]... Which means that this needs to go with that,
> what's the procedure to take this along with that one?
> 
> [1]:
> 73a5379937ec ("nvme-fabrics: allow to queue requests for live queues")
> has:
> Fixes: 35897b920c8a ("nvme-fabrics: fix and refine state checks in
> __nvmf_check_ready")

I don't understand, is there some other commit you also want backported?
If so, just let us know what it is, and how far back to take it.

thanks,

greg k-h
