Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4F03BBA5
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 20:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388744AbfFJSIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 14:08:13 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:44989 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388573AbfFJSIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 14:08:13 -0400
Received: by mail-pl1-f177.google.com with SMTP id t7so1352317plr.11
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 11:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PWEt9HQVUTjdXyvPcFRPdZkrJA6gt1ypvb9OiD54haw=;
        b=m05Wwy0jIZJKLRyF13/YcNdtLrOHx5h7nWMHF9m+T9xCyWMkfT6K0ihA7gXMFqmQPS
         H3Ha8+tyYf8odJ4qV763XqqAW1Q6AYq0SAlytlJWbmN+La495QG4ycgSBkUMoPS5lhvv
         zCjRaS2c9XylyFjMdmdZW42RIH6wOI3cjmNus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PWEt9HQVUTjdXyvPcFRPdZkrJA6gt1ypvb9OiD54haw=;
        b=fmyvy8Po4Bd/g+eqk2OcnZKc2bN2mCshs4cDLKV2m3wFA7sZGpq+JnXdTts7vJ/0zQ
         pGx0x4KYcve8A5YBP0RXkrS/FEzS/kOL7tJsQoso33ioC73oN6lEo+Y3369aiW0tuf4W
         V+lkx7wlsFrk/kSqT73zKJngYdqtBBtFlAjoFm4pwzLYT77wEVlj1cyr1wDBwo1HbGyA
         WK6qvpevaYOIAi9/hdZF2NPl+FmCC6+e9hWFCJ4/K46h5Tn8LMKzEulS9M66VhDgiG7/
         5iGEvPDiDLk8J3aiww1vBioKDusele0aB0QSXHmZCDQzoLj2lJb8/p+IiEec+WTP9oJg
         INyA==
X-Gm-Message-State: APjAAAXn16i/l+9oGgV6PP8ki2SH5wa4ZrzULa7/VWG1S3ax0CaXdsmC
        Qv1jhOq3StrUPEhqUh4lzV8paukDWMM=
X-Google-Smtp-Source: APXvYqxWxVsQFAivl6Le/33KPqE3RobY+lHbY35xBTBhqtimnjH9NK06LY0X3ZJGZ8vn2cOUh8fUmg==
X-Received: by 2002:a17:902:ac82:: with SMTP id h2mr1461124plr.303.1560190092700;
        Mon, 10 Jun 2019 11:08:12 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id y133sm12422255pfb.28.2019.06.10.11.08.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Jun 2019 11:08:11 -0700 (PDT)
Date:   Mon, 10 Jun 2019 11:08:10 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yaro Slav <yaro330@gmail.com>, stable@vger.kernel.org
Subject: Re: pstore backports to 4.14
Message-ID: <201906101107.9089BE9D@keescook>
References: <201905310055.F37C37E@keescook>
 <20190609095005.GA20602@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609095005.GA20602@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 11:50:05AM +0200, Greg Kroah-Hartman wrote:
> On Fri, May 31, 2019 at 01:06:15AM -0700, Kees Cook wrote:
> > Hi Greg,
> > 
> > Can you please add these two pstore fixes to 4.14 please? They are
> > prerequisites for another fix I'll be sending to Linus soon that'll
> > be needed in 4.14 (to fix the bug Yaro ran into).
> > 
> > b77fa617a2ff ("pstore: Remove needless lock during console writes")
> > ea84b580b955 ("pstore: Convert buf_lock to semaphore")
> 
> These also were needed in 4.19, so queued up to both trees now, thanks.

Okay, sounds good. Thanks!

-- 
Kees Cook
