Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316174AAAFA
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 19:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348405AbiBESlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 13:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiBESlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 13:41:12 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53FEC061348;
        Sat,  5 Feb 2022 10:41:10 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id y23so12518967oia.13;
        Sat, 05 Feb 2022 10:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B9Bm+yAr31loFfVFxMsXKKX2xve88jnXA1e2Yt1FPUc=;
        b=ZqSkArklkvjjwFEwFqEVIgp3BmpyM7LLTf38xfEGQZ67ur3c/ro2jou4WS0PlLgv0D
         34HIZhzM1DqTdi3nRPwDu4DgIK/c1lDunPeWE/aMV5Jr/qtdTPwpPN8PuZYMFld1vAxz
         k9Z+nW627BzxzMmfNkJip3v0mwBSr6MUe3JFc7QOqG8+ETRejLmSuyFs1VCJQTeB9DOb
         5XltNMm7qpabAXlLVG8xrIDw25p1tCcqomu4rAHw7pePJpUeKRatWJmbCsDDvGTXLE9d
         Ggsf+8mg1UIkf8jXrC8ziOjQqDk04vHVcR/fLYlP42uN7iSu6A/DtGFP/XnJsIDK/TVd
         U61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=B9Bm+yAr31loFfVFxMsXKKX2xve88jnXA1e2Yt1FPUc=;
        b=NUcM0ABimHCFEWM+FvHpt6MHp2juXPbyPnGVLkzbe3ky69E6rigXcPgxR5Qrzt7Ldu
         Cm8ry6yxDt9F8b4sQXnHVMHJIYnulHkz/5uQ0V2U9wXe3jAPRA5+ZBQTKC3a1FcFL8oE
         oj+poBhQQWZj8ta6aS39vFIHqRC2P8Tim8+fzPM1ajmwaT5JU9ubG89iX/mf0qm0VMjb
         s9pG8MjNz3va/P1gBsZSi1LQB4NLAGzmrWi6kUqnBIznDfSi9Te7fzT6GNRBE8yIuCsz
         LmOqJn/xu7acpC3d3+Cg4pFuHJ2/7zCKq/G5WaYcO9haGYI4fw27tJ2XKMAcnTAFUbtI
         lgJg==
X-Gm-Message-State: AOAM5323vYbJ4uNaBKci+ajVLjqqc87nIpyvfmLCVp0kjbtCNNYKCCEB
        MP+Z3B0za/4pAejhR/Kcac4hIHOwT4hY1g==
X-Google-Smtp-Source: ABdhPJxI6P/fJrYExhnyx36u814hvLBgT6Wks0Zc4QF3GZiy9rt43MZbqvZbYbZWudV944md/ydkYA==
X-Received: by 2002:a05:6808:1206:: with SMTP id a6mr1058871oil.279.1644086470111;
        Sat, 05 Feb 2022 10:41:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bi41sm2015506oib.39.2022.02.05.10.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 10:41:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 5 Feb 2022 10:41:08 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH 5.15 05/32] drm/vc4: hdmi: Make sure the device is
 powered with CEC
Message-ID: <20220205184108.GA3084817@roeck-us.net>
References: <20220204091915.247906930@linuxfoundation.org>
 <20220204091915.421812582@linuxfoundation.org>
 <20220205171238.GA3073350@roeck-us.net>
 <Yf66Y2/N0nh9tMxT@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yf66Y2/N0nh9tMxT@kroah.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sat, Feb 05, 2022 at 06:56:51PM +0100, Greg Kroah-Hartman wrote:
[ ... ]
> 
> Yeah, something is really wrong here.  I'm going to go revert this for
> now and push out a new set of releases with that fixed.

If you pull a release for that, can you possibly revert 9de2b9286a6
("ASoC: mediatek: Check for error clk pointer") as well ? It does not
realy fix anything but breaks pretty much all Mediatek systems using
the mtk-scpsys driver. I sent a revert request
	https://lore.kernel.org/lkml/20220205014755.699603-1-linux@roeck-us.net/
but the it looks like the submitter keeps defending their patch. In the
current state, pretty much all stable release starting with v4.19.y won't
work for affected systems due to this patch.

Thanks,
Guenter
