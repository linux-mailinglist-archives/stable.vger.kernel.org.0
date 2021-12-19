Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAD547A021
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 11:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhLSKOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 05:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhLSKOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 05:14:33 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F81C061574;
        Sun, 19 Dec 2021 02:14:33 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id p8so10938448ljo.5;
        Sun, 19 Dec 2021 02:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=hKGb9w8KG5b73eiq1K1JTU4pcyHL51jKG9VctVhGJnk=;
        b=f+V0CkkhnztRfIT54g00ZqQAvSLl+KO47996Tdp/Xbuyp/BONbEN3cUVfOPuFaJ7KZ
         A/fPHKlM3X6cBGT84cxhGyZzyiUqF8HEnlsJf1zX+kfG/mwF1pU72FFqtMTt6+pWaHEX
         gPEhgcmuPqwrusKFv7FErNaiV6tv8Z++YdmFP0zbJBHFr7Ym6/hJFcNzRPc0zfkDpP1h
         yLC6rvgTLv+1qNnFCckatJavDMIa6+WWz6JAaYUUKMf9m9bp+s315BlSd0lSb0rn0MH9
         bA/QqiOLzIR+MvBhwijqjcQy9n/05vmG11m3WknjOxBTALlcZCKMzb+0EzI+iFGdQf6p
         V8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=hKGb9w8KG5b73eiq1K1JTU4pcyHL51jKG9VctVhGJnk=;
        b=Q6IhtulleN11VrasbH7BYsEiF1+0WKItceR3MqV1SvWJStL+HHqkVWIvnl3sMOO6o2
         09A6aAFSR9P2hR3U/Si6tL3g2dCVYSIjwbRrKqDhlmvNUJHO+jRBE+WuzZ5gdWMjly53
         hhLpr+TrZ8//NAT8bs/VAR9inZqS1EcD/SXrftvib9AELaWpa7iSEFHSs8DNPXBDID/u
         R0Z22zgHUzq7IOJQvTAUKh29gOUPhM2XU42khn0yLrgGCDmz+CLhNsBAhNAR99COz8qb
         mn//L3BdPEtziL7bzHo5KXI+TQ/3vdtmSKD1qtPUiSZuRAIWHWZ7DNClqr7F9t+1VHLC
         Wz/g==
X-Gm-Message-State: AOAM530RnNUtiDM07t3rgiMkkWPvVOtxitRaKKBoQZ3M4JpQFJbFFltP
        TiCzCubfkJBP2wvgOXCeTpU=
X-Google-Smtp-Source: ABdhPJw2YSsSu09c3sO8K26eMzGbJwXH2EBNbCGZHGfeNhI3hKtXngb2r9yWYq4379t6U+LBk27HEQ==
X-Received: by 2002:a2e:9703:: with SMTP id r3mr9953312lji.422.1639908870993;
        Sun, 19 Dec 2021 02:14:30 -0800 (PST)
Received: from [192.168.1.100] ([178.176.77.193])
        by smtp.gmail.com with ESMTPSA id h17sm2009168lfv.62.2021.12.19.02.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 02:14:30 -0800 (PST)
Message-ID: <64b9453a-84c5-8d41-26d5-698d1ae9d473@gmail.com>
Date:   Sun, 19 Dec 2021 13:14:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 3/4] usb: mtu3: fix list_head check warning
Content-Language: en-US
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>, stable@vger.kernel.org,
        Yuwen Ng <yuwen.ng@mediatek.com>
References: <20211218095749.6250-1-chunfeng.yun@mediatek.com>
 <20211218095749.6250-3-chunfeng.yun@mediatek.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
In-Reply-To: <20211218095749.6250-3-chunfeng.yun@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.12.2021 12:57, Chunfeng Yun wrote:

> This is caused by uninitialization of list_head.

    Again, there's no such word as "uninitialization" (even if it existed, it 
wouldn't mean what you wanted to say); please replace by "not initializing".

> BUG: KASAN: use-after-free in __list_del_entry_valid+0x34/0xe4
> 
> Call trace:
> dump_backtrace+0x0/0x298
> show_stack+0x24/0x34
> dump_stack+0x130/0x1a8
> print_address_description+0x88/0x56c
> __kasan_report+0x1b8/0x2a0
> kasan_report+0x14/0x20
> __asan_load8+0x9c/0xa0
> __list_del_entry_valid+0x34/0xe4
> mtu3_req_complete+0x4c/0x300 [mtu3]
> mtu3_gadget_stop+0x168/0x448 [mtu3]
> usb_gadget_unregister_driver+0x204/0x3a0
> unregister_gadget_item+0x44/0xa4
> 
> Fixes: 83374e035b62 ("usb: mtu3: add tracepoints to help debug")
> Cc: stable@vger.kernel.org
> Reported-by: Yuwen Ng <yuwen.ng@mediatek.com>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
[...]

MBR, Sergey
