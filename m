Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BA2404D01
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbhIIL7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:59:10 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34158 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238480AbhIIL5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:57:07 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 07B5522380;
        Thu,  9 Sep 2021 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188556;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q7ClmyTqSyGLWiYG/kJYGnJtKGItbnH3oUr7gYMJP4s=;
        b=OfqyL95cUCgxy9iWGCIRwhbW3CPXM2WQAYhTSRWKAIvjYK1Y6dxxyzQbfJ6ey1jo5kqsN/
        OQQMoGKUL0rRmZeceUHW6nDdXWWEUA8fW1dQ4I3Hart1LIuWWUHURqYr+RHylVpe5qviBf
        yu+2ipeaSKazmEWo8R9QdHwNUdmpQHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188556;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q7ClmyTqSyGLWiYG/kJYGnJtKGItbnH3oUr7gYMJP4s=;
        b=NuJfhPX2uqZE0ZJgn47U5YR0MUw++beV9x+GfjZ8BMHGq0FsuUUjfuT2W9a2z3OZ3tbXHm
        KGhvAfDVIwprPBAg==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id F34A1A3DB0;
        Thu,  9 Sep 2021 11:55:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 040F7DA7A9; Thu,  9 Sep 2021 13:55:50 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:55:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 195/252] btrfs: subpage: fix a potential
 use-after-free in writeback helper
Message-ID: <20210909115550.GE15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-195-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114106.141462-195-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:40:09AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 7c11d0ae439565b4560b0c0f36bf05171ed1a146 ]

Please drop this patch from stable queue, thanks.
