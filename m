Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A478568C275
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 17:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbjBFQGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 11:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjBFQGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 11:06:14 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B082BF03
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 08:06:11 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id x2so5511203qkg.7
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 08:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCK5q2KqyZAm748h5YxDABxwN3/tJRQtvsYX7XQOJzA=;
        b=HY5jMgBAW4h23yH0SV1nQyc+p8PUJ+KivncnIFL466QvBXdQBzp6rsBc5ySOWvUmvX
         wQQbicnBwb2xwK1pWqC5yTBGj8WoXNL/SgqZMMY2zpvteaxCQr0xuGt12ToAUfXEufqR
         2Spdns4hW2Zz/lV6GYo2Do5mDgHBnQO3PAHZ45nxFUt4wlEn+EWiUn2f49+4UpnVbdLA
         m3cgajFUrADZwJKa/05egi3mS8vdchBOWXQS1otVTxyy+JYPNe8kP5RXyN+zSEHsZ45G
         DkSW16p8MGMB5dZi0Apzjm7iwUzFA/k90TDmOB8hmJ5n+ghBB8Q2AYpMdYeFo6tGs6LQ
         v0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCK5q2KqyZAm748h5YxDABxwN3/tJRQtvsYX7XQOJzA=;
        b=Q+ehcySiygbVY2wAVneeM8Fi2s0t/H43mswwwYMHSmpSSkzwWWka/cmoAWsRumQGw6
         G10FW+rtveFir3bx0EeHKReSeUNAs0pSAwM4oIFfw/foWAz901FDIwNNVR5+6f1Ll9Dn
         55JAGUaFJLedH7z7h/vW8b7B3K6qxk/X975yV1luBZpZQ5VRjkLxfvifnr26nz7gYieP
         n2KN0EFiqOTSPTftL4nqO+20B1eaLUkNOohDKnUP9miyJzxaoMukXXhkJOqV88BlHUNg
         BxfQ+mGeFJxdYEWfPAywtm/KcwWlI6lkusbu/0uYw9Vd3iNw6UblMHD5NyJ93f/pdJ50
         GzbA==
X-Gm-Message-State: AO0yUKXx/KREmk8vO41BL1nPIs87/8cBZuihtBQ7Fc3ZKpLm/DaVAvcW
        DugppPJYZI1bgfFOtxM6/Y46k4wmcZxVbpE/t4E=
X-Google-Smtp-Source: AK7set9nUbX0BXMXKldxfeUeQ//sZb2s+tXSTqAXI0ZIeAnwL9dkDI/kpc768aeyds1tpYCo9FOGRchwHG8vpRqIdHo=
X-Received: by 2002:a37:93c7:0:b0:71a:cd64:2b3f with SMTP id
 v190-20020a3793c7000000b0071acd642b3fmr1437354qkd.87.1675699570638; Mon, 06
 Feb 2023 08:06:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac8:57d1:0:b0:3a6:6959:22d1 with HTTP; Mon, 6 Feb 2023
 08:06:10 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <milleymilley83@gmail.com>
Date:   Mon, 6 Feb 2023 16:06:10 +0000
Message-ID: <CAEuePDFTcVwYno5_YExK-_185xgxSM3MWjVGirxTc3bJBJrJcA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear Friend,

I have an important message for you get back for more information.

Sincerely,

Mr Thaj Xoa
