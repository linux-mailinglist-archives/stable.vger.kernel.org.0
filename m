Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09FE2D5D34
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbgLJOKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgLJOKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:10:23 -0500
Date:   Thu, 10 Dec 2020 15:10:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607609382;
        bh=Y8zQm7tt3tR3f4WekmTR3O+BzFBKhjMeCn4N80P7tlM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=RYRhHsT88RUbIDmuiyniIP+tC3j+lpylV1jt0KjBGwNNsqo48IKssAwyQobd8Fdyo
         FPUWCp5n4dAIUwNxEsX+LdY+Zkfi1UlUMPgj+3OKnNK4wJXO/pPC0y2A0vYQuHTI1S
         bo25J6qjipKgbyPMD+Qg78/hF7VBxWnMSI8KvQVc=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/insn-eval: Use new
 for_each_insn_prefix() macro to loop" failed to apply to 5.9-stable tree
Message-ID: <X9IscFka1aS5N6f2@kroah.com>
References: <1607503687153242@kroah.com>
 <20201210135103.hwvk6inj4t3bqinq@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210135103.hwvk6inj4t3bqinq@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 01:51:03PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Dec 09, 2020 at 09:48:07AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will apply to all branches till 4.19-stable.

Thanks, now queued up!

greg k-h
