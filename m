Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9613E46861C
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 17:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355144AbhLDQM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 11:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244750AbhLDQM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 11:12:58 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADDFC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 08:09:33 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id bj13so12325598oib.4
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 08:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R6Bbzt/MO9B+P8FzyuXjc890gPkHD6284PTertXt/tc=;
        b=ZSodjAVpUwIM/bmdCTYSo2uKynwBKxYB9YblDMbax2c1MUisoAZsA3uV/9ghKHTtOR
         75XoXl5CpCpwJXpBbiOS/jmORkiyCiDpZFG6ZGg/c9r9as2QeQdWKVPZgxk3jXnjs5ul
         2xi+N52Y/8umkC9Ow/puJtBr68aZCjxCQ78XUNPzcQW/msCrcxy6GMhKBvaNgBRZorP2
         XN0Ys2N/NoMojLe+EJBEH4jeZo0AWUPFX9LI+d4S1LcvMvOgE14H+0gFBHRaK8fZ25js
         WntEuhrMwkoUZTSHBhag7fkPxKhRC5NX8YQLWcq6CGk+ErWrkj4ofUwznngLFUiUaoON
         AxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R6Bbzt/MO9B+P8FzyuXjc890gPkHD6284PTertXt/tc=;
        b=s2YSMzL1nPibtTu2gkPccFiUdanHoIWO5k2Wq2JnxY0EW1406JcYzMA4hUNKUUtulM
         vMJYKgIEe/3HCDzyPVr25NK2YL503aFFUDu5x+6tF3bXeD5S15cHb3MVkH6zzsxCNU7Q
         qK/moU1vkUfEqVLS3WpFTpkQjPZft7cbtKhKZFOwSEp6WNSBRt/y+WbcQiVlu10hTNpt
         GuydSsGhy2WXMzaTdw3eBBJEAUhra/3HL3trvNV2oXnnUh2lnlGiddQOypWxKZ5z5x3c
         +KzBZ3BIo6PnvsH7796PW0gi1msxp1Zh5UHSUSWcR3fPOEfZQ5g14EKZxHX06V2PcqSq
         kefQ==
X-Gm-Message-State: AOAM532mvkaLOpft8ojSqmi0ujK/BMFbzKvAKAl4LOy6yrDCf0GnG9We
        2IPgYFJDdK/pMeXR6K7QRUA=
X-Google-Smtp-Source: ABdhPJzA4fTSGINmYt9uggrsjQO5P8TvxRdZOVz8V9Zd54RUNJQwBuNLQXpXgN4DQ21BHLZdG51CVg==
X-Received: by 2002:a54:4104:: with SMTP id l4mr15248810oic.17.1638634172339;
        Sat, 04 Dec 2021 08:09:32 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id t18sm1223208ott.2.2021.12.04.08.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 08:09:32 -0800 (PST)
Message-ID: <366a22ac-ab74-f4e5-55ab-10ca988a6f0f@gmail.com>
Date:   Sat, 4 Dec 2021 09:09:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: FAILED: patch "[PATCH] vrf: Reset IPCB/IP6CB when processing
 outbound pkts in vrf" failed to apply to 4.4-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, ssuryaextr@gmail.com,
        dsahern@kernel.org, kuba@kernel.org
Cc:     stable@vger.kernel.org
References: <1638613684143163@kroah.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <1638613684143163@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/21 3:28 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

This patch is not needed in 4.4.

