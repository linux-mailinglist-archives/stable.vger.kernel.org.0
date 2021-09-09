Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F05404D4E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbhIIMBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34680 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345089AbhIIL7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:59:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 226232237B;
        Thu,  9 Sep 2021 11:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188705;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pruN5hWifbYMlRtAyhOCyVp+chQU+hTNuDbEIgsZYFA=;
        b=0canCd3xyLhjU4t0eRDdI2LTkGCVVKtdyAfcX2JOTu494YUAh0GoU2AWd+/2WQt+SIkJUt
        Y8yND0jTt/eQpGvbxVMm2h6KssI1HMmF2qlcDj/iNX5JkHnDZq/VQTe5wH0Q5gP+/zAtuN
        sUa0hYkaNEB7J+ViepRYsVp31w3EtjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188705;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pruN5hWifbYMlRtAyhOCyVp+chQU+hTNuDbEIgsZYFA=;
        b=hB9ACBwq+/sBw2S1lsTYHaSLYm21XDIOsWx8hyBSbi6zQd8aXIq3axGVo8vWLREoYCWu6b
        w3piknbdjmYhR6DQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 18604A3CA9;
        Thu,  9 Sep 2021 11:58:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1F65DDA7A9; Thu,  9 Sep 2021 13:58:20 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:58:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 174/219] btrfs: subpage: fix false alert
 when relocating partial preallocated data extents
Message-ID: <20210909115820.GJ15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909114635.143983-1-sashal@kernel.org>
 <20210909114635.143983-174-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114635.143983-174-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:45:50AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit e3c62324e470c0a89df966603156b34fccd01708 ]

Please drop this patch from stable queue, thanks.
