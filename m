Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C8F66A73D
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 00:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjAMXzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 18:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjAMXzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 18:55:40 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395637C38A
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 15:55:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso25926809pjo.3
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 15:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LF3WsXigIPtoM91xDdGg1MKwYTSeuEO0M3pVuLY/JbQ=;
        b=UooW/gPdlyiA1OGaapbkni44sryCSNVmMvtT9Ul9RLHWTvKLioT8nJxXKUFZqlBUC2
         fVRlwYCZe2oHJ/vbuFEOs/HGaZgm2cDjSh/ntaE0nzKPdbPqZTP/JRCDDWEyuLIALOYC
         KECbXHdpPj+Ai1NKz/0SixoNMulCOF6hUTPX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LF3WsXigIPtoM91xDdGg1MKwYTSeuEO0M3pVuLY/JbQ=;
        b=U7inoR4EHbAuIcvuQmXFzM6q/xUfboBOXsFMXBRyBdUZdg/BeykUcCBrU8gLoaWUcf
         0CxyZ7B5PL3cwHVq++ViZrlWeCMZqR6y0IhqJXtjl+wEQ6eEYo8/ujOowtWLHXGiIQ/K
         j/cgFqjPtgokaspVwHTd1pmLv7s2S1LRCxhwNztpl8vaI29v6LqcAvLEBngaKX+amjly
         XMFBRjLu6mKrRqMAnfc8nT4mIgQl1ZIFiJ+UZrjLvIEOOYepY/nhk753eplxjMmzVHHS
         dG98C1bcP36ECPIpc7U86kqry4mzPhTyDUU3ubd/LJRtKlpn9MXM0THOYvDSJM2DmS5w
         UriQ==
X-Gm-Message-State: AFqh2kqedq76mfjGme01oskq3r7g7HsCrTamLBLnDSrucJwxshUfOQOC
        ebA5vJQlj3OlN9/Nf7VhEJ6+Ew==
X-Google-Smtp-Source: AMrXdXsOAdCKdSgYkiZ/E0ZO8oA/rxRKPzE25xlurZuhM3GKj0+vty25gaw2s5FBdvVB2khEsKzUew==
X-Received: by 2002:a17:902:d50e:b0:194:3e44:26a5 with SMTP id b14-20020a170902d50e00b001943e4426a5mr22623176plg.66.1673654138780;
        Fri, 13 Jan 2023 15:55:38 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r3-20020a632b03000000b00478e14e6e76sm12379469pgr.32.2023.01.13.15.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:55:38 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Fri, 13 Jan 2023 15:46:49 -0800
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Holger Hoffsttte <holger@applied-asynchrony.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-mm@kvack.org, amanieu@gmail.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: check_empty_area_window(): Error handling issues
Message-ID: <202301131546.73FBCC7B6@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

This is an experimental semi-automated report about issues detected by
Coverity from a scan of next-20230113 as part of the linux-next scan project:
https://scan.coverity.com/projects/linux-next-weekly-scan

You're getting this email because you were associated with the identified
lines of code (noted below) that were touched by commits:

  Wed Jan 11 16:15:43 2023 -0800
    ebc4c1bcc2a5 ("maple_tree: fix mas_empty_area_rev() lower bound validation")

Coverity reported the following:

*** CID 1530569:  Error handling issues  (CHECKED_RETURN)
lib/test_maple_tree.c:2598 in check_empty_area_window()
2592     	MT_BUG_ON(mt, mas_empty_area(&mas, 5, 100, 6) != -EBUSY);
2593
2594     	mas_reset(&mas);
2595     	MT_BUG_ON(mt, mas_empty_area(&mas, 0, 8, 10) != -EBUSY);
2596
2597     	mas_reset(&mas);
vvv     CID 1530569:  Error handling issues  (CHECKED_RETURN)
vvv     Calling "mas_empty_area" without checking return value (as is done elsewhere 8 out of 10 times).
2598     	mas_empty_area(&mas, 100, 165, 3);
2599
2600     	mas_reset(&mas);
2601     	MT_BUG_ON(mt, mas_empty_area(&mas, 100, 163, 6) != -EBUSY);
2602     	rcu_read_unlock();
2603     }

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1530569 ("Error handling issues")
Fixes: ebc4c1bcc2a5 ("maple_tree: fix mas_empty_area_rev() lower bound validation")

Thanks for your attention!

-- 
Coverity-bot
