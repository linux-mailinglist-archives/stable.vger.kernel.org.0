Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AF231E987
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 13:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhBRMGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 07:06:04 -0500
Received: from linux.microsoft.com ([13.77.154.182]:48740 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhBRLth (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 06:49:37 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5C53F20B6C40;
        Thu, 18 Feb 2021 03:48:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5C53F20B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1613648930;
        bh=Uz4RGBS+kCxkXc3+z9UyxgYLJavxJt7GPGvD/Iq9nTo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AA5GYFBQyBNAi/11hdQel3FiO4R1VUOkXJgxUq+4U2g744uEOrdE2SQ4RIyMTWvnB
         zPoakkjpACveZStpaCr93prIwrm9GIHjaSWprRXvT0E8j7oCUBurkY/fqQ8MY3UDui
         g/RlS4AomTDff+HWulRc6Oi12va3lnyIuIlO90uc=
Received: by mail-pl1-f171.google.com with SMTP id e9so1124707plh.3;
        Thu, 18 Feb 2021 03:48:50 -0800 (PST)
X-Gm-Message-State: AOAM532Xsn/w6mB7/Qsrb69LXpaMXVfjgeEPKSKtlnH+njT7Zytexcu8
        jwVUgo303scC34g1BuFoXGd2Su0z/8QcgcqXrRw=
X-Google-Smtp-Source: ABdhPJyRydmvZhtYhXgEVUjD6pvNVcR4tzn3J1dL13HlKYGXW0G+dswuc5XCl8RnuOyfc23koPxjC7URreNUYhCsT+s=
X-Received: by 2002:a17:90a:694f:: with SMTP id j15mr1915872pjm.187.1613648929959;
 Thu, 18 Feb 2021 03:48:49 -0800 (PST)
MIME-Version: 1.0
References: <20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz>
In-Reply-To: <20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 18 Feb 2021 12:48:14 +0100
X-Gmail-Original-Message-ID: <CAFnufp1OqLtPQva-i5JzwAL-GB6fcz0guxvoOkhE4s=ALFTd_g@mail.gmail.com>
Message-ID: <CAFnufp1OqLtPQva-i5JzwAL-GB6fcz0guxvoOkhE4s=ALFTd_g@mail.gmail.com>
Subject: Re: pstore: fix compression
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 12:15 PM Jiri Bohac <jbohac@suse.cz> wrote:
>
> pstore_compress() and decompress_record() use a mistyped config option
> name ("PSTORE_COMPRESSION" instead of "PSTORE_COMPRESS").
> As a result compression and decompressionm of pstore records is always
> disabled.
>
> Use the correct config option name.
>
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> Fixes: fd49e03280e596e54edb93a91bc96170f8e97e4a ("pstore: Fix linking when crypto API disabled")
>

Acked-by: Matteo Croce <mcroce@microsoft.com>

-- 
per aspera ad upstream
