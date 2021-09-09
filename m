Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61795405539
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357368AbhIINJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:00 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52440 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354225AbhIINB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:01:27 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E239F1FDEE;
        Thu,  9 Sep 2021 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192415;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CW/L7kzpCXJ5MhjHwodcb5Rcy9udvXBRmql0353MPCM=;
        b=x1Xus5VhoJ99/6Fv9GyBXsVSaVML/6c1+LyP/3gBZdq3n2o2ocrwZKmtbPWnYTYtO6wSFX
        afmc0FljZW5FVdMQSgabFJVGGcNgeLkWeAaMqoXGdOEZe8+7PWOLLJv5Pi5OecgWca/AL8
        uAfsDFtHld5px9h9gx+eLP+32WKRb2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192415;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CW/L7kzpCXJ5MhjHwodcb5Rcy9udvXBRmql0353MPCM=;
        b=1uzCEPaYnJGb009qZZPKR5rA117Lm3tkhRW61byT0mJng7Ub54AewC2CT5v1GELm6m7jJR
        QmAhhsCtc34ez+AA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D82A0A440C;
        Thu,  9 Sep 2021 13:00:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C56ECDA7A9; Thu,  9 Sep 2021 15:00:10 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:00:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 170/219] btrfs: reset this_bio_flag to avoid
 inheriting old flags
Message-ID: <20210909130010.GK15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210909114635.143983-1-sashal@kernel.org>
 <20210909114635.143983-170-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114635.143983-170-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:45:46AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 4c37a7938496756649096a7ec26320eb8b0d90fb ]

Please drop this patch from stable queue, thanks.
