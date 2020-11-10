Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C4A2ADD00
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 18:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgKJRf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 12:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgKJRf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 12:35:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B30C92076E;
        Tue, 10 Nov 2020 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605029758;
        bh=06yb4c1xSqhSXFdqt/EvNxW7tA55jJL0qM4AUFd1Rh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FqM8pPolaMOfjF71vvSico6HSCqeMhU72RCtN2zt0yaH+VVSgnTApAy5r2qMacp/H
         P2hV+tFLAdy5K25X2pbGhdGjS4ojQlgS7N0yWpNjS7i0EqnyqwadV0nwFvOd8KwzBR
         ArrhUiexmeocAQ9e/8ZxE0rsTnKCzHsm9ovdjLyI=
Date:   Tue, 10 Nov 2020 12:35:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 53/55] seq_file: add seq_read_iter
Message-ID: <20201110173556.GB403069@sasha-vm>
References: <20201110035318.423757-1-sashal@kernel.org>
 <20201110035318.423757-53-sashal@kernel.org>
 <20201110090528.GA23535@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201110090528.GA23535@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 10:05:28AM +0100, Christoph Hellwig wrote:
>Should not be needed in stable in any form.

I'll drop it, thanks!

-- 
Thanks,
Sasha
