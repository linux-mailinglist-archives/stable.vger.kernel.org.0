Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88343510203
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352395AbiDZPjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 11:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352397AbiDZPit (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 11:38:49 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069A0140FE
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 08:35:42 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f38so33661237ybi.3
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 08:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQZiXIxdmiSHbCLJF1D/j7DSaBPKECeHRKKl9HR5UoM=;
        b=gIVAOUhxi9y7Yo2xEP1k3yvfEjLLjCtl0ov47OXgb2YCXUDGXxTF49I30qX40KpVIm
         PWJB2dxCEcNfr6k05ghawsu1qtRmlx9cTvrJrx+rnVihvgKCMR8vBZPwk9e0VEt8q+4U
         NjXgq3Q2vrQYiUVZiAB7lOASwk5Zh83hQ9PxdcAVsBLhCV47LWDcuUvzbm7kXsdD1m3N
         W1lajCBO/M0wsQhg0lxIM7FhiARI0aiGYKWoHDYAFXy4fhJn5JRqpCiCJdeG8u2kO8cO
         cPEt+wBCbojy4fJI+skhC/N9MI11C5v1WHRb3WYHJ8jC8vP8TGcNI/J1Tbu79wD82rUH
         YAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQZiXIxdmiSHbCLJF1D/j7DSaBPKECeHRKKl9HR5UoM=;
        b=Zb3xE8l2XG34jc9rLmL4TLtTd0ReQNfYpAO/PWI053UYryu9izjfyR/CE7WGQa3RNO
         iYiD7k81kXgo7iQoKkpRQd1c/niz8r2XchQ5R4raF0nESBqXLQGy3un3E6XknloiaJ84
         RGNE6U1HH0EPQaRgbDX6QM5jTbg6CWrfM2BuzzXUUZbIKwB4D7E1xIZfQw/FX11L2NgF
         +8iMOSc9qwGaoAigGZVpmqXYTgbrvyI9f3X5MqPhXK9RY8W88eXUc4hp9/4BtMTgIza5
         tE0VxgIjfgnTOjkRfXV157F9aHWrsqtFE/PAp9QH3CgHhNNV9MrTjRaHSIx+K8w5HfaV
         d/kA==
X-Gm-Message-State: AOAM532+nv50dQ6goN1wRNngbPGKQUM8Fm8LfDGEvpc80qk1WZ73f7Al
        gMZ/QMJTHF29mFLpNnG8CmODZDjz4BvcpdYpSTrlZVILOSk=
X-Google-Smtp-Source: ABdhPJxfB1kY9NVGiRey7y5jAZNb0HTOXTxJRiyMxZf+112Opk8r9k1XvSYnyKCCkyl+dnyJaWo3Zer8qmQsHZmSOI4=
X-Received: by 2002:a25:bcc3:0:b0:648:7360:8e75 with SMTP id
 l3-20020a25bcc3000000b0064873608e75mr8726230ybm.533.1650987341152; Tue, 26
 Apr 2022 08:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220423221623.1074556-1-huobean@gmail.com> <20220423221623.1074556-3-huobean@gmail.com>
 <CAPDyKFrksB_kgrnmcay+ub0nDfmPVZfw-zJihop5N8_6qUqrug@mail.gmail.com>
In-Reply-To: <CAPDyKFrksB_kgrnmcay+ub0nDfmPVZfw-zJihop5N8_6qUqrug@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 26 Apr 2022 17:35:29 +0200
Message-ID: <CACRpkdb-snMG8Aabq_oa43_UQx1CVccQteRa8_Ur6OHDKFAc2g@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: core: Allows to override the timeout value
 for ioctl() path
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Bean Huo <huobean@gmail.com>, adrian.hunter@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 3:55 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On Sun, 24 Apr 2022 at 00:16, Bean Huo <huobean@gmail.com> wrote:
> >
> > From: Bean Huo <beanhuo@micron.com>
> >
> > Occasionally, user-land applications initiate longer timeout values for certain commands
> > through ioctl() system call. But so far we are still using a fixed timeout of 10 seconds
> > in mmc_poll_for_busy() on the ioctl() path, even if a custom timeout is specified in the
> > userspace application. This patch allows custom timeout values to override this default
> > timeout values on the ioctl path.
> >
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
>
> Applied for next, thanks!
>
> Linus, I interpreted your earlier reply as a reviewed-by tag, so I
> have added that. Please tell me, if you want me to drop it.

That's fine, sorry for being unclear!

Yours,
Linus Walleij
