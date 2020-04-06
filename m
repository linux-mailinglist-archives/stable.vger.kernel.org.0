Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2991A19FBC1
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 19:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDFRhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 13:37:33 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35880 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgDFRhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 13:37:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id n10so7905790pff.3
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 10:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5A3bNXVMj4bj2AIVGBTY6hkB7xXy6vHb/Ne3iBpS14=;
        b=rrSX7xYpeX+bHyGEQlSON19LD7lreb2fX/+BUAFWLrraEB3870brsaTUDGlKvZ+WbA
         okiizodDDWDe0I1c9wp6P10/IURo0Dp42oTRqPfBfBT94AEaR25gHV8M0uJnWIrqcRQT
         B9GgFKFirF9rNvOkKE+h/Prt3xi46RJqG2628YvTRgo0/8vnkljYYSNqr8VnO+048T1h
         FEGiFql2L6BeKuNpUqHG98M4XI20COeI1Fe/UxEZQHWfqnWlCHxbkiymcaBKYWlsKHxE
         YckP1GGir+P/4rGXfP1CJhFfeM5Hd7kKqnt76x5oeM5QMo8gl2alKtwZL8R0u85gk1PX
         kVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5A3bNXVMj4bj2AIVGBTY6hkB7xXy6vHb/Ne3iBpS14=;
        b=epO8Kalw+JEhw8WKklDRsE7bjtorAtyvM3KGWKBQnXqhdDjFPfNalu8soD+ypSN6gQ
         ni+XzKeo5JiiUkqTenO+6T9wRVZbA52YH7+S834T+w/f1Nr0o9iZTnmzkTNsTjBeFUK2
         tH4MbdC7F8XBF74sHnWyOoPlKUSWKIhTK+4cT5glk0mo0ECkoiDlITt/LyscDlwQf7NW
         CxldKJ/fiP/+w3R5VXhRzk+IZ5sRlw/pg2iRe1H54jR7BTWrCi3xnAreiK/wIiv7Ma44
         ix2sXHXwOgPp+1Qk/8umGkF0Zwz9WwVkdGALZtGnnV84/enVvjJ57k0+CAhrVznYQYHP
         vuDw==
X-Gm-Message-State: AGi0PuZb1FouYKjAAitGB2K9Zw15/XQo7VG0ZyeVrqEVW47whA96Wj8c
        jSFXffs5DmxSHNIPm0QBJrpLzCmdwjhGfX6mGRyL5A==
X-Google-Smtp-Source: APiQypK4THjk0/924HXK0lneuIRW2pDdfofHcU3350bUKo3i7NqT/XE/GcgZTk9z/a3bHv/m+/bcja20DZZgBPATRpg=
X-Received: by 2002:aa7:919a:: with SMTP id x26mr544210pfa.39.1586194650619;
 Mon, 06 Apr 2020 10:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <202004050547.XbHnZtwa%lkp@intel.com> <20200404213110.GA34553@ubuntu-m2-xlarge-x86>
In-Reply-To: <20200404213110.GA34553@ubuntu-m2-xlarge-x86>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 6 Apr 2020 10:37:20 -0700
Message-ID: <CAKwvOdnPOVfi35Vrxr1+FsPN+V2X5UiwxTdOu+pdwsBAGXxb5g@mail.gmail.com>
Subject: Re: [linux-stable-rc:linux-4.4.y 9959/9999] drivers/usb/gadget/function/f_uac2.c:601:40:
 warning: variable 'devqual_desc' is not needed and will not be emitted
To:     Nathan Chancellor <natechancellor@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Cc:     kbuild test robot <lkp@intel.com>,
        Dirk Mueller <dmueller@suse.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>, k.opasiak@samsung.com,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        kopasiak90@gmail.com, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 4, 2020 at 2:31 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Sun, Apr 05, 2020 at 05:23:53AM +0800, kbuild test robot wrote:
> > Hi Dirk,
> >
> > First bad commit (maybe != root cause):
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > head:   1d2188f191be66572f9e20c9486eda0544ab750f
> > commit: ce513359d8507123e63f34b56e67ad558074be22 [9959/9999] scripts/dtc: Remove redundant YYLOC global declaration
> > config: x86_64-allmodconfig (attached as .config)
> > compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 62f3a9650a9f289a07a5f480764fb655178c2334)
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         git checkout ce513359d8507123e63f34b56e67ad558074be22
> >         # save the attached .config to linux build tree
> >         COMPILER=clang make.cross ARCH=x86_64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/usb/gadget/function/f_uac2.c:601:40: warning: variable 'devqual_desc' is not needed and will not be emitted [-Wunneeded-internal-declaration]
> >    static struct usb_qualifier_descriptor devqual_desc = {
> >                                           ^
> >    1 warning generated.
> > --
> > >> drivers/usb/gadget/function/f_printer.c:164:40: warning: variable 'dev_qualifier' is not needed and will not be emitted [-Wunneeded-internal-declaration]
> >    static struct usb_qualifier_descriptor dev_qualifier = {
> >                                           ^
> >    1 warning generated.
> >
>
> Not caused by that patch.
>
> Fixed in mainline:

Hmm...no fixes tag, probably should still be backported to stable.

>
> https://git.kernel.org/linus/d4529f9be1d72919f75f76f31773c4e98d03ce6b
> https://git.kernel.org/linus/e5a89162161d498170e7e39e6cfd2f71458c2b00
-- 
Thanks,
~Nick Desaulniers
