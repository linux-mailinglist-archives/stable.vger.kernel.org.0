Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74CD6C8692
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 21:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCXUMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 16:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCXUMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 16:12:15 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25D719102;
        Fri, 24 Mar 2023 13:12:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id bt19so2012876pfb.3;
        Fri, 24 Mar 2023 13:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679688733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yaavObOWzHRvJy2JM91YkUKlJ/WIEwIWML4qoWi7FEI=;
        b=orIdYEplRNwQiKg7avw+Yw1CMIHIbZqmvuxpyoAwqC2WiYOiJrPLGwfsIodVwaeZ4F
         VxUeYFTWvu7hP3fFnKo7IkHvM2R7tkuR5C3R7VgnvN/iOhRWGqtbiGB5W4kwJZKoNW8s
         uhqy3XaUTZO8Wj+N8GHb3QHVrKiyLqBLJRIe+1nTPWEa/sJRitphHBoKo7FBnHIKjrZv
         amREXR7mFpgtqoGF16N7bdt9TTVG4Qx3braoxn5Yfk7X8lvTdzf2a+k9XwTGp6NrjSf4
         PZECsxjwIOrVgM+eIcjFhMjJV18X9jkMTwpXzSqYaut+JWwwSkCmvtQvjrL9xxRU1whD
         5iKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679688733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yaavObOWzHRvJy2JM91YkUKlJ/WIEwIWML4qoWi7FEI=;
        b=XvJXOf82UA39VVEirtiPtyLWamUqvETBe3OeyfD8FFoKcm/7VYKKqs23Xkx9lFNG81
         YHs2D0VWqb2+wH3IcUkXnLobUkOqUcKgp238aU6peF+Vg4ssh585T+JEU5ZSKdRhpxV1
         wUvBN8RjXWsl8rOjeYZYOhoI4zbtYBxoBsp224r3tbgn3kZHvbIa8PxY8dUK0Opn2b3Q
         R1eR+83+IY8bWcRTicgyt6lZSebfZXMUfaclOmtF/NN07rZQ/zYEbmcPeQuLyV6x7v6p
         mjIYz0PlKj1KPN90BZPu/rZlj6bYb1bBwyizaDFmtPUtndbQeDrqMtwft9t882eDaj+V
         zxNA==
X-Gm-Message-State: AAQBX9cCeyuNqM2RpjTCluJvKVliAlaKVadAPcJDGliDif8IVADBEfjv
        wxzRwwDucOfX5YqcRege8uvGHFWbngBx6Qmwt9A=
X-Google-Smtp-Source: AKy350bmLPJFtuX3lJO6ZUzJk8S0hGYzGagCcVbStVFTm0oD36plkeQv3bwT0ZDg0yEKHa7Y46o/Pio3ZO4D1PeoAzM=
X-Received: by 2002:a05:6a00:1344:b0:625:a545:3292 with SMTP id
 k4-20020a056a00134400b00625a5453292mr2245607pfu.0.1679688733556; Fri, 24 Mar
 2023 13:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220203182641.824731-1-shy828301@gmail.com> <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com> <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
 <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com> <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz>
In-Reply-To: <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz>
From:   Yang Shi <shy828301@gmail.com>
Date:   Fri, 24 Mar 2023 13:12:02 -0700
Message-ID: <CAHbLzkomXCwabFrNaNyuGBozmindHqVD0ki4n75XJ2V8Uw=9rw@mail.gmail.com>
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     David Hildenbrand <david@redhat.com>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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

On Fri, Mar 24, 2023 at 4:25=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 3/23/23 21:45, Yang Shi wrote:
> > On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >
> > Out of curiosity, is there any public link for this CVE? Google search
> > can't find it.
>
> Only this one is live so far, AFAIK
>
> https://bugzilla.redhat.com/show_bug.cgi?id=3D2180936

Thank you.

>
> >>
> >> That's good to know so at least my bogus mail was useful for that, tha=
nks!
>
