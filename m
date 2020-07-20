Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECCA225D75
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgGTLaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 07:30:16 -0400
Received: from foss.arm.com ([217.140.110.172]:37644 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbgGTLaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 07:30:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AFCC106F;
        Mon, 20 Jul 2020 04:30:15 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F7DD3F66E;
        Mon, 20 Jul 2020 04:30:14 -0700 (PDT)
Date:   Mon, 20 Jul 2020 12:30:08 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Nicolas Chauvet <kwizart@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pci: tegra: Revert raw_violation_fixup for tegra124
Message-ID: <20200720113008.GA25297@e121166-lin.cambridge.arm.com>
References: <20200717213510.171726-1-kwizart@gmail.com>
 <20200717215304.GA775582@bjorn-Precision-5520>
 <CABr+WTkJ8jZDkM_=-LYxpbrqrsPEb96YBRJvBjR5u+0Ck9R4CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABr+WTkJ8jZDkM_=-LYxpbrqrsPEb96YBRJvBjR5u+0Ck9R4CQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 09:02:59AM +0200, Nicolas Chauvet wrote:
> Le ven. 17 juil. 2020 à 23:53, Bjorn Helgaas <helgaas@kernel.org> a écrit :
> >
> Thanks for the quick review. I've addressed all comments and I've
> resubmitted a v2 to
> https://www.spinics.net/lists/linux-pci/msg96863.html
> Unfortunately I've missed to modify the [Patch v2] tag. I hope this is
> fine. Let me know if I need to resend.
> 
> > Is v5.4.x really the oldest kernel that should get this fix?  It looks
> > like 191cd6fb5d2c appeared in v5.3.
> The commit was introduced in 5.3 indeed. I've added 5.4.x since it's
> the last maintained kernel from long term branches.
> Now I'm using the Fixes: tag, I've dropped the version of the kernel
> for stable as it seems duplicate and less accurate.

I have applied this patch to pci/tegra, thanks.

Lorenzo
