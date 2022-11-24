Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2B637034
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 03:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiKXCEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 21:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiKXCEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 21:04:12 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FEBC6960
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 18:04:12 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id c184so307299vsc.3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 18:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=mqKagfDM1mH134fHZKf3zeVln7tuiOAi8YSZb4JzWr0vwjIpTz3yu9nAQkTtdgFAjZ
         TUwjKNRrqw/v7wtFnSgTZilP0in30ly+xIIPrVS0z6DYFEoDrNYNCHoFR1oYecjDnRZa
         VjaOTErkwxQ7FLNPMspLG8go0YZGTmzDIPDIhAuE28CEl4lFY6GNR8mKjC57MaL5QRAx
         usJLA8WqIehCQZytzSPQ5r0jV3NpG3mg+RthCOoNH2sRBh/aLM9hxnbgmxTPXZ9noaeO
         zj5Ia7wkZ5i/bDSA1qgqGhyEzxQZJlVluyi2fWj1jcaOm5IEOuGeND0A9tYZYPj1xIMB
         IGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=YcZuJB7+YEe417zJcnVihdK1rWCNVMOAQpfnTKxVvNH87VwKtiHWGfzNn7dpnyJqsk
         pD+SI03Nz2e6J4KX3Hg+WWwswnlePIpdSs2DfSoqOOnXg7xscslrSsHuAxQYHTD55BAd
         88t7wxwvQQT16rUyyaNqf1G/00nUaYHQkPpN/d2Yu3WOf9GlKAxR6qSOTcnZgcdHcZ1j
         uf5W812WVrBwdn84gTeuvU1nwZRNQ9dfiHMjYfMw1swbHWNBPQVTj7Yvi8AspRpl5UgC
         Tz8jr6egSc0KNsPMR9mWt5mCjw0kHHWRGSezedaRXUYxDLXxMpapuv5CpoAbz5Jqf5mw
         OwmA==
X-Gm-Message-State: ANoB5pnH4WNLsRg00H8bhPdwW4CroMRfq1hZQ7eaZ4fNFGjiQ3e3nMbC
        YcEWGRHA4LNR+2BdTXFscSiHORncGCXXo/Bg4U0=
X-Google-Smtp-Source: AA0mqf4aKClbQYybQaKt7gAaVw6d5l4jA/oNoOEhSJ0/JkPQg6cTfCCi1bK161gaIVwDc5ey03/B7JiKKU3LhofRu50=
X-Received: by 2002:a67:c792:0:b0:3aa:9c4:a9a9 with SMTP id
 t18-20020a67c792000000b003aa09c4a9a9mr6977575vsk.75.1669255450991; Wed, 23
 Nov 2022 18:04:10 -0800 (PST)
MIME-Version: 1.0
References: <20221123084625.457073469@linuxfoundation.org>
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Thu, 24 Nov 2022 07:34:00 +0530
Message-ID: <CAHokDBkriHyn0UTyXiCLXKqW8ZkEJ-+YZ0=hrYCanWYsnVjzzA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
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
