Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB4693F8C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 09:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBMIZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 03:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBMIZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 03:25:06 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D8A4C10
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 00:25:05 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id h4so4906476pll.9
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 00:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNFhsPbkfGfOWNF5M4aRb8nwKD8L5aVj2WV/H46NM8s=;
        b=J5Jw57HYo5O4vVKyaljAC8wyUiGkdKO4Ay0vXg0cd4WBoy5vEvyiGxcAOhLmk34qEV
         IZ8l24p4VZ98hZjaWWEay8sYmYRI/LD5goPjty26yKApzKQ5Uba/D5hU20QqomYOU8OY
         1i1Su16jNCeB3sQKJn0x1d8LgYcKCXyIcNO8ro+kilsYRdN5mXQDGIBjteMkZElQsR/U
         eDcMXAiA+6L3xYgMbFL9wYm4BfrHFpfFzznacovvaoE+Kcc0x/ObVtm11EdoB/Gb9sRw
         Marr1vp3enECLaXIx3/C2hwqiiVVn4uoJ5X1/ZzrponYaeAAKuVetBEYZ/HBXLk/WCX2
         78Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DNFhsPbkfGfOWNF5M4aRb8nwKD8L5aVj2WV/H46NM8s=;
        b=1qkNrEAvZJPXBjigm4xV0PR9qVfDfJoZgK7Iu2wqgv+RJcj2YtTVYE6XVqz4zYfR5s
         W3DjOcIbadKxDG9H36uz5SutrfP5Gmx0OGAlw6qEa2t7szIbKIGqDPm/ogXbrNHJUdbA
         tRUGuOKGuqv/Nnti8xRXuvGFkwFyXV/9EtJ0k12oEkjaORTVC5diFj4XYfDKxuU+rOXT
         5jZsc/HAcP5b+uyGWUzo2jSzmmJplpZ8e3DRT0BvuUITMHWTd+Icxnz2yg8hpcExv3Ck
         KmjLDK0aZVo7MDVOKKeQYyUzV8pf6zN+rYWgI3af5WCg4LvC+75yk7TH9hw++DWqXpyW
         drcQ==
X-Gm-Message-State: AO0yUKVzJ1tMm1rczbNxu2v6UeOZHfVJjeBni8IF6kzL/+OhjIGAx6hP
        3ymrJCnw3BkBqlI3nMDto4TkPYCfSYbIb9RA7g==
X-Google-Smtp-Source: AK7set8gtOx/VYdathpb9GJbmV+W6lzbOYoAa8HfjCSt+0fkP2tBuzraQ6mLzHogCOPT5V5QSW1ymru5hKBOwjN4gHc=
X-Received: by 2002:a17:90a:16d6:b0:230:8005:5c05 with SMTP id
 y22-20020a17090a16d600b0023080055c05mr4296562pje.33.1676276705226; Mon, 13
 Feb 2023 00:25:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e251:b0:40a:aaf9:3e67 with HTTP; Mon, 13 Feb 2023
 00:25:04 -0800 (PST)
Reply-To: engr.fred_martins@aol.com
From:   "Fred Martins." <deliverycompanypossacourier@gmail.com>
Date:   Mon, 13 Feb 2023 00:25:04 -0800
Message-ID: <CANPQYVOjmwd0gSoqC+_sg7B3CiRMSdzxhUq88hNvwcDTf+MbJg@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

I wonder why you continue neglecting my emails. Please, acknowledge
the receipt of this message in reference to the subject above as I
intend to send to you the details of the mail. Sometimes, try to check
your spam box because most of these correspondences fall out sometimes
in SPAM folder.

Best regards,
