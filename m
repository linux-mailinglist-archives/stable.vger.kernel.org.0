Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C19F67E6FB
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjA0NqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbjA0NqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:46:10 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8251C3FF33
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 05:46:04 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z1so251826pfg.12
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 05:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTaxy2TnPiRYJ0TKsln4Bi8WHW10ryilnxtI3oqi5QY=;
        b=zwHRs1Ei802Vb9no/UBDk4nyvDIsa8z0aiIsZLwZ9pympF/lz5acogC3JN2nWyu/9U
         3S9tGvXoCsrlnZMfsC3UjsG4smKdI8+4wRRJoZdf7nr9l8mE30vlEkkZALb2lxQfoFHz
         0TMrLz5QDSXemYRJxwuLzcNrtq45oCapUrNYuWXaOXl39N81BttTTRmGLf3ucP3XlwFb
         3XPiYPrW+zt3UnbPF7DTRTt4PFTe2vInB44hNlpA7/yEn2OAnrTRH0SlUox+gOEZ8QSe
         Jt3TmEXFmucyDv6iaRqbkTnqO04KqTJlwaVPTEDf4lGiKKvge9YqIuA0CwnFYHSI3hja
         Slgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YTaxy2TnPiRYJ0TKsln4Bi8WHW10ryilnxtI3oqi5QY=;
        b=t242I2IrcICap1BmAqc+9T5vUG18ws2xYiMGFKfCcopRbX/tqfY94lmkVzpGrp8siw
         pPkBra4uOtrsYsQVL82AZsz/cdLGJvZgNYNRljcJ3U8E1ekHYlVvKns/6vzzBHzokQeo
         yfX2dxvga5VpsPWJDqTZrNGQhyFBLTOWIz6RLbGfNyufxbgw/NwNTmtnDB7csF9MH2y7
         j5/pL99WbZf6q8sqSTTdycnN5aApSq94OqH1z0DAxn4WIWn0YMEQpBKRAt0OlsilyvL8
         MaKbW2SrUvtR57MerMpF8uiu72WN9AyUUtPGQ2Afr8Xkq5vRB7voSTDmJgHxtLGZK3zJ
         zlig==
X-Gm-Message-State: AFqh2krWIK4FBImXYDTXuMHtm2bhbZPIjojhzaiFm9FhehgP8hFtnccb
        p4VNgWXCMSHQTcYzNxiDanqM/A==
X-Google-Smtp-Source: AMrXdXu/rw9R+blC7zGSLJiHnv/+xU+Pp5JXlaMt4HY9oYtf6XrqmtOQVOw2pRTXl+awfZfDtJ0VuA==
X-Received: by 2002:a62:e919:0:b0:58d:be61:7d9e with SMTP id j25-20020a62e919000000b0058dbe617d9emr8848731pfh.0.1674827163722;
        Fri, 27 Jan 2023 05:46:03 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b25-20020a056a0002d900b0058bbe1240easm2602912pft.190.2023.01.27.05.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 05:46:02 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, stable@vger.kernel.org
In-Reply-To: <20230127105911.2420061-1-dylany@meta.com>
References: <20230127105911.2420061-1-dylany@meta.com>
Subject: Re: [PATCH] io_uring: always prep_async for drain requests
Message-Id: <167482716231.273660.4883362917562226118.b4-ty@kernel.dk>
Date:   Fri, 27 Jan 2023 06:46:02 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Fri, 27 Jan 2023 02:59:11 -0800, Dylan Yudaken wrote:
> Drain requests all go through io_drain_req, which has a quick exit in case
> there is nothing pending (ie the drain is not useful). In that case it can
> run the issue the request immediately.
> 
> However for safety it queues it through task work.
> The problem is that in this case the request is run asynchronously, but
> the async work has not been prepared through io_req_prep_async.
> 
> [...]

Applied, thanks!

[1/1] io_uring: always prep_async for drain requests
      commit: ef5c600adb1d985513d2b612cc90403a148ff287

Best regards,
-- 
Jens Axboe



