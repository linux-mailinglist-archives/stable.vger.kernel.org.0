Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0303FC2E9
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 08:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhHaGlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 02:41:13 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:53842 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbhHaGlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 02:41:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id 4DD8B2020F
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 08:40:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630392016; bh=OXVMywrixrT9yT7clbRYVI1BHTcNFp3MKsx2GWiEvCM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=JmO3qzzcks264yxPyGp4W/TCS2hFKhI6SdAezF6RI2gkO9DZidXmmwRxSUyi3+EJW
         W5Q9NSlYiD4MaxcsRA8TYK0gzie6D+8vNwX74PSg/YT+NBT9SjIreHLPjByRA3nXiv
         j0Mg9oRemtY2CVgOiJEqrV5Q3p/saWS+Qt/uHq4E=
Received: from mail-lj1-f181.google.com (unknown [162.158.183.170])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id DA89F20230
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 08:40:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630392011; bh=OXVMywrixrT9yT7clbRYVI1BHTcNFp3MKsx2GWiEvCM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=pcGkPfxAE098Pm2wqxHEx6oaO90z3IGGrw8IzsVx57pdkNK4PC7AXLuDI5VASbS7f
         SZytee9RRZV1/DSyQdt7UpfbcnCgN9nOjbLcEcYOVrEbF6ouz2Ud0v5eCDZnL+d/ao
         EKKl1EsuLcpX+mBF4o29F+ln78W/upjE1X1vdhRo=
Received: by mail-lj1-f181.google.com with SMTP id i28so29946575ljm.7
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 23:40:11 -0700 (PDT)
X-Gm-Message-State: AOAM530xhte9xjlEesQ6NqOF7O8hHHaqB6/NuI65cRlvZLTPlMbvUXaV
        p1e52cpMei9xBCj5sLquZuqw+pfDU1fL9BlNWSk=
X-Google-Smtp-Source: ABdhPJxWbwpIvql9UAq8X5K62htW36rGjrfpipvyDqFC253wF73u9gx3zSRiypXGj0SvYflJwk2Br+OVT0b7LswJM2M=
X-Received: by 2002:a2e:8855:: with SMTP id z21mr19164526ljj.294.1630392011234;
 Mon, 30 Aug 2021 23:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <YSy7lOd+qB7LXq1n@zn.tnic>
In-Reply-To: <YSy7lOd+qB7LXq1n@zn.tnic>
From:   Patrick Schaaf <bof@bof.de>
Date:   Tue, 31 Aug 2021 08:39:53 +0200
X-Gmail-Original-Message-ID: <CAJ26g5Q7L4dqf9f3K8H-5cWhJWT=4d09qF=SO=mcHqW+Vbq4dg@mail.gmail.com>
Message-ID: <CAJ26g5Q7L4dqf9f3K8H-5cWhJWT=4d09qF=SO=mcHqW+Vbq4dg@mail.gmail.com>
Subject: Re: [PATCH] kthread: Fix PF_KTHREAD vs to_kthread() race
To:     Borislav Petkov <bp@alien8.de>
Cc:     stable@vger.kernel.org, bugzilla.kernel.org@e3q.eu,
        anubis@igorloncarevic.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 1:06 PM Borislav Petkov <bp@alien8.de> wrote:
>
> Hi stable folks,
>
> please queue for 5.10-stable.
>
> See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.
>
> ---
> Commit 3a7956e25e1d7b3c148569e78895e1f3178122a9 upstream.
...

Aha. Seconded, and please also consider for 5.4. This looks lke it
could fix the WARNING I reported, seen with 5.4.135, which Igor also
saw on 5.10.

best regards
  Patrick
