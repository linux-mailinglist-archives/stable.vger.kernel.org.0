Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57211A1E42
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 11:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgDHJsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 05:48:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37962 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgDHJsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 05:48:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id v16so6942534ljg.5
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 02:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eEezST1RXJ88ybnVOwFKxlJ6+MPqHS1LvuVkjRbNDs4=;
        b=AtfViQT1klZEFep9wTrnlBNvl75uK2hyUO/WqUNRXSA41ipnxHC6/JdTZ3LZ2pYsiD
         aVWUeYmPUfXymIYFRcLAfKqAtXhxI+0x8F71hJj3VwT8OA2db3sAhZcSKfJdwPs33Jdm
         ebi6utBvs/stkR0zNal8RJLdCUJdcqw56v97JaMJ4h1bgaiSQAzOSbUGbLJ+c5tQnb2f
         gp6kz/XUdx2fc8Nq4gRN9GAzGAtdlLOEChwhCUBlQ5q6OMPNHqw2tKWqI2YcCq8exhku
         4UumWQGM+wUD+m2N6hhQYDG5WC9E5o0NH2k0LGeMMn6+O0BGBEeEQugb4L+3crwWu09L
         a/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEezST1RXJ88ybnVOwFKxlJ6+MPqHS1LvuVkjRbNDs4=;
        b=mL6Gy8SXUg7bbuLCzcgFD+x3uYUxnDIdQ4Nx3n0AnBNUzXiHycAfo+QUZ0RRT4ey2y
         o7fFZztV5BvKrYES/YfdLU+inDYGNWHMsDuwiNp1kbghk8aoGtoe5vPNnAEfifq6QuhN
         79NRr10iMS8Tch3Rg1R6EMcAJky6xprpQE4xvHiEkIpOyWJgw4vjSfLddj1OvdJrYHSJ
         EZ7Nk7lWLviANGTX2AGQmot3nt1xA0zlOzojoXfNFCukz7nULOlarkqClQLOqCa3l6zf
         x8oAJ8JLgKVVAseX+KLCFSYV/EbyUADM59ggGYshx4dM6B1fN/olqb1V97JFQ9x4BIC/
         fgrg==
X-Gm-Message-State: AGi0Pub5tkkP4aI6LM4NrpaXoZ2YxhL/+8V6iLK8jB4RGlMeyNbLCXXi
        rs/Rrg3jBUwJywJzVL6P52WJtJ8AWT1FwvFoe1GPVgNB
X-Google-Smtp-Source: APiQypKzRT3tjcthaIy1IYrParD4m/MJGtYTGgck/20gGjrf0nKgcCSDB9gBB+Pbu1aw6GTj8C+5BqYtxFna/wpkfJg=
X-Received: by 2002:a2e:5048:: with SMTP id v8mr4074814ljd.99.1586339328475;
 Wed, 08 Apr 2020 02:48:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200318205337.16279-1-sashal@kernel.org> <20200318205337.16279-30-sashal@kernel.org>
 <CAG48ez1pzF76DpPWoAwDkXLJ01w8Swe=obBrNoBWr=iGTbH7-g@mail.gmail.com>
In-Reply-To: <CAG48ez1pzF76DpPWoAwDkXLJ01w8Swe=obBrNoBWr=iGTbH7-g@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 8 Apr 2020 11:48:22 +0200
Message-ID: <CAG48ez29d-JJOw8XMp1Z=7sDj8Kvmt+9KXC9-ux-0OBhUP02Xg@mail.gmail.com>
Subject: backport request for 3.16 [was: Re: [PATCH AUTOSEL 5.4 30/73] futex:
 Fix inode life-time issue]
To:     stable <stable@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

@Ben: You'll probably also want to take these two into the next 3.16 release.

Sorry, I forgot that 3.16 has a different maintainer...

On Mon, Mar 23, 2020 at 8:18 PM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Mar 18, 2020 at 9:54 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Peter Zijlstra <peterz@infradead.org>
> >
> > [ Upstream commit 8019ad13ef7f64be44d4f892af9c840179009254 ]
> >
> > As reported by Jann, ihold() does not in fact guarantee inode
> > persistence. And instead of making it so, replace the usage of inode
> > pointers with a per boot, machine wide, unique inode identifier.
> >
> > This sequence number is global, but shared (file backed) futexes are
> > rare enough that this should not become a performance issue.
>
> Please also take this patch, together with
> 8d67743653dce5a0e7aa500fcccb237cde7ad88e "futex: Unbreak futex
> hashing", into the older stable branches. This has to go all the way
> back; as far as I can tell, the bug already existed at the beginning
> of git history.
