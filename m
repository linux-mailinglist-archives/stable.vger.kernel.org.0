Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF64B95DC
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 03:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiBQCR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 21:17:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiBQCR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 21:17:57 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7298992D2F
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 18:17:42 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id f37so7246210lfv.8
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 18:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2YgHo0H517WEj3fHcqk34QMO7WKaAwRwB1iGBO4O3xc=;
        b=RcVTrH2VmQ9hsnwJ+uSWt9LC62+Tu+CxjP5bYzCb5mNLHXXP+aSNuVVZI8FqVK++oD
         nUsVsr8qwJPmIYnGgufzWUi/L5mMd+mACMHe2n0mESWqT5RPSM30T6Dc1gXsEwtPXRXX
         yCAHivzPvVDIqK74I+YlSEke+ZFqKFvbJ9n1GeOkYHjvvgzk4DOoDVo4ekD2MrYLtb2V
         0N274r7kItJGfQlh4jkPmwCsLuBLQ31DOzXFb5SE6pfGBByjjOYiboq+kTBdzg6Pvra5
         AHR1JKeynACzC20Xft75g9HVvxd1AH+cIoAJJWHpYF/KsD2xUBmW0Yah4A6V310ApZMU
         AWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2YgHo0H517WEj3fHcqk34QMO7WKaAwRwB1iGBO4O3xc=;
        b=v643LX0CJK5E1P+1Q05/grgc1tC7wRTyXa7m2XuTUpgLHjvIwdv3RPnveq75+C7v99
         tmVHHo2DI/ASGa5EUPE+cTvz7Rzr//SrU0TVhzJcwg3uEzRuFrN5C7FBKaOX6Dy2Zt3a
         BRiaLDIFi2qthme+xF8RolbhzPsu9T+tOsPEyWMP+KBAYS9uq1hn+RuNT8pD4jpEZ6bH
         xHhf6Dwt5NjyfC571w2yE/gUGN13XQoPyfPw4e1ls8HiyMZaX7izo2E0lycrn0cxIigA
         FFqZcxvJj8ZVb7a07ichLsqaP1/StIjvai8Vq76FkcCfnBwo7yEoY7zTu5zhi9pupeVG
         hQ1w==
X-Gm-Message-State: AOAM533FOG4ASXpgaJc7j7TdSFMpuvA8Xk6oYYGQ5B4tsEUiKe7D8MwM
        5moUHwxlfWiR/n8oO0WRyTo8Hgi1UgaBrLQu+1u/P9AJ2CpKJw==
X-Google-Smtp-Source: ABdhPJya2C3+CZoQtNYAKyl46BeYbp9OEJbKlmsbf+jPLnR2HoOFU7IicU9fpXYteV2gGWefNXnIX3svWiVuuP18vAo=
X-Received: by 2002:ac2:58cb:0:b0:443:3d32:7f21 with SMTP id
 u11-20020ac258cb000000b004433d327f21mr587391lfo.107.1645064258768; Wed, 16
 Feb 2022 18:17:38 -0800 (PST)
MIME-Version: 1.0
References: <20220215234036.19800-1-masami256@gmail.com> <20220216121142.GB30035@blackbody.suse.cz>
In-Reply-To: <20220216121142.GB30035@blackbody.suse.cz>
From:   Masami Ichikawa <masami256@gmail.com>
Date:   Thu, 17 Feb 2022 11:17:27 +0900
Message-ID: <CACOXgS8gpd+V=+iO5WnCXMuQakBMokTrwKfgp7TaC+D41SLc8w@mail.gmail.com>
Subject: Re: [PATCH for 4.4.y-cip] cgroup-v1: Require capabilities to set release_agent
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     cip-dev@lists.cip-project.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tabitha Sable <tabitha.c.sable@gmail.com>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 9:11 PM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Thanks for sharing this Masami, I've been looking into pre-cgroup_ns
> backport too.
>

Thank you for the review.

> On Wed, Feb 16, 2022 at 08:40:37AM +0900, Masami Ichikawa <masami256@gmai=
l.com> wrote:
> > [masami: Backport patch from 4.9. Adjust to use current_user_ns() to ge=
t current user_ns.
> > Fix conflict in cgroup_release_agent_write().]
>
> The condition to allow modifying release_agent is two-fold:
> a) caller is capabable(CAP_SYS_ADMIN),
> b) cgroup_ns is owned by init_user_ns.
>
> In pre-cgroup_ns kernels, it is IMO safer to consider all (=3Dthe only)
> cgroup_ns owned by init_user_ns.
>
> So the (positive) condition translates into capable(CAP_SYS_ADMIN) only.
>

I see.  Thank you for the details.
If we treat cgroup_ns as only cgroup_ns that are owned by
init_user_ns,  we don't have to have an extra check.

> [
> Additionally, there's invariant/implication
>   capable(CAP_XXX) -> (current_user_ns() =3D=3D &init_user_ns) ,
> so the expression
>   (current_user_ns() !=3D &init_user_ns) || !capable(CAP_SYS_ADMIN)
> simplifies to
>   !capable(CAP_SYS_ADMIN) .
> ]
>
>
> > @@ -2839,6 +2856,14 @@ static ssize_t cgroup_release_agent_write(struct=
 kernfs_open_file *of,
> >
> >       BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
> >
> > +     /*
> > +      * Release agent gets called with all capabilities,
> > +      * require capabilities to set release agent.
> > +      */
> > +     if ((of->file->f_cred->user_ns !=3D &init_user_ns) ||
> > +             !capable(CAP_SYS_ADMIN))
> > +                     return -EPERM;
> > +
>
> Following the reasoning above, the check simplifies too but it should be
> be against the opener, not the writer:
>   file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN)
>

Thanks. I got it.

> (It seems to be to be incorrect even in the original commit.
> So I'll send a patch there to rectify that.)
>
>
> Michal
>
>

Regards,
--=20
/**
* Masami Ichikawa
* personal: masami256@gmail.com
* fedora project: masami@fedoraproject.org
*/
