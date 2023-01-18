Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6272671247
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 04:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjARD6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 22:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjARD6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 22:58:49 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7D9222F4
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 19:58:47 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v19so30795921ybv.1
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 19:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=EltB6c9wF05nNqy4iNHQfgZJKPx/aCilMiarEgO2Ct7kuZiCNNICVpm5/PcISkLBli
         DP5at1JgH4HBrtjQXHGru8MFJmrquJONsu9RYjtVuYvlEI+OCNZk3glJVvH8g7fQYM2P
         y6VonpgM0yXgMul8Hq8tVX/9kQ5+jYPGPciJKoly8r+VBcmPQZoRFADP4OWW1b36PbOt
         M8RCUto7dHZXnwr531Uw6YEpOky/H6v9ANicqwbK5fJUV/pAhAo2kGjtcW8vmdZ9Y9KR
         SUWm4AbibyIjdOxfykaadq4ysQQZOpi0rhtfAfUgruLKmEiFvcELGN6M5Yj0i0+CG1wZ
         k7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=EB8LLf8xS6ai6O4H4NWAWI7jgOs8Xg99KBMSi5AlWjlY2Mw+T7nZD6UykgOw90bIph
         513x1YBoligBDxwjkbmX55F+wb6BYJxbNzY7B8arqvutdkxANDUK6FjW5MHL5mVEuOb5
         T0tdkYQ+Z2LHIE5hTkESNDHbwrrI6phBs3jktkHueAyv9bAisnm98fsllLsLCMJ7D7CD
         d68gKogF183/7JD5CZABgg7NEkmdtWy53OxzyKE3qTxKJXyL0X2f5AsqHhOPlCFGe3Rj
         rgYsnmbXn8ePm7UwQQGLVP7Jm2YQxHecyK58qw76U2jqlRd75qWNtf+fMjMb9BPQngl/
         7qtQ==
X-Gm-Message-State: AFqh2kqcPUnRSbkeEhWMrFLoEIc5Ok5VxFgC1SeAjQ7yRnkb6/7oTGix
        SwN7y2LuTgyrDo2wOd1PI1VCWO8De0xWepRWY0f1YCascDo=
X-Google-Smtp-Source: AMrXdXs3dGfWSXa4poRcm+akvr5h87NCFbLwGFvyDejv8zUEpmPi7VzysGMrauuakQYCLyfEpTDUpsgisoo+1yZemgw=
X-Received: by 2002:a05:6902:4eb:b0:78e:9ffb:6421 with SMTP id
 w11-20020a05690204eb00b0078e9ffb6421mr777098ybs.95.1674014326814; Tue, 17 Jan
 2023 19:58:46 -0800 (PST)
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 18 Jan 2023 09:28:35 +0530
Message-ID: <CAHokDBn5ytqpcDwk_6xP6bBDNW51SZ8cN+LYGMM9EQkkOZhYgg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
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
