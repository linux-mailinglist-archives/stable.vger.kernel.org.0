Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7895D255D1B
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 16:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgH1OxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 10:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgH1OxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 10:53:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3564207DF;
        Fri, 28 Aug 2020 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598626392;
        bh=+nq3CRvheOQU+5630aawMkQ6zj16ut4Bm0WRDnH9mgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ps5hkknnCIadnIPZQwxPg/tbVMcPp4Yxmbi7Yn7W6XL7VgXTE5rHxiGT1VsNBHeg6
         1s9MMhFpQGr2VIiv1VTKEtOhcv+TGy6jaU9REIHW9b3m9CH0vWsTz5gss4DJDSC/+e
         DLkliswSjDcYQgBae5ZiMzI62iEBSGm/n1m5zHCI=
Date:   Fri, 28 Aug 2020 10:53:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Stable inclusion request, 5.7
Message-ID: <20200828145310.GR8670@sasha-vm>
References: <00c75f42-f71e-2455-272d-d6efc715f299@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <00c75f42-f71e-2455-272d-d6efc715f299@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 08:40:24AM -0600, Jens Axboe wrote:
>Hi,
>
>Can you cherry-pick this one:
>
>commit e697deed834de15d2322d0619d51893022c90ea2
>Author: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>Date:   Wed Jun 10 13:41:59 2020 +0800
>
>    io_uring: check file O_NONBLOCK state for accept
>
>into 5.7-stable? Thanks!

5.7 is dead :)

-- 
Thanks,
Sasha
