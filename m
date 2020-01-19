Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7AC141EF3
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 17:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgASQBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 11:01:49 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41024 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASQBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 11:01:49 -0500
Received: by mail-lf1-f66.google.com with SMTP id m30so22002948lfp.8
        for <stable@vger.kernel.org>; Sun, 19 Jan 2020 08:01:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70ouyfgzU8wnsNt1yBKflJHJYDYR1JWQfCzn+aHF6o0=;
        b=S7u/Maoq4XRe+VaUzQRTcSzJKdOu7nQmthL4/63Xbv6RmYQvYaYCWttybDaCkKJ8oY
         S6sdyXZB2fpoau+XnKzrc+c/UCK+dvqs5iNlnfYq11NT8JGQu4DlyNWZFYiMLyShU6KU
         qJjlUbVr7TlcYlaqudKugD5EYGHiE+iUULFLneCF7Q880gnzMCagpOkmrusXq7/HblEI
         0Maqnb1j6CZ0rqOqogf/a58CbLHRAxPG438xGa8zi1XS3/v4Qu8GvlA/MRh2AnxgNE7j
         xAvrnzewswuFZL9TKDftnn/sK6xLAHKsg+M/NhTEZ03VMZ8M8TApKvOvPT5rj6pTgzew
         ai3w==
X-Gm-Message-State: APjAAAW2HI1bXFZ/nCXdnbk8epdLDUR92MMst5qyAuNZiMng6eM1s+91
        eDkaI1PbOgxPEJZKUybPPjY=
X-Google-Smtp-Source: APXvYqzHJX60KQxxoQLAv80V8lark8VHM/Z3iON0of3vAEHGZVMBfKgl75ZDSQcum4V2UZ4DqjqGow==
X-Received: by 2002:ac2:5f74:: with SMTP id c20mr1307890lfc.15.1579449707386;
        Sun, 19 Jan 2020 08:01:47 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id y10sm15367713ljm.93.2020.01.19.08.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 08:01:43 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1itD16-0007s9-FP; Sun, 19 Jan 2020 17:01:36 +0100
Date:   Sun, 19 Jan 2020 17:01:36 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, johan@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: keyspan: handle unbound
 ports" failed to apply to 4.9-stable tree
Message-ID: <20200119160136.GB2301@localhost>
References: <157944127621242@kroah.com>
 <20200119154733.GR1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119154733.GR1706@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 10:47:33AM -0500, Sasha Levin wrote:
> On Sun, Jan 19, 2020 at 02:41:16PM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 4.9-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From 3018dd3fa114b13261e9599ddb5656ef97a1fa17 Mon Sep 17 00:00:00 2001
> >From: Johan Hovold <johan@kernel.org>
> >Date: Fri, 17 Jan 2020 10:50:25 +0100
> >Subject: [PATCH] USB: serial: keyspan: handle unbound ports
> >
> >Check for NULL port data in the control URB completion handlers to avoid
> >dereferencing a NULL pointer in the unlikely case where a port device
> >isn't bound to a driver (e.g. after an allocation failure on port
> >probe()).
> >
> >Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
> >Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >Cc: stable <stable@vger.kernel.org>
> >Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Grabbing the prerequisite for the other USB patch also resolved the
> conflict here, now queued for 4.9 and 4.4.

Just curious; which prerequisite are referring to here? I can't seem to
understand why this one failed to apply to 4.9 in the first place as
there hasn't really been any changes to that code in the keyspan driver.
 
Johan
