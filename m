Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA04D36B0
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiCIRUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbiCIRTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:19:32 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F9F811A1;
        Wed,  9 Mar 2022 09:18:06 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qx21so6528791ejb.13;
        Wed, 09 Mar 2022 09:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7oxE4fFKx58NyjRtMtX0xZQenpnJa7HJH2t7nBfbM0=;
        b=Y1eZY2aSMQF3FYs/zSOiOsjAuhxEUy3agYDVLBR1fosROQdd77++ho6YhSryc8HgIO
         2NZ3OivbKBedBaRr5X4euD9wNJuBJkWSmUJMR5EWaoO/d00RVVoAq1px9vq5nG7AB9iG
         YNqYLUnm29T0sRm1cAf99VshmFwYw9qJ9dEXOj3WOdOqaEQydswFveibOfX20uRHVusw
         2DVTucTJ8jclPEmmjngvT2lA0uanpchns5L2bPumZgI3RmGD9Nu05yn5irnFQcTmsnnA
         vaM4rfL/MKN4uEVpEQEyeZAl7k1x8Y1cq+3G6N573/vzJMiku6cZQR39usbraCuQqHm7
         FOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7oxE4fFKx58NyjRtMtX0xZQenpnJa7HJH2t7nBfbM0=;
        b=pKi45Jl1B2tbIq5qxdPyvxuGCeYfoDW+a1tzUpF0PWBurQk1FTP3pf6AgdE6bsdeU/
         mmIqEo7hiCHKuENtWtfSoxiQLWiJz1fwOL6/WfZL9kozSr+8/Z1LhC7001T0veXtyPwK
         9h+9uSQVoHvBmwnHFB+4Ak0bs+mG65KXFrS/ayyxsketXccZHnm3UFrbBX1xzmCGN3Mu
         /Q8UU3xhKz3yB2a8FXkOYQGWM6OgEVqePXNegcXaoCfsAmaTwRZv/iFNCy9UyO8YNuLZ
         z6faRdJCX+mguqPkpzxKEWxp8odlhvw/ZPbH9RQ/ExeRC39kkz8saI92z3rJQk7wVy7o
         vG1A==
X-Gm-Message-State: AOAM532pzLjUX2v4rHomMOH7pwfsjfMXvBi3pw3KRtVS1KyqZrF3Hmsu
        LBSuBdu1m6sYxq8Bqmlp0FP9o1W5N9Y9o28AWIQ=
X-Google-Smtp-Source: ABdhPJyKloDe4ClKvdZSQX8+04jMZcVWIXzwBt1cZ+doTm5lDUCfySKxxaPvCU6hz4fsS3AH406wtEFzZR+rFQ3RzJc=
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id
 i6-20020a170906264600b006d5d889c92bmr736614ejc.696.1646846284996; Wed, 09 Mar
 2022 09:18:04 -0800 (PST)
MIME-Version: 1.0
References: <20220309143322.1755281-1-festevam@gmail.com> <20220309143322.1755281-2-festevam@gmail.com>
 <d75bbdb1fd01f0c1ff89efe1369860cfccc52f5f.camel@pengutronix.de> <25171f0f4e2712fdcae7b2fc2e7792f8f744db6c.camel@pengutronix.de>
In-Reply-To: <25171f0f4e2712fdcae7b2fc2e7792f8f744db6c.camel@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 9 Mar 2022 14:17:52 -0300
Message-ID: <CAOMZO5DTZrcjXFvuXbBJ-x_idXBe5rLTWfbif20ES5oxZ+gMSg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: coda: Add more H264 levels for CODA960
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@iktek.de,
        stable <stable@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Philipp,

On Wed, Mar 9, 2022 at 1:29 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:

> Looking at my notes, I've never seen the encoder produce streams with
> levels 1.1, 1.2, 1.3, 2.1, 2.2, or 4.1. Has anybody else?

On my tests, I only saw 3.1 and 3.2 levels.

> Level 4.2 streams can be produced though, just not at realtime speeds.
>
> Also, this encoder control change has no effect unless max is changed
> as well. I think it should look as follows:
>
>         if (ctx->dev->devtype->product == CODA_960) {
>                 v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
>                         V4L2_CID_MPEG_VIDEO_H264_LEVEL,
> -                       V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
> -                       ~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
> +                       V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
> +                       ~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_1_0) |
> +                         (1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
>                           (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
>                           (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
>                           (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
> -                         (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
> +                         (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0) |
> +                         (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2)),
>                         V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
>         }
>         v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,

You are right.

With Nicolas' original patch I see the following levels being reported:

h264_level 0x00990a67 (menu)   : min=0 max=11 default=11 value=11
5: 2
8: 3
9: 3.1
10: 3.2
11: 4

With your proposal I get:

 h264_level 0x00990a67 (menu)   : min=0 max=13 default=11 value=11
0: 1
5: 2
8: 3
9: 3.1
10: 3.2
11: 4
13: 4.2

I will submit a v3 with your proposal.

Thanks
