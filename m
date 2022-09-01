Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C305A9410
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiIAKRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIAKQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:16:57 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8502E134D51;
        Thu,  1 Sep 2022 03:16:52 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id i129so8006140vke.3;
        Thu, 01 Sep 2022 03:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uLi7Z0/akrty86Oo3nrBunvH+TYZ+AoE/dlgGE9Xprw=;
        b=idekwaTIblFhAInDUgjI5+/eSmpRvJrpl1n1XyImglLanT4na3gC2SllvO5DCP2w+9
         fZ9yeSpp5/Vf1PO0I/kRWE903ykRlV7OWqlw2Q28aeU5ozStGrnVZ982Zh5nqYZRBCJn
         ETEiGc19bPufP6KYARNwdQofPF5RqFMTMi3G74xjYhpO++lXgVK6k8+bC4/yOsVXU3tz
         4I5dw4xxI4V74lOcDS4dGWxyssObWz7q/cdXVF5ClGc48FRk9mkT9xXL+wFWZTvkBjcW
         w5UokG7WXHSkv9I1xXQK+GXuLgYaH32y7ET62Cp1n0jI1zzOxnfN6HWLbX4dE/IF2VHj
         JxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uLi7Z0/akrty86Oo3nrBunvH+TYZ+AoE/dlgGE9Xprw=;
        b=nLAUcEbfzq/SBqnr3RbDrf6FxVQ5chu9CC2XIng/qUBNZij9AZl9FWbYmCmKMvprTy
         WI5nRqGQyDXpmnQHxMbBUPKqwmbj1OZlZlFpAFdR6GR5ugrdjqy1ZIh6WzTiRyxZYbxI
         U3mvoabaBJjJK/8pFULDKe0xete/TSQ7iLSdzJlTxBJhGmL3hM6AU5FkKd+eLobZyzh0
         z5C7Cxe34xcMpYF0cmI0LN1JAeyRfjJOHKfjxwlqfTjs2SPZZB8qt5flEGdfzM+fB5h4
         OB2iokuRUR5UWDJfszBX+9N1UdXjQdAnOAvU7TNWhsE4m8WkqvsRlWILkdlBXBOLhocd
         qdwg==
X-Gm-Message-State: ACgBeo0CclickUX1s7o9ZoyIj1oZAVyAQHaZtRZE+TgmppF1Q1e0AkAI
        ef/NchuV6UGR1gGpur+siGChZQsvElqHgXCnYdRm2QWz
X-Google-Smtp-Source: AA6agR5gj1ga0CHpCylkBefbMoXdQrClspboU5wK9gWJ/hdJms6QVuZz7CvVQnJEvo+UrYBPLcUwwLcTFJ1cAQJwPwU=
X-Received: by 2002:a05:6122:d86:b0:37d:3fe:df43 with SMTP id
 bc6-20020a0561220d8600b0037d03fedf43mr8095521vkb.15.1662027405175; Thu, 01
 Sep 2022 03:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220901054854.2449416-1-amir73il@gmail.com> <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
 <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com> <YxB+QmIwCgMtj1r+@kroah.com>
In-Reply-To: <YxB+QmIwCgMtj1r+@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 1 Sep 2022 13:16:33 +0300
Message-ID: <CAOQ4uxjxq346_dwEhrTm7_WW8nDqaQxNUCfVqDwOYAJGtmtpQQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in xfs_ifree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Frank Hofmann <fhofmann@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
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

On Thu, Sep 1, 2022 at 12:41 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 01, 2022 at 12:30:13PM +0300, Amir Goldstein wrote:
> > On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> > >
> > > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > > >
> > > > [backport for 5.10.y]
> > >
> > > Hi Amir, hi Dave,
> > >
> > > I've got no objections to backporting this change at all. We've been
> > > using the patch on our internal 5.15 tracker branch happily for
> > > several months now.
> > >
> > > Would like to highlight though that it's currently not yet merged in
> > > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> > >
> >
> > Hi Frank,
> >
> > Quoting from my cover letter:
> >
> > Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> > I pointed Leah's attention to these patches and she said she will
> > include them in a following 5.15.y update.
>
> And as you know, this means I can't take this series at all until that
> series is ready, so to help us out, in the future, just don't even send
> them until they are all ready together.
>

What?

You cannot take backports to 5.10.y before they are applied to 5.15.y?
Since when?

Thanks,
Amir.
