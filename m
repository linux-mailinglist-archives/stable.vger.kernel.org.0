Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89D622F21C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbgG0Ohb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:37:31 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732941AbgG0Oha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 10:37:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595860649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5HKAp4ZUkGbVlQE18UlOQNKjizI/cY6UzIC6ImvqWM=;
        b=Y6Ctstxa01bguxMbIpM06aqH77wWdAFCBmDQlFypzoTFcAUZUA2edV88HNC15cBbnE5cet
        EBlToPRN8vYPJovnginvUu13omYmzpoq5JPSayh36M32eKtXvX8gYqry+/G/EKkjJk0ZjD
        pfZL22bjnA1abUC56QlRT8lxhJ/83TY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-U-lg2wDwN8-C7Ti5hy4rpA-1; Mon, 27 Jul 2020 10:37:27 -0400
X-MC-Unique: U-lg2wDwN8-C7Ti5hy4rpA-1
Received: by mail-wm1-f70.google.com with SMTP id a5so7902836wmj.5
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 07:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u5HKAp4ZUkGbVlQE18UlOQNKjizI/cY6UzIC6ImvqWM=;
        b=eA9GJsxLIesodWfJ09i41iAgxQ93qvcbg/1ykQV9t37U0FtmtKUi5Xh2nxKht+PF0/
         pk01WjQQkgYrNbhWsEyhl4Mg/R9jFRChMcGkJJNNLUlZA7Tuj04+UYYLqpC1RTKR3WaG
         Pb/I41DyWMw0e9KdhUJ96cWZ9D06O2BBeqMZV8Njs5E5ujFEeuBFhlKZvmz23/lRHakG
         Yo1aYJNGIL5IWFrcEu2DW5xUAEn019AbEzQ24bISs+08SW0YGRBNpqvQWD5NzU9LWKJe
         b9dKRvMl9w7ZhUU+M8ZiF/nH65pPPvdk3wVaY2TN5qMYEZ4FVEM22mXw67BJ/xTb9VOA
         7isQ==
X-Gm-Message-State: AOAM533RqKFyiqdutRp/hbyYEajAOS+AnVZhvGS+q+j78oflSLguRwr3
        QVRP6RpwL0jOdVxouGVIFZV+OGt4KWhXjzTiLF3kPrskHaQHVP1laXiVVBGK2PqfsTirYiD2JVl
        0b96/rq1BH5StKhSu
X-Received: by 2002:adf:f248:: with SMTP id b8mr21851978wrp.247.1595860646124;
        Mon, 27 Jul 2020 07:37:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAQpp+VslCFH5JlkAq7a2IphD8QcADVVGEUVmcuWS0HNr9I77f3KRIAzXhaAX4q+h0XMcYwg==
X-Received: by 2002:adf:f248:: with SMTP id b8mr21851965wrp.247.1595860645912;
        Mon, 27 Jul 2020 07:37:25 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id z6sm7209387wml.41.2020.07.27.07.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 07:37:25 -0700 (PDT)
Date:   Mon, 27 Jul 2020 16:37:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Kieran Bingham <kbingham@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 42/86] scripts/gdb: fix lx-symbols gdb.error while
 loading modules
Message-ID: <20200727143700.rtouw4mgim4kjmeb@steredhat>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134916.556617777@linuxfoundation.org>
 <7675dec9-7b66-b785-5034-22e8ede0b597@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7675dec9-7b66-b785-5034-22e8ede0b597@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 03:26:42PM +0100, Kieran Bingham wrote:
> Hi Greg, Sasha,
> 
> On 27/07/2020 15:04, Greg Kroah-Hartman wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > [ Upstream commit 7359608a271ce81803de148befefd309baf88c76 ]
> > 
> > Commit ed66f991bb19 ("module: Refactor section attr into bin attribute")
> > removed the 'name' field from 'struct module_sect_attr' triggering the
> > following error when invoking lx-symbols:
> 
> 
> Has ed66f991bb19 ("module: Refactor section attr into bin attribute")
> been backported to 4.19? It doesn't /sound/ like something that would
> require backporting unless something else depended up on it,  but if it
> hasn't been ... then *this* patch shouldn't be either...
> 
> Same for 5.4, and 5.7 that's just come in.
> 
> This patch will 'apply' cleanly, and not hit any compilation errors, as
> it only changes python code... so my reason to highlight is in case some
> automated system picked it up based on those assumptions.
> 
> If ed66f991bb19 has also been backported, then I'm sorry for the noise ;-)
> 

I had the same doubt, but I just saw that ed66f991bb19 was backported to
the stable branches (4.19, 5.4 and 5.7), so I think this backport is
correct.

Thanks,
Stefano

