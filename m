Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21A293208
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgJSXd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 19:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgJSXd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 19:33:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FAB2222F;
        Mon, 19 Oct 2020 23:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603150437;
        bh=PXeFeuESIa+daODZU6VawXuXsXXTOP2d+OWVNl8JNiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecimiw/VTzR4Bfomfg6D9rJbJSri0iYKDxBGgxcEHLLyJcOYGV3ACMJajRkj3hwI5
         6qQ7ZnJEo5Y7oKy83Hd1Zds06qlBdVbPfIli7dBFVd0Kq7JGPkugbQQ+z2zpq9FjHc
         m8ywN7NQjmKlslGWhSWY78Fn+yJrPsZkCscASinQ=
Date:   Mon, 19 Oct 2020 19:33:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rich Felker <dalias@libc.org>
Subject: Re: [PATCH AUTOSEL 5.9 026/111] seccomp: kill process instead of
 thread for unknown actions
Message-ID: <20201019233356.GF4060117@sasha-vm>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-26-sashal@kernel.org>
 <202010191627.EAD97F5E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202010191627.EAD97F5E@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 04:28:19PM -0700, Kees Cook wrote:
>Hi Sasha,
>
>I'd prefer this was not backported -- it's not a bug fix, and if the
>behavioral change is actually disruptive, I'd like to keep the fall-out
>contained. :)

Now dropped, thanks!

-- 
Thanks,
Sasha
