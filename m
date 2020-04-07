Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D6F1A0FAA
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgDGOxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgDGOxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 10:53:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AD1E20747;
        Tue,  7 Apr 2020 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586271201;
        bh=Xd7Rnw+CWDD6+E/dRk88F9Xam/sSAiajsiR/6TQ9CqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vdejVhiIeu02/tlJANr0PBUl0mu1Nma+5P2lTvj4fQ20+ZMaXyrf947PFGHlIfhh+
         uV8onxDdAet+sRcGyKeHZhTRN5oJ3X3cdxSyQcfHJ3zossQ1gs7Pzu4EEvRhoFnfEQ
         1/OOQLNqF/ALB0z6t7+0eIrc6AKxkHiS9GS4C7p8=
Date:   Tue, 7 Apr 2020 16:53:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Commit aa9f7d5172fa ("mm: mempolicy: require at least one nodeid
 for MPOL_PREFERRED") for stable
Message-ID: <20200407145317.GA892934@kroah.com>
References: <19632ce1-bd85-9bf4-e76a-e3abfb11a4dd@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19632ce1-bd85-9bf4-e76a-e3abfb11a4dd@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 07:41:43AM -0700, Guenter Roeck wrote:
> Hi,
> 
> please consider commit aa9f7d5172fa ("mm: mempolicy: require at least one nodeid
> for MPOL_PREFERRED") for stable releases. It does fix a real problem, even though
> the CVE assigned to it (CVE-2020-11565) may be a bit bogus.
> 
> I verified that the patch applies cleanly all the way to v4.4.y.

Thanks, now snuck in.

greg k-h
