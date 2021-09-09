Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EFA404CEA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbhIIL6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:58:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34128 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbhIIL4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:56:45 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 717C92237E;
        Thu,  9 Sep 2021 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188535;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SgcGpgCok67Bfm15+9kz4zmTvyKC+BSHeecrZCiv49Q=;
        b=GTACSpY5D5vHon7LNL/+6ZVKddjICjrNBmK5SDUBpu2sGpWRpZGQycZW+D4F8GCSTtdArx
        sv/u8p85QqKmkoC6oIo7xjp/tiAh5mDUukKaQwGsppcpfunXTdhgB6Iy7+67AZcqdfX7Ml
        YFeH8vNbzlVIa9JMX6E0W8avL+YuZ08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188535;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SgcGpgCok67Bfm15+9kz4zmTvyKC+BSHeecrZCiv49Q=;
        b=UblPpw5lVd/sRIPqMYDUmQifGMRHk/cBjM1jCfVKUmtM7Dmm7DsoKIAEhY90232FSJjQLp
        4iAw5HEu/5lWq+Dw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 6290AA3ED7;
        Thu,  9 Sep 2021 11:55:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5DADDDA7A9; Thu,  9 Sep 2021 13:55:30 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:55:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 193/252] btrfs: grab correct extent map for
 subpage compressed extent read
Message-ID: <20210909115530.GC15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-193-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114106.141462-193-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:40:07AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 557023ea9f06baf2659b232b08b8e8711f7001a6 ]

Please drop this patch from stable queue, thanks.
