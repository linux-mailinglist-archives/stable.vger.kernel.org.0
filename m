Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88845BB78D
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 11:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiIQJcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 05:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQJcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 05:32:15 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582C911A3D
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 02:32:14 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id h1-20020a4aa741000000b004756c611188so2982402oom.4
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 02:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=b6Rk2VjsiPjHo1xYYwZ5uILWbCCxICuJWWU8wu60448=;
        b=mNI+ssuxsfTZPCb18KdGlZ7BOY9F6Va5G489h6W52ICzeTqekdhA0yfE8Nzs0X0deh
         Ui7JFXo809cs+qtLZtp94+1/TrF1flOdgK8JizUNzpGZjW2uPBqQlwJXAkqA/tOEr26X
         86o64rGhIwiesckId+wQAbvCkZAEd4f24tFrsZpIU97T/+ZWeSTpupWJ7JzAaXa6kX3f
         mcNx1QNDwfMGiJz0g5css6NH84oPZ09EF4sYx5DGgW9XZ4xgpQuER/aj0t4nd/vPpCrE
         uKHVB9G+16gKPFUQXPl9RZ8Xzyf2ZYWExER+FFqCus+lPvqBlnyk/lnKXocou72MwwuW
         vjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=b6Rk2VjsiPjHo1xYYwZ5uILWbCCxICuJWWU8wu60448=;
        b=lGItH57NTqQughLE6xN5oEYXVd/BgZPLwghkhfTbHB+iVxm/3ekpIV4dvS0gYwo6Yi
         YYB5HRgK8b15S/nbbnkXJG5bzWzgUBWWuvMKJGfHPN3TENjp65E2bnjKb2Gl41OfdfK1
         Ifx1gxzxfRTgvfBiR5xREaW7ObgtUXnUxjZM7YiAqRRlbdcrLooEdR7dCQ99TMlrb1Ro
         SuOd1ue2Kb1QlvdS/p4WdCIfRoHxlg7BtTt/4Evp8c4KAgoVk6dZLsL2JTa0Xbr41hJG
         75GY8G8JDUH9yE2usfk3JicTHc+Y585F6k0jqhXb/hxi9EVVdaMF9b2tfgO7s7GAU7dJ
         czjQ==
X-Gm-Message-State: ACrzQf3RifPJdxUdamOL58z9eBBu8Eqy3UI3CATmCrB7PCo7DC1OJolr
        C+sOHewtipkXrn2uhkFft+Xe1H2iVFb6LPNTjiY=
X-Google-Smtp-Source: AMsMyM661qSz74tyM45Tav3iGE7zS8moXkR8LAgQke373cqohCKyW+LOjh73Rmx0zOCCy068su1Yh56QUN30UtRpZYM=
X-Received: by 2002:a4a:94a6:0:b0:435:f61e:d7a1 with SMTP id
 k35-20020a4a94a6000000b00435f61ed7a1mr3538962ooi.82.1663407133704; Sat, 17
 Sep 2022 02:32:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:784:b0:c2:7021:c168 with HTTP; Sat, 17 Sep 2022
 02:32:13 -0700 (PDT)
Reply-To: emile.collet@hotmail.com
From:   Emile Collet <colletcollet67@gmail.com>
Date:   Sat, 17 Sep 2022 11:32:13 +0200
Message-ID: <CAK8ZtmcFapm8kj1YU3jwWk0sQSwZhJLndLztKO3s=N03mj1N2g@mail.gmail.com>
Subject: Mes salutations,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:c44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [colletcollet67[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [colletcollet67[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Mes salutations,

Je suis un employ=C3=A9 de la Soci=C3=A9t=C3=A9 G=C3=A9n=C3=A9rale Banque.
Je vous contacte au sujet de la succession des fonds d'un client
d=C3=A9c=C3=A9d=C3=A9 depuis plusieurs ann=C3=A9es.
Consultez la pi=C3=A8ce jointe pour plus de d=C3=A9tails. Si vous ne parven=
ez
pas =C3=A0 ouvrir la pi=C3=A8ce jointe, envoyez-moi un mail et je vous enve=
rrai
tous les d=C3=A9tails.
Mon adresse e-mail personnelle : emile.collet@hotmail.com

Amicalement,
Mr. Emile COLLET
