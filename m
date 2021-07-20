Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACAD3D0498
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 00:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhGTVp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 17:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhGTVpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 17:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22506101B;
        Tue, 20 Jul 2021 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626819961;
        bh=N/QVPaoMJEJ5+FFJpuBm9gxMMZrk9cnFnG+T9svgsmg=;
        h=Date:From:To:Cc:Subject:From;
        b=ZTY2JHE6nB8vAT3ikPBbw9hDct1zHKz27pU55/OvgoHOTUpFGja4sbPsvjeVVs2YC
         Qeb1pirpFc+ld2Os7hJFuUyxbRZuDtldEmJ4kHfUJzWDrF8v1xOAd38A7xX3Z0YY+u
         aUVCsPhqPgdAzRlB25m5+WPtF+wML+GwC0q/R1ePKJTfpV/+2ez7f8BUdXXDQdJOIP
         FvSAN1HhoxnEUrcIuETkYpRGDZoVmWKCe6fCEskURGXclWnaZpZQ83Hs8UkUBQhbzY
         WBR1a4NmgQN6YHtAic0QaiK8q9f6nV4X7ryooqOLX1U4fcifz3ikmIOWCIRtJUXK4x
         KHhtLYGdsIYtQ==
Received: by pali.im (Postfix)
        id 55325871; Wed, 21 Jul 2021 00:25:59 +0200 (CEST)
Date:   Wed, 21 Jul 2021 00:25:59 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        stable@vger.kernel.org
Subject: Backporting armada-3700-rwtm-firmware DTS changes to stable kernel
Message-ID: <20210720222559.k4zoqr2rk62pj7ky@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg & Sasha, I would like to ask you for your opinion about
backporting DTS patches to stable kernel which allows usage of hwrng on
Marvell Armada 3700 devices.

Driver is already part of 5.4 kernel, just DTS bindings are not there.
I do not know if such backport is suitable for stable kernels. In file
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
is written that "New device IDs and quirks are also accepted" where
"device id" could mean also small DTS change...

What do you think? Question is about these 3 small commits:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=90ae47215de3fec862aeb1a0f0e28bb505ab1351
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=46d2f6d0c99f7f95600e633c7dc727745faaf95e
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a52a48973b355b3aac5add92ef50650ae37c2bd
