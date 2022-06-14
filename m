Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6725254B1BE
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbiFNMzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiFNMzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:55:53 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5428D3DA5B
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:55:53 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-30ec2aa3b6cso28196517b3.11
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=h3Um7szXECSysF866bSC3LYnArFwF7HY0gDjOEK46VQ=;
        b=GrDL6fgCW/Lt0XWlkp2SaFpPoK/pUVpbl29jncSQm4i+Cq+0t3Lrex+eQeDiZtJi0Q
         0QYU7RYSQqOkPEXUfEOcAyphNDBUqrSrpnHJhRE2LUyJL8comxa1P0J+P+zE+X6AXIQ6
         3pYVb9qT9GbtamC7FHWWmaCRGs1V4e7TUW2ThwYi6HRThqR44G36WVHCyWMrmL9ezqOp
         aKaGPcn3C9ejhgO2NJhsk+Qrrhexjv9uc9qPHmfu3c/DPxUFbVf3avKlXyKdBUZf1Xu5
         MlhCzSlk646orhpl7xhkCUQqS/djQGgk++80NOkkNdsQXadUGk3QqPXcTQ0ukq7/n1+3
         /T4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=h3Um7szXECSysF866bSC3LYnArFwF7HY0gDjOEK46VQ=;
        b=lFUp8qVBSdSPDH2p24hCKqGJBY0caA5Z/3jrrFB7dw3SnLGgc+vtVFyo8S27WiwsrZ
         In5n1dGwJn4tiTN1flhGB9gV6/LjTyE2JPPB0TE2RN/VVAFFyKtMof4opo7f58basTDx
         2NX7VDfhknRl2rZIwgpt3fYTFJHU/QmDWlEPhFi62Ph4Aq0M3iXiCmdOgPeKy1e24HTb
         moZRfhIxF7FKDjSjEfQR+dgD4nnR7arrJEpQESjp0yZqVBpm04v/5cCYgKT0Vmmjmjez
         UwXpCqXuAC7ZKud5Lw7jTOPoVKqQJm/kghta4fjVzehTkgMGfz8PDZ7DaiBC5jU56SDo
         g88Q==
X-Gm-Message-State: AJIora9d37zksL5vovhZqDB4G00LU1VKCr4L+ZXOnM9a9cEtd2BUhP2C
        8URdtng3/xbqxdh3gmpQyebf6MKprZrJmvVGRrM=
X-Google-Smtp-Source: AGRyM1v7tIhVGHS/98196L+hmg02Pn5r5QDClrS8yNQgSFpOVeki9/ZlRoeBETxbLowK93JmsSPpJotsuGoOtMW6ess=
X-Received: by 2002:a05:690c:289:b0:2eb:e870:4f90 with SMTP id
 bf9-20020a05690c028900b002ebe8704f90mr5617968ywb.250.1655211352512; Tue, 14
 Jun 2022 05:55:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: la9127806@gmail.com
Received: by 2002:a05:7108:7847:0:0:0:0 with HTTP; Tue, 14 Jun 2022 05:55:52
 -0700 (PDT)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Tue, 14 Jun 2022 05:55:52 -0700
X-Google-Sender-Auth: Eg4PyXlvqND_CvvXADFapPhTIj4
Message-ID: <CAGaGidfAp-+nDAqevk5gN2CSvsDF852Nw-8omNO-S1AP3t489w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ciao, hai ricevuto le mie due precedenti email? per favore controlla e
rispondimi
