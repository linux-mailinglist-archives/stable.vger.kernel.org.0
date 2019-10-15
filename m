Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9761D6E8B
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 07:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfJOFY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 01:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfJOFY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 01:24:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBC532089C;
        Tue, 15 Oct 2019 05:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571117096;
        bh=3MTJGF8pEWXIj+m/CKzbVv7ee7JQxw5c2NRaeI9Kk+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0cxO9abzaR8zY5bL8Pp7OAHlgEbwpCS5Z79bKb+ev3SPhXRKSc2ypOUlPU9vFY3V
         Hi8p0dyqj7WFBUGZ72Dj8Mk0cta/l6rN6n3YZPXCc7u/jhns2fyWw2OhcvN5I5Zuci
         sTbqRC1SxjuUn0Gk8f/+I5Mqtgpqw+8j0R/jwLA0=
Date:   Tue, 15 Oct 2019 01:24:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     gregkh@linuxfoundation.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        stable@vger.kernel.org, stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] cifs: use cifsInodeInfo->open_file_lock
 while iterating to" failed to apply to 4.19-stable tree
Message-ID: <20191015052454.GN31224@sasha-vm>
References: <15710699036748@kroah.com>
 <CALF+zO=wKs7Yt4_q6F_p3jAiexMdxGK3ogFsFFLV0uGCEey90A@mail.gmail.com>
 <CALF+zOk4fC_QdnGKaZQ-TxWfUJDKtpUbE5kK8a4TUTRQjP5MBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALF+zOk4fC_QdnGKaZQ-TxWfUJDKtpUbE5kK8a4TUTRQjP5MBQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 04:38:13PM -0400, David Wysochanski wrote:
>Original patch applies cleanly to 5.1-5.3. Prior to that (4.19-5.0),
>needs minor fixups.
>Do I need to re-send the original and the fixup with different kernel ranges?

Just patches that would apply on top of <=4.19.

-- 
Thanks,
Sasha
