Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8BC464972
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhLAIVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 03:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhLAIVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 03:21:47 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA33C061748
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 00:18:26 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so339059wmi.1
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 00:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uhJW+9opegtBmg/vvEbcApUZeD/bLQN5cLKvGNtuOsk=;
        b=d/0ktreiQUpcB732uQ1gyQMEOhSYXXXmtBNJRlEKMt9odu+BViiNltMp1ba02Xgh0b
         usZe9dMTWcdb20qnE+l1POhrKt83DyCPFhqxkvn8OsO/U/E5N+zWJHWoUixVK/j4EbQP
         kfED6JIqqdOsBeDiUNtdnmiNHu6li68OsYDzG5ihxmIwftkYf3L35uq61/J6QOJ36Ens
         oLVMGXX2Mrt87UuyXQk7Y8r3WPhji96U5A8R9u0xdCgIRfaLd8N27oUMvodO7OJ8NaH6
         eS1lwxSIdh/+K45laromb5fOUeyxALYSWdJmcl9w4+cAOI9uAnFHIHII5RsiuTRGM05Z
         C6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uhJW+9opegtBmg/vvEbcApUZeD/bLQN5cLKvGNtuOsk=;
        b=IDipIa/ZnzOX6hp6KQLIxC9J4EW5M4ra6qpZ7AjTinKSb9iubjh9xgxzmUOBQdliZJ
         kHK9640rx9c+riyIBa1uhc3lNCra0rW0t55QQkbc0xflA13AKZlPkkcfKhhjSssK5b6R
         2/Ps+Ud4Al6JTqWsiQidBziipqZPS8qTh5Bq8mgFTsO42KUsZn65nL/C2J1rud4bE6sf
         bXR7hvn5bInZjyR+hl5kL5XaRlX8oGz398Ysvym7ny9JnQ9sm5CjufzIN1P/RajGCwIR
         1s8A2kt3u4ysNU1VuTCb+wnHm97V6hZEEYh8K5kn/Z3d8HRCAWfB7QMnsyLGp0h8+zfn
         uYZg==
X-Gm-Message-State: AOAM533WqM5MmozvWZnSoNXB4a1c8KPJNusjdGMMkIuMzoCyJKvgv5SI
        1NnF2DGX214njVMjqYEnVFs3bOXux5BpGg==
X-Google-Smtp-Source: ABdhPJxXXN2bKFMla/dtgZS6jHW0gS7M0Y1D7wJMmVEwk/5ys4n00T/g88YrlXGHbvIJLYRSN2W4AA==
X-Received: by 2002:a05:600c:4f8a:: with SMTP id n10mr5057178wmq.54.1638346704928;
        Wed, 01 Dec 2021 00:18:24 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:c1e4:d45e:bc53:784a? ([2a01:e0a:b41:c160:c1e4:d45e:bc53:784a])
        by smtp.gmail.com with ESMTPSA id m9sm277781wmq.1.2021.12.01.00.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 00:18:24 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] vrf: Reset IPCB/IP6CB when processing outbound pkts
 in vrf dev xmit
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, stable <stable@vger.kernel.org>
References: <20211130162637.3249-1-ssuryaextr@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <7dc2911a-0cb5-6901-0dd6-d4385a8f8d7a@6wind.com>
Date:   Wed, 1 Dec 2021 09:18:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211130162637.3249-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 30/11/2021 à 17:26, Stephen Suryaputra a écrit :
> IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
> in the codepath of vrf device xmit function so that leftover garbage
> doesn't cause futher code that uses the CB to incorrectly process the
> pkt.
> 
> One occasion of the issue might occur when MPLS route uses the vrf
> device as the outgoing device such as when the route is added using "ip
> -f mpls route add <label> dev <vrf>" command.
> 
> The problems seems to exist since day one. Hence I put the day one
> commits on the Fixes tags.
> 
> Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
> Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Cc: stable@vger.kernel.org

Thanks,
Nicolas
