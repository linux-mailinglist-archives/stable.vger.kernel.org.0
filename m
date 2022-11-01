Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F0614EE2
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 17:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKAQM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 12:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiKAQM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 12:12:27 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80531C428
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 09:12:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id t25so38273847ejb.8
        for <stable@vger.kernel.org>; Tue, 01 Nov 2022 09:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ab9TumGnVcQYDbKNM45MvF3h/etVGLXj7Sk0rQBsw6s=;
        b=ULcFfhMCUyMy4Bls0YByc376JJlGzb4PF2gmzFQiuA1hAE3rTe5bFdq/1tdW/zn7yZ
         lL+UDCU13ErCSuEyyTHtbYh+5n5sJivkt9jRSXZSXDZN8e1ldNEGKw4aDG5ZVAzTiPoU
         0LkJAJlAdkCz/LtDgoRW4GpTFLkxyBSLhBEQRedBxJesVp18WSsPvnH4eRGilQn8faMZ
         Fn42KEtzuKgubU7Byh9a1xUKJ6QnLVPW2ZP1hBVkmLw6HvsdE+0GF+jIwAVm6U+SkB/6
         No4matFol/mrexh+rZ8YWEfxtZz9g5QfrJewcBlv8yx4F4t8b4dOGvpjOPV45cG8kL17
         3XKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ab9TumGnVcQYDbKNM45MvF3h/etVGLXj7Sk0rQBsw6s=;
        b=d1NhDPf9PWLbJk+B+YTZDstIIqENevkSS7OKsJT1qMp28xAA07N55M90UEfDAgk5p1
         G76wDxsqCTONSCY7qkXf5TfRp5ln7Izvzu0g5UxU0A/8V5PnsjBQMZIDf9GpwB+/dY0A
         2jd9dI6csHhZRzsN6ENjXme+Q2I1nhuSMwxunBZKzeOG//GEAZcgmd5hjT1ZPnr25Zr6
         aS6ljCkLZpbwVnANjiELV3fadLv1KhlvsU7GccBkd3s+ChTSBjvAdn2NGyfDppJWtPSk
         52l7RDSNpeql9vftcSH6oWPXZynDxT0Q164DZPyxHrpQaCSFsj2SLwCvGza9+vOBsMR4
         SumQ==
X-Gm-Message-State: ACrzQf1d89O/dTSH6StHEDx1QQ7fBXhpzAtPLjt5pMz9cNJak1he7ZGG
        oZE2hIzlrfov9T4mR/dhSOPEf+H7WR+qKxVoaCmEag==
X-Google-Smtp-Source: AMsMyM7S4RF2BkvtcpNXDlgORfJXftSzemj3U2XM1jc/wCeA6rhQGSQ9o9FEfAxWrYRj5xDc+JkWTZySunWPW24D2Ek=
X-Received: by 2002:a17:907:6e1b:b0:78e:15a3:5be6 with SMTP id
 sd27-20020a1709076e1b00b0078e15a35be6mr19096151ejc.750.1667319143878; Tue, 01
 Nov 2022 09:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113005.376059449@linuxfoundation.org> <20221029011211.4049810-1-ovt@google.com>
 <Y2ATiXtpwPxfsOUD@dev-arch.thelio-3990X> <Y2ClHT6FNL+DLfqP@kroah.com> <Y2C70Gc5vcrRIsRr@kroah.com>
In-Reply-To: <Y2C70Gc5vcrRIsRr@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Nov 2022 21:42:12 +0530
Message-ID: <CA+G9fYsyNp2vNupc55CqoTiKLAEmLHYdFoPNqChbe05RvX9U0A@mail.gmail.com>
Subject: Re: [PATCH 5.4 086/255] once: add DO_ONCE_SLOW() for sleepable contexts
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Oleksandr Tymoshenko <ovt@google.com>,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org, w@1wt.eu,
        llvm@lists.linux.dev
Content-Type: multipart/mixed; boundary="0000000000004c953205ec6afd13"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000004c953205ec6afd13
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

On Tue, 1 Nov 2022 at 11:55, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 01, 2022 at 05:48:29AM +0100, Greg KH wrote:
> > On Mon, Oct 31, 2022 at 11:27:21AM -0700, Nathan Chancellor wrote:
> > > Hi Oleksandr,
> > >
> > > On Sat, Oct 29, 2022 at 01:12:11AM +0000, Oleksandr Tymoshenko wrote:
> > > > Hello,
> > > >
> > > > This commit causes the following panic in kernel built with clang
> > > > (GCC build is not affected):
> > > >
> > > > [    8.320308] BUG: unable to handle page fault for address: ffffffff97216c6a                                        [26/4066]
> > > > [    8.330029] #PF: supervisor write access in kernel mode
> > > > [    8.337263] #PF: error_code(0x0003) - permissions violation
> > > > [    8.344816] PGD 12e816067 P4D 12e816067 PUD 12e817063 PMD 800000012e2001e1
> > > > [    8.354337] Oops: 0003 [#1] SMP PTI
> > > > [    8.359178] CPU: 2 PID: 437 Comm: curl Not tainted 5.4.220 #15
> > > > [    8.367241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> > > > [    8.378529] RIP: 0010:__do_once_slow_done+0xf/0xa0
> > > > [    8.384962] Code: 1b 84 db 74 0c 48 c7 c7 80 ce 8d 97 e8 fa e9 4a 00 84 db 0f 94 c0 5b 5d c3 66 90 55 48 89 e5 41 57 41 56
> > > > 53 49 89 d7 49 89 f6 <c6> 07 01 48 c7 c7 80 ce 8d 97 e8 d2 e9 4a 00 48 8b 3d 9b de c9 00
> > > > [    8.409066] RSP: 0018:ffffb764c02d3c90 EFLAGS: 00010246
> > > > [    8.415697] RAX: 4f51d3d06bc94000 RBX: d474b86ddf7162eb RCX: 000000007229b1d6
> > > > [    8.424805] RDX: 0000000000000000 RSI: ffffffff9791b4a0 RDI: ffffffff97216c6a
> > > > [    8.434108] RBP: ffffb764c02d3ca8 R08: 0e81c130f1159fc1 R09: 1d19d60ce0b52c77
> > > > [    8.443408] R10: 8ea59218e6892b1f R11: d5260237a3c1e35c R12: ffff9c3dadd42600
> > > > [    8.452468] R13: ffffffff97910f80 R14: ffffffff9791b4a0 R15: 0000000000000000
> > > > [    8.461416] FS:  00007eff855b40c0(0000) GS:ffff9c3db7a80000(0000) knlGS:0000000000000000
> > > > [    8.471632] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [    8.478763] CR2: ffffffff97216c6a CR3: 000000022ded0000 CR4: 00000000000006a0
> > > > [    8.487789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [    8.496684] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > [    8.505443] Call Trace:
> > > > [    8.508568]  __inet_hash_connect+0x523/0x530
> > > > [    8.513839]  ? inet_hash_connect+0x50/0x50
> > > > [    8.518818]  ? secure_ipv4_port_ephemeral+0x69/0xe0
> > > > [    8.525003]  tcp_v4_connect+0x2c5/0x410
> > > > [    8.529858]  __inet_stream_connect+0xd7/0x360
> > > > [    8.535329]  ? _raw_spin_unlock+0xe/0x10
> > > > ... skipped ...
> > > >
> > > >
> > > > The root cause is the difference in __section macro semantics between 5.4 and
> > > > later LTS releases. On 5.4 it stringifies the argument so the ___done
> > > > symbol is created in a bogus section ".data.once", with double quotes:
> > > >
> > > > % readelf -S vmlinux | grep data.once
> > > >   [ 5] ".data.once"      PROGBITS         ffffffff82216c6a  01416c6a
> > >
> > > Thanks for the report! The reason this does not happen in mainline is
> > > due to commit 33def8498fdd ("treewide: Convert macro and uses of
> > > __section(foo) to __section("foo")"), which came as a result of these
> > > issues:
> > >
> > > https://github.com/ClangBuiltLinux/linux/issues/619
> > > https://llvm.org/pr42950
> > >
> > > To keep stable from diverging, it would probably be best to pick
> > > 33def8498fdd and fight through whatever conflicts there are. If that is
> > > not a suitable solution, the next best thing would be to remove the
> > > quotes like was done in commit bfafddd8de42 ("include/linux/compiler.h:
> > > fix Oops for Clang-compiled kernels") for all instances of
> > > __section(...) or __attribute__((__section__(...))), which should
> > > resolve the specific problem you are seeing.
> >
> > I think we should do the latter, fighting with all of the different
> > section entries would be a pain.
> >
> > Unless someone beats me to it, I'll go make up a patch for this...
>
> Can someone test the following patch:

I have tested the following patch and confirmed that reported issues
have been fixed. The test performed on 5.4 with patch applied and
built with clang-nightly and ran the LTP CVE (cve-2018-9568 ) connect02
test case on qemu-x86-64.

>
> diff --git a/include/linux/once.h b/include/linux/once.h
> index bb58e1c3aa03..3a6671d961b9 100644
> --- a/include/linux/once.h
> +++ b/include/linux/once.h
> @@ -64,7 +64,7 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
>  #define DO_ONCE_SLOW(func, ...)                                                     \
>         ({                                                                   \
>                 bool ___ret = false;                                         \
> -               static bool __section(".data.once") ___done = false;         \
> +               static bool __section(.data.once) ___done = false;           \
>                 static DEFINE_STATIC_KEY_TRUE(___once_key);                  \
>                 if (static_branch_unlikely(&___once_key)) {                  \
>                         ___ret = __do_once_slow_start(&___done);             \
>

Step to confirm the reported issues has been fixed attached.

Regression log detailed link,
https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/daniel/tests/2GtjmfCgOwjkQo76N4YkscpHSqw

Fix kernel,
https://builds.tuxbuild.com/2Gx1SmgFoS1AwMMbNCnOmO540py/

- Naresh

--0000000000004c953205ec6afd13
Content-Type: application/x-shellscript; 
	name="tuxrun-ltp-cve-qemu-x86-bug-reproduce.sh"
Content-Disposition: attachment; 
	filename="tuxrun-ltp-cve-qemu-x86-bug-reproduce.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_l9yek9ke0>
X-Attachment-Id: f_l9yek9ke0

IyEvYmluL3NoCgojIFR1eFJ1biBpcyBhIGNvbW1hbmQgbGluZSB0b29sIGFuZCBQeXRob24gbGli
cmFyeSB0aGF0IHByb3ZpZGVzIGEgd2F5IHRvCiMgYm9vdCBhbmQgdGVzdCBsaW51eCBrZXJuZWxz
LgojCiMgVHV4UnVuIHN1cHBvcnRzIHRoZSBjb25jZXB0IG9mIHJ1bnRpbWVzLiBGb3IgdGhhdCB0
byB3b3JrIGl0IHJlcXVpcmVzIHRoYXQKIyB5b3UgaW5zdGFsbCBwb2RtYW4gb3IgZG9ja2VyIG9u
IHlvdXIgc3lzdGVtLgojCiMgVG8gaW5zdGFsbCB0dXhydW4gb24geW91ciBzeXN0ZW0gZ2xvYmFs
bHk6CiMgc3VkbyBwaXAzIGluc3RhbGwgLVUgdHV4cnVuPT0wLjMwLjAKIwojIFNlZSBodHRwczov
L3R1eHJ1bi5vcmcvIGZvciBjb21wbGV0ZSBkb2N1bWVudGF0aW9uLgoKdHV4cnVuIC0tcnVudGlt
ZSBwb2RtYW4gLS1kZXZpY2UgcWVtdS14ODZfNjQgLS1rZXJuZWwgaHR0cHM6Ly9idWlsZHMudHV4
YnVpbGQuY29tLzJHdGptNnBWemRxbkRLMm5LSEZ4bEpPdllJUy9iekltYWdlIC0tbW9kdWxlcyBo
dHRwczovL2J1aWxkcy50dXhidWlsZC5jb20vMkd0am02cFZ6ZHFuREsybktIRnhsSk92WUlTL21v
ZHVsZXMudGFyLnh6IC0tcm9vdGZzIGh0dHBzOi8vc3RvcmFnZS50dXhzdWl0ZS5jb20vcHVibGlj
L2xpbmFyby9kYW5pZWwvb2VidWlsZHMvMkczbzQzWFBuNXhqOFRERHkwcHg3YU0xWXZQL2ltYWdl
cy9pbnRlbC1jb3JlaTctNjQvbGtmdC10dXgtaW1hZ2UtaW50ZWwtY29yZWk3LTY0LTIwMjIxMDEz
MDIyMTU3LnJvb3Rmcy5leHQ0Lmd6IC0tcGFyYW1ldGVycyBTS0lQRklMRT1za2lwZmlsZS1sa2Z0
LnlhbWwgLS1pbWFnZSBkb2NrZXIuaW8vbGF2YXNvZnR3YXJlL2xhdmEtZGlzcGF0Y2hlcjoyMDIy
LjEwLjAwNDAuZ2MzOGQ0NDk3MSAtLXRlc3RzIGx0cC1jdmUgLS10aW1lb3V0cyBib290PTE1Cg==
--0000000000004c953205ec6afd13
Content-Type: application/x-shellscript; 
	name="tuxrun-ltp-cve-qemu-x86-bug-fix.sh"
Content-Disposition: attachment; 
	filename="tuxrun-ltp-cve-qemu-x86-bug-fix.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_l9yek9lk1>
X-Attachment-Id: f_l9yek9lk1

dHV4cnVuIC0tcnVudGltZSBwb2RtYW4gLS1kZXZpY2UgcWVtdS14ODZfNjQgLS1rZXJuZWwgaHR0
cHM6Ly9idWlsZHMudHV4YnVpbGQuY29tLzJHeDFTbWdGb1MxQXdNTWJOQ25PbU81NDBweS9ieklt
YWdlIC0tbW9kdWxlcyBodHRwczovL2J1aWxkcy50dXhidWlsZC5jb20vMkd4MVNtZ0ZvUzFBd01N
Yk5Dbk9tTzU0MHB5L21vZHVsZXMudGFyLnh6IC0tcm9vdGZzIGh0dHBzOi8vc3RvcmFnZS50dXhz
dWl0ZS5jb20vcHVibGljL2xpbmFyby9kYW5pZWwvb2VidWlsZHMvMkczbzQzWFBuNXhqOFRERHkw
cHg3YU0xWXZQL2ltYWdlcy9pbnRlbC1jb3JlaTctNjQvbGtmdC10dXgtaW1hZ2UtaW50ZWwtY29y
ZWk3LTY0LTIwMjIxMDEzMDIyMTU3LnJvb3Rmcy5leHQ0Lmd6IC0tcGFyYW1ldGVycyBTS0lQRklM
RT1za2lwZmlsZS1sa2Z0LnlhbWwgLS1pbWFnZSBkb2NrZXIuaW8vbGF2YXNvZnR3YXJlL2xhdmEt
ZGlzcGF0Y2hlcjoyMDIyLjEwLjAwNDAuZ2MzOGQ0NDk3MSAtLXRlc3RzIGx0cC1jdmUgLS10aW1l
b3V0cyBib290PTQ1Cg==
--0000000000004c953205ec6afd13--
