Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128CB54B195
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbiFNMpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244522AbiFNMmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:42:52 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C76443F6
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:42:39 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u9so6134474oiv.12
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=mwDPJhjd2vyqyQhKM3XpUrvQpeTvmwN4Bz+TItaS0Me5KSK7R706VP0rqVYkg7j1td
         b367vf24JlPd2kHmuuCT6N3vJRZAOlkMe/WZmQDBBoFq9OhQucwyUVIOwaIF3VE/K9bz
         o12MpFMSjL8BycyIIVdQi+Pfj4MItG0iyYPe0CUZagPAqXUsWsgjoR/HBDV3h7CmmPSM
         XWUeVm0UE34+B0YKHclfF9yH42xRmUcfGtbu6G4CvB79ehsPUWPii5FpXY+0AyNrITO0
         3DYJHrET4WDOEJyFWQ5THj/61F9z7OPk4ayNCy4cAKsT5HpdGQz0JawjfxBdNhgnzs2c
         2j7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=bgNB4zFUUOi3W3qyXnLAi1jNfq3NvvqAnX5VzioWtAEQ164aNJrk7WCr/TEnhMK8Xa
         n05hE1+tHio/METxLS0K04jur9RSY+3qC2H7UqYA2rXnjRio5fXOrqqZNT3hW5RKLYev
         qnuis/nepOz/gG6C3taB8wFM4MhNN7WObC2Go+cIibxPcTM6O4aH4o9trYffXlyDe1Cc
         tNqY491YnL5Bi7899+L3Iz1e+n1lozqgyXbpjA2WyWqpRCPI1WzauZdAuP/IIdAGivyJ
         BiCmzEyVZASUkmgFgBRnDL9sZP2afWP7yYx6Jy79W97/LLApY+5WX0lnsHwJWHD5Y1ll
         JN6Q==
X-Gm-Message-State: AOAM530cChjKl2qcecko0RRzjPkTNR4ll9m5u2cx+6pH6KKwaPtOOWwF
        faJILpKLopjYWzshg3Dh5SPdVW/NXdOSH40PCWE=
X-Google-Smtp-Source: ABdhPJzU3y4bklZJP9OpFZOO7cVBMgZ10bmyGcPPR1lNJeUUwhBu21VnSCR2Ao3xyVnpA02xcZ60P6t1t9JEt7EDcOY=
X-Received: by 2002:a05:6808:1a01:b0:32f:284c:5e28 with SMTP id
 bk1-20020a0568081a0100b0032f284c5e28mr1937151oib.194.1655210558975; Tue, 14
 Jun 2022 05:42:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:c46:0:b0:42d:ab20:ed24 with HTTP; Tue, 14 Jun 2022
 05:42:38 -0700 (PDT)
From:   Daniel Affum <danielaffum05@gmail.com>
Date:   Tue, 14 Jun 2022 15:42:38 +0300
Message-ID: <CAPkju_NViPzK9C2+7NpUCr7s6EJnOAxMqVKNaxLDuegLiwP6zg@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Daniel Affum.
Reply to:danielaffum005@yahoo.com
