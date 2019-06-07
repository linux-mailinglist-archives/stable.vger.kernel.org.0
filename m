Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F4C38297
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 04:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFGCKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 22:10:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44792 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFGCKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 22:10:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so577321edr.11;
        Thu, 06 Jun 2019 19:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ThOXkYce0vYPq+T2x3kRAGENrENTl6Mt6vUE0HQEfpQ=;
        b=vZBdnFljbXPzoW+6v6jYu+caHGlQkyDDaSIQ+3vYsCJDOqISxVlL98fIAzmoiw9eMG
         ZxBXoI5/5ChuSVGoAI3DG0+K2mYM82Tg2eHE4rffRyzdjNJ0W8WQPoCV+++TftsxedkD
         UO7iRZIqDJ4eIEvu/AfpqY8oAVyxIAq2/j79vmZWm1w43enVrdYhudsz5HfcPR/79Cny
         rS3zRK2qGfaM/3bBqRZk5w7VJcGOiTWJgTq5AcZiox8zY0fBaM7AkguUJkop+YT+XzYz
         WKMo57lpIhcGWswJE9+m23PGFSz+kMn+LVgPGQdmi+UnXlxr74X505VhCcJkT8TJ7zla
         HCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ThOXkYce0vYPq+T2x3kRAGENrENTl6Mt6vUE0HQEfpQ=;
        b=qG9bsye00R7/6FA71yalpKuXX0XNoST/mtDR+qgEoKFy4Aq0x3NZD38ozouac8Th0b
         EsSK0b4Hcykak3Xky0iaN59NiHy8zEByB6dw3fV6yjHqHhwi2PavQmATS+qCxf+DleeF
         zF0B0mnLlNY+n5H/tqmljRREXlqMQFYWHm2hAToADHHTNf4hHvwi6cHgNh2yfGlK451U
         gmnb73Rr5SVbCkfJXEpMqeSgaaemT9E6iyxk/lHQ41iKEX5wnkNPX/Cs13wX5C7BEXg2
         OsXhy4sDZmJOK6etiBgfNl3nnFoFtqB4t/VHps7tQpHbh1+hLa84RzQd8pzhSJHFOgxM
         e7yQ==
X-Gm-Message-State: APjAAAVGrq9/GVDUCc91dSMXhUoofH5d7F9dWxf4kwU70MT3Cp/hwyVX
        x7iBaPqePp7ScStGVdG/hTQ=
X-Google-Smtp-Source: APXvYqyBAOMYsalSRWOktfhuLtSLXM3lYKeO2jiNUzKayLcm0tycPyQRykUJD5Uwd/nhg/0H+a2p5Q==
X-Received: by 2002:a17:906:261b:: with SMTP id h27mr44103209ejc.97.1559873450093;
        Thu, 06 Jun 2019 19:10:50 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id s5sm161252edh.3.2019.06.06.19.10.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 19:10:49 -0700 (PDT)
Date:   Thu, 6 Jun 2019 19:10:47 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Joe Korty <Joe.Korty@concurrent-rt.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alistair Strachan <astrachan@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [BUG 4.4.178] x86_64 compat mode futexes broken
Message-ID: <20190607021047.GA53764@archlinux-epyc>
References: <20190606211140.GA52454@zipoli.concurrent-rt.com>
 <20190606231130.GA69331@archlinux-epyc>
 <20190607010128.GB24007@zipoli.concurrent-rt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607010128.GB24007@zipoli.concurrent-rt.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 01:01:36AM +0000, Joe Korty wrote:
> Hi Nathan,
> I started with 4.4.179-rt181 and worked backwards from there.  Per your
> suggestion, I tried 4.4.180 and it does work properly.
> 
> Thanks,
> Joe

Great, thank you for testing and sorry for the breakage in the first
place, I missed those commits in my series :(

Cheers,
Nathan
