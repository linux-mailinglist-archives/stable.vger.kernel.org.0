Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B8C135897
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 12:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgAILz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 06:55:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38985 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgAILzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 06:55:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id y11so7091537wrt.6;
        Thu, 09 Jan 2020 03:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mFkJFYkrFDlWwhK3VKXDGs8jHD7xXTyu7e9TssfROcw=;
        b=VupQPDUFRW6nGI/fzWa+ImG6XxRsc/hamERXHTC1dosaWxKNgdAbWQDk0HOMqzR66F
         +2dhGR+dnG6oMn7gR22cxPsacp8CL5RP63fJFGXzFeQ+4apuOHZL+lHxNifRs8OQnJg1
         E+otA/VR0s0acLtclp9GbEySjXdImnzLwESx+PL/+SoIpENiFYmczifnTPlZgwr9MYDc
         SZC7aUgd7yxZif/HC4+zpmRUYOQMviQpQdqPK/fgF4hlQ5W7tl7ZCE5iOxkoOyWA01c1
         s7/jp7cpF86j/jZ2mjNHNi8TPPegY78m8Q2gbP0afcYMGZZ05ADgKsoX1OtyxB4Bxkjg
         gUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mFkJFYkrFDlWwhK3VKXDGs8jHD7xXTyu7e9TssfROcw=;
        b=IBx+/0OQxcLiYOYI43+yn5aArRtLY50ckQ1ZRtV6OJ0D6oageu/+DHbaVU0D5NESQ4
         PLJwfYD5EmHSs390pxrzvaxcIiW/0/IOUQeKGJK3lhqc1+s1sHeRVrbt3XR+SksuukX+
         PlXwIqafvC9nS8mjmsHCnWwaGHil3NINsm/REFCx8v50yi1jNQ8Q5GXVPc/bGw+/Aph+
         fZxgQxlUWxBjBDZ6A91+Uij+rL4t7VZfXlxC8yxOpL/WKSHgAAy2BP7El3LFZfNVPM+h
         EFpiqSK2EGGr76CsqTziwSIRMXO5q+pR7sSu//j2l5JDC4bD0tRve0iBP97Ek4B35Jql
         Cc0g==
X-Gm-Message-State: APjAAAUF+qnB8B6Jc1rVf+E9Wtxi1to/VZCLh2bMWh6XuLz8l4bMFK9u
        sx9C6kiRhtgISLZ/E+8IWcZQwhGf6+w=
X-Google-Smtp-Source: APXvYqzZdiDmnWeIjKl6Zs3UBhHThSKFOQFbH9wX9X39v5aH1m8oz0pIqOBHZJxJHGAj4woPe0HMbQ==
X-Received: by 2002:adf:d0c1:: with SMTP id z1mr10906394wrh.371.1578570923526;
        Thu, 09 Jan 2020 03:55:23 -0800 (PST)
Received: from lorien (lorien.valinor.li. [2a01:4f8:192:61d5::2])
        by smtp.gmail.com with ESMTPSA id g25sm3634075wmh.3.2020.01.09.03.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 03:55:22 -0800 (PST)
Date:   Thu, 9 Jan 2020 12:55:21 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     StableKernel <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: What happend to 5.4.9??? Kernel.org showing 5.4.10!!
Message-ID: <20200109115514.GA1270@lorien.valinor.li>
References: <20200109114330.GC19235@Gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109114330.GC19235@Gentoo>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jan 09, 2020 at 05:13:32PM +0530, Bhaskar Chowdhury wrote:
> I am wondering, it might be lack of morning coffee for Greg  :)

5.4.10 contains one followup, backport of 6f4679b95674 ("powerpc/pmem:
Fix kernel crash due to wrong range value usage in
flush_dcache_range") which fixes a regression introduced in 5.4.9 via
backport of 076265907cf9 ("powerpc: Chunk calls to flush_dcache_range
in arch_*_memory").

Regards,
Salvatore
