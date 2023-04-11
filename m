Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4898B6DE0BE
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjDKQOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 12:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDKQNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 12:13:51 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84427A81
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 09:11:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q2so13200064pll.7
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681229484; x=1683821484;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WKWP+1bJsa9Fos+0dc7Wt+iOOKLQgTx41/jRI0g1eVA=;
        b=D0HN5SiElRC5ry3YhEOcCs/JAfDnLjkFMmfb8ikEwnC2DJKCagmACk9bR3hJaoRy1Q
         6BNMNVONoz4ZV1NeP8ss8GTu8F/f7xVPXlTij+xdzz8/70H8lvhIQQTHkW9qMxOoT1Gx
         p3hTdfv+11rCVNW9D/8CgAWO4nzfOYZX66chMafclT8xfmZoamibJqvUAP+2z4fuVHie
         AMnFF/WkvOfMHhepSDbuaR6JQDCSDdfmEoyiW5seI6EVB/uYbkDc8PBoaj4ZA2bT8kuZ
         4bm6D+EvT7mzabovG21nZcJZzu+kORa0Ya/7eTuBn5aKjCn50hexFflBQ+1E4jGvl0gB
         TUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681229484; x=1683821484;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKWP+1bJsa9Fos+0dc7Wt+iOOKLQgTx41/jRI0g1eVA=;
        b=xdXhaAO8qpeiCt5fV2Y15zXRiKBukNh2Rp9krs6UwpxU9kUqJylc9nmk88CnIwAC93
         bARraeZ0UMBcQ9i9WoJOB3lRwtG+rMLgfVgoMVpYdFrQ95B8wn+TlfTZC0U8gS9Wc4eS
         DTN0O9BIqEhp5ETwCELi2rv7N/NiRXqhnfF1iiDlZRkBXFi7R9YESdotgkig+nLTj6b8
         fMhdTQxxojeuXNliZL9+yAxSs+8q4z5/jD62yuc+RIGFRPapvn6VmRHUg1jnF+BkYs7e
         L0wjgzmbWrailaetjep7XbuVG5Tj5TlOTIteo++xddm6HL1/xW4QoxUVqTXuAsSuG2zI
         3/8w==
X-Gm-Message-State: AAQBX9eljjyV3oHuGAGhcFx0wq/LKu1Qe+p+temmaXPGN4PGfUcf+R//
        2SWeurUTsWQHsN8pe8st4dwwFifI9PddBMGAHnw=
X-Google-Smtp-Source: AKy350aABZHvpCWt3tqfEqBE2KMVaWu9VpxP+VV98a8qLSpjnWRc5WRK1ZPOqEPG+bkJR42SESBe98+CFtiIkU2qqtg=
X-Received: by 2002:a17:902:6b07:b0:1a0:7630:8ef4 with SMTP id
 o7-20020a1709026b0700b001a076308ef4mr4981202plk.2.1681229484169; Tue, 11 Apr
 2023 09:11:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:c27:b0:9f:951d:b1b2 with HTTP; Tue, 11 Apr 2023
 09:11:23 -0700 (PDT)
Reply-To: justinekevin013@gmail.com
From:   justine <davidagentekenna90@gmail.com>
Date:   Tue, 11 Apr 2023 16:11:23 +0000
Message-ID: <CAKGf-8-vffV5c6assHscyE0HBzopExoCJDUyRM9LMohm_p2Yfg@mail.gmail.com>
Subject: Attention: owner's email address,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

my greeting to you my friend i sent you messages many times without respons=
e?
----------------------------------------------------------------------
mans sveiciens tev, mans draugs, es tev vair=C4=81kas reizes nos=C5=ABt=C4=
=ABju zi=C5=86as
bez atbildes?
