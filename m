Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7B61E00DB
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 19:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgEXRLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 13:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgEXRLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 13:11:12 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74808C061A0E
        for <stable@vger.kernel.org>; Sun, 24 May 2020 10:11:12 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f4so7677529pgi.10
        for <stable@vger.kernel.org>; Sun, 24 May 2020 10:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NAKQIMXaezFdXHBbMJu01Ob1tgUW1xbgfN1NaJcrV+o=;
        b=nS9zohrnXJ9wZUY66WysKaXhh1jnYTTsxnRDAqht0ybl6Qs5f5x6UVdtKaL6HsDhoc
         do8iTf/I4jby/AzEfozLdf04+IAlhhrHrmEwvMba+0mngT3aQaEYCbjR2X2Tzy85oSHn
         fjabdj/SQqcQMzeKLrq2CfbosfiO1viPOEm1GCefJ3ZV5bLQD5hzXHKUTWGpw19DAMVA
         WonBIb/whY1aivBanR7Z1qUHFwtopdMZk9yI/b9paD3xCPpJ60rkRK7+XVUKVIbkBLO+
         nftiqLd3sF+MmNTaX3JuRfjIbgy2SG5Gq7u+VUrqULlRsh+OEFWANbFzLhjvIT2k4oxo
         oCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NAKQIMXaezFdXHBbMJu01Ob1tgUW1xbgfN1NaJcrV+o=;
        b=WXHT0v1F/+/Jt90pWrW76J6NYA/PLAIAas6WBCRxx1dRcZ36vKZhRHwADdtd0O7u7Q
         iHNS66VslEZKFWKZthTVQJaWO5rfKt0Mwz7MuHQHPmnDJf+IaOPBc+NwvyCGVlqCglPk
         wgcrh0iGKZzLX2jpXCWSJWO7nt0ApC7vMNElXN0GTs9hjw/ujycGhJKTAB8z5uy6IT+K
         8QsjixmHhKO8DU2IsbKHcnHpZrJy/6nQhL6BOsQMASNPHAAL4iT3rEhgS0qqzVFW0t9j
         8zv+nj3bRnSjNWZZhvOvD8vdJRI8tMMRWz89UkB8efQHBp30V/RM3g5zqzifI50Xdy9A
         KGKQ==
X-Gm-Message-State: AOAM531Oup0qFVPHRQJsASxdSgUgA8h8BRYy1SMZ7cebnqbgiRu+4jOY
        t1RNj/F/6GctyY0b1BUrvseRyQ==
X-Google-Smtp-Source: ABdhPJw8MlcE6q1bgDbdvqzESvVcHXDIgHx/p+Ojv3Higy7hExFF/ztp+hLtBCW/RVQSpT6qWmAWgw==
X-Received: by 2002:aa7:9096:: with SMTP id i22mr13653267pfa.250.1590340271803;
        Sun, 24 May 2020 10:11:11 -0700 (PDT)
Received: from google.com ([2620:15c:201:0:4e3a:fe5d:27e5:c203])
        by smtp.gmail.com with ESMTPSA id k18sm11269363pfg.217.2020.05.24.10.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 10:11:11 -0700 (PDT)
Date:   Sun, 24 May 2020 10:11:05 -0700
From:   Eric Biggers <ebiggers@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"" has
 been added to the 4.4-stable tree
Message-ID: <20200524171105.GA56504@google.com>
References: <20200524135255.8821820776@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524135255.8821820776@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 24, 2020 at 09:52:54AM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
> 
> to the 4.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      ppp-mppe-revert-ppp-mppe-add-softdep-to-arc4.patch
> and it can be found in the queue-4.4 subdirectory.

I already explained last time that this shouldn't be backported:
https://lore.kernel.org/stable/20190905161642.GA5659@google.com/

The commit message explains it too.

Is there something I could have done last time around to properly prevent this
from being backported, or do I have to continue to be ready to respond to these
emails which can come at arbitrary times forever?

> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Hard for "anyone else" to object to it when you didn't Cc any real mailing lists
(stable-commits doesn't count) and just sent this to me.  Lucky I saw this.

- Eric
