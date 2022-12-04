Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDEF641DBC
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLDP4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDP4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:56:08 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3A13D70
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 07:56:03 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id p18so3333978qkg.2
        for <stable@vger.kernel.org>; Sun, 04 Dec 2022 07:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ymxb9P0IjaxkkgKVbX6h7FxkgCqELgbUOIk2uateazM=;
        b=cVlmRloO4KNhNRrJ63bRjLA13sTnnbulFLVFURZ33x90IiP0Kt4zYLx7438l15k6Il
         T1sFgex4nd3dgVNBGFDg3wphlvnA8nSsBmSd/rakfg+Sdt5newA6wcvknuPi39QPnkCR
         /4UCaZCbwnFEuC50dJvo7AAquprObV6SAFbIy/tb6UWrhN1BUhbfFyJbaUvUMqE/x7oR
         mbLeIopRbc6asTNB5CW2B8CSykyKkCvAH5imkoz/KR/p2NFSaq5p2PXHdoPaG0vvkeMO
         0ZAerAr5K49Fij96V7b/ct8wzZGegscRki/+jtQFpJlVN30rLOvL/3LJ7ugctn3pkhq0
         sddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ymxb9P0IjaxkkgKVbX6h7FxkgCqELgbUOIk2uateazM=;
        b=kpKndj7Uwx4C1+IfQ39ruTWYAZrEMxLJOcS15KUckuSuvzHvOxPVQPIynEGTZBGyVP
         8UrLXxcudlghu6YmB+ydSJf/ACH/XpAu2n1JHtjpu4WnRUUEa4iQ1DGGdkx2jeWF1oSk
         MYpv0TQMBIanIYDtKmJhbz40UuUtH8XNMnM2kMydAAd2Q6yohxD5p/M/ZnLpPTQIqgbg
         wN7x3r9yEt4lNsGrHzgL9zQc3nT1o9+PK4tEeZ1DXXmjOygDgIGasYBPbF3jvC6yHBXV
         e5oCNFqi8etzAUZxLGKhbc0DllebunXguzD8rWbYp88ER9+h7cFDPrKKEkExP6krv59k
         uADw==
X-Gm-Message-State: ANoB5pnXov4z8f/Zj7Vzqt70zpCwG/viOuRLVW/Q8RN1nfhSqw/mZwkB
        eDlNBiZ+5u1VUdBQ62hqEuV3XA==
X-Google-Smtp-Source: AA0mqf6gCQUk4Zkn69FtuBXcBs5H3jj6g8nCuhuHwMPCyK6VBX7d9hPjDPz8CKyc3kK8wBUIASjdNw==
X-Received: by 2002:a05:620a:31a9:b0:6fb:c632:f915 with SMTP id bi41-20020a05620a31a900b006fbc632f915mr55217860qkb.492.1670169362509;
        Sun, 04 Dec 2022 07:56:02 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id az15-20020a05620a170f00b006ce1bfbd603sm10117567qkb.124.2022.12.04.07.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 07:56:01 -0800 (PST)
Date:   Sun, 4 Dec 2022 07:55:51 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Hugh Dickins <hughd@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section
 warning
In-Reply-To: <Y4y/AEsLmKRcQ/R0@kroah.com>
Message-ID: <e43dc462-9eca-e1f8-2fb8-7d5ebd2342ae@google.com>
References: <20221128225345.9383-1-nathan@kernel.org> <Y4tQYgjDgodwR2pP@kroah.com> <5f9317c7-e899-a6b2-dd23-664a1b6d629@google.com> <Y4y/AEsLmKRcQ/R0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 4 Dec 2022, Greg Kroah-Hartman wrote:
> On Sat, Dec 03, 2022 at 09:41:34AM -0800, Hugh Dickins wrote:
> > On Sat, 3 Dec 2022, Greg Kroah-Hartman wrote:
> > > On Mon, Nov 28, 2022 at 03:53:46PM -0700, Nathan Chancellor wrote:
> > > > 
> > > > As far as I can tell, this should be applied to 5.4 and earlier. It
> > > > should apply cleanly but let me know if not.
> > > 
> > > Queued up everywhere, thanks.
> > 
> > Thanks for queueing them up, Greg, but please read through the thread:
> > I have doubts on the 4.14 and 4.9 ones, which would want a different patch
> > if we're going to make any change; but thought we could just leave those
> > trees without the patch, and Nathan agreed.
> 
> Oops, sorry, now dropped from 4.14 and 4.9 and I left the 4.19 one as
> that one was ok to keep, right?

That's right, the 5.4 and the 4.19 ones are straightforward.
It was just the 4.14 and 4.9 ones which were questionable (because
of other related infrastructure missing), so better dropped.

Thanks,
Hugh
