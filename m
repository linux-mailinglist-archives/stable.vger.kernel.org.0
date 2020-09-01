Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304E2258A25
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 10:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgIAIOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 04:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgIAIOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 04:14:18 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051B6206CD;
        Tue,  1 Sep 2020 08:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598948058;
        bh=cvvx6pMHEUqt1jAoCrPznLjt+GLoFLr866bA7ElvqFc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=yGEv2I3JcTia1x43JmcS0QzPA7kfpoZYSu/R3oNmscAtk8LUkB6uouZC8neuN7z7A
         nl20gA5HnBru5GzCZTz6Re0CLOkIKiXqEPcnfU7RJ4LnPPVOwzCQM+Es/B96ANKeon
         +QWtzqJb8Q98YlC4A28q5ZWPxNawXKjf2UtLrCcs=
Date:   Tue, 1 Sep 2020 10:14:15 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] HID: core: Correctly handle ReportSize being zero
In-Reply-To: <20200829112601.1060527-1-maz@kernel.org>
Message-ID: <nycvar.YFH.7.76.2009011013400.4671@cbobk.fhfr.pm>
References: <20200829112601.1060527-1-maz@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 29 Aug 2020, Marc Zyngier wrote:

> It appears that a ReportSize value of zero is legal, even if a bit
> non-sensical. Most of the HID code seems to handle that gracefully,
> except when computing the total size in bytes. When fed as input to
> memset, this leads to some funky outcomes.
> 
> Detect the corner case and correctly compute the size.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks Marc; Benjamin will be pushing this patch through his regression 
testing machinery, and if all is good, I'll push it for 5.9-rc still.

-- 
Jiri Kosina
SUSE Labs

