Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6FC5AFDDD
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 09:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiIGHqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 03:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiIGHqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 03:46:32 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1569E8B5;
        Wed,  7 Sep 2022 00:46:31 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id n125so14051557vsc.5;
        Wed, 07 Sep 2022 00:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=70UlwKdvq7GCSl1IbEvE1dyc4cQjRqwl7FIkEoDrwBc=;
        b=gxENM3C5F/mywTCZjPzfG6V5EIvSHxSCqhJc0UIsQZrs0XWrlJVrw0WQrNZRioOOiP
         wDLaRWt5myCkFnsgPQFpDQgUDPTWODeEW50CByj0vbbs+rcipZ9tN3NQ1BAPsDSJnjyO
         2opDHjziA3CpiB0JiYyVfKsQ6dmaCK4/bzXbWTtwUL2TqY0M9xyxbqabDHlATL1EffBO
         EPXQFtZjcdQ2bo9cp5iVPmyADfCdH/8LNrBKek3LdfQqHcOFheLwo5f5pm/up29C3XzE
         PJ39NymUSNHGnCzJzDqmFnGjbEsP5kbUGXmO4GmZttcwC6R5SBAyzungYgtwYYA6t/gb
         kGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=70UlwKdvq7GCSl1IbEvE1dyc4cQjRqwl7FIkEoDrwBc=;
        b=G63ye3JtXHcR+vPJEx6uRc0m7vINjUY10XRaFtgc6s6bq92GnmaLj3itnplsKZpL/c
         iqJrhYNT42KvRjXop86d18ApaL9y6vgwhmkTRO680k/CaK+awduM6PQ7TYhzSlZLW96L
         Sn8956FLnieoIu4Z3Rc49DmtLas/mreTOlP/pHWC60jkf+ndl24JY/glTgeG5XtouEn0
         b4D5uXHVYI9AemLWDvC82yUEt0K3h/UrKH08YUqDO2zkj0sS7DCRLxXfKlDqQqU0OxNt
         XvSDamWVbCAN/ES+F4NTJlzW2O1IbGGYv90WIXr0xgGSSr76JkE3kx7EO+NO2Vy4L4p1
         9nIw==
X-Gm-Message-State: ACgBeo2yIC5PAYQmcjN00Av2izvc8Zhk2BNihWhFisBxxNFr2bz9paP0
        BYxCg5F0gL80T6dvvrJq1Fmm7RIR7/1vU3+slN3vAhsZJkQ=
X-Google-Smtp-Source: AA6agR6yyYcaIk9n4JzQ9dl81gPkNJ+UBU3hY4U/5E+5LQpAjGggTmyFyfJHh9AjJUl7m++VA/jK35zZbvb2BAc2kz4=
X-Received: by 2002:a67:d00f:0:b0:397:f237:98f3 with SMTP id
 r15-20020a67d00f000000b00397f23798f3mr613990vsi.71.1662536790612; Wed, 07 Sep
 2022 00:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220906183600.1926315-1-teratipally@google.com>
In-Reply-To: <20220906183600.1926315-1-teratipally@google.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 7 Sep 2022 10:46:19 +0300
Message-ID: <CAOQ4uxiNqxx1jK9k2-3yuvVTRwc09__5XMu7MdX75K1FGp5Dhg@mail.gmail.com>
Subject: Re: Request to cherry-pick 01ea173e103edd5ec41acec65b9261b87e123fc2
 to v5.10
To:     Varsha Teratipally <teratipally@google.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 6, 2022 at 9:36 PM Varsha Teratipally
<teratipally@google.com> wrote:
>
> Hi all,
>
> Commit 01ea173e103edd5ec41acec65b9261b87e123fc2 (upstream: xfs: fix up
> non-directory creation in SGID directories) fixes an issue where in xfs
> sometimes, a local user could create files with an unitended group
> permissions as an owner and execution where a directory is SGID and belon=
gs to a certain group and is writable by a user who is not a member of this=
 group and seems like a good candidate for the v5.10 stable tree given that=
 5.10 is used in versions of debian, ubuntu.
>
> This patch applies cleanly. Let me know what you think
>

Since you already posted the patch, I wrote what I think on the post:

https://lore.kernel.org/linux-xfs/CAOQ4uxi_Q8aXUg+FM0Q9__t=3DKqJSVqOgkS8j8k=
NC3MQfniZLWA@mail.gmail.com/

Bottom line - I think that the patch should be applied to 5.10.y
without further delay.

Thanks,
Amir.
