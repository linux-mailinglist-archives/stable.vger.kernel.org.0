Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C724E6D712A
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 02:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjDEARH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 20:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbjDEARH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 20:17:07 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594A244A2
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 17:17:06 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id m16so20431537ybk.0
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 17:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680653825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MQmc0UR/PhGblsuUcT6vb9hLInFryTUtJTR15eyIQg=;
        b=L3X5EEwiU480XS0ZRRvJp7JD+k7IF+tZQWJEBQUUx9Jc9M6qMeOiyrdt4d/ZWaRK8k
         yMWX88A/fyVrQ2kgx+XdxyXQixBLJFIzxDfvQ1q11JR6Ecx6E/9iHUFcvEbQGgCP0yFU
         arFCXfeEm41wu+KXl+JCug3HdOAcaQgfGTnrbRZ3NPnAjZRKgIEVND0OxlD0fwWilgE2
         5p0MscNhwFerAVdpwLxsBxsC3eaFp69T9txai8LsrSa8DBRkmIDz9JzlObU8gqwZIjtK
         MlAUvQVrI+P+o7dejIol2+IXkzLYTy23OCFFqG3FekooAYejVR9111Fbn4j5kNA+xD3j
         g8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680653825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MQmc0UR/PhGblsuUcT6vb9hLInFryTUtJTR15eyIQg=;
        b=1ciI9BTUb/kRKToB2NAul6MUwVHSwCoksX+k2QPKQaRniEuHwLyzGID0Q7Tgu+LcTF
         xF0FPeAIAg4uo8Zy2pGX07gFjeXvQYuhkG5bXYQx8ddqj9vcBP2xDEUq1vyvgK/6kxBx
         vnPmJewLGxy1vcMH2s3i4aWdGzRyvhEdSoPdYUp+AR+scxHjk0SszqOmp6SygYS+UoKJ
         6znOb9h3FyxcuE+jxLU2g7G1YKE2htxb+JnS18yEIyjUlMcTexYm90/qwfwvSHmgKmrl
         te22rhvoIqUnsmYPwh/pZbDb3GjKfMCBcRhwrRbNl5sK8N8fisLgjocLMPIBuOB70FA5
         8B6w==
X-Gm-Message-State: AAQBX9f3EpKoy7H845uyHy8qxkiiQyDF+JAvz+sYLcoTwSJAxpPuMohJ
        hm/G/b0oafgJ32dKMc1PUo2FQ9h5sUiGfKHI0X/4SjYPxb30WthgiCdLSw==
X-Google-Smtp-Source: AKy350aMTY97mEg9+Ocxvb2VwLVxDKfVsEhdpzu3ChtQ6pmrTDo1VZQ5vATtI3FED+yJ+sGUId9EHmFJoKCu02c6iPs=
X-Received: by 2002:a25:cb95:0:b0:b46:4a5e:3651 with SMTP id
 b143-20020a25cb95000000b00b464a5e3651mr3036548ybg.9.1680653825439; Tue, 04
 Apr 2023 17:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANZXNgPN=yNchM00fn0-7nd5xs_6DEgTFng0zS96J+tGnntynQ@mail.gmail.com>
 <ZCK8Voa2AWbCUHo6@sashalap> <CANZXNgNgYvsdD6y3QETRG-XM4ShiNGOrz9AmvnzNRL3uuLvGJQ@mail.gmail.com>
 <ZCbGdXSqEO1NlpxG@sashalap>
In-Reply-To: <ZCbGdXSqEO1NlpxG@sashalap>
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Tue, 4 Apr 2023 17:16:54 -0700
Message-ID: <CANZXNgM2Pvb7aofw-0zk4A8iPCzbGHK8egnUekt63f++E=91Kg@mail.gmail.com>
Subject: Re: 6.1 Backport Request: act_mirred: use the backlog for nested
 calls to mirred ingress
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ah I think I see the problem, I was missing a dependent patch. My
mistake, this should be fine.

On Fri, Mar 31, 2023 at 4:39=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> On Thu, Mar 30, 2023 at 03:04:56PM -0700, Nobel Barakat wrote:
> >Hey sorry, looks like
> >act_mirred-use-the-backlog-for-nested-calls-to-mirre.patch isn't
> >compiling correctly on 6.1. It probably should be removed. Same goes
> >for 5.15 and 5.10, looks like those two are running into compilation
> >errors on our config.
>
> I've tried the provided 6.1 config, and it seems to compile just fine
> for me. What errors are you seeing?
>
> --
> Thanks,
> Sasha
