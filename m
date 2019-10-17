Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6970DB1AA
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392630AbfJQP7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 11:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390726AbfJQP7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 11:59:36 -0400
Received: from localhost (unknown [192.55.54.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D9321835;
        Thu, 17 Oct 2019 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571327974;
        bh=2CRNB1p1GOnl8ECcjxkKpwficsiVPrm6HqbiYt9a9T8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRi7c2OikBn7ZfVce+efv7hSv5e/IUd+J8B6BGqls5oZNRVoY3b4N5HbOppjdnvJO
         ZLFWTy2V5U8uizihJfafbq5ElQu0D1qoOdKeFFqsv7rlNpfIgTxbNYxYp4XdCtHFl5
         mtnoXaD0eNPX0piXhXJjRSMi32W41jVTLsdwoMdU=
Date:   Thu, 17 Oct 2019 08:59:33 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Erik Schmauss <erik.schmauss@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Garry <john.garry@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 68/81] ACPICA: ACPI 6.3: PPTT add additional fields
 in Processor Structure Flags
Message-ID: <20191017155933.GC1079687@kroah.com>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214846.058277835@linuxfoundation.org>
 <20191017085912.GA8594@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017085912.GA8594@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 10:59:12AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Erik Schmauss <erik.schmauss@intel.com>
> > 
> > Commit b5eab512e7cffb2bb37c4b342b5594e9e75fd486 upstream.
> 
> So this introduces another format of "upstream" information. So far I
> had this:
> 
> 		ma = re.match(".*Upstream commit ([0-9a-f]*) .*", l)
> 		...
>                 ma = re.match("commit ([0-9a-f]*) upstream[.]*", l)

do a case-insensitive search :)

> I believe this information belongs to the signoff area; it is
> important to know who pushed patch to the upstream and who is pusing
> it to the stable.
> 
> Could we just introduce "Upstream: <sha1>" tag and use it? It would
> improve consistency...

It would, I have plans for that, been busy with other stuff...

thanks,

greg k-h
