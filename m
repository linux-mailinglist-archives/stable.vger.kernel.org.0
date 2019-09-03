Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8D2A73DE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfICTp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfICTp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:45:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61EBE2087E;
        Tue,  3 Sep 2019 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567539927;
        bh=6rDGf6Mr2PWH+edV87q7LtUbadgXTDv9RgfsX/XKqn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jw3H8NWSRa/rp7Tx15FaQOmdJ42hgPL1DfPKDvlJtMeuGY3Dg6vh3yf8D4795tj5m
         tI59r7Ki98NrvwlFHhIZ6Bx15f1w2DWv8YOHeEZ/koehoD56ZFPYbTSK0ngOX9DVfi
         MAIVxuFzvhWu76lGqTl8bZoIzPrXfYJEXGunY9Z8=
Date:   Tue, 3 Sep 2019 15:45:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-snps-arc@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 111/167] signal/arc: Use force_sig_fault
 where appropriate
Message-ID: <20190903194526.GH5281@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
 <20190903162519.7136-111-sashal@kernel.org>
 <87ef0xqq9f.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87ef0xqq9f.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 11:49:16AM -0500, Eric W. Biederman wrote:
>Sasha Levin <sashal@kernel.org> writes:
>
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> [ Upstream commit 15773ae938d8d93d982461990bebad6e1d7a1830 ]
>
>To the best of my knowledge this is just a clean up, no changes in
>behavior are present.
>
>The only reason I can see to backport this is so that later fixes could
>be applied cleanly.
>
>So while I have no objections to this patch being backported I don't see
>why you would want to either.

This patch along with the next one came in as a dependency for
a8c715b4dd73c ("ARC: mm: SIGSEGV userspace trying to access kernel
virtual memory").

--
Thanks,
Sasha

