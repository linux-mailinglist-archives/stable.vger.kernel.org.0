Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCA132EC9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgAGS6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbgAGS6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 13:58:01 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33D3C2081E;
        Tue,  7 Jan 2020 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578423481;
        bh=0kzkaTId9GUlgG+1rgKgSR1hmuFSu2R8+JP+t3YE+BQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDoBhbROxQ95wWByF4/C+Yk9t8ShPkCEh4garzTwM5RA+Lk+pujsXZkpFtWR/ORIk
         zAzamidTq62FT05nMlRbBsB5/vP/Skqb/kGYKIk3NtxURrXXY+/83zYnCAFEzVAA2M
         AmxTQxQGbLohQViW62AyC6cDES9uvLePm0rQwlz4=
Date:   Tue, 7 Jan 2020 13:58:00 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Aleksandr Yashkin <a.yashkin@inango-systems.com>
Subject: Re: [PATCH v4.9.z] pstore/ram: Write new dumps to start of recycled
 zones
Message-ID: <20200107185800.GB1706@sasha-vm>
References: <202001071023.9BFD4C51@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202001071023.9BFD4C51@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 10:25:16AM -0800, Kees Cook wrote:
>From: Aleksandr Yashkin <a.yashkin@inango-systems.com>
>
>[ Upstream commit 9e5f1c19800b808a37fb9815a26d382132c26c3d ]
>
>The ram_core.c routines treat przs as circular buffers. When writing a
>new crash dump, the old buffer needs to be cleared so that the new dump
>doesn't end up in the wrong place (i.e. at the end).
>
>The solution to this problem is to reset the circular buffer state before
>writing a new Oops dump.
>
>Signed-off-by: Aleksandr Yashkin <a.yashkin@inango-systems.com>
>Signed-off-by: Nikolay Merinov <n.merinov@inango-systems.com>
>Signed-off-by: Ariel Gilman <a.gilman@inango-systems.com>
>Link: https://lore.kernel.org/r/20191223133816.28155-1-n.merinov@inango-systems.com
>Fixes: 896fc1f0c4c6 ("pstore/ram: Switch to persistent_ram routines")
>[kees: backport to v4.9]
>Link: https://lore.kernel.org/stable/157831399811194@kroah.com
>Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks Kees, I've queued both this and the 4.4 patch up.

-- 
Thanks,
Sasha
