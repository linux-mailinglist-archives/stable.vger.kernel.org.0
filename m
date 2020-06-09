Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778391F3B3B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 14:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgFIM4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 08:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgFIM4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 08:56:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56532064C;
        Tue,  9 Jun 2020 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591707370;
        bh=+VryJQNxBWFkv8bTOekG/WnjLqz8V0x6+guPU02MGxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sTrAAGOEV2VsmInG5ZAcOt2AoE3vMJVilEDKOnlBcXtUTbS1JERhsgVLJQe4Mu/cT
         bgSxD3AlMUu//uObVFFOSEC7r/Uydq1+/G0Q426lu4C/1MJJHt0yYI1v4zKmhTmbJZ
         wcVQhY+rcnsoRqByLAl5KdYeUbW5lapmcimokXdw=
Date:   Tue, 9 Jun 2020 14:56:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH v2] scripts/spelling: Recommend blocklist/allowlist
 instead of blacklist/whitelist
Message-ID: <20200609125607.GB827447@kroah.com>
References: <20200609122549.26304-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609122549.26304-1-sjpark@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 02:25:49PM +0200, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> This commit recommends the patches to replace 'blacklist' and
> 'whitelist' with the 'blocklist' and 'allowlist', because the new
> suggestions are incontrovertible, doesn't make people hurt, and more
> self-explanatory.
> 
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  scripts/spelling.txt | 2 ++
>  1 file changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
