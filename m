Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D991D0023
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgELVIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 17:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgELVIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 17:08:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A09C20659;
        Tue, 12 May 2020 21:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589317701;
        bh=F+2WbWtzZmspGMo3quzTGNs6ARRecftvye2TAGk7HSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WopJ5WYLsFeJZNzAyj1nG6KtYYxUCdVdXf6nMtOJstIMAPWAS5nmj/1H2KqRjB3ij
         W9hSIQe47U5NG31jLfif9KSnHcj94ZJa7m1wIIFz/lrIU2cutWyRURAoiJWMkWfEG5
         eo5PwLgwHnw5lO+mqIBIs8zayqBW/ehbxiWA+xk8=
Date:   Tue, 12 May 2020 17:08:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please apply Revert "serial/8250: Add support for NI-Serial
 PXI/PXIe+485 devices
Message-ID: <20200512210820.GA29995@sasha-vm>
References: <CACRpkdb3WrEp1uvzMUGebtdXYPv5sMNF_gd5_zcB+=n3P48GQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACRpkdb3WrEp1uvzMUGebtdXYPv5sMNF_gd5_zcB+=n3P48GQg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 10:03:30PM +0200, Linus Walleij wrote:
>Hi Stable folks,
>
>please apply commit
>27ed14d0ecb38516b6f3c6fdcd62c25c9454f979
>Revert "serial/8250: Add support for NI-Serial PXI/PXIe+485 devices"
>also to the stable tree.
>
>My Fedora cannot switch baudrate or write to my serial port and
>that makes me so sad.
>
>I have this problem with kernel v5.6.11.

Hey Linus,

Are you sure about the commit? 27ed14d0ecb3 ("Revert "serial/8250: Add
support for NI-Serial PXI/PXIe+485 devices"") was merged upstream in
v5.5.

-- 
Thanks,
Sasha
