Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BFD364D88
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 00:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhDSWNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 18:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSWNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 18:13:17 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C87DC061763
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 15:12:45 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id r20so41175782ljk.4
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 15:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+H3mqp2R90G8NCw9fCRyS3oUOaUPPm2FiUG9y073Tek=;
        b=CvduBEQUHFFh4Jq/ayDbLyMywS01YXp5FiMxStQ35SFbmG4ML4iS2QyKJWWBBzlOUg
         f1XbpwtpjLvOtS3v5710aVWlGcZKjR2JsPDMUdojSq7OYYl101N3FbPXm3uM5qcs7lgu
         te+yhQMxUKyArjW5eUhlZoc0312JyUXJVws3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+H3mqp2R90G8NCw9fCRyS3oUOaUPPm2FiUG9y073Tek=;
        b=qlM5w2KbX9swFpF9JTpvhvDSA2V6r88pzKbHULs9zDHeLTuV+p6+so/P9OBRVxnw9C
         GLOcDIRK0E/dMl2DGy4UA6H3wLWRc+iHFk13G6IWk/2w+8ha5cjZ8L+nDrBUb9a1yvUL
         54QNy0LD92J5DFMP4wwWkqs+C5Nn1W+SoacuIZHPKpLVSreVVZ5PG1LtmmAg8h3zhx+U
         6SlWjbK7B51H+83M5njnk+rvviwwz1qLBAB8hudPw7JhJmVjpN/gvIly2Ew0cyqALCkR
         OQrPW5eI3VUPLqqd+nZg/8yR/uwfWUwxcFFWjwcpCPg4C45Nq/YqmUHbQ1oERUFNs9Tn
         sTGw==
X-Gm-Message-State: AOAM531SXnLashCTtvKrEeF3pCqNj0FobAg+QrStXGHXPCxJUX9yTwHU
        zR3ebVQNCZJXbqthwh0RDLKrrmalLPYuyK6V
X-Google-Smtp-Source: ABdhPJyUlK3CmLdDHoeyHS/qujU8g89GJP7Egob7oc9Qo1YRJng4CF7gyksv7QJxVrBSwYQjr9KLWA==
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr12104232ljr.239.1618870363662;
        Mon, 19 Apr 2021 15:12:43 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id d15sm1962258lfn.7.2021.04.19.15.12.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 15:12:42 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id j4so18916940lfp.0
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 15:12:42 -0700 (PDT)
X-Received: by 2002:a05:6512:3763:: with SMTP id z3mr13215500lft.487.1618870362276;
 Mon, 19 Apr 2021 15:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
 <20210416224623.nZhisHrwM%akpm@linux-foundation.org> <YH33+R8pwviVysY5@archlinux-ax161>
In-Reply-To: <YH33+R8pwviVysY5@archlinux-ax161>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 19 Apr 2021 15:12:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgkck4D7ANx-uJCTugfR5GgH6MgvrmmGcqQRy6ZMECdTw@mail.gmail.com>
Message-ID: <CAHk-=wgkck4D7ANx-uJCTugfR5GgH6MgvrmmGcqQRy6ZMECdTw@mail.gmail.com>
Subject: Re: [patch 11/12] gcov: clang: fix clang-11+ build
To:     Nathan Chancellor <nathan@kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        johannes.berg@intel.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 2:37 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> This should not have been merged into mainline by itself. It was a fix
> for "gcov: use kvmalloc()", which is still in -mm/-next. Merging it
> alone has now broken the build:
>
> https://github.com/ClangBuiltLinux/continuous-integration2/runs/2384465683?check_suite_focus=true
>
> Could it please be reverted in mainline [..]

Now reverted in my tree.

Sasha and stable cc'd too, since it was apparently auto-selected there..

           Linus
