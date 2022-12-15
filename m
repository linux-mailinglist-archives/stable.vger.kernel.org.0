Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204B664E276
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 21:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiLOUm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 15:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLOUm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 15:42:26 -0500
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED00C4A581;
        Thu, 15 Dec 2022 12:42:24 -0800 (PST)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 0C7B78C16DC;
        Thu, 15 Dec 2022 20:42:24 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 412018C2163;
        Thu, 15 Dec 2022 20:42:23 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1671136943; a=rsa-sha256;
        cv=none;
        b=3Z6ZmfHUVrb7igXZCuvGBl6VhKEEFeWzkwjJv4vDK/d8gM+Wuyv/tVRfgqLqeNjyaGPOGv
        q9dcuNqtrwmtMKae4pUgXbASpvAr8Nk7Xy5NguVi919gwd33nApZR0xQl1dVmMdWX8d+Oa
        hGQgpdb9n33hGXyjJukR2cmAOxuU94JIDmoPd8sdnhNoSqtBD6yajzchOL0r+E1k2A7uh+
        mgdC88itlmHN9WcyyZnp7BKLfq6r/+HUrlY6mCC+qn+gwmIevs0q5Rf6hGP9I6ydxht9ZC
        ms2ysvRmSpbPuXSZBiuxrkkPzSTk+UR5e4zW1nqkjO1yQz7Vr9UgNfNnGAqP1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1671136943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=4GyRKY3YSfdpIpa89ZXKkQRvCCOpmKnI4/N4QENiFPY=;
        b=wQwzTPL2gNQx852ALwKz4DjE23jGHcT7ni3XY06H7NFQUKS+sgi1K65ClQecYtCqJlBRXO
        YEgOQWOVhi5QnF9MmU1fjfdOgMArBt+q4RciWPd0XBihOL+is7TwomqX327QEDx5nPAIcf
        1gPVXf4bJqbNhs1MOYoOGXiITzoV5lr2QISQq0wJZBbFjsiNzf6+hahMlDNtBlvAyCKP2N
        RzbheSe+vcpKrfd7sRRh5lS3wr/phBmr9x1b9my51kO6w63dXiYp0TKf/mTVab1m0aBGrt
        qCw3MJk+zr6hMY4+eG677JCLcSaXsVZCVzzcVDZV5uwcI86BbKgY7LuRiutBag==
ARC-Authentication-Results: i=1;
        rspamd-747d4f8b9f-z9kfm;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Ruddy-Illegal: 5cff925632607440_1671136943632_428128638
X-MC-Loop-Signature: 1671136943632:1732326357
X-MC-Ingress-Time: 1671136943631
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.116.179.68 (trex/6.7.1);
        Thu, 15 Dec 2022 20:42:23 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4NY40t25Qkz4r;
        Thu, 15 Dec 2022 12:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1671136943;
        bh=4GyRKY3YSfdpIpa89ZXKkQRvCCOpmKnI4/N4QENiFPY=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=ZRw4P5d79Z3C184Ocy245+dKfN+mYC56/a9jF1yiAzOUfRCVrx7t03ktSN9gEZ4p+
         OlvxNCuZCXq648uo0dtVycPs0ICyGQQGP5kQ2AL87M65w5UL4t93swWqRimmpYkALN
         r2EmpwWXDBwBEBf6s/I3BrHKtVh1MKT4x5GgAMVaI/cy/jeCLvJ56WrKcxlezIRVwt
         oYdmUn1t7M5BRx1RLj7uQf5GuTZgWRnyUsuMZIDWhJbgfPOGPiwUQIzsJRiMzEyNk5
         ryTlP1gBqH8O+/gouTuclnoaMFCMLr6t6vzpTkOQX49GwM6O1fwK/QGM9k3rXHTCeH
         N+TliLAE8hMew==
Date:   Thu, 15 Dec 2022 12:17:50 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Andre Almeida <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>, stable@vger.kernel.org
Subject: Re: [RFC PATCH] futex: Fix futex_waitv() hrtimer debug object leak
 on kcalloc error
Message-ID: <20221215201750.kefgg25ptsjbmq2u@offworld>
References: <20221214222008.200393-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221214222008.200393-1-mathieu.desnoyers@efficios.com>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Dec 2022, Mathieu Desnoyers wrote:

>In a scenario where kcalloc() fails to allocate memory, the futex_waitv
>system call immediately returns -ENOMEM without invoking
>destroy_hrtimer_on_stack(). When CONFIG_DEBUG_OBJECTS_TIMERS=y, this
>results in leaking a timer debug object.
>
>Fixes: bf69bad38cf6 ("futex: Implement sys_futex_waitv()")
>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>Cc: Andre Almeida <andrealmeid@collabora.com>
>Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Cc: Ingo Molnar <mingo@redhat.com>
>Cc: Darren Hart <dvhart@infradead.org>
>Cc: Davidlohr Bueso <dave@stgolabs.net>
>Cc: stable@vger.kernel.org # v5.16+

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
