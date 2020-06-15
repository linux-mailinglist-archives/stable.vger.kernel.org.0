Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CE31F9FBD
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 20:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgFOS5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 14:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbgFOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 14:57:45 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA94C20656;
        Mon, 15 Jun 2020 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592247465;
        bh=NWVVT6SIA9QCKt9N/o9vk+11N+Glc4ICuhbSSl+eUbs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwlUqB0UM7cQzSe31aMIgP+ifo278pdgwmImImkSPAZS0cQ87Nk3nlskyriixVz2C
         PQMhY9sr6cGeXzoBMILI9673fZlwmwLeA+iCXo5Pp+wn/UYCZ5UVtttpKpCiGfBlIg
         872wHFd8YggsES7Nuj6//LgH1LZ3E0cpgInXyvAQ=
Date:   Mon, 15 Jun 2020 14:57:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     asteinhauser@google.com, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE
 enforcement for" failed to apply to 4.19-stable tree
Message-ID: <20200615185733.GH5492@sasha-vm>
References: <159222803512332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159222803512332@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 03:33:55PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 4d8df8cbb9156b0a0ab3f802b80cb5db57acc0bf Mon Sep 17 00:00:00 2001
>From: Anthony Steinhauser <asteinhauser@google.com>
>Date: Sun, 7 Jun 2020 05:44:19 -0700
>Subject: [PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for
> indirect branches.
>
>Currently, it is possible to enable indirect branch speculation even after
>it was force-disabled using the PR_SPEC_FORCE_DISABLE option. Moreover, the
>PR_GET_SPECULATION_CTRL command gives afterwards an incorrect result
>(force-disabled when it is in fact enabled). This also is inconsistent
>vs. STIBP and the documention which cleary states that
>PR_SPEC_FORCE_DISABLE cannot be undone.
>
>Fix this by actually enforcing force-disabled indirect branch
>speculation. PR_SPEC_ENABLE called after PR_SPEC_FORCE_DISABLE now fails
>with -EPERM as described in the documentation.
>
>Fixes: 9137bb27e60e ("x86/speculation: Add prctl() control for indirect branch speculation")
>Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Cc: stable@vger.kernel.org

This patch now applies fine to all branches after we resolved the issues
with the other IPBP patch.

-- 
Thanks,
Sasha
