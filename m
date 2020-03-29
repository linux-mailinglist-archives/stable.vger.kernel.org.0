Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD038196FCC
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 22:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgC2UCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 16:02:54 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43491 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbgC2UCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 16:02:54 -0400
Received: by mail-lf1-f67.google.com with SMTP id n20so12277033lfl.10
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 13:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R8GqRsFC9lpRrZ8Tz6twpMUaToXmYAA6X+bUddnOEzY=;
        b=hKe99HIqcKU3EAdOZ9PqMnLpq1wEx2kSODy6hLqaPdZjaacagUOtwbwzHBYmkQ6x2a
         6gh+VxwuMnWpfNWKNl3GjrhVgdILXVO7sikV+Nu5VBYUSqALgBOw/iDnBVH6S0BfGt6Q
         eI9crudv+YoXYMKGVCKFw9d5qolEh+zzqvWqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R8GqRsFC9lpRrZ8Tz6twpMUaToXmYAA6X+bUddnOEzY=;
        b=qrIDNmSTiKRgtlvFh22XpsbWgrLJjnz8DZ1R8xoS19jVLj7Lmgy1RZ/xzLf+0WS0lf
         wEdXzTXQF0O1ADzkwHdr79CQD9w69PZS5ixhLrGZGzQxNh614yKnahQyJvymGsj+d0zR
         x8AU82YOb7G7DmJzpOKUXPPGne8+XYmu/X8bVUH5D6maqEM5IFSQe7WIwpS4tXGmwPmL
         ciQBUYjtSeR3HnwH/+eti6Jj0D3p3Xgr4f9fspCI178xhKevLF0DdhV43bnxdotxsxR8
         w6Kdfblt7G4SjKIFw/Bl0WGwTMDhtN1qWE4gS2BS2/XzCaRwbTdj983y8vrBwIBiUZ/u
         O5Lw==
X-Gm-Message-State: AGi0PubCmg8ke/jTGsPMnphG2l5IE6qR1e7AI+Y7kMn6VhRam4SrXayC
        S8ryEbaQShvRD26nDDv4juuZWaXchRo=
X-Google-Smtp-Source: APiQypJKgkca0CXfBVWdOGXiacEhyubyitPsvJxoQGFmSZB8Kjbtpdm1/hEZL7ky15rvwHVufPp6uA==
X-Received: by 2002:a19:c78a:: with SMTP id x132mr5954380lff.83.1585512171691;
        Sun, 29 Mar 2020 13:02:51 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id 28sm6719368lfp.8.2020.03.29.13.02.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 13:02:51 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id r24so15807803ljd.4
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 13:02:51 -0700 (PDT)
X-Received: by 2002:a19:c3cf:: with SMTP id t198mr6106176lff.30.1585511784958;
 Sun, 29 Mar 2020 12:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
 <20200329021719.MBKzW0xSl%akpm@linux-foundation.org> <CAHk-=wgs1mfvk8pwefSD2A4=RgH6td50x9D-yn3Axm7icp5Xag@mail.gmail.com>
 <b80d7cea-a8f7-11c9-66fa-bdc272bdf099@redhat.com> <20200329194354.xrbzlvlbjimy3pzz@chatter.i7.local>
 <CAHk-=wheAem=MzY=F0ox7tuxFR47SgUj7zB+2S_KOhEB49zsPA@mail.gmail.com>
In-Reply-To: <CAHk-=wheAem=MzY=F0ox7tuxFR47SgUj7zB+2S_KOhEB49zsPA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 12:56:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=whnabUvMx5XUkSqGB7JCqD4A35jcjczuT5sV3=d=xYAsg@mail.gmail.com>
Message-ID: <CAHk-=whnabUvMx5XUkSqGB7JCqD4A35jcjczuT5sV3=d=xYAsg@mail.gmail.com>
Subject: Re: [patch 2/5] drivers/base/memory.c: indicate all memory blocks as removable
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Karel Zak <kzak@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        ndfont@gmail.com, pbadari@us.ibm.com,
        Rafael Wysocki <rafael@kernel.org>, rcj@linux.vnet.ibm.com,
        stable <stable@vger.kernel.org>, steve.scargall@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 12:55 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Which is why I was suspecting people cut-and-pasting the raw emails
> for examplanations or something similar.

"examplantions"? Really?

I had some kind of mini-stroke. Example/explanations ;)

             Linus
