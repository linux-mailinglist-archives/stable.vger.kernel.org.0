Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F14346656
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 18:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhCWR30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 13:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhCWR3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 13:29:12 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E578C061574;
        Tue, 23 Mar 2021 10:29:12 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id n11so12421210pgm.12;
        Tue, 23 Mar 2021 10:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wi4LJHw5jfEvsk7wZ9OkrUtU3aXuAPjNOhKa1Fc/yDg=;
        b=N6CofipRIMKcvqeE8tzhfWegNuhV3wp/ZE5mQDT+o/Gl9Sed65kludEkrkz6O/RMIk
         S2KHPRfM1Jbr+4fQpjr2BcPm+/K5dPvMiNWPeb+foeWRhjyWEm/2fOR2otjI++xx5Bid
         9sYScbwwVBQ4fxjJd9IWJmJ2k/zIBl8BTDjkBdnZbObjcQGF7Ho/D2TqcT4yUdrb0SN0
         eWOOF74MAjNzenT1XefOeurdoRstXYYY3b1Y8rYMlQQ6mPoeQMQo+F49LNe+/3ZlSLPd
         F2k5ZmW7Q/OjkvnEr9AtnZMHl1wFHWsn8Ou6L48puWDLcDlKMcKbA5BZ53N/ON3xwS5U
         HLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wi4LJHw5jfEvsk7wZ9OkrUtU3aXuAPjNOhKa1Fc/yDg=;
        b=anNN3Ic0mX6wvUkqqvrWjMA4Ud1GHqK5KQg98cjaHfbw4zApDTQ2pliq9bCfc8Xd8V
         lwDfBM31hcfpnG1De/xd8elIpJd1UZ94LGjlfpryqUXV85TzGQDaKaJ16XgiafDslcTu
         OvWboGTbYw6Dw5KPaweDCMR7k1DOSRDL1d34Z9G9AMd04TwbLMcixK2/QhH4nG6ZuJcn
         P1RvlVOleAZgG08UGrseqkphTV3t6lpM0mLo08pavlKQCScXKy/M/wMJnUoRGbSoKjU8
         pm+KMFKLjUd5KTiipI2Mu2Lr3QgXluOBbskedkWjRPzp8YhE1IVdhHHcScItoBrKApPq
         5tyg==
X-Gm-Message-State: AOAM532Rtv4CWUIsQ19fE/JznD/tGkgejZ7QyH+saCDuIgrr/fLSydlA
        AOxDeSZ8KetI8GuMV8h2ojAqKKJKqNg=
X-Google-Smtp-Source: ABdhPJyDfOInpSkfi+8RTFT36FMcMpYAJCNMk4gBB2byJ9jSBhhNHGkFmSZhYPos0xTUriOooKLyUg==
X-Received: by 2002:a17:902:bd82:b029:e6:1ef0:82dd with SMTP id q2-20020a170902bd82b02900e61ef082ddmr6810849pls.43.1616520552179;
        Tue, 23 Mar 2021 10:29:12 -0700 (PDT)
Received: from atulu-nitro ([122.174.244.83])
        by smtp.gmail.com with ESMTPSA id 6sm19050446pfv.179.2021.03.23.10.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 10:29:11 -0700 (PDT)
Date:   Tue, 23 Mar 2021 22:59:07 +0530
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     gregkh@linuxfoundation.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: rtl8192e: Fix incorrect source in
 memcpy()
Message-ID: <20210323172907.GB21444@atulu-nitro>
References: <20210323113413.29179-1-atulgopinathan@gmail.com>
 <20210323135811.GI1717@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323135811.GI1717@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 04:58:11PM +0300, Dan Carpenter wrote:
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This is very clever detective work.  How did you spot the bug?

I remember trying to investigate a sparse warning couple of weeks ago in
the same file and went through the code when my eyes caught a struct
pointer being indexed, which looked wierd. On further reading of the
code and trying to make sense of what was happening (especially after
calculating the size of the pointer) I became sure that it wasn't
correct.

The first patch led me to the second patch as they were related,
"CcxRmState" was used in the same memcpy() of the first patch. I caught
the error in it's type while trying to fix the first.

Thank you for your encouraging words :D

Regards,
Atul
