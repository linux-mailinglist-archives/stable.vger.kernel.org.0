Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8918EB657B
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfIROH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 10:07:28 -0400
Received: from foss.arm.com ([217.140.110.172]:42558 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfIROH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 10:07:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F399E1000;
        Wed, 18 Sep 2019 07:07:27 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B15A3F67D;
        Wed, 18 Sep 2019 07:07:27 -0700 (PDT)
Date:   Wed, 18 Sep 2019 15:06:51 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: vmd: Fix config addressing when using bus
 offsets
Message-ID: <20190918140644.GA7301@e121166-lin.cambridge.arm.com>
References: <20190916135435.5017-2-jonathan.derrick@intel.com>
 <20190918110800.18D9021920@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918110800.18D9021920@mail.kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 11:07:59AM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,

It also contains a Cc: stable tag :)

> fixing commit: 2a5a9c9a20f9 PCI: vmd: Add offset to bus numbers if necessary.
> 
> The bot has tested the following trees: v5.2.15, v4.19.73.
> 
> v5.2.15: Build OK!
> v4.19.73: Failed to apply! Possible dependencies:
>     0294951030eb ("PCI/VMD: Configure MPS settings before adding devices")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

You should take into account the Cc: stable tag requests, namely v5.2+.

Thanks,
Lorenzo
