Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF2654B350
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346928AbiFNOfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345495AbiFNOfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:35:31 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726373B2B7
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 07:35:30 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a29so14276392lfk.2
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 07:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=MsEbM59CSkuLMcT/9zVTPnErh+g07q4oEg/h0KS70Ic80zz/4SWwfkbf607S5SlXCI
         9YFyvSHzfX5da0y62S8dMoYfY/S14M1sYTc9zNzfXagVj5cX2C4knZNPHFgqOI83LgOC
         n9wt7YK5pR3RoJNw7MrFLCPPhL0SFl8M0dJdkZqZZbu+kHH807RAI1GMtiGbtsdUIKbR
         Xr8WiHddwqdm2YJBEFpqZEswllY8kicBdQbHDbl8y3/KTY51HPkiwJB20fcfuUWkNrJz
         bNtN1Yr0O6kFYcdE6NXqyebApuStM/V7vglun9QnfPfGCQlJmm+4fdl0YZvTqo//1wvA
         +y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=E86zNsHjMBW705NKySUswl8vGwF7VBJdw4mSfxDuTTMCPgVsJfReU5EvYHdH3E7zyg
         jOGHyJMP40Yty6APTgzlaOgtc4pb6OiNpdyYnYHhUDFqGhyhxUjt+4c+X7gEpyke127g
         poyUd0zMXFqtkdn22hCK2t1ZI/TAF2DVvhnoB3uZiP0qUYZ5U//XTaLJnUTPscvUDIWx
         CJ6rGgm7bmUQutReCgXnz8hmnbx1kGSCwFCGIEqoJxsjniaz4S6tCotS7RdvSlfCDQpW
         YZKrqct94Iu60qfYHU+wWnGIcDKosxTTpohR+OnU+BH2d8THpZ1dHJDG31VB3upAXenX
         JWxA==
X-Gm-Message-State: AJIora9dGXiVQuZS7mh35a0WlqgA5GOU08cdaKbnaseMlq2vTz+LCHzT
        LJo+6bLZMAoD6OslfVDXmN97Tl4Yz47L6GXlfQQeOFCklcwoQg==
X-Google-Smtp-Source: AGRyM1txNhCWYBTxSCCgm4fr1Nm0nUpcpW0XfLdEPf1M7OFmR0ukuags8e737z7iJtFKCY/578/rkRAkTYZePHE9p9Y=
X-Received: by 2002:a05:6512:33c5:b0:479:64d2:f26e with SMTP id
 d5-20020a05651233c500b0047964d2f26emr3262367lfg.605.1655217328622; Tue, 14
 Jun 2022 07:35:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181233.078148768@linuxfoundation.org>
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 14 Jun 2022 20:05:17 +0530
Message-ID: <CAHokDBn6PHeV_Y+TGkA_o=S3a9wJFr1-KK3F_Wqr-DEJQTzurw@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain <fkjainco@gmail.com>
