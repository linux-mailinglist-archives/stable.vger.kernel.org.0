Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF5123B5FC
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 09:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHDHrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 03:47:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727854AbgHDHrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 03:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596527226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cg9TD9KR6aQ8DCDj8rct6KumwH28jaxmuwePKYiLJXw=;
        b=eZj6zjVPGBIKvtc0lc8BCCkeCxzxc5pi3jTSsJ/zbeRAO/gA9cs641ZXpgKmKg59U/Zt/F
        k3N4GElqn92uNYU17IzzA5zWVRFg3bbfSil/bllZNzG3rQajVjfM8mGjc4zyDi0TTWD/b2
        sq88/cxYYbxbiBY4IXv2KaUJ+bsuTc0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-Hr3KNOWXPrCn3jqKLDeAbw-1; Tue, 04 Aug 2020 03:47:04 -0400
X-MC-Unique: Hr3KNOWXPrCn3jqKLDeAbw-1
Received: by mail-wr1-f70.google.com with SMTP id j2so9752914wrr.14
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 00:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cg9TD9KR6aQ8DCDj8rct6KumwH28jaxmuwePKYiLJXw=;
        b=dSpeJVa50My4Us1aYg420H1qsHSmRwBo2deU5nHgzy2GEG4XrHpkqjc5UGTv19kpsI
         nrJrkYm5jj/LW0/ALiMm90gNndYLqTLj8/A26w7uqAjAR/xZBPUslYgCarpcHmieL2Bk
         Z/p4NGwpczaYR53TwP2nM+FeJKlI2/yqt+lZrYfp/Hz7W8MSox5vt7BiNqIKjoUyQsuL
         Jh0V/nwwnKEK6Q6ds2uciB8bKj/1yk1IwOy5HpoN/ZWPRYNbMf1quivVPOQIeH4gz+6Q
         te/xnNixezgxX5y82i3QFZQEXg3KTrMb0YqSs2HBgnse3ehBQ3AkqRRMfE08cDjZnnTr
         ArEw==
X-Gm-Message-State: AOAM531wlKzfKRqPmQkrZ2sdmThZcj11WmKq2i2FsQJa97bhaL1b6h24
        VX0JBz9FwcvRAgcPqZiFYWQrcPJGMmdNpzCroBuWL/sCavJugTbHTArIBFBPwaI0hr0cbTucpBG
        QwF6D/aq7K3Njzv96
X-Received: by 2002:adf:bbca:: with SMTP id z10mr17609780wrg.425.1596527223360;
        Tue, 04 Aug 2020 00:47:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPjz5bwTC3Diibtx3CA+YLdF8jlrDG6oiEBzVV7ZwSBS5VL29gytQGv8qz1KPtfL41oeE0bg==
X-Received: by 2002:adf:bbca:: with SMTP id z10mr17609757wrg.425.1596527223080;
        Tue, 04 Aug 2020 00:47:03 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p3sm3303297wma.44.2020.08.04.00.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 00:47:02 -0700 (PDT)
Date:   Tue, 4 Aug 2020 09:47:00 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 net 0/2] Add IP_DSCP_MASK and fix vxlan tos value
 before xmit
Message-ID: <20200804074700.GA3798@linux.home>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
 <20200804014312.549760-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804014312.549760-1-liuhangbin@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 09:43:10AM +0800, Hangbin Liu wrote:
> This patch set is aim to update the old IP_TOS_MASK to new IP_DSCP_MASK
> as tos value has been obsoleted for a long time. But to make sure we don't
> break any existing behaviour, we can't just replease all IP_TOS_MASK
> to new IP_DSCP_MASK.
> 
> So let's update it case by case. The first issue we will fix is that vxlan
> is unable to take the first 3 bits from DSCP field before xmit. Use the
> new RT_DSCP() would resolve this.
> 
> v2: Remove IP_DSCP() definition as it's duplicated with RT_DSCP().
>     Post the patch to net instead of net-next as we need fix the vxlan issue

Acked-by: Guillaume Nault <gnault@redhat.com>

