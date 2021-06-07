Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7DF39E67C
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 20:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhFGSYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 14:24:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47266 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFGSYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 14:24:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 832E32196B;
        Mon,  7 Jun 2021 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623090178;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGZYmpSj+jrwarwTXzn5893z98oSd/bgnCqq5gnuk1s=;
        b=WwHdAsdQraN0Q1mP3+ekHqNHF/U3DC94BZ+/2Jev5n9fV/eSGjiVWm5Ay1LTv44pkepkyJ
        M9wHqqT7GOqG8u/fhkewoqAc921mTkkienDJM/lbfg0v+9KICtxZPt41tUT9ZUY2bVsVm3
        GZZ+6AS5blzg9XItbqboVQesktAI6dE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623090178;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGZYmpSj+jrwarwTXzn5893z98oSd/bgnCqq5gnuk1s=;
        b=D5Rf+lpYxWqJwNoaWqFmY8Dlw0XPB+6L3SM7v1K9RAqIvkcVgI8qjU1Vt2y5KUWb6oxF/t
        7SIYxcdGGZlDcZCg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 79F65A3B98;
        Mon,  7 Jun 2021 18:22:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 67111DB228; Mon,  7 Jun 2021 20:20:15 +0200 (CEST)
Date:   Mon, 7 Jun 2021 20:20:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: handle shrink_delalloc pages calculation
 differently
Message-ID: <20210607182015.GJ31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Is there a better description of the change? I don't find the
'differently' helpful, could it be something like "split delalloc flush
waiting states"?
