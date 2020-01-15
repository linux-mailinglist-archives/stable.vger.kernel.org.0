Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBBC13C6EC
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgAOPGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:06:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbgAOPGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 10:06:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A81B2187F;
        Wed, 15 Jan 2020 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579100794;
        bh=nmcQ4INQ0vr/EuJwiCwf353BYx2T8xs8cdyU/nH2zlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dw/oxCVt0RnqgpqYxmBXu/gk4R227oHrtiA5nDasUyT9jgJ8Cw8ZcZoUjY/QSL+1k
         V2EmqquMUkOQFXVzaKcwrijnxKJPdJdL52wlFJNLriq5l6lBreAtGnkc1JgpWstC+Q
         1BXuXSU+2G26j6DINuyuEGQke5ml4OBfsoB7VhGY=
Date:   Wed, 15 Jan 2020 16:06:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.4-stable] Mostly security fixes
Message-ID: <20200115150631.GA3740793@kroah.com>
References: <c5186fdbe5fd36cb4b6bd9021c4149f39b490a1a.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5186fdbe5fd36cb4b6bd9021c4149f39b490a1a.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 09:11:20PM +0000, Ben Hutchings wrote:
> Some more fixes that required backporting for 4.4.  All these fixes
> are related to CVEs though some of them don't seem to have any security
> impact.

That's a nice way of saying "these CVEs are crap" :)

Anyway, thanks for digging through them all, that's a thankless job.

All now queued up for this, 4.9, and 4.14 mboxes that you sent.

greg k-h
