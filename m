Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9277D6DBD
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 05:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfJOD3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 23:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbfJOD3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 23:29:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D2A20873;
        Tue, 15 Oct 2019 03:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571110153;
        bh=iKMjyufndaAx8GHo/jNaZk2aVccwowb4IbEOX4IOYJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vM4s75KynPMe6QWhdsyPjbdpWbcXa/PvErXlLqy8zqW6WMjsAs2YH2+mVCdPiDMUO
         +F/PbF9Z1pE2YAqIesSKtOszuD1bShyzwUMH7ZtMfOP3bCiLibHy/I/NfIvomqs2Qg
         kMo1KreHIHopfni+7v8eesPBNkXgIcLgIsIU74GE=
Date:   Mon, 14 Oct 2019 23:29:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     gregkh@linuxfoundation.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        stable@vger.kernel.org, stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] cifs: use cifsInodeInfo->open_file_lock
 while iterating to" failed to apply to 4.19-stable tree
Message-ID: <20191015032912.GL31224@sasha-vm>
References: <15710699036748@kroah.com>
 <CALF+zO=wKs7Yt4_q6F_p3jAiexMdxGK3ogFsFFLV0uGCEey90A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALF+zO=wKs7Yt4_q6F_p3jAiexMdxGK3ogFsFFLV0uGCEey90A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 12:38:57PM -0400, David Wysochanski wrote:
>Unless there is objections, let me try to fix this up.
>Thanks.

Hi David,

This was mostly due to missing fe768d51c832e ("CIFS: Return error code
when getting file handle for writeback"). I've adjusted the context and
queued it for 4.19. However, if you do end up fixing it up on your side
please share it with me and I'll confirm that I did the right thing.

-- 
Thanks,
Sasha
