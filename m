Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C021B94F2
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 03:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgD0B3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 21:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgD0B3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 21:29:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A54912080C;
        Mon, 27 Apr 2020 01:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587950948;
        bh=mxEwlmlNCncbkRyrNi7hx14grVUAmfAQXU/UWRTYlZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zu3JIjzTSa5jmyp2ynPude/p+2B6f6+BBTL97uMdLL5AWGZPly9896CaRmkpKScJA
         uSWJubGXwuJw0Tnf0k18z1Qfy+TJKTQMWhAQvwWNELbGnTgb95FEwtUBUAgE/jrFZJ
         lImTuMk9QY3eVfM93R50fnQ9FKDlXVMIf8rXOfVg=
Date:   Sun, 26 Apr 2020 21:29:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.19-stable] Security fixes for KVM
Message-ID: <20200427012907.GO13035@sasha-vm>
References: <dd9bbb3b4eefec476db8b28ad3044e9abd8450f9.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dd9bbb3b4eefec476db8b28ad3044e9abd8450f9.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 12:52:14AM +0100, Ben Hutchings wrote:
>Here are some fixes that required backporting for 4.19, this time all
>in KVM.  All of them are already present in later stable branches.

Queued up, thanks Ben!

-- 
Thanks,
Sasha
