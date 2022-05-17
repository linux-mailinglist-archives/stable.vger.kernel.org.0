Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CCD52A586
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbiEQPAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243507AbiEQPAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 11:00:33 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5023D4BB85
        for <stable@vger.kernel.org>; Tue, 17 May 2022 08:00:33 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v10so17140742pgl.11
        for <stable@vger.kernel.org>; Tue, 17 May 2022 08:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=zLAXOt0+g+Gz9bXUVZthS9o5V8JSghOXkCMObSfdPds=;
        b=Ii4UAEQXQX69S9hlO6M6h1W8eCRDCVhotYlzJPkgjS2sy6KIreo+6DOD+qE/ODwAxm
         cFLpo/HOW8Vd53q7rFYRQLAXP9XM7PgX2m3iC18g1UPdUgcx41A5JSyIOkBCYhwbEY1g
         s6XGwL9S/O2pqYJTdy6RMHKIRTVxjfvT2/IV0dbx9IBLTV05ytBI1VNTdJf9yFzXRHXN
         RVj02NOT/YQPq7/Bl+D/RyfjPKvbj1N2XCjerGT5lnEqY5PsBhoPm/euhT8KG2zo2JXN
         ygVkv/N5zf7T1q8aRk2TtjAb4gskU2kB3QAUW6RWCnSRiihL3iIDitKUFg98v6B1enUk
         2qRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=zLAXOt0+g+Gz9bXUVZthS9o5V8JSghOXkCMObSfdPds=;
        b=hS4Xe8FpOr82vGOdyjgPSTWxbFFhInKrcw7IwFbx2Hk6UUkjY0W7pehvXeFW3mpdO0
         mfcCsb2cIx6k1unHIsNWZuD4xAtb3OqRLzVkYP9SDyUloaZrbMmPO/So9On0vwGFGBxG
         2I0bhfd6Aoj+UiWpnqMZXTeYnzG3c33PvZs4pNtCSbwCADJ+HoYLyAHoOKNZmE8yTT1t
         GjqoZwjv/Gg3moo1Ndsswcx5xWmnQVSg8MWVCPNz7hlaSJAAIOhirlacXQnRWqlZms8B
         Rxj0yLnXZuQXOv/fxzy7YUzyHyAHsZUlh1bdtjoWLBFPKwXjMJUrQ/dD6Q1QYNrF1JeO
         5aPg==
X-Gm-Message-State: AOAM533vSR82+nQlKdxsoilxGe7ER3cTxkC8AHqBZrsi7Qg1sZm8qYdy
        S4xPMtRb8x6k42MPDphUs3pg4a6IJRGDJLkf/GA=
X-Google-Smtp-Source: ABdhPJzjppc/KVCG8+EfJAzSJD5MzH0d6QeIDHcVHyipF1xMLySmzo8GIsOneCk7VOE/jucR8HH/wn7Z7n0oOxI14r8=
X-Received: by 2002:a05:6a00:14d4:b0:50e:12c8:4868 with SMTP id
 w20-20020a056a0014d400b0050e12c84868mr23070664pfu.72.1652799632537; Tue, 17
 May 2022 08:00:32 -0700 (PDT)
MIME-Version: 1.0
Sender: nedumgil619@gmail.com
Received: by 2002:a17:90a:404c:0:0:0:0 with HTTP; Tue, 17 May 2022 08:00:31
 -0700 (PDT)
From:   Mathew Bowles <mathewbowles2021@gmail.com>
Date:   Tue, 17 May 2022 15:00:31 +0000
X-Google-Sender-Auth: 97g8h1qMmiPEls6JQsQTPY1GynQ
Message-ID: <CADOF6YPjA6Zno2+9N1HRxBb6jM2S-bGQ7PV8T0-bTuFnDBERng@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, I need your assistance in this very matter
