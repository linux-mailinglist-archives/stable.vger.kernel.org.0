Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645FD404D41
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242960AbhIIMBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:24 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34668 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344744AbhIIL7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:59:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 07C5021F7D;
        Thu,  9 Sep 2021 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188691;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iEdrw1PijOZaoVJKm9mL5ftTW8+6PaGuf/9mDi2hCl8=;
        b=kqlCMhDdNqqfNy4rt4x97gvGl8yu81MxRDMx+AwPvUew6vFpeVyQHt/zH8HYQbeQPe0GXk
        ghfLr1JOF4YgKJlZHyx5U37HbWs5VoQ3drIvpEzC4NWdbhpUPsjLf9/YKN7obiSDymG+am
        0rilAsrNfKogymmf0ksIjCIwA8xBTzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188691;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iEdrw1PijOZaoVJKm9mL5ftTW8+6PaGuf/9mDi2hCl8=;
        b=wMAM0HFxlevtBnAfdPTU7hf7NPROEgmWuSJemB1vD8CBfZbFMJpwoZ5B5wz1DiP6i4kvCB
        lrDetLy+JKwmw3Dw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id F37E7A3FDA;
        Thu,  9 Sep 2021 11:58:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0700DDA7A9; Thu,  9 Sep 2021 13:58:05 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:58:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 172/219] btrfs: grab correct extent map for
 subpage compressed extent read
Message-ID: <20210909115805.GH15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210909114635.143983-1-sashal@kernel.org>
 <20210909114635.143983-172-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114635.143983-172-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:45:48AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 557023ea9f06baf2659b232b08b8e8711f7001a6 ]

Please drop this patch from stable queue, thanks.
