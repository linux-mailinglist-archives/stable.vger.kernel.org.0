Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189875A0124
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbiHXSME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 14:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiHXSME (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 14:12:04 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477366CD14;
        Wed, 24 Aug 2022 11:12:03 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id m66so18380196vsm.12;
        Wed, 24 Aug 2022 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=y8J93JV6gz26cEdEOca8rGHXU+Mqo2ViUyga0N8y8EA=;
        b=MIvMlkid0OSkr8pnPdqdCxdivqr/zKCNo/V39p3llKn1iOHqgDMTmr6zvIDuRwtjpl
         MOVfmWk0urMXv3qePyft8wRK6RddvajJgxqGgIdUAH3LhCSzK3xd63LGW300sZuVTeC+
         dNx88dERcmpjWfwdPSkFnF4cUtozPvdipGqa74wA3yqmixM0YHfCs7AWtgCSehe9uCJj
         uU+ik6b9vtJJRlRqBBYsedf2lBgJDEyjTU03dG5qDd+T1oyUEYpwCOASD7CJCkoWvVgI
         /0RGqyUytYvk9HI3iCTFpmsLBfdaVyJsvF5kZ9ZJIblQcWYO9Zh9S5EPytQjnjNWs15t
         BS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=y8J93JV6gz26cEdEOca8rGHXU+Mqo2ViUyga0N8y8EA=;
        b=JNky53o9BWyoIs5Pwu8Lk3Ux8UuJhpTzu76bcgwZ8gmpmzJbmgSfnRbEVbHUsiMxPo
         taSNWVzqelSfJV89QLnzIknJd/IB0P56OcgBN09FiAOGKHHcPK5kPfbIT049vrAHA48L
         DxMNDU11ZHjGYrM2u+VciOBwedlJcdRmesD9sD5/W4Lx+N00FRlh7Ukw0l0n8vPpkBaP
         mew77veboKZZqxDD02FnpvTzk61DhIn4JxLQVYMLWtFBZmZkcM9WktaXBsBOFQ5Qtm2f
         WorYc0BQgZjgAD4P1KHizNSINgOpOXQEuidEV/v9NE2VbGJ1rarxhPjBXNrvKA0z0ZA9
         EJnQ==
X-Gm-Message-State: ACgBeo1eAyBQHAuLwFmz2Lj5I9ji3uGc1BHOH2jclFLX5R6fInrnYkqP
        vsU+TZ945yi9OYa1rg7K6JVSVeBOi/QD2C5BT9M=
X-Google-Smtp-Source: AA6agR4FFGGSFOy6C9OF0fjIwX+QfUAg+EKDiEDFJu+1RADgVKZNmeDokLPTtlVqnDvBPwFutsazt7VcpeDurcaiByI=
X-Received: by 2002:a67:b205:0:b0:390:7910:aae6 with SMTP id
 b5-20020a67b205000000b003907910aae6mr102245vsf.61.1661364722176; Wed, 24 Aug
 2022 11:12:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muO1OkOV0jjJo89Zpvj43u_X95smuujg66-emQFgSXfgQ@mail.gmail.com>
 <YwZmu1ZTbjVqIY/C@kroah.com>
In-Reply-To: <YwZmu1ZTbjVqIY/C@kroah.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Aug 2022 13:11:51 -0500
Message-ID: <CAH2r5muu2F3-GiioJsJRdJTbM-gktf0Y8kMFsAD_Evq6a5+DwA@mail.gmail.com>
Subject: Re: "Fixes:" vs. "Cc: stable ..."
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Aug 24, 2022 at 12:58 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 24, 2022 at 12:14:12PM -0500, Steve French wrote:
> > Do changesets that already included the "Fixes:" tag in the commit
> > description also need to include the "Cc: stable@vger.kernel.org" in
> > order to be included in stable?
>
> As per the documentation:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
> You should be putting cc: stable@... on the patch.
>
> But as not all maintainers do, we have to dig through those with Fixes:
> in order to actually catch all bugfixes :(
>
> So please, use cc: stable.

Makes sense - I had noticed a patch which I was going to include in next P/R
which was missing this (fixed now).


-- 
Thanks,

Steve
