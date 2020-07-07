Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900B2177EC
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 21:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgGGT0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 15:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgGGT0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 15:26:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EB4206BE;
        Tue,  7 Jul 2020 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594149972;
        bh=uxcMM/Sf9inJLIkj1U8e0LfZX/0p8ULXiZ2yN0bNMnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OZ9oxJPKMjuAxAmKeMAMKFymbhEyjmXIECfqDtlfmvgSF4TgxNY9YLFoNZb2hIrPd
         gSeBgN0IW5+L1EdPdkdCwjTulvRa1gyxwU0fX8CJRmFSwYpz0k85UyPielx4nyddEa
         CWRf3xdhMMl7uifSsvzoml6r7C6cp901pUmd8EQY=
Date:   Tue, 7 Jul 2020 12:26:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        stable@vger.kernel.org,
        syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/6] fs/minix: check return value of sb_getblk()
Message-Id: <20200707122612.249699c3f136968dd6782452@linux-foundation.org>
In-Reply-To: <20200628060846.682158-2-ebiggers@kernel.org>
References: <20200628060846.682158-1-ebiggers@kernel.org>
        <20200628060846.682158-2-ebiggers@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 27 Jun 2020 23:08:40 -0700 Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> sb_getblk() can fail, so check its return value.
> 
> This fixes a NULL pointer dereference.
> 
> Reported-by: syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Originally-from: Qiujun Huang <anenbupt@gmail.com>

Originally-from: isn't really a thing.  Did the original come with a
signed-off-by:?

> Signed-off-by: Eric Biggers <ebiggers@google.com>
>
> ...
>
