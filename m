Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDFA3F97FE
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 12:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244706AbhH0KRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 06:17:54 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35640 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbhH0KRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 06:17:53 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 022B31FEE8
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 10:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630059424;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hz3531wAlQR2DFIo5y9F0/0nuKqp1ppatcRh20egxM=;
        b=tBxAhRlguvkeL3tKqViZw2/u2QTz0NbJLb/JwD+QPVcR+4G9gmBt2WARxe9xFjZj6t2fRl
        TWmnukGC/sWradfCkQVZ+4tbZl95x/HP5WtSYFLQa61/HyAlMH5d5MWdzIeGzgzaaV2zwp
        Frt8+l061tBudgEiNEhg8sM1mrD1SAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630059424;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hz3531wAlQR2DFIo5y9F0/0nuKqp1ppatcRh20egxM=;
        b=ZR0rT5Oc/3OYL68oZi8+mIC0Vqcf3LyBOtfBiIggsLYVsEVg8z6Ug7UYEt0VYifTj+fB2f
        941KuIT3AB7/jODA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id EEFFAA3B92;
        Fri, 27 Aug 2021 10:17:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 673C2DA7F3; Fri, 27 Aug 2021 12:14:15 +0200 (CEST)
Date:   Fri, 27 Aug 2021 12:14:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Re: Please add beadb3347de2 to 5.4 and 5.10
Message-ID: <20210827101415.GX3379@suse.cz>
Reply-To: dsterba@suse.cz
References: <20210827091500.GT3379@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827091500.GT3379@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 27, 2021 at 11:15:00AM +0200, David Sterba wrote:
> Hi,
> 
> please add commit
> 
> beadb3347de27890  btrfs: fix NULL pointer dereference when deleting device by invalid id
> 
> to stable trees 5.4 and 5.10 (applies cleanly on both).

Please disregard this request, the patch is still in development branch
and will be pulled during merge window.  It's tagged for stable so it
would go via the normal workflow. Thanks.
