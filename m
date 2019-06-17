Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00DE6479BD
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 07:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfFQFmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 01:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfFQFmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 01:42:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCF092189F;
        Mon, 17 Jun 2019 05:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560750136;
        bh=17xLqZ/9BBNtYazO6siyKMf+ed4hKL2wnyPhFJCFhGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WjYCxv6vx8d9lWtpFnXv3QP0VI2hCn+tG0ChOvzkXqr3UHpKQeXbURDISsqxH8195
         g1Wv+PISVwvvcEnNRakSw3n0U0r0gNwgeD8abpwzkdciGzhx/LDXRNbq2VqrdyPT4s
         cnDFunR1WDHMWhPFUiYdIQ42q1t2Q8kAfnZeGB9Y=
Date:   Mon, 17 Jun 2019 07:42:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Murray McAllister <murray.mcallister@gmail.com>,
        stable@vger.kernel.org, linux-graphics-maintainer@vmware.com,
        thellstrom@vmware.com
Subject: Re: [PATCH] Backport commit 5ed7f4b5eca1 ("drm/vmwgfx: integer
 underflow in vmw_cmd_dx_set_shader() leading to an invalid read") to
 linux-5.1-stable
Message-ID: <20190617054213.GA3524@kroah.com>
References: <20190616055740.4055-1-murray.mcallister@gmail.com>
 <20190616235757.GA2226@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616235757.GA2226@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 16, 2019 at 07:57:57PM -0400, Sasha Levin wrote:
> On Sun, Jun 16, 2019 at 05:57:40PM +1200, Murray McAllister wrote:
> > Commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in
> > vmw_cmd_dx_set_shader() leading to an invalid read") upstream.
> > 
> > Commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in
> > vmw_cmd_dx_set_shader() leading to an invalid read") resolved
> > an integer underflow when SVGA_3D_CMD_DX_SET_SHADER was called
> > with a shader ID of SVGA3D_INVALID_ID, and a shader type of
> > SVGA3D_SHADERTYPE_INVALID.
> > 
> > (The original patch failed to apply cleanly in 5.1-stable
> > as VMW_DEBUG_USER does not exist here.)
> 
> What about 4.19 and 4.14?

I already applied it everywhere (even 4.9.y and 4.4.y) :)

thanks,

greg k-h
