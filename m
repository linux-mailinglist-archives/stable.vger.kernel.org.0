Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819554452DD
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 13:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhKDMVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 08:21:34 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:47066 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhKDMVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 08:21:33 -0400
Received: by mail-wr1-f54.google.com with SMTP id u1so8260009wru.13;
        Thu, 04 Nov 2021 05:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rVo87bzT1q+3lxpKKQfe0E7aqWJ8l7doBXZyWPSD/lA=;
        b=QoMqkQSSqls0zgsx6FRDwQ2y7YoF/N0F8zaWoKFqCisiz0NB6ntb/ZUY688CLx1gDN
         IGObO7gP19t31AnmUvoR35qX3TM3uaddFyxFh5KO2hyDRQRVcDN7atqQNHO8SWNSST0O
         yR+UZUf1TqxBTvvoMwmognVL6a3WnCB6DelURhVx5/64zIivuLqv/CpAWoHZPcn8aPDb
         hLr0wyL9BoyI5/cxCW96Hs24DcrvC2jU7Xg6R45K1G0HDMUJT6IckKqzKBIgn3gUOVj7
         i3+RY5URrrkUOyu10CXo5cKeZvv9NxhzMwjDRwvsHzgTzVV7DvHb0kjDxoVpshJtENo3
         3jNQ==
X-Gm-Message-State: AOAM531j2xBUlcxhUsRQR9QMMSBS94ZUQ4jDYcYptACKajMxBJ0QoNLt
        VcvlcCGwVbidzGBrQZaL2sk=
X-Google-Smtp-Source: ABdhPJzoEHfI/LbhfZUxWVf+tSi5htVRPuUCElvWBsEp9YLV4INYKMsMrhLjk8QTNpmu19rhDdPLtQ==
X-Received: by 2002:adf:8bc4:: with SMTP id w4mr63092167wra.36.1636028334798;
        Thu, 04 Nov 2021 05:18:54 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id v185sm8422578wme.35.2021.11.04.05.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 05:18:54 -0700 (PDT)
Date:   Thu, 4 Nov 2021 12:18:52 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Boqun Feng <boqun.feng@gmail.com>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        stable@vger.kernel.org, Baihua Lu <baihua.lu@microsoft.com>
Subject: Re: [PATCH] Drivers: hv: balloon: Use VMBUS_RING_SIZE() wrapper for
 dm_ring_size
Message-ID: <20211104121852.zhmhf7fogq6iaz5r@liuwe-devbox-debian-v2>
References: <20211101150026.736124-1-boqun.feng@gmail.com>
 <87h7cuk8ua.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7cuk8ua.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 02, 2021 at 02:03:57PM +0100, Vitaly Kuznetsov wrote:
> Boqun Feng <boqun.feng@gmail.com> writes:
[...]
> 
> Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

Applied to hyperv-fixes. Thanks.


> Thanks!
> 
> -- 
> Vitaly
> 
