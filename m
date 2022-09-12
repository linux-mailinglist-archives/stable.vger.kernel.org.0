Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13AF5B639F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 00:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiILWYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 18:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiILWYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 18:24:00 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E28165F1
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:23:58 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id r20so56415ljj.0
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=NCtttdECmfJqu2KiU47AUiW9xR5atr87NWWDkE1sdyk=;
        b=WDnIzrh3SmaeWIT8onKD4rWqxFsXr2wnf4IBEkoCQqy62XNvdfoqynp4wDTzkSg3ER
         N5HpA/lvQ5z9RiNYYOcZ3pdN5T5nV17mGr5Z/gB6BLc5G6fwmOzcc5lQBy7Lb9zNxzSr
         g3fwX5cvfN6HE9Wt/YKJGQ4TKbadQu8MVU8is=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NCtttdECmfJqu2KiU47AUiW9xR5atr87NWWDkE1sdyk=;
        b=vrSpWtG3troMt1W6kVkjFJ1ehHn/y/jnjSteZvGU/y1VQobqZo3ExQEeG71PQpP3br
         P338mFpWho7FhUEn1SP49s5Mcck45RSKgp4Za5D+9SOpxQqkygqFQ2dJTs84I+CtyDGO
         4npEJJoY17u8/bBlBrVBoWamBAVZ1J/o+2LIXyokgjFr4sux5fZuJ8gDDSDJF/TtXUc6
         w9FoclMK+dEpVXzFmypqVAYArAca62oELKyr+MWNjp1vnGzGZ4h8cG/yaQ6HMXWkrLdM
         P0HLXXhxoh965NluUt6rorxMq19aHfWNAnwJPRPXDE57YAv6eRQOumyomjtkVrPDnut1
         pg4w==
X-Gm-Message-State: ACgBeo3IDUp5eBajoKYb9Cr+EzRqvqS5Uxa6uDztCyyIjLZjKb2J0f0C
        VJ2qnB5m5kuFXHJi6YOxw732CWYC34Lg1Nub
X-Google-Smtp-Source: AA6agR4aMGxyqDDVxugm/uJcDRJJgj62X7Pd4LupKvZnh5MODrHYwd/mq6NGf4RrQD2sFjomQNUIZA==
X-Received: by 2002:a05:651c:1109:b0:26c:27d:eb6f with SMTP id e9-20020a05651c110900b0026c027deb6fmr2499448ljo.384.1663021436587;
        Mon, 12 Sep 2022 15:23:56 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id p10-20020a2eba0a000000b00261e8e4e381sm1343757lja.2.2022.09.12.15.23.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 15:23:55 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id l12so12267572ljg.9
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 15:23:55 -0700 (PDT)
X-Received: by 2002:a2e:54a:0:b0:26a:c623:2a3 with SMTP id 71-20020a2e054a000000b0026ac62302a3mr8795887ljf.135.1663021435324;
 Mon, 12 Sep 2022 15:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <166274826116451@kroah.com>
In-Reply-To: <166274826116451@kroah.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 12 Sep 2022 15:23:42 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNVxj-fCM94p5sbAn5-TShamWvTXN2r6KRp9+J9xJNqkQ@mail.gmail.com>
Message-ID: <CA+ASDXNVxj-fCM94p5sbAn5-TShamWvTXN2r6KRp9+J9xJNqkQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tracefs: Only clobber mode/uid/gid on
 remount if asked" failed to apply to 5.15-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Sep 9, 2022 at 11:31 AM <gregkh@linuxfoundation.org> wrote:
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Did something go wrong in your automation? The same patch applies
cleanly to me (currently, on top of v5.15.67).

> Possible dependencies:
>
> 47311db8e8f3 ("tracefs: Only clobber mode/uid/gid on remount if asked")

That's $subject patch. OK, so not that one.

> 851e99ebeec3 ("tracefs: Set the group ownership in apply_options() not parse_options()")

That one *is* a dependency, but it's already backported to 5.15.y as
of several months ago:

commit 6db927ce66ac68bf732f0b14190791458e75047a
Author:     Steven Rostedt (Google) <rostedt@goodmis.org>
AuthorDate: Fri Feb 25 15:34:26 2022 -0500
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Wed Mar 2 11:48:05 2022 +0100

    tracefs: Set the group ownership in apply_options() not parse_options()

    commit 851e99ebeec3f4a672bb5010cf1ece095acee447 upstream.

So I'm not sure what to do to fix the backporting, other than ping back here.

I think the same applies to the 5.10.y rejection notice, and possibly
a few others.

Brian
