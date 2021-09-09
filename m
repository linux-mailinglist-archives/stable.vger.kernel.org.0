Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597F640552B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355941AbhIINIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:43 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52688 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354328AbhIIND3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:03:29 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 422741FDF8;
        Thu,  9 Sep 2021 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192477;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DkoeQTQgiF1ez3B2ympiPX6tcDSmIofrAnG1Jbs455Q=;
        b=JZH6e8S1BaECI2uqbFiVc01/Jcma6F157NUWoMLjk2wWjZSdc6pbQLsSM5btxM6uXW7Q6Q
        Gy3VgHqAE3JaucCfqgRtcRzRCokBGE6VSqI7KvCa2kjIQs+JFB4Q0Vw1ONxyGLOF5qe/6k
        cUuvV03Q7ZxWyrrv3qVRfG/ICSUA2nk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192477;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DkoeQTQgiF1ez3B2ympiPX6tcDSmIofrAnG1Jbs455Q=;
        b=qp0xFRrPcconuWXZ9Wx35DKP6vjEADfHbCZCNU3gxHIeAdPVWO52ALHu0oYVO7I1guHuyH
        XVCYWMPq4z8pF5Dw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 3AC07A4169;
        Thu,  9 Sep 2021 13:01:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3C932DA7A9; Thu,  9 Sep 2021 15:01:12 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:01:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 55/74] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909130112.GQ15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909115726.149004-1-sashal@kernel.org>
 <20210909115726.149004-55-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909115726.149004-55-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:57:07AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]

Please drop this patch from stable queue, thanks.
