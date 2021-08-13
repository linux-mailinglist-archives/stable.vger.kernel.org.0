Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F294C3EB6B5
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240021AbhHMO3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 10:29:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231683AbhHMO3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 10:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3540060FC4;
        Fri, 13 Aug 2021 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628864943;
        bh=/cqNzACPqcBS0pfC83RuYUywEKTsSl1LDOlFMkxJ5Gg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=fY0uNgdOiK+nbEdRejR9hT+lQnGMKKlCJe7FdZ2ejJumGUTrw0hBLNPmiHtKK7UTT
         HJJJWilUuP9H7va2On823//UJJZXkYmzj0eMhyKvFHx6MOVfrlt9yRxQbb/M/2j5JG
         TIC6TFOIwMXCU0NlHYeGHLQ8ysgw9Vk3OpI57xsNiCVyLsXwXpO863Q6Hcz55HcS/l
         7G63JbyyydwhaFtgGOB3Eygt4eytjxsJ1iFciEgC29pf0gGJHrrcqW7c/W7ZmQPonp
         Noz7HUmyp8fLHHhf3pXXEcmYhyjQWMnpcTkIDQ6HF51Uk/O3RxgeqTz42W6fNPoZcI
         AF98CiaqzKCmA==
Date:   Fri, 13 Aug 2021 09:29:01 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI/sysfs: Use correct variable for the legacy_mem sysfs
 object
Message-ID: <20210813142901.GA2574831@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRYrDQ3yuvtLtoKr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 10:19:25AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 12, 2021 at 12:14:50PM -0500, Bjorn Helgaas wrote:
> > On Thu, Aug 12, 2021 at 11:17:12AM -0500, Bjorn Helgaas wrote:
> > > [+to Greg, please update sysfs_defferred_iomem_get_mapping-5.15]
> > 
> > Actually, Greg, totally up to you, but if nobody else is depending on
> > the sysfs_defferred_iomem_get_mapping-5.15 branch, another possibility
> > would be for you to drop that branch and for me to merge the two
> > patches on it + Krzysztof's fix below + (hopefully) Krzysztof's PCI
> > static attribute work.
> 
> I can not "drop" the branch as it is already merged into my
> driver-core-next branch that I can not rebase.  I could revert it, but
> is that really needed?

Nope, I don't think a revert is warranted.  I'll take care of getting
Krzysztof's fix into v5.15.

Bjorn
