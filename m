Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E96404CDA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236764AbhIIL6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:58:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42486 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243694AbhIIL4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:56:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DD3721FDEB;
        Thu,  9 Sep 2021 11:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188509;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LF5iiXOxIOPlqm1WdseD0cCvYoH7p/7BkKS5zwgUj94=;
        b=zspsoDHzNXOdUVEuqhaTewCHNNSB4NUlJJofAGADRktnHbvE3upCVYJD1tXL5X+yIYasaA
        IBjHo2FppQl51kAjoUlwIdFiwocheSN08GO4uXj/zbtPmrHD2Gb6Ju3dCJHsGaE1ROE1Hd
        QSA6sx/VyKc2Y5muf9TCAcHty2zaBRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188509;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LF5iiXOxIOPlqm1WdseD0cCvYoH7p/7BkKS5zwgUj94=;
        b=TgJcZ6CrJIDKZmSomk3JGCtY0eLh2IYfj2qZhyUmUPdrLZJ5jzz1HHYUFtwCHDcFQVoU0e
        7U7s14Stsx1jB6Cw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D0EA7A3D8C;
        Thu,  9 Sep 2021 11:55:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C111FDA7A9; Thu,  9 Sep 2021 13:55:04 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:55:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 191/252] btrfs: reset this_bio_flag to avoid
 inheriting old flags
Message-ID: <20210909115504.GA15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-191-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114106.141462-191-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:40:05AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 4c37a7938496756649096a7ec26320eb8b0d90fb ]

Please drop this patch from stable queue, thanks.
