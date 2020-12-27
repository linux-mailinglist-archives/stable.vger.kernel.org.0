Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213832E3330
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 00:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgL0XQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 18:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgL0XQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 18:16:22 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB34CC061795
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 15:15:08 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m25so20317495lfc.11
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 15:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrNOaQo0oSTN20/mx1QqDm0D9Hn4DJtx5m8uXXKpN2M=;
        b=XshKrP2k0PDVU2K6lhXixd1gTp8qTDNhDlzphLGpgfbe84tNYj8XD7eF8JA2/BhefG
         oZ8CeBrJBey0Pe9KTSPuFpO/Kxn8QJTrkjk0Lk3N3/Aminrcw8fb7ZPcYBhYOh8xpxyM
         bKSOKbZhJErLVNxbS7swBwPc48F3MTRdNyekI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrNOaQo0oSTN20/mx1QqDm0D9Hn4DJtx5m8uXXKpN2M=;
        b=cmda2t5mJhzpd7TE89tMpI+LnKz1mrVYB3DpDJh4Ct8kLgpIb1B9KROl5VopB6zilL
         P80dC/yMjTAwbklBIHrai2FkZrmqWQVVARhvK75U10NRIJ/w5yfblXqPzlPIi+DBpdDM
         on68eDuHwQmfwEiJ/QLlNARniwSiijExWhegGXlEjJCbaZoWeUvZ/SuMMxSbuOJR26iE
         9n9Kb2pr3yRlHX3k6FWTPrzvisxMACXkPcn0A08/xUdoHogOJRJH5QC8DXYtauBqtj5l
         +7QwVnAICA9Y2YZKHJaO4e4f/xDmPNX/s02yqWXe7xjAWIZzSxG5nflMx2Od4v0hnST+
         PQhw==
X-Gm-Message-State: AOAM530TjGLkiDDkT5VSU1akDNqs6cln8GRpIPJBewRTYgmOt5zUACu5
        8jZAIo38Mx+AqVHCLwXGgOk9oP2B3fvSKA==
X-Google-Smtp-Source: ABdhPJw6V0oD5cjLyfqBA9E06X1zzkwx2poGqFVuBtP3u45F9nOVzwBL1B0VXCncYi4N90kTLlWv/A==
X-Received: by 2002:a2e:a553:: with SMTP id e19mr21897308ljn.454.1609110906931;
        Sun, 27 Dec 2020 15:15:06 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id r9sm6182373ljj.127.2020.12.27.15.15.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Dec 2020 15:15:05 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id m12so20373176lfo.7
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 15:15:05 -0800 (PST)
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr19658039lji.48.1609110905217;
 Sun, 27 Dec 2020 15:15:05 -0800 (PST)
MIME-Version: 1.0
References: <16089960203931@kroah.com> <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
 <CAHk-=wgtU5+7jPuPtDEpwhTuUUkA3CBN=V92Jg0Ag0=3LhfKqA@mail.gmail.com>
 <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi> <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
 <CAHk-=whF=+EzrxP=3zNMH-1L2Nfs7fNoSufqDwOdRQo5qyMwfw@mail.gmail.com> <20201227212531.GD3579531@ZenIV.linux.org.uk>
In-Reply-To: <20201227212531.GD3579531@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 27 Dec 2020 15:14:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiXQVE_jGN0ajk+Km925WSbCL16mAZ-UXNkp+nkc1nuQw@mail.gmail.com>
Message-ID: <CAHk-=wiXQVE_jGN0ajk+Km925WSbCL16mAZ-UXNkp+nkc1nuQw@mail.gmail.com>
Subject: Re: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux 5.10.3)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 1:25 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>
> Is there any point in not doing the same (scripted, obviously) for
> all instances with .read == seq_read?  IIRC, Christoph even posted
> something along those lines, but it went nowhere for some reason...

I'd rather limit splice (and kernel_read too, for that matter) as much
as possible. It was a mistake originally to allow it everywhere, and
it's come back to bite us.

So I'd rather have people notice these odd corner cases and get them
fixed one by one than just say "anything goes".

There's hopefully not any actually left anyway...

                  Linus
