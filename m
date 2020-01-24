Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E3148C7D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 17:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389304AbgAXQtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 11:49:04 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41365 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389151AbgAXQtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 11:49:04 -0500
Received: by mail-ed1-f68.google.com with SMTP id c26so3006444eds.8
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 08:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lyle-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j/pCUkUXqt7IJRuIMfwIokzok7Si+AnLB+RYtRYMUPw=;
        b=q+M5/Wbr2gTYL/RwnfBG6o+uBV20hu+ShB/5u1W0Uz93y0SkZrYr+o5m47rKfRCdVq
         GzLicSRnHOP55u4tefuMTSMrfPzyqecPE/hIE0RQiriXzdXtPALIjhUSUc+pPWRGkTTT
         JklX1WTyghosTYHOSYAAopSxiPc4IGe0S6I8O/5NNIY77Bdm5ogjsj54hYc6xJ5jMnq6
         ohz/vIACAmgc9Bm1NNm/5NoqwLuXB/sZPfQA2lxvlHyfP3/+Mow5iiinfG/Upjo1BvDY
         w2YMIM1ZRYorx9pUEMX179VAm74fOozvEHSLbhmX7N5h2pDjp0NcGxG8cka/hDhPPahc
         NXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j/pCUkUXqt7IJRuIMfwIokzok7Si+AnLB+RYtRYMUPw=;
        b=Lj9qOGyRfYic63eQbaLpiC3cn19VQe8YJK76HR7Cla63ULw18DclIfZkiTYEBvbtoj
         fZ+deHAWG+yMwMeonSfBw9vX8t1hK+wIFty29jfNMcMh/xN9mz5607Y/98BuI853BGlp
         zjcJrjQ9O1d2O+EgxLDkawTkasn9PJsfgQZ/wHT47mEw9tcrCp/ZeJIRXtHQI8NdTfVG
         5PENS4W3t8+DGuiPz6FZ6yO5wy+fUhyQCUhhrLmotqKzmlzIuMzzUqxdIz4QCtErBvtw
         FotIeIi4l8pcPz4XMTvEX8G9i0mAbixXktdiBTuumiy8Msj0NqZQp7f2wDaoCCXixVh7
         AYyA==
X-Gm-Message-State: APjAAAWDSTLu/kxH3cTzblmnOBhWZ9nAxBWEr0kFwQq6+XA4QtcQoJ66
        ai0x8c9FGzS0kLr1aiPvy4cmQUlJ1F8IIy5Gaup28Q==
X-Google-Smtp-Source: APXvYqxHM6dnZ9+d3MhfdaXHEVzrjYeeX80fsXkv9h/1xIE8MmMgPBF2bcFvbExVRjnFjC4j64qY7rYyQQTD1ly0GSo=
X-Received: by 2002:a17:906:1cd0:: with SMTP id i16mr2036189ejh.186.1579884542578;
 Fri, 24 Jan 2020 08:49:02 -0800 (PST)
MIME-Version: 1.0
References: <20200123170142.98974-1-colyli@suse.de> <20200123170142.98974-15-colyli@suse.de>
 <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com> <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
In-Reply-To: <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
From:   Michael Lyle <mlyle@lyle.org>
Date:   Fri, 24 Jan 2020 08:48:23 -0800
Message-ID: <CAJ+L6qdThUX-Lk5T7-_xw-8KTtR73-Cbxj+oSr0n_tmth5EM+A@mail.gmail.com>
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
To:     Coly Li <colyli@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        linux-block@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Coly---

Thank you for holding the patch.  I'm sorry for the late review (I was
travelling).

(We sure have a lot of settings and a lot of code dealing with them
all, which is unfortunate... but workloads / hardware used with bcache
are so varied).

Mike

On Thu, Jan 23, 2020 at 9:28 AM Coly Li <colyli@suse.de> wrote:
>
> On 2020/1/24 1:19 =E4=B8=8A=E5=8D=88, Michael Lyle wrote:
> > Hi Coly and Jens--
> >
> > One concern I have with this is that it's going to wear out
> > limited-lifetime SSDs a -lot- faster.  Was any thought given to making
> > this a tunable instead of just changing the behavior?  Even if we have
> > an anecdote or two that it seems to have increased performance for
> > some workloads, I don't expect it will have increased performance in
> > general and it may even be costly for some workloads (it all comes
> > down to what is more useful in the cache-- somewhat-recently readahead
> > data, or the data that it is displacing).
>
> Hi Mike,
>
> Copied. This is good suggestion, I will do it after I back from Lunar
> New Year vacation, and submit it with other tested patches in following
> v5.6-rc versions.
>
> Thanks.
>
> Coly Li
>
> [snipped]
>
> --
>
> Coly Li
