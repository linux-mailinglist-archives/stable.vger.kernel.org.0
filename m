Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62902468DE1
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 00:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhLEXMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 18:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbhLEXMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 18:12:23 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E545C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 15:08:56 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so11357146otl.8
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 15:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Nc5yd40+w2QwFetOm6H3wDqkBGvwBYQDD1WuAN9IRnQ=;
        b=PRm2SGuyG16zOeha31Z9f5eIjhrQLLwiXEJCVGmv1LXO9oyXJbpn5R2FQcAB8RaqM7
         fuEpqkt2sa5Wr2CuphUdNSYH/QsBdCzX55rek9Ji4KUJWn/6j+zIGBokDf0aymIv2Nvm
         CIyEYaOXfoN5RAEYAd3B/47zs072NBrfU5HAreLq0nAIBjZ4CIn4hrGIYhTpeBdj4TG6
         TMXIKavrehWmpT7LhX5p6dpu2BAATLYH1GaGzpH31KjG5zGoXmQYER39o6jhIoEQpjFS
         ukkVp1koXd9PPx871t5+YStkcPCWys9era40LaUtgLE5Gyp0K78vykD2p+HIFdscbgTI
         Mo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nc5yd40+w2QwFetOm6H3wDqkBGvwBYQDD1WuAN9IRnQ=;
        b=QDMmQ4sNiSSQRlvXFNMt/UfgD7WefYlES2315FoVlXZK/xCwIOrvFMo2WbJ9nlQuQ3
         XsDD/U/3ZLu/vyQKFo8BOmWzCpp0P9RH5FcOoa88hO04D8RmTikPEscbbrE1cU54ZdI4
         riOOh8VHsZvpRxc3rOw4Q3cXOvbuhP4sFNXcoAKttqJbZgm9K7/u+KsmuuAMXhEK5vzr
         OhieUeowEAPBddvw9/3ziUD5J7dMvqOBgjj9SON1ZbptenEN1QApQsBs/IAJboEiZbB5
         LdHZMY+qrb5gMrSPWwe18lfsRsqkCfz2W9HKtFGkJZBo+oc0xP1DWTJiAZp1mKFfjfDo
         QAdA==
X-Gm-Message-State: AOAM533KYG+hH7RCTe+1DNBlz7vZk1p8bKJs4fs1pGbJb2Q0EN+LxmWU
        K1l+iIjkjpXLzCsMSxr/OEs=
X-Google-Smtp-Source: ABdhPJxiVX6jwmQIgD80YVkB/V9/PKap0OkNtCGwNO2mMe8kHJ1ujILPNig0mS2gKs2YbEFOttpBgA==
X-Received: by 2002:a9d:12f3:: with SMTP id g106mr26331567otg.175.1638745735726;
        Sun, 05 Dec 2021 15:08:55 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id c3sm2422372oiw.8.2021.12.05.15.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Dec 2021 15:08:55 -0800 (PST)
Message-ID: <658227e9-091b-cfd3-c71a-a16e5295134a@gmail.com>
Date:   Sun, 5 Dec 2021 16:08:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: FAILED: patch "[PATCH] vrf: Reset IPCB/IP6CB when processing
 outbound pkts in vrf" failed to apply to 4.4-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     ssuryaextr@gmail.com, dsahern@kernel.org, kuba@kernel.org,
        stable@vger.kernel.org
References: <1638613684143163@kroah.com>
 <366a22ac-ab74-f4e5-55ab-10ca988a6f0f@gmail.com> <YayzH/JxsYmWXdLj@kroah.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YayzH/JxsYmWXdLj@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/21 5:39 AM, Greg KH wrote:
> so why isn't this needed in 4.4.y?

The patch fixes a corner case with MPLS + VRF. The VRF feature is not
really usable before 4.9; I doubt VRF + MPLS with a last label pop is
usable in 4.4.
