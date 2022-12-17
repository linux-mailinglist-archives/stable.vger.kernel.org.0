Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E28C64F8BE
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 11:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiLQKrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 05:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiLQKrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 05:47:02 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D6A27CE8
        for <stable@vger.kernel.org>; Sat, 17 Dec 2022 02:47:00 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id c129so4161053oia.0
        for <stable@vger.kernel.org>; Sat, 17 Dec 2022 02:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=jqomnUp2ICUTwl4jKwQKBkdnoRLyWP/QaQ/9WKYQHGScyqFD0mMnfwJmPwqmbTGo5P
         ws/YMjJbHqaUSqqqUnsZ7BUJxH2v70yroD6uqRv+dkMbF+t12+d6pXz4KYcahxoXbPtK
         Otg0lJbHzJ+28d+gtq44lkLr3n08KWYt0fc/S5gETuzT/wH4fdUtF8FcIYEV4KvQgcOi
         dvy8vNWu47/XFIgS932215knHsrlgUlq3jp8cyIJUQWLhUhQ6e2R5eCie1I9VM4C++9w
         xAAR8Wn7flHly/eWPyo/TBhb5eAzmOFy7ATPdEthUm+CP5h8EsZsPJ3401ML75Zna8u9
         kFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=5XA8QYHLEeuWg7jTfaraYTj88UU46lhF4rcU7z6iWEdgfwOP9zPoWZeesZ32Fyv7qS
         OAwDH8xMib5LN2ndPiIhMSVORqKU/AeggKt2TfyM9iPUMXhUvA439ZE2rk3jYn87tNWw
         RBAmLd8jM+xr1GW7PpqiVRTKstLAjlIuG0slVV4/vIs6DsvJVsIuURNVctF5vw7Abb/B
         RAvvsIK0I4Jtbz+eLrGWwIY/1Pskomc5NmONuhFeMscSoZjJemI8idLzdaKtXc51qKxv
         JVZIrHrkgIo5u7CtbhvIe82tRIw4w60BCNwGZwGhUfKtJa8T0icfRxkiibcy0vr7vQRO
         HVlg==
X-Gm-Message-State: ANoB5pm/zCjFr1v4WhCiFCLTAG06mS3l9Vn91gCQCj42AacNJUkck/rv
        FGaBzO0zxUjsOOfU/OcN6fyv3mOWAk/O9pflGNluu8KZYmk=
X-Google-Smtp-Source: AA0mqf4nx5nBZnHcufuYAAiY0jOhiwBabXkMHexVr64RgYg6xambPGNlBWXLVcZz1JpKfsFOCXsp8v1Sosmn/+FcIOI=
X-Received: by 2002:a05:6808:159:b0:35b:a671:ec59 with SMTP id
 h25-20020a056808015900b0035ba671ec59mr745727oie.138.1671274020036; Sat, 17
 Dec 2022 02:47:00 -0800 (PST)
MIME-Version: 1.0
References: <20221215172908.162858817@linuxfoundation.org>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Sat, 17 Dec 2022 16:16:49 +0530
Message-ID: <CAHokDBmMavscs+XZtVGGUxT4r9kkQFjKSVt4AJYk8yMxa0KKuA@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
