Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7819D63FFF8
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 06:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiLBFuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 00:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiLBFuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 00:50:50 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768C8C8D14
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 21:50:49 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id 124so3727318vsv.4
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 21:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=PonfF+VQBmKM8Ftmu9lk3DE9TV2hWwwvCdkfCRtsAPWg5nKEFIMCYGN7bABCfreB1l
         L3WxNYjoVX9B4fBu9/AFxRL0+McHarxiJq+ADzrG+H5fhjdwAEe7aSJC3ln4MMflDsTM
         swkKa+lHKBYS6e2DsODctoYm1Ys8Z9SNqcWHCU/B25r3NYw4vFkZ2z52pLHxjhlkSYvn
         mbw7lrXYpwa2B4/rKxQ3B42nxnHNRcU1gRcahzwF+0YPcCvzR+cB5Pz7S4Qw2+QPPENx
         4UCHPIXef9z4O1h49AtuTCFLEg5t7N5Ub/FerqPqlrA9aQ7sQ0AvghdwfvTfxMzyMrXT
         mSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=SPM+K+0fnF+LqmUHHhQqrm2W/kqtJXbwXMdy56sOWiQTFxd+nXk+gLeo5FYilx1U/O
         7Ta8FDiqdvScbrB+J7tkcm2QjIoBtRDVx7tE/gQVrOlmWDK+dL5wYHExU1epsKsiyXrg
         z8r/KXj8MADpUOT5Udl4eNq3duFl17UiGFx2djsdOa+Ei2+4mHKWMLv+ojFa3Cebi6PA
         ODGjWkbQ7yJzvdPdDOGz2131MELQdGZA004kZpRv72QYugOrO1pVZczQcoK/NSMZtdyG
         vUGP60ME1FL9GfjSS5aEeqT1xSlXvJEDvk8ZpYb1O/26+hdmwRsB5FO6Bl85ihU7+3qX
         JETA==
X-Gm-Message-State: ANoB5pnT+1CMEH3kvDyHwmwgwuKg9MyIM84VEEB7WIxo3N14rmCxHKSM
        kSc1FmCvPyOWtLgbrDZuwot8BJ3HERKrNPmcJ1H/ExCs3Xg=
X-Google-Smtp-Source: AA0mqf5UzrEDgJd75nJAbhsd/JqHZziY6nz1vvEThnkRoZLedrRmhTZHlgVRCZdk5qIul44gPCjtYEsc/YG1/z94yws=
X-Received: by 2002:a05:6102:502:b0:3b0:df43:87af with SMTP id
 l2-20020a056102050200b003b0df4387afmr5240871vsa.1.1669960248540; Thu, 01 Dec
 2022 21:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20221201131113.897261583@linuxfoundation.org>
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Fri, 2 Dec 2022 11:20:37 +0530
Message-ID: <CAHokDBkyTX1PkR3MEMj6urGdRX+si5qNJB0sweaiOPueUxirLg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
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
