Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5506F4ED2F0
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiCaEYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiCaEYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:24:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DC247AEF;
        Wed, 30 Mar 2022 21:13:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso2395007pjh.3;
        Wed, 30 Mar 2022 21:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/+vGbz8SAWz67QqrCsaqBWY6f4aSs8L7q9rG9URu324=;
        b=pC+ufU2hTzJJ4NnNPWS67Q4pTurIZpN/8TM2Rug587P2VYpw26BZj6Q6J9+uTrpwFh
         unYJWww6phnB78O0dY+yzUWNwYzoasEwuMGE2HvGTAU8pd/Hum9/Khs11nfKrXn1h8ah
         jP/9OBVZra6QcxFniQj2q3QnC4P59vzAM9yf9wXFsPvGGjYWcB17wNcJES2CU/LYfX+f
         xLA0cx3JBq5+x3Pvvuc7pqvlSxSX/LfaOA2KO8C3I1lDVoSZOtfGlHxkqYfLOxCkir0T
         KDXY2uMW1vDNNzTtrkIkJc1VtS7yzoIPal/cCwyvVjnTOflGA4QIfXn3t/LMj0dnRtHI
         K63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/+vGbz8SAWz67QqrCsaqBWY6f4aSs8L7q9rG9URu324=;
        b=buTsWaxxbbbkHIOc0QJEvhvx9O+TedNp51QdpsEGBzDZd6pyh7iU9CnINDsGTAO677
         0Ntt332QuhX56yJjRaQXzM11ygrUK+2MKW6yKTJ939jErcDstPnOYi+YOxrkftTnmFpz
         AbIrxWDpZEUp6KNnk+B0Gzlk2XE4qNS7ne2bUMJOSas4pPU4ObYD5oh+eOdGcLkaTF7f
         uULjuWMu6r58ZXv054J8pm1ytUO8DpMjgv1T3pZSPGLMKC1KGNihnvuyqSIe9ZuGR9bu
         trrt5DV8DlPBR75Rmb08+k8JmxFosC4aq18IfJnnynpCiRpclPiMxqyFojUVoD6DkkQJ
         XqSw==
X-Gm-Message-State: AOAM531yqwYOUkbror3l+KqaI5EC1Q3z+c6l7e1vqT0NSfr+cfU2w5jw
        pPnUTNrbiNU/f734j+NaD3w=
X-Google-Smtp-Source: ABdhPJy+J7klF/WLTrxUys3ijbiydFDR1WqJxE7Y6/oefX3HIuNphCu5GOXq+etXWFl9gTYN3Mzf+Q==
X-Received: by 2002:a17:902:bf07:b0:14f:a3a7:97a0 with SMTP id bi7-20020a170902bf0700b0014fa3a797a0mr3392328plb.105.1648700014186;
        Wed, 30 Mar 2022 21:13:34 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:3d5d:c235:d5ab:d23])
        by smtp.gmail.com with ESMTPSA id i8-20020a63a848000000b0037d5eac87e3sm21067376pgp.18.2022.03.30.21.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 21:13:33 -0700 (PDT)
Date:   Wed, 30 Mar 2022 21:13:30 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Message-ID: <YkUqajiNZmi+lAPC@google.com>
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
 <44abc738-1532-63fa-9cd1-2b3870a963bc@leemhuis.info>
 <CAO-hwJJweSuSBE_18ZbvqS12eX9GcS+aJoe7SRFJdASOrN3bqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO-hwJJweSuSBE_18ZbvqS12eX9GcS+aJoe7SRFJdASOrN3bqw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 02:30:37PM +0200, Benjamin Tissoires wrote:
> On Wed, Mar 30, 2022 at 2:27 PM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> >
> > Hi, this is your Linux kernel regression tracker.
> >
> > On 21.03.22 19:44, José Expósito wrote:
> > > This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
> > >
> > > The touchpad present in the Dell Precision 7550 and 7750 laptops
> > > reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> > > the device is not a clickpad, it is a touchpad with physical buttons.
> > >
> > > In order to fix this issue, a quirk for the device was introduced in
> > > libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> > >
> > >       [Precision 7x50 Touchpad]
> > >       MatchBus=i2c
> > >       MatchUdevType=touchpad
> > >       MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> > >       AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> > >
> > > However, because of the change introduced in 37ef4c19b4 ("Input: clear
> > > BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> > > anymore breaking the device right click button and making impossible to
> > > workaround it in user space.
> > >
> > > In order to avoid breakage on other present or future devices, revert
> > > the patch causing the issue.
> > >
> > > Cc: stable@vger.kernel.org
> > > Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
> > > Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
> > > Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> > > [...]
> >
> > Jiri, Benjamin, what the status here? Sure, this is not a crucial
> > regression and we are in the middle of the merge window, but it looks
> > like nothing has happened for a week now. Or was progress made somewhere
> > and I just missed it?
> 
> No, I think it just wasn't picked up by the input maintainer yet
> (Dmitry, now in CC).
> 
> FWIW:
> Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> José, please do not forget to add the input maintainer when you target
> the input tree, not the HID one :)

I see that there were several ACKs, but how many devices misuse the
HID_DG_BUTTONTYPE? Would it be better to quirk against either affected
Dell models, or particular touchpads (by HID IDs) instead of reverting
wholesale?

Thanks.

-- 
Dmitry
