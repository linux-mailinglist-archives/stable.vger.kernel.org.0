Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067136C920B
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 03:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCZBWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 21:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZBWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 21:22:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCB8AD06
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 18:22:54 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id dw14so3516727pfb.6
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 18:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679793774;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oi7mqheHWwWvotxETfaXeotL9pTGJ8sRo9xGGWOooQ8=;
        b=qaw6jrEmpr3RtEtfNDGugRlcKJ9PmkrXOUe02sXOj82MIDMHElqx4TvRRYSyGl3Bk4
         OYdSB31xzMQWU9S2jXBPMTWvUrxCES3+zh9CoerlQDQyPpeH63wivy8sTTN64EP3MuVw
         dGaAZxANG8Xry8neGFzmVrUSwXxgxp6jUMkr2WBXoVGbjlZKDNWSsc/8Knt0RZX+abE7
         X/0uwJ1kbdTMpnb/NLx1IFD/tw1ZAaCRL4zZsFHfuN+hdNOyVb3dCW5N2INwXdGfzNNY
         7QPuNmeRx5vvDB1uCILYVJ+CzKGCrxhip7zmN45r7ZjZTr+iSMSyTFOQozKDlT2rpHca
         GU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793774;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oi7mqheHWwWvotxETfaXeotL9pTGJ8sRo9xGGWOooQ8=;
        b=dojJJB6ivjmx7U/B3yy9ZjqPGXkcKsWW/q3AXAdVgxSy9gfKMXMPW6MEtK4S1r1c18
         iwzDNT4nm0HyxDLsTVU2m5zTdEYMsguasyNWAJeHa54jo9eUVE11sZp86iX9RLS2WKda
         ojqLgsTEGwnqFCqdn1AAXGqkBiyAlQijPYUPz5LiYB2HQUqUEuc4dQ5qd903SYa8/fa/
         tT6VpUe/S3whU7E6f6P6M7Ke8u4ONyt4cq+FUsfITxE1heBm7l+2oTOhth/YNBHrzOKS
         8nYm6WqsgyZ7Haua1NbifiDcK36GwrOcWAjz5/n2jsyP3qXdmckiYv1w3ZizoDRmu9gD
         1Euw==
X-Gm-Message-State: AAQBX9cGWTxJxKpVYtTBLvONuNwFa89ciCe1htg6Ysx/5jvwWWUSj0bV
        Qow4U+2grPWNT/UfUtV1dcVERSqdYP3eF6Nw1qE=
X-Google-Smtp-Source: AKy350b+ubjEgfOMOwsJuKKC5RZBvqkodHuxlp+m97HDDlH2+6fXQao3iEUO89hlfDYusT34scn4P1f1EfUOVLxofbU=
X-Received: by 2002:a05:6a00:a14:b0:625:66a9:c393 with SMTP id
 p20-20020a056a000a1400b0062566a9c393mr4024492pfh.0.1679793773311; Sat, 25 Mar
 2023 18:22:53 -0700 (PDT)
MIME-Version: 1.0
Sender: bbchitex8@gmail.com
Received: by 2002:a05:7300:7486:b0:b0:e4bb:a132 with HTTP; Sat, 25 Mar 2023
 18:22:52 -0700 (PDT)
From:   "Mr.Patrick Joseph" <mrpatrickj95@gmail.com>
Date:   Sat, 25 Mar 2023 18:22:52 -0700
X-Google-Sender-Auth: nLSJLV2uheMvvC9-xQ0DigtoaK0
Message-ID: <CABNUN+KKth3o4YPD-XJ6rjHoGEJ4bsp4QFeBkQ+s9YoukHeXHg@mail.gmail.com>
Subject: Greetings from my side
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good Day. I know this message might meet you in utmost surprise.
However, it's just my urgent need for a foreign partner that made me
to contact you for this mutually beneficial business when searching
for a good and reliable and trustworthy person. I need your urgent
assistance in transferring the sum of $27.5 million dollars currently
in my branch where I work. If you're interested please reply to me
immediately so I will let you know the next steps to follow.

Thanks.
Mr.Patrick Joseph.
