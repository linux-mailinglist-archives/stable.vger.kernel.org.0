Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AFC15749C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgBJMc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgBJMc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:32:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70F120661;
        Mon, 10 Feb 2020 12:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581337947;
        bh=xUNAYD/1ZVUppS6eKOwQ8M5jHZgr9KTjMJLNjGKtO0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2vDTrzQcb96UxXrm7iORdRcE1D2sNiunDm6elsKCHcdrjcbwF9T2oJmR3GyQ2vhG
         84xn22Q1/y7qW/Cg9b1rKTCDPB7MZoTCbTY+4Zil5BHoS7bM6ORmqMA73+7x1G8ozr
         qu+5UG9prt+/tjA+6cDh8+PJ2PWkW9Jb37xok+Do=
Date:   Mon, 10 Feb 2020 04:25:27 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Stephen Warren <swarren@nvidia.com>, treding@nvidia.com,
        Sasha Levin <sashal@kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: clk: tegra: Mark fuse clock as critical - build failed on
 4.4-stable tree
Message-ID: <20200210122527.GB413013@kroah.com>
References: <CA+G9fYt1d+kyNkqzaSMO2D9X4EbmU6dq+Qaw2VC_2B7xxdb3Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt1d+kyNkqzaSMO2D9X4EbmU6dq+Qaw2VC_2B7xxdb3Jg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 11:49:52AM +0530, Naresh Kamboju wrote:
> This patch caused build failed on stable rc 4.4 branch for arm64
> Juno-r2 device and arm beagleboard x15 device
> 
> commit bf83b96f87ae2abb1e535306ea53608e8de5dfbb upstream.

THanks for letting me know, I've now dropped it from the tree.

greg k-h
