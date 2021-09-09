Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD840551F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354999AbhIINIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44908 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355519AbhIINDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:03:41 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 28FC622364;
        Thu,  9 Sep 2021 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192522;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W3ietC/JnHW5XNxDmZGC8dOEl7RaaMevJeQlTwQPZBg=;
        b=AJOXq7ZO1Luv5N6mUB5SqvenoGQITZsJVGjL7pYlmosPvvsm6VxBWL6vAoGulDp221B3h0
        AglmXMIFBJzTG0Z/PKU/rwR0ptn74I+WbGSblsqq82ymOuhAxXVQu9y9WQrJ7P6HEuoOnH
        X0VodAE1uTqFLfsqdtgHIxDZxU0Qh2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192522;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W3ietC/JnHW5XNxDmZGC8dOEl7RaaMevJeQlTwQPZBg=;
        b=1cWUlWRE34M7sTmjEkKMVTmmQSAKNG1ffhrPMnsX28hd5cOyme15aVGVO+DELgxQhVg+0k
        6Xyl5e9l6QTD3bDw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 227CFA420E;
        Thu,  9 Sep 2021 13:02:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 251CADA7A9; Thu,  9 Sep 2021 15:01:57 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:01:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 27/35] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909130157.GW15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909120116.150912-1-sashal@kernel.org>
 <20210909120116.150912-27-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909120116.150912-27-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 08:01:08AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]

Please drop this patch from stable queue, thanks.
