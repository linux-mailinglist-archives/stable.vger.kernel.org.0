Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467552E02D7
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 00:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgLUXOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 18:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUXOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 18:14:16 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6D9C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:13:34 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id o19so27700068lfo.1
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f06zvCtNpwfTL+4Itq4rCpQRN53L0BPN7ECqHQNOVpQ=;
        b=YPEH2Xb2Ow8JmzRAuCKa272elvNzGdaJcJVbXOAswsyaU1vW/qvS3mZEvPQgkSsF4g
         3oN6qkAJWfGl+PmPsyxxPFKtVeKvVltnzERL2UIJN2ckt8Aovs/Zb9VTbJx3IX+lOwGm
         SPwiI22Arin2BcxLEmElXrQkTZ3/UHRfgC5iE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f06zvCtNpwfTL+4Itq4rCpQRN53L0BPN7ECqHQNOVpQ=;
        b=e9MujbbRSD2Ag/CcZgxP56ZV3bM8TQAqOARMc9XvGlSA0+i/wPnzu3kvDOr51ZrkHq
         id/skz6tmfIr8NemlbBmpp0K4G00TxwszimH7RSS492R75mITgm1h0xnwWkCE3UWDE93
         WEB1xTm7+sXX8LEq4Ljdlk0hWCJPYrZJWW+1vsbwOcPFFszGzVDksA6az99q6FBN+UlR
         ldZMpEYNSe16cPfyBX4PMRZ85Roz90gRLpsSA1zJdAN9N6o6nB8kxR7heR1feKs0s14w
         T+cZo7itjJTC0i1JcSCp9IHAB13nJzmSO2BmmaaI8o0MYaVWjwBiV7ZY2U5vBxXUfvZg
         zitQ==
X-Gm-Message-State: AOAM533RRA0oOyVJ+03VQKmOzczMdHRxPhXemcCcgo2Jiauii8OaVSm0
        yX/sbKgax6ggahW8LEEfR5/LKCp9N0FHgg==
X-Google-Smtp-Source: ABdhPJybqElqHbspbNJD5s2UzoQyRDcejhAFTkqngOfuVil+cIWavdLHWpyR7HL4eqe1Qq5K1EUD/Q==
X-Received: by 2002:a2e:9916:: with SMTP id v22mr8312187lji.221.1608592412693;
        Mon, 21 Dec 2020 15:13:32 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id 187sm2271102lfo.16.2020.12.21.15.13.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 15:13:31 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id a12so27630255lfl.6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:13:30 -0800 (PST)
X-Received: by 2002:a2e:3211:: with SMTP id y17mr8114725ljy.61.1608592410631;
 Mon, 21 Dec 2020 15:13:30 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com> <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com> <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com> <20201221215526.GK6640@xz-x1>
In-Reply-To: <20201221215526.GK6640@xz-x1>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 15:13:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjSeNSeT44BZpZoQu+nFjDHVCy2t0kKMjkXnBfLOaPGLg@mail.gmail.com>
Message-ID: <CAHk-=wjSeNSeT44BZpZoQu+nFjDHVCy2t0kKMjkXnBfLOaPGLg@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Peter Xu <peterx@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 1:55 PM Peter Xu <peterx@redhat.com> wrote:
>
> Frankly speaking I don't know why it's always safe to do data copy without the
> pgtable lock in wp_page_copy(), since I don't know what guaranteed us from data
> changing on the original page due to any reason.

So the reason it should be safe is that

 (a) the pte is write-protected

 (b) we're clearly not a shared mapping, so that if anybody else
writes to the page in another mapping, that's irrelevant (think of it
as "page copy happened earlier")

 (c) before we install the copied page, we check that nothing changed
our initial assumption in (a).

And the problem is that userfaultfd basically can cause that (c) phase to fail.

                Linus
