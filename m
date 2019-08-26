Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EBD9D926
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 00:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfHZWct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 18:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfHZWcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 18:32:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82DF2080C;
        Mon, 26 Aug 2019 22:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566858767;
        bh=ekJn1ZHa2mqYvuF9e4G0tou57yHn9+myPCgwLU57YXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGsBFI4/K9RZz89i5FyRZzi+M2xOrD/3fPGRKbXEWX4QX79+fgp1Z1yowomD2a4xh
         QxzgL0iGegyTFNsdQ7i9Tu9nJYbjSOwYW899EwBMmzwW28/0UWQ8SpKq9wd67MZ/nv
         QDuOQQgAmcnBxAFpghQwTRmy4W4EtIOYZZBq6bOA=
Date:   Mon, 26 Aug 2019 18:32:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: fs/io_uring.c stable additions
Message-ID: <20190826223246.GN5281@sasha-vm>
References: <06ff6a5e-ecaa-ce53-5db0-6ff6e128c119@kernel.dk>
 <20190826214132.GM5281@sasha-vm>
 <b7419a63-cf1a-7618-0c77-c065aeb0c81e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b7419a63-cf1a-7618-0c77-c065aeb0c81e@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 03:56:27PM -0600, Jens Axboe wrote:
>On 8/26/19 3:41 PM, Sasha Levin wrote:
>> On Mon, Aug 26, 2019 at 02:39:28PM -0600, Jens Axboe wrote:
>>> 500f9fbadef86466a435726192f4ca4df7d94236
>>> a3a0e43fd77013819e4b6f55e37e0efe8e35d805
>>> 08f5439f1df25a6cf6cf4c72cf6c13025599ce67
>>
>> These 3 look okay, but I haven't queued them up as you were explicit
>> with ordering instructions, and as I can't take the first one I'm
>> playing it safe.
>
>Thanks for checking, just these three is what we need for 5.2.

Queued up for 5.2, thanks!

--
Thanks,
Sasha
