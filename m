Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4448B9CF
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 22:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245426AbiAKVnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 16:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiAKVnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 16:43:23 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE568C06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 13:43:22 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id u21so1738607edd.5
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 13:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xsqhUFSsA1y57pFVxbW2TpGS3GqpQFY9bMvhPWyEkY0=;
        b=ANt4NWqhMTNSYmLTnu/YS5GiESGRsRRTJhSClnpJrH92h3FutHSoJ9XGeQr/F6QYQv
         iOmGgjte+EUw3MqFNz1A/cnjqXkcAIMEsGqBGRI7EIAyWWLmNDM5jPG0dgbSq3P0HATC
         m/sE09dWDeRfOqqMMYaG/DVFkKsb9e+VmtRLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xsqhUFSsA1y57pFVxbW2TpGS3GqpQFY9bMvhPWyEkY0=;
        b=JWLJtdyrtUkhNLmmsWphh6vJ0g6XB5Pcb7CUI9h8wJRrE2Dv6T6W+wYIAmrZOZCYRx
         7ZAV/c+yEMuWc9Mx0JeXHn3DuGt34EHx53Iz0MwR3pSXPjidPQLX7TWkNu8rXPv3U1yQ
         jRpRKdFNHe/3YqB2TDdumRfxUUXnQpJqrZrZMHL3AwR+cgJSj5pOc9Yt7BzS4WceL9Le
         MzLvW6bq8u90XMWlBsaeRcpDUOPrK/Yr1GIdpyFdmjKDmVWcZ70bf27TRbUgTQRyTSCJ
         jb/y71wyRRIYiUmhjVmIePWPw6Fs5QEO52nYhKvQF0Ym5IfQxk5IhSpbNPgPjhprTALu
         tIGw==
X-Gm-Message-State: AOAM530f8UiXVM0kckExFlschQ15ZGSoI022H5fb9+CCW3MZEfdfGwm2
        XjAAxFa2HBvBFvsu7w0woBFIyoImuiRqqqO1bPA=
X-Google-Smtp-Source: ABdhPJzXX4JLJ6lNgoLPwA2lcLYyeXsDnsWax5h7WjGBbUxkwMOpmOLa4qW0NtMGF//e3eBzq0+0gg==
X-Received: by 2002:a17:906:2f0c:: with SMTP id v12mr5249156eji.761.1641937401339;
        Tue, 11 Jan 2022 13:43:21 -0800 (PST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id g2sm3952327ejt.43.2022.01.11.13.43.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 13:43:21 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id o3so643664wrh.10
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 13:43:20 -0800 (PST)
X-Received: by 2002:adf:f54e:: with SMTP id j14mr5320871wrp.442.1641937400749;
 Tue, 11 Jan 2022 13:43:20 -0800 (PST)
MIME-Version: 1.0
References: <20220110181923.5340-1-jack@suse.cz> <CAHk-=wj39rpqNZX99dJUpErT+yX9aZN-Z1Lyfx8tbUqFUFeEqw@mail.gmail.com>
 <20220111212710.5atbl7zmg7w72a3h@quack3.lan>
In-Reply-To: <20220111212710.5atbl7zmg7w72a3h@quack3.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Jan 2022 13:43:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiZwLHzDnsg60Waev=qJKxoBgDRJoeimspvofMRL1sC7A@mail.gmail.com>
Message-ID: <CAHk-=wiZwLHzDnsg60Waev=qJKxoBgDRJoeimspvofMRL1sC7A@mail.gmail.com>
Subject: Re: [PATCH v2] select: Fix indefinitely sleeping task in poll_schedule_timeout()
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 1:27 PM Jan Kara <jack@suse.cz> wrote:
>
> That's not quite true. max_select_fd() called from do_select() will bail
> with -EBADF if any set contains a bit that is not in
> current->files->open_fds.

Yeah, that probably does take care of any normal case, since you need
the race with close() to actually cause issues.

Good point.

           Linus
