Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE08E08A0
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 18:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbfJVQVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 12:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731132AbfJVQVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 12:21:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E58A2084B;
        Tue, 22 Oct 2019 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571761282;
        bh=XiJYRU7ajMJtwOUS07fTbPUY1C7bg5g690IkU7ds5TU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQ8AeNxBRvLieUvX9+acz3sqz9PT1lwMHX0K7LNAoiiN13Uy19cU6/WyVhsThXjr4
         S4Vq8hcs0Uq8bDWDeW/iA1lyMTMlWlsG/EBkBul0gvsuXQog+veyGUlyFw4gogB1d3
         GOP2KEET6CQNVR4twehPfrap50oa/rGZm1PyiIGA=
Date:   Tue, 22 Oct 2019 12:21:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     stable@vger.kernel.org
Subject: Re: Two MIPS fixes backport
Message-ID: <20191022162121.GA31224@sasha-vm>
References: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 22, 2019 at 12:49:50AM +0800, Jiaxun Yang wrote:
>Hi stable folks,
>
>Here are backports of some MIPS fixes failed to apply to stable
>tree recently, please take them.

I've queued it up, thanks!

-- 
Thanks,
Sasha
