Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFAF6E31D6
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 16:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDOOcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 10:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDOOcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 10:32:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEDF1FDE
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 07:32:14 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-94e53ef6815so236947766b.1
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 07:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681569133; x=1684161133;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=Lpbh5X1w82H2RM5TJF//dOL7QXbOEa2s37G4VQX5PfxrANiksdiA/OrFmB+AZZJjv4
         T+g4cdaX2/V6wjS6dpIy1DcudFbC+/Zl4554WRWv6B81gA8k3FNzdPT5ssgg0pWRVh4O
         Yz3bB5ptTjPdPo/I/DAv+KBP1P3g1cY3QsN7rNNlP3l7RV72Bg4uNU3RFgw9VqOYzBMg
         RZzEqTlqVyGmVrPM474v/1p9zpt9dPDLn4DZFlLjnQLYr4yNzwewII98nQaJdCeaRjR3
         F1QYG5JwlOfZE8KH9JQN5j9M3Bk+EqTvndfRsokJwNxEU7Hr1TKXzcnM1bnq0fq+XWxD
         3BhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681569133; x=1684161133;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=GaBmKn8+BDyBah1+qQx8DjY+/TT+8BGMsWvyEvf2C/h8cGbuW1MiAtIGrNw4MAIi/t
         cNQFlJ9maCHESJawzjy/YpynV2AuOA5I43s4TR13SxyfruCO09tvJ7T89jN/Nriem1fK
         flqYXEuBRCS3RiU70JIMunrASA1g6e+PY35zyr/8Bqg63EGTrJtfgugU5VfMw86C9HnB
         OOqfxA9js1Dl5qFm5dcngGUV9C9yyOtATmz0E9/nrRJD1sGLtPlvNO4O/mHahNwm27JQ
         Y/kaOfWEqo0HT8cNyYMbDZ8sVF7qaGeAMfqS3ajETp8MtyuOOqhYz8YdYDNB5LtOhgzt
         RwKA==
X-Gm-Message-State: AAQBX9cypaBCeGv+Vch05XZeq+n5KstKT9/3Uk3zAUYjPMQy52FZfNee
        Pcd2FS9I2KPPqmhwPc3drthIIRq9knxLysfYLaM=
X-Google-Smtp-Source: AKy350YFGHL4vpq4i8YMWsviwKFv9q0Y8WzexouAvwu5PkY+zPK6UseuUgOH1o2ryTDiRdEIZgiwKoyehk5gkgawe80=
X-Received: by 2002:a50:8acd:0:b0:506:2750:d2a5 with SMTP id
 k13-20020a508acd000000b005062750d2a5mr4698399edk.0.1681569132760; Sat, 15 Apr
 2023 07:32:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a5d0:0:b0:207:9d22:3f56 with HTTP; Sat, 15 Apr 2023
 07:32:11 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <avasmt002@gmail.com>
Date:   Sat, 15 Apr 2023 07:32:11 -0700
Message-ID: <CAGJq2vsx_6SJ=e=Pd44BR5gjqE27SAvKeE=Ckx8qo61tRdtUzA@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
