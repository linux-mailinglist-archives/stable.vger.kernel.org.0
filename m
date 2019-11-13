Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA1DFBAEC
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 22:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfKMViM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 16:38:12 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37662 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfKMViM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 16:38:12 -0500
Received: by mail-qv1-f67.google.com with SMTP id s18so1488373qvr.4
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 13:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1jdNYztEtxc8SfImaEzyFgaa9SQwFgVwrspdhS4uESk=;
        b=TPR3K/r6XvAteM0JaP1KBWpEhwecRZn365xgRo1ztlHHa9PEx2ccIhE0TiFliRhSjH
         KIQEYNuzL4kpccd5YK/E+EuSgRU/FHPNGINMda/SoLoCn31bprYoJ8rUYMUp/+sSmPyy
         IaYC7/Was/5vsDwGWDBCa01+/LDhIIBnrZfouRADWLT4xEq72wQcBF6RKtbzTPOsaMxL
         cY4FELOeE4rCvgZFGzox3YZbmNp+D8AGSPnOoZvMohgJcRSv9NIY5pn886ctjgaIC3Su
         XU8UGnWIty+CbanQSLN3Npb4xcYtxlidFhqspHOlg2BfCmM1Qt2JWHQiVqOc6q8dq3oO
         LIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1jdNYztEtxc8SfImaEzyFgaa9SQwFgVwrspdhS4uESk=;
        b=YKvgQA8TV/LIwYYirILwjPqyHSuBG+fLO5Mtqv93WMeIY3X8oOlVT2YWH9s3DsaCGu
         D9qbaAMcFIDIt1XDK3v0rG51GVIgHldRFxvTz5+3jJNWVo7O5+EKxfPMZ+4S6hNzjYqv
         G+9zbtFWTo8AbLXNxB4/z/QtDunufxqCcqz0rmOzoCcWle28/+NqPDj7ajYdfQGJ0mCS
         u3LJXPLWL5i24hZclX5d70g0+5yRKjBnZeSUwLtO7MaVCmAjc6q8qKW51lZiw0TfvXhp
         tDIqgaIe9q3Ty3+s7XiNcwpd24ibOlFwLR4Vj2TrspzthestkXMHxkVf9asOGtGE2RG3
         AyjQ==
X-Gm-Message-State: APjAAAUsvCumEKpJPmutXqqdm6LVrj9f0jtWPD1/estYDDKYmEK68lgc
        C73X2+0Gax1iomGyIBPxN6qtNI4Vl1PUh3W2on4l8Q==
X-Google-Smtp-Source: APXvYqzBPtxmCxOGVmM3ecLjmVJEpWoL2fFkW94ZVkNcjD0QBsupbILPe/9QBBSkDQZNDqOl0hwctTXuQqReOk0/sII=
X-Received: by 2002:a0c:9637:: with SMTP id 52mr4897544qvx.174.1573681091430;
 Wed, 13 Nov 2019 13:38:11 -0800 (PST)
MIME-Version: 1.0
References: <20191112223300.GA17891@debian> <20191113013026.GO8496@sasha-vm>
In-Reply-To: <20191113013026.GO8496@sasha-vm>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Thu, 14 Nov 2019 03:07:35 +0530
Message-ID: <CAG=yYwnJKcriaHcZFFrznxq1V9-ZcLzC-O=fAhQ6Skmn4eFPAg@mail.gmail.com>
Subject: Re: PROBLEM: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
        christian@brauner.io, tj@kernel.org, peterz@infradead.org,
        prsood@codeaurora.org, avagin@gmail.com, aarcange@redhat.com,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        "Mr. Jeffrin Jose" <jeffrin@rajagiritech.edu.in>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 7:00 AM Sasha Levin <sashal@kernel.org> wrote:
> Could you bisect it please? I'm not seeing the warning here, and
> kernel/exit.c wasn't touched during the life of the 5.3 stable tree.


I tried  using related to  "git bisect"  and managed to  check based
on kernel revision related. The warning existed even on 5.3.5 and
may be even back . i think may be it  is a compiler issue which creates
the warning and not the kernel.


-- 
software engineer
rajagiri school of engineering and technology
