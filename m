Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0D26053E6
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJSXZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 19:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJSXZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 19:25:49 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6BB18D442
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 16:25:48 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id s28so2954872vsr.10
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 16:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XX++Y+PXwYnUfgGRnflz5/CywsjweQVErdsHTTGA6fI=;
        b=WQ1QmKIF+m1UKPXyfNW6ma5zVbWpouQfAN4znwgvzpVwRDPx5Yzm4jzRi7F3Z4uopg
         SJlc0vYcqF2t8pzsJHXtY1PuHeCZ4wdrWxH50v+5HVVU+Q7e33hqfeJeCki+FQ4bpNIn
         m+y89WUZTEVPNwAM+WBjhH3SWL2y677yct87TZ9WLLddaHIBFswlxt7wESSS6oDaLz05
         HR5AZhNYsfuOnIvTnDf8DN7HiWveyNLRhyeCAvs30YVUcKGrTozdt6BMMQgDzDrB+jUY
         nK7aHvzwtoVA3ywK7zFY3IWDyebq/HZPLWKbA+sFBWosbh2r357DtiuD9phgLQTpZjh6
         ZFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XX++Y+PXwYnUfgGRnflz5/CywsjweQVErdsHTTGA6fI=;
        b=kBkSZ1DTLrDmz8kAthVYInqkbsuanc7AVcdbnnAouV2WkxHlWj1puJWnPpUXcQSsJr
         WMCFgd30khB8Qj++eWhoGMqwuQflMrMvu3mfk21RSvZ6lscRHW/1eupPxn1kKIV7EaCp
         526U8Cxw2RYC30+BygCSw2YkLiBPG889megmMQdxJstr1Qqt0uYqummWdzF0PhUyfLsI
         BftFItHzxuHpAkZJxb+2b0h+gRkBujCSt2x5H2M9APO6MTBfeDE97eUJT+Nu/ST5NlhS
         QcetyvVkHnqXRzdlRVwbg0KAXO29iiHcbEl0uspEXzKTuTPlF5oA+sJmzhLzVcoDxODZ
         /Kog==
X-Gm-Message-State: ACrzQf1H33NJbzng8Kvngzgg3h/t+S1QtoU6MM6cjAn0m4GMP+QkmciP
        ILk2wRj1s067JRbpytI68YlHBUpO02E05wBrbVfXDQ==
X-Google-Smtp-Source: AMsMyM7xSyjAULSMhLu/YxfM5AcyEFt7+szNFOR0jmeVz39aXWV6eofN1bateTcW59TCPVsVwDQX3V038rNkVCFvCA4=
X-Received: by 2002:a67:b708:0:b0:3a7:d440:398f with SMTP id
 h8-20020a67b708000000b003a7d440398fmr4921917vsf.56.1666221947078; Wed, 19 Oct
 2022 16:25:47 -0700 (PDT)
MIME-Version: 1.0
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Thu, 20 Oct 2022 08:25:35 +0900
Message-ID: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
Subject: LTS 5.15 EOL Date
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        sashal@kernel.org
Cc:     Sangwhan Moon <sxm@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I saw that the projected EOL of LTS 5.15 is Oct 2023.
How likely is it that the date will be extended? I'm guessing it's
pretty likely, given that Android uses it.

Thanks,
-- Suleiman
