Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89834823DB
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfHERS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfHERS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 13:18:56 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A4CB20880;
        Mon,  5 Aug 2019 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565025536;
        bh=7FgdwxmBcW7VdTEvDEF7l/bTa0iUiuqsyuzt1pSCX3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mp0PTeraXcLpRiLPTPGiwxiJp1ya8KiOxBIRnfH4GgKAzw2mVFFDXTOjn4ih/KMR8
         ENOt1r2RgrCPjf+Ue2B5QWi1pKe9fLXXXAT0BniZjNYAtbCWhTeCc10uDmclpJh3kA
         8wZHeO8hpHx4WFEJoaQ7z6UjNAttxak+c0hkg5h0=
Date:   Mon, 5 Aug 2019 18:18:52 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     catalin.marinas@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: FAILED: patch "[PATCH] arm64: cpufeature: Fix feature comparison
 for" failed to apply to 4.4-stable tree
Message-ID: <20190805171851.7pjvjv5qek4sbfqb@willie-the-truck>
References: <156498316752100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156498316752100@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 07:32:47AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Backport posted to:

https://lore.kernel.org/stable/20190805171308.19249-1-will@kernel.org/T/#t

Will
