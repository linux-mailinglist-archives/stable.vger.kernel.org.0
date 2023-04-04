Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B50D6D55A8
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 02:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDDAvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 20:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDDAvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 20:51:02 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB1910CB;
        Mon,  3 Apr 2023 17:51:00 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n14so13913736plc.8;
        Mon, 03 Apr 2023 17:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680569460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKRSKYp1K/d7cEVS79Gw2CfFkDGQoLe08di4qI6GwFc=;
        b=Y4Sm9ZLwxJ+D+r6pF3ybUyM9uX/W2R/Dr4HzTggbAbcnH+ZO6kQCx+RGIW5DW9vq/z
         mNbpUQcUxuiFplYd76ZytcfYMQ2+T5idvYbV3OJDE6A+YMXw704O3OrxvGpCZfw3ggvs
         yC2EopAz8OBnJo5KSsN3akJy0IPH8lz2eqB0ZUzLDi5EUnGh24cIwMJ0Q/HT4m662zPJ
         8GUrXZWc38SwiKWH18Govx0BOeHwgpXPcLyHrxAvFnjoFGdsJ4EZSDfTzESzdD2BkJr5
         SfVXRWBR/+Wwlz6cptLQJz+esFusFxqqWaOfpxZuy+5t32sPiTkKNSJeyEDf8+UhzYrX
         27lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680569460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EKRSKYp1K/d7cEVS79Gw2CfFkDGQoLe08di4qI6GwFc=;
        b=MB2ZitqlFaQTpkcKVXFyxx6Hf55L8OnNLkt7eq6QRlN3gs9kwiuCcsPXVOEOhZt/UZ
         8pdbIyM2+t5GLkLUosYXscqPlAcpnH0aNGBL9/1Wf08VOKwTYBigoNfQpas0VO/+Ub2d
         AI+ua8yKuGJTds00pcjukziSWaOmJcmTIDOyS7WkOxcKR+LaQqUEWz0gbB53EWOm8tKu
         br9wtOQLIccskqLAAvC6UvRWSK95SLdfLXWaowHzuBt2fLeRctN8qzIGaDlc8OIVFeg2
         cx7orQU/JzW7bT0jnwht52EkJe5eJVv//6DtbEsGv/1kkp7CA711zf+pMjjfnLOxPntZ
         zdNA==
X-Gm-Message-State: AAQBX9foDLAzByTDPh/sCkQAbZhO3HeWXVBYyh4RjPtXnLjZSpGZrW50
        Flz53XLg41yZJkqd1NqYhZE+pa5jSwthwe8mY00=
X-Google-Smtp-Source: AKy350aSCysYEOdKcdoXKNZMkelmdTgziRdPavBpkcvm7+SAoMAg2VeCxrcZIcniXwvkpWcnm/AWv4Il6OMnqcNY4n8=
X-Received: by 2002:a17:902:d2c4:b0:1a0:1f4e:a890 with SMTP id
 n4-20020a170902d2c400b001a01f4ea890mr357591plc.1.1680569460152; Mon, 03 Apr
 2023 17:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220203182641.824731-1-shy828301@gmail.com> <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com> <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
 <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
 <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz> <CAHbLzkomXCwabFrNaNyuGBozmindHqVD0ki4n75XJ2V8Uw=9rw@mail.gmail.com>
 <5618f454-7a88-0443-59e7-df9780e9fa50@redhat.com>
In-Reply-To: <5618f454-7a88-0443-59e7-df9780e9fa50@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 3 Apr 2023 17:50:48 -0700
Message-ID: <CAHbLzkp16tAzFRnM3BUnspnR-qR2JG3c9TqaNq3YHxy9u5ZC6w@mail.gmail.com>
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     David Hildenbrand <david@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, kirill.shutemov@linux.intel.com,
        jannh@google.com, willy@infradead.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 3, 2023 at 12:30=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 24.03.23 21:12, Yang Shi wrote:
> > On Fri, Mar 24, 2023 at 4:25=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> On 3/23/23 21:45, Yang Shi wrote:
> >>> On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> >>>
> >>> Out of curiosity, is there any public link for this CVE? Google searc=
h
> >>> can't find it.
> >>
> >> Only this one is live so far, AFAIK
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=3D2180936
> >
> > Thank you.
>
> There is now
>
> https://access.redhat.com/security/cve/cve-2023-1582

Thank you.

>
> --
> Thanks,
>
> David / dhildenb
>
