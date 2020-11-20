Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A212BA52A
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgKTIyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgKTIyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:54:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0452B22253;
        Fri, 20 Nov 2020 08:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605862438;
        bh=f4BGBwrIRm8gPS5Jp17Ug2jQVG4S8TaM+ZZVFb8/BF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIEhc+JOWEQlX/0yFRrIOjOaOPQ2FjHWs7tZ4kNSKBDRMV05iLvC7YI978VLJlpwA
         l1smamWHU/kQnmLiw3aX7c8rLV/CQSANaRFPynCEc0f2tbiteUVcwFsZIcFsNb0uUL
         cVj480RNU8sHeFReVHgZ99/gP5QfTnlul3QoYmDQ=
Date:   Fri, 20 Nov 2020 09:54:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     ultracoolguy@tutanota.com, pavel@ucw.cz, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] leds: lm3697: Fix out-of-bound access"
 failed to apply to 5.9-stable tree
Message-ID: <X7eEUWOEl4dl2uvf@kroah.com>
References: <160440470667193@kroah.com>
 <20201118225938.5nvkjdhc4st2zs57@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118225938.5nvkjdhc4st2zs57@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 10:59:38PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Nov 03, 2020 at 12:58:26PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Please consider for 5.9-stable.

Now applied, thanks.

greg k-h
