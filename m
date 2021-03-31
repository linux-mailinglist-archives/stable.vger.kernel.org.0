Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C783501D2
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 16:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhCaODL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 10:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbhCaOCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 10:02:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3456AC061574
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 07:02:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gb6so9580003pjb.0
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 07:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BBqQTDzGLPckErr5u2EE8zpjNyIbvjrv5eRhf0bAVTw=;
        b=R0ZT/acDdgaUL+8/ArAc+npUaj6gC+JPpEYjVwSJYvHeyhibF2p3N+QjEh+vqUbXs8
         G1P64Z51JhREdMHmC3DMPPTa/OhzdY5weSva/POh6sXhILQxa7JvVEERnSCYhlt//ni2
         hKUXPKjPYCx1zCu7P7qSIqETgqv9pYXmAhoA9kZ+yxRD/Tx0lu/6orNEYPeHmwYoM+jI
         rwVVvH4jSeUKeKZdqKeEWjRjTPuhDa7Zv7uFbaFn7/zXv1DI2s04fYM6Aur7yoUylfSS
         yNSNfXMlrzcFQkmlmAfhSXi2p06k0VOyHAvoGSQoGAtrZJiZKzRPEh3WLqWHXeObPLEI
         uPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=BBqQTDzGLPckErr5u2EE8zpjNyIbvjrv5eRhf0bAVTw=;
        b=jbXMd1qSpLgMQSbwldf2ukForoXRbLGKlNRHAsqzhfQN+UQoAIDVY/8F44qYGIstcc
         ozDqLo3koAcSo1sRYWB9c021gc8B0FdS1t6G9MZskzMwhRikoVF8I9tinxDwgvogY9Xf
         U1DrAk4nK+a0GQCGCMidwwK387bF6QOIXlzUJXRPaH/EJ6wRM6QthsDa7FYDJpuaRV7A
         jNRYHini0DCiblZkANiUVMdVh1ZjLmNmx3ukoSa+HfQEEaa85/Af9B0qjk1WgSTXriPf
         Bge7O+aWzNaJa5yvY6NavuFAsIjfOeXPe0hBD0B+fRjf6/eDhwjsrC0WYYwNZPugZ15o
         gOJQ==
X-Gm-Message-State: AOAM531d+1E3V7AVAkb4uNXgwGEmTAR9Al7aA3on4j3cOJZH8ItFpq8K
        dTaHVTXNE0HP1xe+pDLEXJoMZIyALFZEh3dZJvs=
X-Google-Smtp-Source: ABdhPJyrwg+vYAE2wqfcEJinKBaPMCiJqLVWdGFO734/cPzrok4F4+Uck0fw0tlEmtrEoySSwXfj/Jg73GhMUlYv+XE=
X-Received: by 2002:a17:90a:ea96:: with SMTP id h22mr3633032pjz.24.1617199368709;
 Wed, 31 Mar 2021 07:02:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:3c4e:0:0:0:0 with HTTP; Wed, 31 Mar 2021 07:02:47
 -0700 (PDT)
In-Reply-To: <CAGW3yD22p2Md+r4ePkMURP73b8dFvNbH2n82Z_0mm0c+hZFjvA@mail.gmail.com>
References: <CAGW3yD22p2Md+r4ePkMURP73b8dFvNbH2n82Z_0mm0c+hZFjvA@mail.gmail.com>
From:   willson mutanda <hgyftr1234@gmail.com>
Date:   Wed, 31 Mar 2021 07:02:47 -0700
Message-ID: <CAGW3yD2nuP+6c0FWZZ+C8RZgwD9mosRL-0Tab_BOVaXQpW0GKA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear  Friend

I am sorry for the inconveniences; my name is Willson J. Mutanda, from
pretoria, a Personal assistance to (Mr. Andrew ) as I have earlier
explained to you.  Mr. Andrew, is Gold and Diamond mining contractor
and a business man here in South Africa who passed away a few years
ago. I am writing to you due to the urgency of the same matter, all
effort to locate his relatives after his sudden death failed.

Since I could not locate any of his relative until now and the
Investment is about to be moved to the state treasury as unclaimed
bill, Please, I demand your consent to contact the company as his heir
as you have the same last name with him; I want you to stand as his
relative to possess his capital investment valued at (7 Million two
hundred British Pounds) with the Investment company as recorded in the
file before it will be confiscated. The fund has been dormant for long
time waiting for his successor which until now no one has showed up
and I cannot find his direct relative.

I got your contact on the internet and decided to contact you as you
have the same name as my master. And I hope you will not expose me
even if you don=E2=80=99t want to help. This deal should be a secret betwee=
n
me and you even after archiving this aim.

 I can guarantee that this case will be executed under a legitimate
arrangement that will protect you and me from any breach of law if we
can put heads together to discuss on what to do about it.  All I
require from you is your honest cooperation to enable us to see this
transaction through; I hope to hear from you immediately after you
read this message for more details.

Kindly, contact my private email below for security reasons if you are
willing to contact the institution regarding this urgent matter. I
learnt your language is not English; please respond to me with English
if you can write with English

Thanks in advance and God bless you,

Willson J. Mutanda

Email:  mutanda.j.willson@gmail.com
