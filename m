Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58936A7482
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 20:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjCATub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 14:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCATub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 14:50:31 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600413589;
        Wed,  1 Mar 2023 11:50:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso406884pjb.2;
        Wed, 01 Mar 2023 11:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EcL2xc+jo1Oi21C4TguKPhlvvdT+vHzHD0oes4K8qgA=;
        b=ZLXczby2hIHf3MV6UZoaPOjrtM1tTj+011ky/R3TnLUo1e/GeUPfQJIVaTpWhmOf91
         XG+hxBzeDlSjDXWmt7pdII2kIgRAY3VjxoPDo2ckY+QcxyG+ch7vjujrjJUu0CC5CwOL
         0MVeTBoOUlU5iHF5I1O2ybYxB2muAnKvRqPaHu0gSwV8MHam2vb1jIHgUWjsFbxLEQ9c
         y7C8+kUjGAK+AHw/FBaBMu1Pc4/8IRWMIPaDyStc3CZeD6GmAfzbsTD5zjcteOYKl49Q
         dRPpj0m7XQHTeO5Bu6XRZY+df69sx5zyCIc3nmV2TjZnyi/LKcSlzXwDACsD6Fi6qsbY
         3n/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EcL2xc+jo1Oi21C4TguKPhlvvdT+vHzHD0oes4K8qgA=;
        b=gGP/RPWdQyvonooATbdhoBAvQJ/q8Ztj90dZCV+DvjyIG1Q6ts/wFjTjcyEd0BkEoC
         p0/amOLQ30KNUq8tC5+qIv/Hn9Y/KfzKPBi+ZsmEmXguxAvkP/CwvWqZCrRrUkWcSNjh
         soSXxLPm1hENpDAqbO4tP2YB1M7pf4IWsR+lt8eajWFmMOQ6IDH7oRLRLPzJz4/TUqYp
         XoJs91LARv14pdRt9GKTZjPPL8PUgHqegnqzWxS4/NwnRs1cJQlbSOsP3s8KjMQbW9IE
         xzwWv13b3jSMEGVfJNMJD0RktKwaWg5+J2TQJBhzO7esdDIxIQXJLsccaO0FwnNEBFAi
         GLAg==
X-Gm-Message-State: AO0yUKUXVzoA6PIuVSfVGANzGHRbvxAf1JCQuMpABcYgMCWlSF3hGGid
        THxXDJ/uA9VtMUNFrGsKJ2cwFcDpJ7HZKHZ4xgQ=
X-Google-Smtp-Source: AK7set/qAHZZUFxZFqXuQhYsV09JbqVtk8MOeNuWxNp9B/4Y9CE61HaKh1lDLxZ9UOT5kuEwDIDWtMwYmAYF26s7e3E=
X-Received: by 2002:a17:902:ef8a:b0:19a:f9d5:684d with SMTP id
 iz10-20020a170902ef8a00b0019af9d5684dmr2806020plb.8.1677700229834; Wed, 01
 Mar 2023 11:50:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7022:fa6:b0:5f:9f12:d99c with HTTP; Wed, 1 Mar 2023
 11:50:28 -0800 (PST)
In-Reply-To: <6eb685c2-6a13-ec1d-ca98-cead97f1c75a@gmx.de>
References: <6eb685c2-6a13-ec1d-ca98-cead97f1c75a@gmx.de>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Wed, 1 Mar 2023 20:50:28 +0100
Message-ID: <CADo9pHjhdVWd789m75ZspktBqw9gWnrrH4cUCNph9773_jpxXA@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        droidbittin@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Working on my Arch Linux Server with an i5-6400

Tested-by: Luna Jernberg <droidbittin@gmail.com>

On 3/1/23, Ronald Warsow <rwarsow@gmx.de> wrote:
> Hi Greg
>
> 6.2.2-rc1
>
> compiles, boots and runs here on x86_64
> (Intel i5-11400, Fedora 37)
>
> Thanks
>
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
>
>
