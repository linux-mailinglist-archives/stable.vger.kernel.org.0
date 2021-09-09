Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E275405509
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358577AbhIINHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:07:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52468 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbhIINBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:01:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3B0651FDF4;
        Thu,  9 Sep 2021 13:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192440;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTx2QhwGNNX3hzvOpnQ7hwzyuThcXCetY/lvamTanXU=;
        b=k/jtqIyqTpnkTle6jXsTiP+hn3mLeGaE18kRyr8OKyvJsVwx9vo2opHgcxyRu+UDaKlfWY
        YXX9qvr+E6xPmKI3EHadyMIDh36+6gr2KXFunxrcrlpgQa0S0UHES6tCytvg4LhLo052r5
        9CbWm7m0Qm88z6VERlg1mijXLDekgDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192440;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTx2QhwGNNX3hzvOpnQ7hwzyuThcXCetY/lvamTanXU=;
        b=PwiHb+9U4SkOxmve404+Ni+7+AHGzEb6ypHX6A2bb/jpLcRa6G1fJYnFcC8Zf1ux7tRjM8
        V8zACTtna9cFdGCA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 32546A3BAE;
        Thu,  9 Sep 2021 13:00:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 34762DA7A9; Thu,  9 Sep 2021 15:00:34 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:00:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 139/176] btrfs: subpage: fix race between
 prepare_pages() and btrfs_releasepage()
Message-ID: <20210909130034.GN15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909115118.146181-1-sashal@kernel.org>
 <20210909115118.146181-139-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909115118.146181-139-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:50:41AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit e0467866198f7f536806f39e5d0d91ae8018de08 ]

Please drop this patch from stable queue, thanks.
