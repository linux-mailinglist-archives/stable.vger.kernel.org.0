Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000AD2B11E2
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 23:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgKLWit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 17:38:49 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:42061 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgKLWit (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 17:38:49 -0500
Received: by mail-pf1-f170.google.com with SMTP id x15so4563961pfm.9
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 14:38:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/7kSb4NjVEecqOcEpqWVXn3fzJoOdZMutr7tqTcoPE0=;
        b=WYcJSyjrQD/ImMLG5JMQV7NSltoOxKQPZtguvhAAKTfIUx2ANxCAxY5cDx81RUpia6
         jV5tzYe3O9WdYkzAddxvIhHucKsSCavpkuxlUY6AvnRAAMLlpehXDF1FYL3lZ1bptrqu
         CSj1sqX/ag904i/MDQ1t39WZ976LBSZOv8rPAplCXDn097Mgwb+oWABD7cLEyqT97fqC
         byr28ejIlP2X/tYoteiJ/AMe7OqdOw8KZ3WgsVqSXQVcxpB2e4OIqcA23e9n9xqBbRSE
         kC9By4ejMqU41VqLpEh8h/cFC/PaoEeYkNUjIuCpiCFpM5IaSbH1RwERPf8zyONIJW59
         3szA==
X-Gm-Message-State: AOAM5326dHagWqEi2+00o5cTtRYZkA9gZLWWt4PEmHt8pJ67x3Dpj3MX
        025G34PZWHqoWQCKGLc1xbI=
X-Google-Smtp-Source: ABdhPJwpQOtNqR82rm/Z71mcPK/Mt5O79eAy835UX8INoMEf5PtKGgLK2MZfh27gUnU14puUFWEddA==
X-Received: by 2002:a17:90a:f492:: with SMTP id bx18mr1425810pjb.123.1605220724465;
        Thu, 12 Nov 2020 14:38:44 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id r73sm7747094pfc.20.2020.11.12.14.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 14:38:40 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 09C2940715; Thu, 12 Nov 2020 22:38:38 +0000 (UTC)
Date:   Thu, 12 Nov 2020 22:38:37 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [4.14] Security fixes (blktrace, i40e)
Message-ID: <20201112223837.GH4332@42.do-not-panic.com>
References: <c21d1ef1ddb071eed868a96649b4edf0b61b4247.camel@codethink.co.uk>
 <20201107152827.GA90705@kroah.com>
 <CAB=NE6U=kTw_R+OkqLf0iT0Bwti8w=7RWjWgeQmVQssbZ4OL3w@mail.gmail.com>
 <20201108091214.GB44749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108091214.GB44749@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 08, 2020 at 10:12:14AM +0100, Greg Kroah-Hartman wrote:
> On Sun, Nov 08, 2020 at 03:04:14AM -0600, Luis Chamberlain wrote:
> > I'd like some more time for this, to review on older kernels. Don't think
> > it's the best yet
> 
> What is "this" and what is "the best yet"?  Which patch(s) here are you
> referring to in your context-less top-post?  :)

Sorry, I had to send the email as I did as I was not able to access a
computer to properly reply on time (local hurricane cut power off and
internet for a while), and in proper form, and so I figured it would be
more prudent to request to *yield* merging until I do proper review.

Given I am replying to patches which I authored I figured you could
at least infer the email was about blktrace... so you are really
exagerating contextless comment here.

Anyway, you can carry on with the fix for blktrace to be merged,
the concerne would be if you decide to backport the other important
fix "block: revert back to synchronous request_queue removal".

That is, do not merge that loosely, even if you don't see any issues.
This requires a bit more work to backport.

  Luis
