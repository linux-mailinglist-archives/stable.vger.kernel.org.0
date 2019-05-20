Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC53F23D2A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfETQYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 12:24:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39050 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388110AbfETQYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 12:24:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id y42so16997048qtk.6;
        Mon, 20 May 2019 09:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=obgbXUzx159p0zANaGXFw4iYxkmhzkfPzdDi+/mATw8=;
        b=gK+bmVnNn35WVy6sMvDlFpTZPT4ZtL3Kr9fkxPXfqz5mwIxvAu/xa6TrnUvux32sTj
         shBmfx81gBWEEbr5sCJ1SGN1329FKEliHW8a9enVAVgQNtknPUVdZ+9si/oWqE4zQKXN
         9x66dJ/PK0mBb14dlzPWZCNO1GzZJ6hCmzfiTJ/XanJ2RMIcaK2G3hrQpMPANMHIK2Mr
         bfgI4kB+D6NZWiHvIsIt8AbUAN28RksCuXXc94Tk2BwHhxg39zfBSZb18MFHGzW/2JIY
         hYKVy/f/LfLz+5WJTVC/LyXPPXNZC0CpFa6yI/qQ+73nJa8lWMOrNvvcbRPFHhAIZDsH
         FU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=obgbXUzx159p0zANaGXFw4iYxkmhzkfPzdDi+/mATw8=;
        b=r2S90ZAkmwfaICGeXpvN805N0BVQVgT0zn+m2VvNk2HsEYdfl1xr8eqLe3SGuSo/Fy
         lCbc2GxZUCF3pc30FwpNuGU/jZyN/EgtJtyg4aUrySpR+V/BTYSEfxksBo/K//SvfDyb
         2B/r+2xXAn8E4kZukFNvBm144hqFSbcY3vxHh+a98+6SHlbr+9cSHsR6JMTAi3Re9Ub/
         aZ4R/nFSC5jqGQO39x6aNjei611ZsMdM4hm5h0/4q0DrHfS5wHzJR4CcxEo/cX2SUowA
         aKsVGg2G2TsyvIUcJFTRxGkwtINn3Lj0VDT5WKiGJ0lDZy3WWdtoduBQfS8l69ITxeG0
         ZcQw==
X-Gm-Message-State: APjAAAUzx7ElxjDoYZYSkgNfzuigTpetYM+PatW4lGNVBUBAJydlTcWm
        DAH9CCNsG9pbmkhghVFHyg6MCy4no33ZQx3Yor02EA==
X-Google-Smtp-Source: APXvYqw0oneV9XVd0KN/ZeYH934enYZ4zh5DGGCv0lqiArz37KKJgvFEx7PjOKMjepBijHamtLkNo16lp9OK/nxTtWQ=
X-Received: by 2002:a0c:d4ee:: with SMTP id y43mr61214357qvh.26.1558369442514;
 Mon, 20 May 2019 09:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com> <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com> <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
 <5CD2A172.4010302@youngman.org.uk> <0ad36b2f-ec36-6930-b587-da0526613567@gpiccoli.net>
 <5CD3096B.4030302@youngman.org.uk> <CALJn8nOTCcOtFJ1SzZAuJxNuxzf2Tq7Yw34h1E5XE-mbn5CUbg@mail.gmail.com>
In-Reply-To: <CALJn8nOTCcOtFJ1SzZAuJxNuxzf2Tq7Yw34h1E5XE-mbn5CUbg@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 20 May 2019 09:23:50 -0700
Message-ID: <CAPhsuW7AwsWiHiqaW55paqtiCLvt3U9C+sQ50fbBr1v=czATyg@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Cc:     Wols Lists <antlists@youngman.org.uk>, axboe@kernel.dk,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 9:19 AM Guilherme G. Piccoli
<kernel@gpiccoli.net> wrote:
>
> Jens / Song, any news in this one?
>
> I think would be good to have this raid0 fix rather sooner than later
> if possible - it's easy
> to reproduce the crash.
>
> Thanks,
>
>
> Guilherme

I will process it. It was delayed due to the merge window.

Thanks,
Song
