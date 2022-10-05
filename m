Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA725F4F4D
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 07:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJEFHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 01:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJEFHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 01:07:21 -0400
Received: from premium237-5.web-hosting.com (premium237-5.web-hosting.com [66.29.146.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C45675490;
        Tue,  4 Oct 2022 22:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sladewatkins.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:Cc:References:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AkzZQ3KqaN9LTG1UBNoaxcl05/M1M5y+uz+VTePBMcE=; b=TbBEgs50FlduDL/WY5P/mJ4Bbk
        VoyhCK4IoHipXbKfmS7gi2DnmTZF/Si74xo8VPnqC5WTt3R9leh44COv8f+ObuXiOW4Bas5rv/rFz
        HPSbx+TCBcYd7AXQCKCqQ/W4W8Igp1FyUnUaF7zE5w/TT7pNuO1edjNB3kdRNlw1Wil4RPiJDpZMS
        4tsVJZUYDIkBJkeCcl5Bsz01W/2QSSFUHSbfVa2oWDdxeKlLmMNrQWhcqv96NwRVCjZgQuMjzV7q5
        IFp7Tn6bVWn8myDma19WpivnndRyvh593/IAj9MB+lE+hZHTU0jJZ5QvLVYbFilgImcoGA59AIJyK
        mBg5QB2Q==;
Received: from pool-108-4-135-94.albyny.fios.verizon.net ([108.4.135.94]:61665 helo=[192.168.1.30])
        by premium237.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <srw@sladewatkins.net>)
        id 1ofwak-001TEf-4s;
        Wed, 05 Oct 2022 01:05:10 -0400
Message-ID: <3034898c-a6ab-6982-aea3-656a09398ffb@sladewatkins.net>
Date:   Wed, 5 Oct 2022 01:05:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.1
Subject: Re: New Longterm Kernel before 6.1 Rust?
Content-Language: en-US
To:     Carl Dasantas <dasantas2020@gmail.com>
References: <CANNVxH9biW6OYNFbF7ZVvSBCk4+1RAWmgjXA9Z55uCntrRasbQ@mail.gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <CANNVxH9biW6OYNFbF7ZVvSBCk4+1RAWmgjXA9Z55uCntrRasbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - premium237.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sladewatkins.net
X-Get-Message-Sender-Via: premium237.web-hosting.com: authenticated_id: srw@sladewatkins.net
X-Authenticated-Sender: premium237.web-hosting.com: srw@sladewatkins.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 at 9:35 AM, Carl Dasantas wrote:
> 
> I was wondering if a new longterm kernel will be made prior to 6.1
> being released with Rust support added? As the kernel.org page
> https://www.kernel.org/category/releases.html states "Longterm kernels
> are picked based on various factors -- major new features...". In my
> opinion, adding Rust support is a major new feature. Of course it goes
> on to say new longterm kernels are dependent on time, etc so I thought
> I would inquire. No harm in that, right? I'm sure there are a lot of
> others in our community that are hesitant as I am with Rust and want
> to see where it goes. It would be nice to have a recent longterm
> kernel so we can see how this Rust stuff plays out. Possibly from 6.0
> or 5.19?

Not sure if a decision has been made yet. IMHO, it may be _a bit_ before 
we see this year's longterm release picked.

+stable list

All the best,
-srw

