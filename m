Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E716686F0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbjALW2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbjALW1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:27:46 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ADF1144A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:54 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cx21-20020a17090afd9500b00228f2ecc6dbso199956pjb.0
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A54yac4BAWkZwqOsOOvFHf19PWyqxHbK9tJTpVIoor0=;
        b=EQoAb1ExTwoGBg5iu0h4ji9Q8ozYqVUjmxuo85Z3uH5Vk06mydwcR8YAQKqDKKo12+
         1W2UmZZUCoPxiCLe22X+wVkFwqgSOucLH2TfxfJMBbNiHeG65OEFpTEfHlX1lR6Poorm
         nK1kOQB143Igo2sQP7Urp06rQINg10PTRo46g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A54yac4BAWkZwqOsOOvFHf19PWyqxHbK9tJTpVIoor0=;
        b=cw7+j3VudBLisJAYQrAQqC6gDaBxt6AOOvUCiFZQxN+PGxnHXB9ebGBrEEiRkjpRCj
         1T1obIcQlI/oaPtw7loFyaMiGQR5ExKvJI7AUxlc/TvLfg7fNKhE/qDz7UiwPxw1fEy3
         onfKkYjXeeIOv8YLya2hJFPe5SFrf4/SEdwbo2/mtkP4BAPhHqNPLlzGP5IZMFKRb3Iv
         VvikOzVjWiz4xSMzYorY1p711Iqjw1d9qFVw+c4rcvSR/60SanWTozNDJ7amEwa1sI9T
         ZH1sO9CaupXMGN5yHH2FzPINT2zV4MFjD9vcGygYajfIMFJcAGdiWkD2j43Mav3nmQ+b
         IT0w==
X-Gm-Message-State: AFqh2kq2A3VXw8JqO/TOkcd0WP8YUQE3a9TQQ8InX+E9ZGJgDUajk6AZ
        01an38V+8VBSSaRt++WiAWAfpw==
X-Google-Smtp-Source: AMrXdXtExiiGpzJwhZ4BU+ZUXWCuCrBSSK6jsQ5VM76HO8tdzVlZ22HjPbCnQ6UwzP2EXolqWHJNrw==
X-Received: by 2002:a17:902:c104:b0:194:66db:778d with SMTP id 4-20020a170902c10400b0019466db778dmr2314847pli.32.1673562293891;
        Thu, 12 Jan 2023 14:24:53 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id jj13-20020a170903048d00b001928d49bf84sm12611649plb.191.2023.01.12.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:24:53 -0800 (PST)
From:   coverity-bot <keescook@chromium.org>
X-Google-Original-From: coverity-bot <keescook+coverity-bot@chromium.org>
Date:   Thu, 12 Jan 2023 14:24:52 -0800
To:     Jaroslav Kysela <perex@perex.cz>
Cc:     Matteo Martelli <matteomartelli3@gmail.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        =?iso-8859-1?Q?Andr=E9?= Kapelrud <a.kapelrud@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        chihhao chen <chihhao.chen@mediatek.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Craig McLure <craig@mclure.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-next@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Coverity: snd_usb_pcm_has_fixed_rate(): Null pointer dereferences
Message-ID: <202301121424.4A79A485@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

This is an experimental semi-automated report about issues detected by
Coverity from a scan of next-20230111 as part of the linux-next scan project:
https://scan.coverity.com/projects/linux-next-weekly-scan

You're getting this email because you were associated with the identified
lines of code (noted below) that were touched by commits:

  Mon Jan 9 16:05:21 2023 +0100
    291e9da91403 ("ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()")

Coverity reported the following:

*** CID 1530547:  Null pointer dereferences  (REVERSE_INULL)
sound/usb/pcm.c:166 in snd_usb_pcm_has_fixed_rate()
160     bool snd_usb_pcm_has_fixed_rate(struct snd_usb_substream *subs)
161     {
162     	const struct audioformat *fp;
163     	struct snd_usb_audio *chip = subs->stream->chip;
164     	int rate = -1;
165
vvv     CID 1530547:  Null pointer dereferences  (REVERSE_INULL)
vvv     Null-checking "subs" suggests that it may be null, but it has already been dereferenced on all paths leading to the check.
166     	if (!subs)
167     		return false;
168     	if (!(chip->quirk_flags & QUIRK_FLAG_FIXED_RATE))
169     		return false;
170     	list_for_each_entry(fp, &subs->fmt_list, list) {
171     		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)

If this is a false positive, please let us know so we can mark it as
such, or teach the Coverity rules to be smarter. If not, please make
sure fixes get into linux-next. :) For patches fixing this, please
include these lines (but double-check the "Fixes" first):

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1530547 ("Null pointer dereferences")
Fixes: 291e9da91403 ("ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()")

Thanks for your attention!

-- 
Coverity-bot
