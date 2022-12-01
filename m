Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511D863F328
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 15:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiLAOym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 09:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiLAOyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 09:54:41 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29568BB7E7
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 06:54:41 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id t10so1620927vsa.5
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 06:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=XBaVql7f+4qzRRyAhxed1XcNL8z+uFAvarDHUndkp94wjlu+iR92cUQTW4r2PnBUYf
         JmytaxB2bYWevPGKgTltyr3KVio3qWQNr0+iPxT+kR0cpJGG/X5YvOoVcENYw+WxDeLU
         Eiq32r/3b8eej+5we5Zof/j3tBEC0gkADA5VBAIrsowZrqc+dizGNjut5E8cyEV8dGC0
         2W4jp/dlPK2BZAT+TUeOD8FwR0NQ1J5CLMPITiUsU5sUv65tQg/ZAfqG1FcShMRZVQeu
         WpYT1ARTQZpSpcYxLEROznfqv6WD41dQE9bhfjpaEXtydlNn2X+mKpeynkVjfvtfMhgt
         9kQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=p8TXhG4xZqlKEIJP+qnNIICbhepu/dF0glmE0FZaZXttMEWKDSnGO7PrVpV5gVIxa+
         6N03ngmLZ8ty1XOjh1sxSu6S2v4sw/m54Z9K4MeDXAQb08lK7T4nyFuo3CvpTwjKs2Zb
         Ah945wyXF5O9vmmxGc4NwbUWV8acL/bd1qA48XMD0KnWv7FoQmZt/I0d+/oB+zcu8erP
         sxRHk/yCkqNOX/RZw1+LmtK+MgO97Mpy8fl297gPx26wrKVPDBPFIyq8jpUr//1r5HfM
         FpIQZFJX/ULEQA3owedJ0p0+G5YS5kL6BZ0dct7K3Qbn0ilQb5wQFpHRvSqGWZ4/ES1O
         GQIQ==
X-Gm-Message-State: ANoB5plBUl423TEqqD9DaTOtDcpB422oWV3+kiRAsWqOm/bxJxHoUajQ
        7l6mdFa0gIOCPSuoZAaSc4kjIyX/7cyn5SLS9Hc=
X-Google-Smtp-Source: AA0mqf7QiOtboSLDILthOpBV/UDIU51+VfSg1GgP7GHLrG9/qSbmMpEFJdwl1y9oqYmvWgJCZHOsCFTq6McsGyaYqAk=
X-Received: by 2002:a05:6102:502:b0:3b0:df43:87af with SMTP id
 l2-20020a056102050200b003b0df4387afmr3591729vsa.1.1669906480192; Thu, 01 Dec
 2022 06:54:40 -0800 (PST)
MIME-Version: 1.0
References: <20221130180544.105550592@linuxfoundation.org>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Thu, 1 Dec 2022 20:24:29 +0530
Message-ID: <CAHokDBmknu-kZajUK5wa3vH3g9mYkDJoAvCFAsM0OUmJoC9BhQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
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

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
