Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E096C17EE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjCTPSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjCTPSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:18:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9A819F3F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:12:50 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cy23so47976312edb.12
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679325166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bnPoW+u0vzf+BZPunGMl2jk5CxoEG9UUZMXR/9y70tE=;
        b=A9u7377RQdcv4EM9LC38AWFlzm8E8+FH0E4psMhjtH9qoN9xorPyZjto49ycpalatO
         fJ+BnUG0BBLgRrK27fmoGyr6sCuR8SUScRDxDNqVjAXsFTnk3hHjQNw0scL80BiX/f8T
         mBd/vpAFF6QtcoH5ub5kfpKCx48Iw0+UDkmGsd04SSWiFmZkvaXm4jF9iW96q12nq0z/
         dfCeQHEIoaityS2Qr4DsHY1XMfubC1rdkqypfTrOTT1P4awayQ3fZsUi8gUcA0zje40r
         U41A8wqovVstl0DjlsPMZW5sjXLKi4V61HduAigSyEFh2QzZ3JVAlPLxEhsDxqI4h5++
         0gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679325166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnPoW+u0vzf+BZPunGMl2jk5CxoEG9UUZMXR/9y70tE=;
        b=oiAryEswQHfX6cWV9sSK0b81Mtc9eW+7LGkCPO5lDfQ06lWL6YOkwFzL44Gp2UkBPn
         JXY37Vhy+TXJYKym6likJTTn/lmOxWX5B0yknxdf4gkm4FdBXJPqEJSmcfdgbHFpGPZJ
         qY1ty/RLKGOrKLihQp9XQgFyhI0wa/gAq9/y1n0XaMjl6siIBEWXHastN4ZuHEVuDgqk
         4DqOTVZYvyirV+7s8EqLT1Dd4/Q45kR9dPcRqlSijcCtpxRdL+KbFvXyR26WjOG/E20A
         5YDzEkk2l7UTJnX4JDS9e2tS19eBBQfxZKWz3rQa8ii1qSeiX5WbQYJytXV/lmNFAUz5
         Siiw==
X-Gm-Message-State: AO0yUKVyxQ3Yc7mwru4x+y2W5qCLEClEYAwfeTLVZj1KgdH4LiaCsRn/
        JNW6WQCrtvrvXeqKK+YlFUwIEA==
X-Google-Smtp-Source: AK7set/pZcd0R7KvaHUP8BZX38ceHGt3s4NAuFPIP/7J/dxPIIEkF1ssNrIe74uKrwbp5zTbD8Y1Ew==
X-Received: by 2002:a17:906:b848:b0:8b1:7857:2331 with SMTP id ga8-20020a170906b84800b008b178572331mr9862862ejb.65.1679325166343;
        Mon, 20 Mar 2023 08:12:46 -0700 (PDT)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id a25-20020a17090680d900b008e3bf17fb2asm4608602ejx.19.2023.03.20.08.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 08:12:46 -0700 (PDT)
Message-ID: <6607c751-2b67-61f9-2803-1dfc6249d588@tessares.net>
Date:   Mon, 20 Mar 2023 16:12:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: FAILED: patch "[PATCH] mptcp: use the workqueue to destroy
 unaccepted sockets" failed to apply to 5.15-stable tree
Content-Language: en-GB
To:     gregkh@linuxfoundation.org, pabeni@redhat.com, cpaasch@apple.com,
        kuba@kernel.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <167930928916599@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <167930928916599@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 20/03/2023 11:48, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Thank you for this notification and all the recent backports!

I think it is best not to try to backport "mptcp: use the workqueue to
destroy unaccepted sockets" to < 6.1 versions (so v5.15 and v5.10): as I
mentioned in my cover-letter [1], even if it looks like the issue is
present for quite a while, it is only reproducible until recently
(v6.0+). Plus this patch depends on "mptcp: refactor passive socket
initialization" which is can only be backported up to v6.0.

So please, do not try to resolve conflicts for this patch for v5.15 and
v5.10. I will try to resolve the conflicts for the other patches linked
to MPTCP (only failing to apply in v6.1 apparently).

[1]
https://lore.kernel.org/netdev/20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net/

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
