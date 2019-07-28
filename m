Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7420B77FD0
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfG1OSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 10:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfG1OSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 10:18:04 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 328A52077C;
        Sun, 28 Jul 2019 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564323483;
        bh=bvucZOHEeigBRhfZ1wa53MCXU4U9VJBVvubbXXY9kQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szFvQQA3xb02kZzIP5StmCP/ZXVpYzjue1tDr7lAecalqv8ATya/Goc6BLx1Gfx4K
         E0dRfXO+01JNrIaeAW9UnKdH1Nb0H5te/Pg0RSA+p1eD8vlvyXaqUTYaoBQ1+P/4On
         g/SEg3MCBk8M0tZjvaQPzNAqYgcDGqtU3QNnJstE=
Date:   Sun, 28 Jul 2019 10:18:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Qian Lu <luqia@amazon.com>
Cc:     gregkh@linuxfoundation.org, tigran.mkrtchyan@desy.de,
        trond.myklebust@primarydata.com, Anna.Schumaker@Netapp.com,
        stable@vger.kernel.org
Subject: Re: Request for inclusion on linux-4.14.y
Message-ID: <20190728141802.GC8637@sasha-vm>
References: <20190726181739.GB31189@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190726181739.GB31189@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 11:17:39AM -0700, Qian Lu wrote:
>Hello Greg,
>
>Can you please consider including the following patch in the stable linux-4.14.y branch?
>
>This is to fix that NFS client incorrectly handling a failed OPEN and ensure that we present the same verifier.
>
>8fd1ab747d2b("NFSv4: Fix open create exclusive when the server reboots")

I've queued it up for 4.14 and older, thanks!

--
Thanks,
Sasha
