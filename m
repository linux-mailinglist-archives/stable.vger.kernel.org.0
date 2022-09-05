Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5015AD887
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 19:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiIERmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 13:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiIERmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 13:42:50 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9495928707
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 10:42:49 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id m1so673701lfj.0
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 10:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=gfkCGBP4m48QkuYXX+qgsDqe0T/a/XX/x3rZw4rN+GA=;
        b=mJYA416e7sl/PHy7rcGnutULbOBDVZTVSMrhbs2T/V9mokZI7lcu9Xqe/Czbf3ujg1
         arZkjRkitfNZFz3TY+8bH2LAh33Gz4KOlMZjZVEcrumVFfI2lQwh5+bTIt+4WtlGErMf
         gJH/bYNKy3DoUosUjXkDw8YxL9kH7lCejid086QINNrqowqXmv9+j3H+g4IskYNApV1j
         6grr0icJLcJzUCrofx1YMFqOgw1ISJNl9UxWFa+xJYkAgh78GI9qAdgKF3mk8ILLoWpy
         BKS9OxcuZ0MhB8o4VO1aEgDQVvM6IGTNsJpkpB3T7EDaEqX4Ll+EgjvqiHDKeU6SECLs
         aRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gfkCGBP4m48QkuYXX+qgsDqe0T/a/XX/x3rZw4rN+GA=;
        b=wvpS1KKQKvpDQ5/HmcPTcWMdQbrTSWblUFtFZGRUCzm7rwQYGdUhSZgS8NEGnQjhvx
         9NtWIt0Vd1QduX9Kb2n44DByFtM1Gu5PJ7MZoKwp000z9+L3hN0Df3ruKcukdnxrSX2N
         lFzKPBPu3vv+UQyf20Q3Ai54ydSDvfF4FEZsYIfo4NnQNnBbgEgujWABdLKqBr3i87nT
         esKhsEYLqjtiSYbSHeNY7RsMOXUfuVD1KNJYn/UxElxvR2tywEAJ4eND14pkUVZcDReb
         3o1BM/T0ZTgYmp0/xYtY7PiMZdcK93RwdpZeRyJDGjAPybrzTtZuRjPjBTUad68S10Mv
         Xcaw==
X-Gm-Message-State: ACgBeo3HrbaEL9vkI9smiM2+EIDGc0icM+gQUhhaWXKEByCLrRw7irn2
        d5soWIJhcpgom12pgg6WXv4gWLtzhgYPClNYVCU=
X-Google-Smtp-Source: AA6agR4Z9K0juxme92VWzjskiLdRuOJ6/oGUIJOCv/kzHG/gpSYh3dpPpQSuUHMX8i7s4EXW33L/olEB2h1CbLZ2n0c=
X-Received: by 2002:a05:6512:33c1:b0:48b:2ef6:f510 with SMTP id
 d1-20020a05651233c100b0048b2ef6f510mr18481312lfg.237.1662399767768; Mon, 05
 Sep 2022 10:42:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:196:b0:21c:ad9a:6890 with HTTP; Mon, 5 Sep 2022
 10:42:46 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Dr. Kim Chang Jung" <depatchdeliveryimf@gmail.com>
Date:   Mon, 5 Sep 2022 10:42:46 -0700
Message-ID: <CAAeqwM8-7+T=BempQ7DxNkvFOJNNyXPgoE2ZKh6qRdA-zp_oSA@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
The Board Directors want to know if you are in good health doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

Sincerely,
Dr. Kim Chang Jung
