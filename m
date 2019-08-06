Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE09F83B0C
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfHFV1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfHFV1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:27:55 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1CB52075B;
        Tue,  6 Aug 2019 21:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565126875;
        bh=DbNlRjFU6udh+wspdL7JjVNlgRe6HKjA4flfIy/gTKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bAIoN5TKPEUYK+1rl46l0NQ1JIfRDLI9d28wpBpobqvtQV6jtrFvGIA5S6PYxgmjW
         EGGxgn7mOZuAiUwqQlQyQzW8SqFdOpz8z421Y8WD3uFOVqQbiIgArDJbP/v0sYCMEY
         gzkiat5AYs/gwc5nD10p4icbTmHhS6F8EymfF9j0=
Date:   Tue, 6 Aug 2019 17:27:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] [Backport for 4.9.y stable] arm64 CTR_EL0 cpufeature
 fixes
Message-ID: <20190806212753.GK17747@sasha-vm>
References: <20190805171355.19308-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190805171355.19308-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 06:13:53PM +0100, Will Deacon wrote:
>Hi,
>
>These two patches are backports for 4.9.y stable kernels after one of
>them failed to apply:
>
>  https://lkml.kernel.org/r/156498316660175@kroah.com

I took the 4.9 patches, thanks!

--
Thanks,
Sasha
