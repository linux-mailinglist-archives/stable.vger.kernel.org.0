Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051AA212F3C
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 00:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgGBWBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 18:01:48 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44131 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbgGBWBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 18:01:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E57215C0184;
        Thu,  2 Jul 2020 18:01:46 -0400 (EDT)
Received: from imap6 ([10.202.2.56])
  by compute1.internal (MEProxy); Thu, 02 Jul 2020 18:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kdrag0n.dev; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=++Nf+jzmk32Uv4KzN6LP0cOsHrUI9Ej
        gYva0jX6LIrU=; b=Pg4yk0YIJrwWMjzDqS+aUUqvdlNb82l4y6EkYHpGnzP70f7
        B1YY40jKsE2vbdvE0u+udHjX9YrAvotz+e5OdBfaJsnBOtxSz4u06wG++5PLV+Vk
        1HmRpvbrHXzaAKDsPStHWr42Y+8wrseqKfCCHrhLiae2YLg9K3dZcZBXeWkJ5Bk6
        mHrFGZhVgmu55nr8o1J5Isiw/wPi6NUodV2SJNJjWHIlPBy9UXmWDJDw/tXZ5ecG
        Xf5Cp1WCkhqZ97Hv6PdOli47zBcoBWFcxy0s5L0YAUXDvLZYNfnNAL2PvzIGNTkw
        3Yn+QjwqghBEkeIb4SVTqaI4fv7diXTn4LauhMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=++Nf+j
        zmk32Uv4KzN6LP0cOsHrUI9EjgYva0jX6LIrU=; b=PhkQcYY6l8VzCLSHHcxsfJ
        FswLbAHWfg7HrJmtCqZlsos0DeSMz6ig3H8wT2YEGMmzuFKYnHf41PJVYGpmEflZ
        SDjp7Hjh6ZW+eW7VLeOB13VO8pkMtqmDVTRHtThjuA9U+KULZJzRUpWa7bmVZoWz
        brdzPcM9y7j7nBWW/JdP6i200Ffowb8ZfRznAL7xCSIdxPCAlSYcmvI8iYhk5sMe
        82Sca2cF1KLVll9kwTGZJfEBhvA/q2XrCYcSLZwimGE+VScCLNDRb4oEQQm3RqOx
        Wckjaj+83NTBUUrHXvE1oCevJM83DZAobdwVvucj0FZf/1JwH2Z/cGN6Ub67k1ig
        ==
X-ME-Sender: <xms:Sln-Xjboo9M_5vghecSHvELG_X8Ep6NsZzlQqXichH2uu-epJdiGNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdehgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedfffgrnhhn
    hicunfhinhdfuceouggrnhhnhieskhgurhgrghdtnhdruggvvheqnecuggftrfgrthhtvg
    hrnhepvedvkeefhfejtdfgleegudeujeeuueehtddvudffkeegjeejfeffvdeuteektdeg
    necuffhomhgrihhnpehgohhoghhlvghsohhurhgtvgdrtghomhdpghhithhhuhgsrdgtoh
    hmpdhlphgsgidruggrthgrpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghnnhihsehkughrrghgtdhnrdguvg
    hv
X-ME-Proxy: <xmx:Sln-XiZ_KI0R7tLQBB603k6POGD4AnwbVGYLqTD9JeGfhWctw0SGfg>
    <xmx:Sln-Xl-f4p6_IADPDXa0-gVkWCwumJOJOq59_ZE0qAP4St7f4qZQOQ>
    <xmx:Sln-XpqhJNQceDvleWresQwqvXSTx4g9OypfHQ-16YAfN43WuXW0LQ>
    <xmx:Sln-XvfGUyibpnCLUa2lxupWF6rFTNlGU2pLzTOUwk6EnTI8kmqm0Q>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1791B1400A1; Thu,  2 Jul 2020 18:01:46 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-dev0-576-gfe2cd66-fm-20200629.001-gfe2cd668
Mime-Version: 1.0
Message-Id: <7304fdf3-23d7-442b-b870-e88ae6f37004@localhost>
In-Reply-To: <20200702160420.GA3512364@ubuntu-s3-xlarge-x86>
References: <20200702085400.2643527-1-danny@kdrag0n.dev>
 <202007020853.5F15B5DDD@keescook>
 <20200702160420.GA3512364@ubuntu-s3-xlarge-x86>
Date:   Thu, 02 Jul 2020 15:01:25 -0700
From:   "Danny Lin" <danny@kdrag0n.dev>
To:     "Nathan Chancellor" <natechancellor@gmail.com>
Cc:     "Kees Cook" <keescook@chromium.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        "Sami Tolvanen" <samitolvanen@google.com>,
        "Fangrui Song" <maskray@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org
Subject: =?UTF-8?Q?Re:_[PATCH]_vmlinux.lds.h:_Coalesce_transient_LLVM_dead_code_e?=
 =?UTF-8?Q?limination_sections?=
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jul 2, 2020 9:04:25 AM Nathan Chancellor <natechancellor@gmail.com>:

> On Thu, Jul 02, 2020 at 08:54:53AM -0700, Kees Cook wrote:
>> On Thu, Jul 02, 2020 at 01:54:00AM -0700, Danny Lin wrote:
>>> A recent LLVM 11 commit [1] made LLD stop implicitly coalescing some
>>> temporary LLVM sections, namely .{data,bss}..compoundliteral.XXX:
>>>
>>> [30] .data..compoundli PROGBITS         ffffffff9ac9a000  19e9a000
>>> 000000000000cea0  0000000000000000  WA       0     0     32
>>> [31] .rela.data..compo RELA             0000000000000000  40965440
>>> 0000000000001d88  0000000000000018   I      2238    30     8
>>> [32] .data..compoundli PROGBITS         ffffffff9aca6ea0  19ea6ea0
>>> 00000000000033c0  0000000000000000  WA       0     0     32
>>> [33] .rela.data..compo RELA             0000000000000000  409671c8
>>> 0000000000000948  0000000000000018   I      2238    32     8
>>> [...]
>>> [2213] .bss..compoundlit NOBITS           ffffffffa3000000  1d85c000
>>> 00000000000000a0  0000000000000000  WA       0     0     32
>>> [2214] .bss..compoundlit NOBITS           ffffffffa30000a0  1d85c000
>>> 0000000000000040  0000000000000000  WA       0     0     32
>>> [...]
>>>
>>> While these extra sections don't typically cause any breakage, they do
>>> inflate the vmlinux size due to the overhead of storing metadata for
>>> thousands of extra sections.
>>>
>>> It's also worth noting that for some reason, some downstream Android
>>> kernels can't boot at all if these sections aren't coalesced.
>>>
>>> This issue isn't limited to any specific architecture; it affects arm64
>>> and x86 if CONFIG_LD_DEAD_CODE_DATA_ELIMINATION is forced on.
>
> It might be worth noting that this happens explicitly because of
> -fdata-sections, which is currently only used with
> CONFIG_LD_DEAD_CODE_DATA_ELIMINATION but there are other features such
> as LTO that will enable this and make this relevant in the future.
>
> https://android-review.googlesource.com/c/kernel/common/+/1329278/6#message-81b191e92ef4e98e017fa9ded5ef63ef6e60db3a
>
> It is also worth noting that those commits add .bss..L* and .data..L*
> and rodata variants. Do you know if those are relevant here?

As far as I can tell, those sections are exclusive to LTO which isn't in
mainline yet. I don't see any sections like that in my DCE-only vmlinux.

>
>>> Example on x86 allyesconfig:
>>> Before: 2241 sections, 1170972 KiB
>>> After:    56 sections, 1171169 KiB
>
> Am I reading this right that coalescing those sections increases the
> image size? Kind of interesting.

Oops, I accidentally swapped the numbers in the commit message.
Coalescing the sections makes the image smaller as expected.

>
>>> [1] https://github.com/llvm/llvm-project/commit/9e33c096476ab5e02ab1c8442cc3cb4e32e29f17
>>>
>>> Link: https://github.com/ClangBuiltLinux/linux/issues/958
>>> Cc: stable@vger.kernel.org # v4.4+
>>> Suggested-by: Fangrui Song <maskray@google.com>
>>> Signed-off-by: Danny Lin <danny@kdrag0n.dev>
>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>
>>> ---
>>> include/asm-generic/vmlinux.lds.h | 4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>>> index db600ef218d7..18968cba87c7 100644
>>> --- a/include/asm-generic/vmlinux.lds.h
>>> +++ b/include/asm-generic/vmlinux.lds.h
>>> @@ -94,10 +94,10 @@
>>> */
>>> #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
>>> #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
>>> -#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
>>> +#define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX* .data..compoundliteral*
>
> I am fairly certain this will fix a PowerPC warning that we had
> recently so good!
>
> https://lore.kernel.org/lkml/202006180904.TVUXCf6H%25lkp@intel.com/
>
> Unfortunately, I forgot to reply to that thread...
>
>>> #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
>>> #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
>>> -#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
>>> +#define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..compoundliteral*
>>
>> Are there .data.. and .bss.. sections we do NOT want to collect? i.e.
>> why not include .data..* and .bss..* ?
>
> At one point Android was doing that for modules but stopped:
>
> https://android-review.googlesource.com/c/kernel/common/+/1266787
>
> I wonder if that is a problem for the main kernel image.

A comment above the code in question explicitly states that not all
.data..* sections should be coalesced. There's a .data..percpu section
in my x86 vmlinux which should probably remain separate.

>
> Cheers,
> Nathan
>
