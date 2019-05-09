Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5918DF0
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 18:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfEIQXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 12:23:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38307 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfEIQXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 12:23:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id 10so1583846pfo.5
        for <stable@vger.kernel.org>; Thu, 09 May 2019 09:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZqtYzU+O8xkixnBvEVTSy+ri8OBdl4QumvuY5tE8XIc=;
        b=P7mGhWaTiYff5q21bj5lLDmC80NzqeYtynH9pGrv56pMqnqMe6x9XiUvvQOylVQbqI
         7XOgv8YB0HQs0drTR6fomNtAsnS14yt+SZOUgW+5v9a9rCmUxR9bSbJOsyXNZwqNkeN7
         /QUn4AhkLoABGtb6BAfUaZrui/beRCk94NOgqq7u9b4OlkLTH0+DQQfMOZ9kzWGePbz/
         +sr+FIxM4lyETLle2RZ/4hwe7HPBwAlQpmR1fnlAsOLNoq13Y9dQIYEVzuPp1Fr71eYs
         6IVE0QNsweXFMXeM7dAVOfvhtaUcJ85LHhvoIlLHzsO4o3tkJ0TExmbfcklFzpMQOlxc
         T+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZqtYzU+O8xkixnBvEVTSy+ri8OBdl4QumvuY5tE8XIc=;
        b=gSxpAqNSGBP015bm1dQcRdYrBkt8aMiHu+wttpQdgCWRyfZ6UNT+0fmD0oxBzFp79f
         2LQ9Fen91apa38RM3hAqENskHOwWIcT9upEBjjs/lGsIFK1VNaSwgCrwMKz79EvclX4O
         phvtj+9RQSeoYivu/q6tcOFIOpMoV4ArdMhjkRPz9qkhdfHfh0sHeZvR8VWpmJx+DE5H
         BZuqEXxwU7WpIg4UHapUZVTNQkomIxhNxFVVd0HN4+BbrkSFh+faBzZQL3ocCjQRQgy6
         IOsZOvtZuFCwwlbIyKB6uGTpdkVrsUUapDlrhJjxsu/jHKaeKBjhhnr7ZZDyeofUYixY
         cDwg==
X-Gm-Message-State: APjAAAUnEIXUDZAwAlEhlQddUECmog2+cMSfYLaTPJo+loLkIToyZS5D
        uE2t+HHeZ09Yjme8AZmOztM=
X-Google-Smtp-Source: APXvYqzESeutcijMnEm2P+b1iANtkkHPtp13kowxdgDlWSg6cEleh1W2tHq9o/AhxuatkxPD8eC0mQ==
X-Received: by 2002:a65:5c89:: with SMTP id a9mr6819806pgt.334.1557419022431;
        Thu, 09 May 2019 09:23:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o10sm4251633pfh.168.2019.05.09.09.23.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 09:23:41 -0700 (PDT)
Date:   Thu, 9 May 2019 09:23:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Build failure in v4.4.y.queue (ppc:allmodconfig)
Message-ID: <20190509162340.GB24493@roeck-us.net>
References: <20190508202642.GA28212@roeck-us.net>
 <20190509065324.GA3864@kroah.com>
 <87zhnvvgwm.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhnvvgwm.fsf@concordia.ellerman.id.au>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 12:31:05AM +1000, Michael Ellerman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Wed, May 08, 2019 at 01:26:42PM -0700, Guenter Roeck wrote:
> >> I see multiple instances of:
> >> 
> >> arch/powerpc/kernel/exceptions-64s.S:839: Error:
> >> 	attempt to move .org backwards
> >> 
> >> in v4.4.y.queue (v4.4.179-143-gc4db218e9451).
> >> 
> >> This is due to commit 9b2d4e06d7f1 ("powerpc/64s: Add support for a store
> >> forwarding barrier at kernel entry/exit"), which is part of a large patch
> >> series and can not easily be reverted.
> >> 
> >> Guess I'll stop doing ppc:allmodconfig builds in v4.4.y ?
> >
> > Michael, I thought this patch series was supposed to fix ppc issues, not
> > add to them :)
> 
> Well it fixes some, but creates others :}
> 
> > Any ideas on what to do here?
> 
> Turning off CONFIG_CBE_RAS (obscure IBM Cell Blade RAS features) is
> sufficient to get it building. Is that an option for your build tests
> Guenter?
> 
I could turn it off unconditionally, meaning it would affect all other
branches. I would rather stop building ppc:allmodconfig for v4.4.y.

Guenter
