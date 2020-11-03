Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B000A2A4F56
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 19:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgKCSta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 13:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgKCSt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 13:49:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682062074B;
        Tue,  3 Nov 2020 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604429369;
        bh=eFnlY2lTBk3LPIoYXWPFok0OkwLeC9Cp15kAiPARqRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6sjtRSUlFN6VVoqPCP/XoZOfol3j1IHqveZ7FDaPCzx4JgM66I+M6Lb+N72YzOgL
         YRPJvlOUyEiybatBxi/rbiQZYu/cR6iFCuft8qG1VNnXcJGYbm1FQojFHilvckVjKU
         FqesS0B9O7C7kXS6+cslCHLkt51/i6nURktCyRXs=
Date:   Tue, 3 Nov 2020 19:49:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 0/7] backports of upstream fixes for stable
Message-ID: <20201103184925.GB173459@kroah.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 11:28:55AM -0500, Alex Deucher wrote:
> These commits failed to apply cleanly to stable so I have
> cherry-picked them from Linus' tree and fixed up the conflicts.
> The original uptream commit is referenced in the commit message
> as I used cherry-pick -x.

What stable tree(s) should these go to?

thanks,

greg k-h
