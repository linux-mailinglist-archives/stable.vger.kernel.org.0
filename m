Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D1D698CA9
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBPGLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBPGLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:11:09 -0500
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3821A48A
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 22:11:07 -0800 (PST)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-501c3a414acso11219477b3.7
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 22:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3GzLoKe2RbYpjca6vWcbTj2qTGQrrVF6Wq34+VFvzcw=;
        b=gLR8ILZ5T4GIGWzbNtPsy9Hds0pa8A5KKsoJzaXZurUtZK3TUl7eT+g4ivW6BKA4TJ
         sQqJqdIw4cqCdZf26POccndG32txj6jWbuOSXSYj5hJjdOlPOoRQ/LbdvjlnHGm4o45p
         2gYMofgNm7ZiyjRTPURkMRNyc8aYjh/fvK89cRag8ICvKhmHEZl/Y4/74edcijKcI8Rw
         1eCAkP6FzDS2d0C9xHZV4wjBqRShr1U22aAmkRAF0x/p4lkgGHWcl87EvO4eOl2YBS9n
         9/gvwAslcQAib9rieGaMpswMpYsSiISWcDI8wX0U8Sl12d/GPist60J3lx5utBs/9kLJ
         sMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GzLoKe2RbYpjca6vWcbTj2qTGQrrVF6Wq34+VFvzcw=;
        b=MkyMIiVBbQHoq1a1rvQNuiNgeIPz00OBSpelSckxVoQtPCi6hAv9/RNPOYDEhINLF6
         e8AfKvvtcrlYkq/AAfFAxxV5IqiuBaiw455JJjPHtVYRer3xTjumaiYkIafFzthttiZl
         Tbo1sLPfLIDU/ttmVct3YC4pJ4me4Dv1WoU92maZqrTCxMQlkWNfyBLZUlqnk8pamnO6
         vTNMd2Ix7fr+G9+oB+GnF5oo0JmHspXXzqjYsplWDny4deJ0Vloiq1bNhBqTwbYONhHx
         Zyu/fYT79tFhbIQcBH6jHOReTKGIxexGAVnyqTCVH5130QmUGBm12l6HM0bk+E3Q59Of
         3IcQ==
X-Gm-Message-State: AO0yUKUdxqEPNuGC82jRSQurQN2jkRAq9btXG6PF2X4YapV1uyJnW6iz
        moN3th3aordzpvqvxL36iXBHFblMrI+9mNnqFDo=
X-Google-Smtp-Source: AK7set+jmSTlVTeyYgfsQCwf/N2nng8m5quvj37xPRqblcTn9nkxAHY07Q+vb/+0s9Jcbdv62yH5AIdpHkjUoODWzNk=
X-Received: by 2002:a81:9e03:0:b0:52e:e396:3ad with SMTP id
 m3-20020a819e03000000b0052ee39603admr702614ywj.171.1676527866568; Wed, 15 Feb
 2023 22:11:06 -0800 (PST)
MIME-Version: 1.0
Sender: sessouaicha9@gmail.com
Received: by 2002:a05:7000:2701:b0:46b:c128:722f with HTTP; Wed, 15 Feb 2023
 22:11:06 -0800 (PST)
From:   Miss Reacheal <Reacheal4u@gmail.com>
Date:   Thu, 16 Feb 2023 06:11:06 +0000
X-Google-Sender-Auth: QY2S5L7ro60q-hNuUpnxZO2LMzE
Message-ID: <CAOcv6REZuG6+EmWitiS4AnX6Yj7tqGwcaMzcC25=K=S6u4bdwg@mail.gmail.com>
Subject: RE: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cze=C5=9B=C4=87,

Otrzyma=C5=82e=C5=9B moj=C4=85 poprzedni=C4=85 wiadomo=C5=9B=C4=87? Skontak=
towa=C5=82em si=C4=99 z tob=C4=85
wcze=C5=9Bniej, ale wiadomo=C5=9B=C4=87 nie wr=C3=B3ci=C5=82a, wi=C4=99c po=
stanowi=C5=82em napisa=C4=87
ponownie. Potwierd=C5=BA, czy to otrzymasz, abym m=C3=B3g=C5=82 kontynuowa=
=C4=87,

czekam na Twoj=C4=85 odpowied=C5=BA.

Pozdrowienia,
Pani Reacheal
