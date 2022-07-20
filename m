Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7239657B6B2
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 14:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbiGTMqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 08:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240971AbiGTMqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 08:46:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD982C133
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 05:46:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f65so16270186pgc.12
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 05:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=sEGQ7L1KrUZZSjc5lTCBdg4P620qJO0ftLSgZHwILC8=;
        b=rwUDwbnnw3bPn47kNfg7ezqzV/LZChu0a3v2CN0AynDdb4B+/tvtYW8/uAOhGtObcZ
         jdMz1+jCJ13tg2VyNFIzZPhKJMc7Ob2J0tf6XGCs9xkgJA/nrmYYJUXRUHBi0tUDuQmj
         v79GFiy1F8xNZ7qkRqvQzBaOyUzpSCbt2HEHzsViyqik+g6/sisTG7KHot3xgK9bWkbA
         SJQ83R0YkKJ6jYgdD1HuOk/8/NmH1MmCioP9T8sQD3DJRieSUOW7MGmgP6Ej+rLEdg//
         DEOGINokGsTjCA7yDSww75D/W4A1AhfCxEmU4SbMXhlSs0PN5n/iF3nOL2lr+c/vdHve
         w/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=sEGQ7L1KrUZZSjc5lTCBdg4P620qJO0ftLSgZHwILC8=;
        b=PodP4qnq11bcE5jfxI81nYx9NKtAiIIEvwMqHuwl7BCa4ycaLzsi1+FubF4FSg255e
         m8mAJIuKAItlstfkIgjwi7eILtLLXhQSohPyTnHZ2LGlh0CsirhaFpnMIBAsl87mMz6O
         0mccCn7WLH6tIA5nYgUvgmh1gjUDIp3Qpaq4rEW7i+/I72eB6NCnS/2loWNlkaEVXm6R
         JH5spLcVy9h7u9jEA9kNb+MxfycuCyCkIyZte5Cgx8c9n5hI3/UMAAl8wzLvO+jq4Cc6
         yNNcjMXGE3TKwaNloOrkT+sW+KmaMncRFyjGvbOsG7gQOGWWKuqCfKFkyvuYki6FUup0
         k8bA==
X-Gm-Message-State: AJIora/5djzyN+Ipf9bOMYkeqJ+RQ+mw0GOKNEkCOqjFG1wRfKq1Pg3P
        DYi5aYcwB7HFYwRjmGAAwYutyA==
X-Google-Smtp-Source: AGRyM1t7wriEhr2mqYC6echsB2BY8+c43mOtwnGP0h8SWWvTQ+c/TMAVrHpPIfdz3GHa7zH8ZeSiww==
X-Received: by 2002:a65:6d98:0:b0:41a:6331:cffe with SMTP id bc24-20020a656d98000000b0041a6331cffemr3365206pgb.297.1658321207565;
        Wed, 20 Jul 2022 05:46:47 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ru7-20020a17090b2bc700b001f219ace0acsm1544392pjb.16.2022.07.20.05.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 05:46:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     tj@kernel.org, hanjinke.666@bytedance.com
Cc:     linux-block@vger.kernel.org, songmuchun@bytedance.com,
        cgroups@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220720093616.70584-1-hanjinke.666@bytedance.com>
References: <20220719165313.51887-1-hanjinke.666@bytedance.com> <20220720093616.70584-1-hanjinke.666@bytedance.com>
Subject: Re: [PATCH v4] block: don't allow the same type rq_qos add more than once
Message-Id: <165832120656.248441.6551351074316660910.b4-ty@kernel.dk>
Date:   Wed, 20 Jul 2022 06:46:46 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 20 Jul 2022 17:36:16 +0800, Jinke Han wrote:
> From: Jinke Han <hanjinke.666@bytedance.com>
> 
> In our test of iocost, we encountered some list add/del corruptions of
> inner_walk list in ioc_timer_fn.
> 
> The reason can be described as follow:
> cpu 0						cpu 1
> ioc_qos_write					ioc_qos_write
> 
> [...]

Applied, thanks!

[1/1] block: don't allow the same type rq_qos add more than once
      commit: 14a6e2eb7df5c7897c15b109cba29ab0c4a791b6

Best regards,
-- 
Jens Axboe


