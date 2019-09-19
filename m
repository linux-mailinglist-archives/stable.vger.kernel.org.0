Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A991B80F6
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 20:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbfISSkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 14:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732030AbfISSkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 14:40:06 -0400
Received: from mail-yw1-f71.google.com (mail-yw1-f71.google.com [209.85.161.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2F60369DA
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 18:40:06 +0000 (UTC)
Received: by mail-yw1-f71.google.com with SMTP id j15so3365473ywg.22
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 11:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=V3gu8US5wEsIy+1LkcKoe94pmNkZCYlreyR55vm3f74=;
        b=tr+CtRZu4SMXUybJBJ90UEbE8ru7Y+LoIDA08/7V91tZWEFr+ydmG01YAoEM+qI+Mh
         lh5Dt0S7wQ7Xq4AqLkpmoRGbx+hpOjjFq7FP2/By0h/1P22sj4278ktWZu8wctZPYADp
         tBXFyBkofBo0w2NseKDCwEXI2Np66PhtI5lUhE2JMN1lXYCxzU8vPF0//XYT4EoIFZiQ
         9zlsBYIXpq1oJSa+JiiSH1sYNkHMH1Ovzz+mPUVUe13mu8IPbMgME6z3H6D0LB+aJjCX
         iCf1lf8QjJBBDnCUhMzM/wqodQwVOCr4wNbrZ2RjmnNbx/OZ6VFlcv6t/c2ahFspoxEs
         cdhA==
X-Gm-Message-State: APjAAAUYFe1fOu88fIamXo/nZ4rHPnQvwwm4DtUOtFxsLCqdQ1wBtGik
        H9L29xCqQmycnqUgWD5Xsm1vBNamrBU9DQemeSR60rVzwsx6mxRWx6zQLSST5lCyWeFx4dZPctq
        +A5DR13LV7Z0izntA
X-Received: by 2002:a5b:506:: with SMTP id o6mr7466451ybp.222.1568918405917;
        Thu, 19 Sep 2019 11:40:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxHcx5s/GDqDO6M2OnBgWHzDmyyd/fWTpAHuKPW3GCRjXmwhZdine4t98DdPnxaf9yEMMJ52A==
X-Received: by 2002:a5b:506:: with SMTP id o6mr7466440ybp.222.1568918405586;
        Thu, 19 Sep 2019 11:40:05 -0700 (PDT)
Received: from desktop ([2605:6000:62d1:e302:a8ab:9c4c:34f3:2fbd])
        by smtp.gmail.com with ESMTPSA id s1sm2098334ywa.67.2019.09.19.11.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 11:40:04 -0700 (PDT)
Message-ID: <9d1e0e07657930510d8b47a2e0b80a18675a857d.camel@redhat.com>
Subject: Re: =?UTF-8?Q?=E2=9C=85?= PASS: Stable queue: queue-5.2
From:   Major Hayden <major@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Date:   Thu, 19 Sep 2019 13:40:03 -0500
In-Reply-To: <cki.E0ED5BBB2C.DDH6J6S98E@redhat.com>
References: <cki.E0ED5BBB2C.DDH6J6S98E@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-09-19 at 14:02 -0400, CKI Project wrote:
> Merge testing
> -------------
> 
> We cloned this repository and checked out the following commit:
> 
>   Repo: 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: 1e2ba4a74fa7 - Linux 5.2.16
> 
> 
> We grabbed the b28a49d2ee27 commit of the stable queue repository.
> 
>   aarch64:
> 
>     ⚡ Internal infrastructure issues prevented one or more tests
> (marked
>     with ⚡⚡⚡) from running on this architecture.
>     This is not the fault of the kernel that was tested.
> 
>   ppc64le:
> 
>     ⚡ Internal infrastructure issues prevented one or more tests
> (marked
>     with ⚡⚡⚡) from running on this architecture.
>     This is not the fault of the kernel that was tested.
> 
>   x86_64:
> 
>     ⚡ Internal infrastructure issues prevented one or more tests
> (marked
>     with ⚡⚡⚡) from running on this architecture.
>     This is not the fault of the kernel that was tested.

Please ignore these testing errors. The hardware tests passed on all
architectures.

-- 
Major Hayden

