Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F42F372F08
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhEDRkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhEDRkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 13:40:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19E1E613AA;
        Tue,  4 May 2021 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620149976;
        bh=XJ2u1bX1NnrdTV1iEPcnkilGSFy9urKrKRresNfGFw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xdzQAtCmAmFxWlfNTF+hjpoOfVt1fS1lG8EB6Qyp7cdK4+s3g7FdGm5VryvVsZm7x
         UsoQu8TTuTnrEu8hzkmTu7YMS4/Rv6fTA75rhe4OIaPMtDhMHTqTYmuUWSPitnvPKI
         bAGqL3F+o4XjqEWCCt4jjePxbiWkCOgEGLLuTLMA=
Date:   Tue, 4 May 2021 19:39:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Backport for 5.4 and 4.19, iwlwifi: Fix softirq/hardirq
 disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <YJGG1kJGTM0aS6Fr@kroah.com>
References: <E086D-ihTz8oxFCOfQojcsu3VO58JvDu-mjy-aXhRSgqf2BfyAm-YD5ZKQBbvt0yQOFbGKzf9vtUWGTtNX5qPLNboxTBcUT2mmaEagFCR4Q=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E086D-ihTz8oxFCOfQojcsu3VO58JvDu-mjy-aXhRSgqf2BfyAm-YD5ZKQBbvt0yQOFbGKzf9vtUWGTtNX5qPLNboxTBcUT2mmaEagFCR4Q=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 05:24:33PM +0000, Jari Ruusu wrote:
> iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
> upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e,
> backport for linux-5.4.y and linux-4.19.y (booted and ping tested)
> Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>

Thanks, all queued up now.

greg k-h
