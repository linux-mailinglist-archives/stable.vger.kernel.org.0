Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96DB39F6D2
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhFHMgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:36:11 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:35590 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbhFHMgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 08:36:10 -0400
Received: by mail-lf1-f54.google.com with SMTP id i10so31824083lfj.2;
        Tue, 08 Jun 2021 05:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vppdoecTv/PkRv6PM81tJQoeiLhJskKJXkfMElri5bI=;
        b=t6WLugjw7okloXSkmrMqkfLxJJvYS/tWhGRJx5RDo1bzpypoUaRBEaksECc2AOL+qJ
         7UREWbf1zl5lYTmLBaMZTS3zzP9hAif0Yz/YT+pOobWW9mGjJYHAYtvFwQMlb5Y32tEd
         QlAHA3+shCPW4ZevlTQyWwwsbCV2T8zuEXiMEBEpmdCIvLYEjgLR/qxg243KwFbhgkYm
         uoAlNvnZgytm3F79HEKTgMiCNtkbZymH7RTK0wyLd2mnGXWK86SjZQaVH7Ate2P9Msix
         cAqPSgGhrVSm4tsPt/tcA5GiW0CGkm6Z30XlbDesdVhe57sylaJMRmCIERtUzg8qqhZY
         eraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vppdoecTv/PkRv6PM81tJQoeiLhJskKJXkfMElri5bI=;
        b=Ljv3JEOeppE9gIC7upNPUniNsBuctuiUS1cZ/b2DnVQaEwv4AnBeyjVFFn/q62Wf12
         FH+HNIMKcTiyuDLvsR5VKVq28Sa4o7H2ChJxGipy2rU24iwBAkZFMIbSUfVSjdrb0rqw
         hAP3Zf1DJOQqJpO6ZYgas4Oz3APoTzQJ0NkhKQoOJx7b40cqDzkNhEN6UkXRoNLTyYEQ
         ij9kSLHscF1WpBaGLBITJnIiBR1YGapa3up5nDVW6pc9yqlrSJHHUSkNmNp563CYJbAJ
         Y5LPdUOc65gPzHubYgN2EzAfEoKA374Cf7MuuDOuyAyB6L2DKZuCuFVHErlJOJA9kTGv
         HRQA==
X-Gm-Message-State: AOAM531bXjfZJcC3LcR+BQPALq2VdGID1WP0YYejZH+z7dHSqSMouiSO
        pjfx42VNrQMDwu85HA3v5zbGhPOzV9LVDA==
X-Google-Smtp-Source: ABdhPJxzeHFyqN29cWJmly3fTrz3avSnBVBknq+Tc9yf+Yg8O334org6hiIzQoUkbQAz+0Olik3azw==
X-Received: by 2002:ac2:4d93:: with SMTP id g19mr14781108lfe.622.1623155596878;
        Tue, 08 Jun 2021 05:33:16 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id bn18sm2232311ljb.48.2021.06.08.05.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:33:16 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:33:14 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        <stable-commits@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 4.9-stable tree
Message-ID: <20210608153314.073d37d6@gmail.com>
In-Reply-To: <1623155433183177@kroah.com>
References: <1623155433183177@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 08 Jun 2021 14:30:33 +0200
<gregkh@linuxfoundation.org> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     net: kcm: fix memory leak in kcm_sendmsg
> 
> to the 4.9-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
> and it can be found in the queue-4.9 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable
> tree, please let <stable@vger.kernel.org> know about it.
> 
> 
> From c47cc304990a2813995b1a92bbc11d0bb9a19ea9 Mon Sep 17 00:00:00 2001
> From: Pavel Skripkin <paskripkin@gmail.com>
> Date: Wed, 2 Jun 2021 22:26:40 +0300
> Subject: net: kcm: fix memory leak in kcm_sendmsg
> 

Hi, Greg!

I CCed stable. This patch is broken and I've already sent a revert for
this.

https://git.kernel.org/netdev/net/c/a47c397bb29f

Please, don't add this to stable trees. Im sorry


With regards,
Pavel Skripkin
