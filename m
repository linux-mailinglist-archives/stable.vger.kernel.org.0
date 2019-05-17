Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E1521CAA
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 19:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfEQRke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 13:40:34 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:41324 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbfEQRkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 13:40:31 -0400
Received: by mail-pf1-f179.google.com with SMTP id q17so4006010pfq.8
        for <stable@vger.kernel.org>; Fri, 17 May 2019 10:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4kGDpYaETtMhU+KqOik42hpQYHaNeLj4GdpBSNRl9ZU=;
        b=EKmlHuwtl/fTIYZr8QWGhaYtZgTB8XztojHfVAlXjpaIUbc6i5U5YrIC2QudpdVEWN
         vRinwemMGxIurKwFnG5ljkLJzgqTciB3wTKPz3SPWYbqxa7OvGTcyY4m71G4tK4k6pyL
         I8JNvmAFgUYojIXXehz9sO1Z+UUec+pJuzeHa/x5jWhKGzpLuzXJo7AOV6lOxV4iJBFm
         Y/9V7UEtxIRiXeKnOjBo3jvnKa068afX5srMBeFBA2nxzn9/Vbur1s713PDmzEqn1eDI
         FuhAv5tgWN3SHDFeh6S4dGpKjtET5avV2K9L6EPVvMHfUmls2kItK2pzvoYSt2BzLrAI
         dcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4kGDpYaETtMhU+KqOik42hpQYHaNeLj4GdpBSNRl9ZU=;
        b=dftBXuJBHVkc9TcvkqXUKJrl+f71JdmRRjsUpSqRYOW0c6DZF6bHONcRWUwAVsWyeO
         G353d6Uwg5V2b6P3AJQRTkYSwy6mtIIjAz/U5uSyC650x1eknIUos8xjiOYTywwO6QiJ
         ScIlW61nup3azJol4MxQnJCkQhMSWN0Niby/8dMk8K5QdtAdYvhgD21axvsH+Gt1HY9G
         QX0+KJYsata80BBGZI3i1acouw528vVCqr4DLrwll7PVM4rVtNj3xK8DQXbEch4j/5+o
         ZDcrPmNeKHLOCzHpxym6ivPQi4a47dhmlT3uKL6XOLF0dkXzHRc3HPU0M+HkqNkggJ/S
         2iXg==
X-Gm-Message-State: APjAAAWmUJKp1QJI7s8L1PZ+JzuX0VS0piTQpf7RgMKEXdbwAVJgMaTg
        Eim6mZJmc94EUHi8soGSxuW6PLNtZYg=
X-Google-Smtp-Source: APXvYqzzdtaQW+FQhhkKmJ1QuJifAGlUMhY/eiGE2NmOc+QyQBjz+O32Fgl9riwjJDfjglUVJaJRtQ==
X-Received: by 2002:a62:128a:: with SMTP id 10mr61180831pfs.225.1558114830884;
        Fri, 17 May 2019 10:40:30 -0700 (PDT)
Received: from google.com ([2620:15c:201:2:765b:31cb:30c4:166])
        by smtp.gmail.com with ESMTPSA id v64sm12002211pfv.106.2019.05.17.10.40.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 17 May 2019 10:40:30 -0700 (PDT)
Date:   Fri, 17 May 2019 10:40:25 -0700
From:   Eric Biggers <ebiggers@google.com>
To:     gregkh@linuxfoundation.org
Cc:     herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] crypto: gcm - fix incompatibility between
 "gcm" and" failed to apply to 4.9-stable tree
Message-ID: <20190517174025.GB223128@google.com>
References: <15580966386436@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15580966386436@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 02:37:18PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From f699594d436960160f6d5ba84ed4a222f20d11cd Mon Sep 17 00:00:00 2001
> From: Eric Biggers <ebiggers@google.com>
> Date: Thu, 18 Apr 2019 14:43:02 -0700
> Subject: [PATCH] crypto: gcm - fix incompatibility between "gcm" and
>  "gcm_base"
> 

Can you apply the following commit first?  Then this one applies cleanly:

	commit 9b40f79c08e81234d759f188b233980d7e81df6c
	Author: Wei Yongjun <weiyongjun1@huawei.com>
	Date:   Mon Oct 17 15:10:06 2016 +0000

	    crypto: gcm - Fix error return code in crypto_gcm_create_common()

- Eric
