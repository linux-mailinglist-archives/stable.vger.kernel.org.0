Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03376C27E9
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 03:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCUCN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 22:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCUCNZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 22:13:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C6B36685
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:13:24 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k2so14543766pll.8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679364804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+aru+LE4EXkeavSro1pWZfyN/YO+OmTYPczjGb5OpGs=;
        b=Bq7TXmOAJ2TfbOMoXQht2qvX6iaeJdNSu0CKGNIbtaKYyoxpLaASa9Ld2V4Q5rdwqs
         3ZrkL6ruhabcNEDgmryoXVn2bERGABCj6eArK5HvqWdGfoOp/0oXfnXZpkJXlFsSm6ta
         oujEbQPraAtv3lktwona5Sje1Y+Xr/tjFpDjewgQBBISRLpJTEL62tAkVpk1Y7HQtJc0
         +5qeExO7GZe7qN2IP78qU817ZTT2v63B+n9OQPpf7ce4zAI7we4cSGE7dNmvfsovsupd
         FWAjlL5OW6J5OlRS0z/cw0txct1eUOH2bm3PhWH0lBkSZmZ2vKvHhqXkpSOA1SLSi9HD
         QO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679364804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+aru+LE4EXkeavSro1pWZfyN/YO+OmTYPczjGb5OpGs=;
        b=rxPK6C7yO0ezLRlgEr7Qb2QHV7fsNW6mmcfONqy3yvADotKQ/lR24Jrwj3mwLOmJ7H
         54BNnMGmnCzzOXfgIZoPSEToEte35hd5GBFWyDaOg9vJ928XS19M2zHej8lm2lqCrAZT
         E1pP+v3nkKn03Dmbxdm4ufUDXW6N2H6sDQajJSBbtO+sub1OAW6/SnGr9Gi8vnEejWA+
         CkqizuIOalwwhzMxEJpnFyGAojEtSN8fQ/PPj/7zL9ocxkb4K1KPaqxam5Xc87BuUkwb
         +hCp7yaodsSGXDh7EvE7+8zFeKny3ePej4+32TuGvyRMu7EIAuu1RspBrXn38VONtmpO
         G0+w==
X-Gm-Message-State: AO0yUKUwYYXe30Ym2pAba2eChKU26FGDBKo8KXptREElbsJLUs3ye2pe
        0j89YCxPxoOn4Iz1pNoGqgE=
X-Google-Smtp-Source: AK7set857l+AUzpri2yHQOlAiVSSITyZ7FxL1EHGrN2CYgnclIFGmclMhx4QGycWAfdenQ68k8Tejw==
X-Received: by 2002:a17:902:ea10:b0:1a0:549d:3996 with SMTP id s16-20020a170902ea1000b001a0549d3996mr1431081plg.25.1679364804150;
        Mon, 20 Mar 2023 19:13:24 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-89.three.co.id. [180.214.233.89])
        by smtp.gmail.com with ESMTPSA id jj17-20020a170903049100b001a072aedec7sm7445462plb.75.2023.03.20.19.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 19:13:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 607A9106610; Tue, 21 Mar 2023 09:13:20 +0700 (WIB)
Date:   Tue, 21 Mar 2023 09:13:20 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Joseph Qi <jiangqi903@gmail.com>, gregkh@linuxfoundation.org,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org,
        gechangwei@live.cn, ghe@suse.com, jack@suse.cz, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, piaojun@huawei.com, stable@vger.kernel.org
Subject: Re: [Ocfs2-devel] FAILED: patch "[PATCH] ocfs2: fix data corruption
 after failed write" failed to apply to 5.10-stable tree
Message-ID: <ZBkSwL37/9DpfnvP@debian.me>
References: <1679313445246112@kroah.com>
 <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4XH3fd8OGZLBNYfL"
Content-Disposition: inline
In-Reply-To: <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4XH3fd8OGZLBNYfL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 10:06:30AM +0800, Joseph Qi wrote:
> Hi Greg,
> It can be cleanly applied for linux-5.10.y and linux-4.19.y in my desktop.
> I'm not sure how it happens.
>=20

If you can apply the backport, why don't you post it here?

--=20
An old man doll... just what I always wanted! - Clara

--4XH3fd8OGZLBNYfL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBkSuAAKCRD2uYlJVVFO
oz8tAP9ajyDoskGN+cc/C/Qf7rPBXQEISy5oRe1wUZg89JY6CwEA3u8AcptsC/7U
TUUt28jkOWlOzrByYESgEI3W9Uwz8w8=
=lXl3
-----END PGP SIGNATURE-----

--4XH3fd8OGZLBNYfL--
