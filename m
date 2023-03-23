Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468FE6C6D51
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 17:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCWQXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 12:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjCWQXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 12:23:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1182139
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 09:23:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t15so21237108wrz.7
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 09:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679588600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKTckmnik7ufAW5a/yVhvsjIsnn5L60QYo3mz1ajlxs=;
        b=kHoLtxqgf7jG7SwPJ9galeH/jl/ma5FM50+xYHVkbe5PjisoqyfONoNmCVlMQ1ptSf
         AMS8S8p9x66RtyZXbE8h0qAJnYLXcO8KqO7nk8BKE1fKgT0u3XoOloOZ2gJU/6ka3qZX
         pQrMvjifOB5coEhpTSZObxPB/EsMs3KX1vP7TcxScOEm1UN3sV0jkZH0qAzPjg45Qfdk
         9G6g6uXi16vTDQb0SOHCbqfZZmtARaHpopb/p5O9rHp0ErVdYMufxtvy2UsVnE4ATgKl
         wcYb5Mj0PWOXUKX3EIKxI21vhAE7Insjr5DMv9jVhUMNJIFe+F2uVoDrJUyvE360LAc8
         JKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679588600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKTckmnik7ufAW5a/yVhvsjIsnn5L60QYo3mz1ajlxs=;
        b=AjFwenRvBnfgck6M8hWqmqb02z0ACahOu29CuAeysPoVDugXn9xHWHpK92wnHJOoth
         tT+4+6PtDbVhInu7o5iDRZ7J81TUzot7uZ8O3KynfIecyaXZOcJZqA5+FbEuCASBvnG3
         tcsQv+j/BTOUwZn0SvOyKLoIP4XjxxmE36rr2BHhFmAEfw1aa7icqRH9YKrAJFseIYIL
         fdcEMUMedJmOGXsSbaQq0Bn/WpHErCVfqN/q8J69tEQg3zVpAhrLcGAxTyhODNYcFqiv
         Nz8aJnFHtdKeezm2UBI7QVxsAdbochURRY/dwengZgITsTqojMZa5cIDjUXDk4arazsB
         Xr8w==
X-Gm-Message-State: AAQBX9fwag6azCW15Gp+RQlVjvA/bjYw4rEoaArKvZam/4tUnpDg0U+R
        EDBXXV4XHWiumYbvx6vasoSzHTDnOem0l7SfBo1IcDL47AHrikic22U=
X-Google-Smtp-Source: AKy350bVjSqa5n16BmXYxK7ZatWZMjNBmyFAi1UakqdmT9ZZoMW46EG+UhoR7qRaeN20O/yY0A7M0YtY5bcMbvjQcaY=
X-Received: by 2002:adf:ec4f:0:b0:2d9:6655:202c with SMTP id
 w15-20020adfec4f000000b002d96655202cmr866417wrn.8.1679588599772; Thu, 23 Mar
 2023 09:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVonLh0jPpZpczXFqVpZ0w41OBg97z+6ixZewWQg_2TxL5ttQ@mail.gmail.com>
 <ZBvXQJMIBkgw/gy/@kroah.com>
In-Reply-To: <ZBvXQJMIBkgw/gy/@kroah.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Thu, 23 Mar 2023 09:23:08 -0700
Message-ID: <CAMVonLhUyp2PY117OeqQaTGZ0TbmbDcV7iVL11yLuHxawETQJQ@mail.gmail.com>
Subject: Re: Request for cherry-picking commit 4a625ce from Linus' tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 9:36=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, Mar 22, 2023 at 04:07:21PM -0700, Vaibhav Rustagi wrote:
> > Hello,
> >
> > In order to resolve CVE-2023-23005 in kernel v6.1 stable tree, I would
> > like to request cherry-picking the below commit:
> >
> > mm/demotion: fix NULL vs IS_ERR checking in memory_tier_init (4a625ce)
>
> This "fix" can never actually be hit in a real system, right?
>

Based on NVD, yes it is shown as "DISPUTED" based on the reasoning
that it can't be realistically reached.

> So it would seem that this CVE is invalid, please work to invalidate it
> with whatever group creates such bogus claims.
>

Sure, I will do so.

> thanks,
>
> greg k-h

Thanks,
Vaibhav
