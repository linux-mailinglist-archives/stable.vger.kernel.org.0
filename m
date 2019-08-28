Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63809A0A95
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfH1TjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 15:39:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42218 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfH1TjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 15:39:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so891037qtp.9
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 12:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=jGdjcaObJA+LOjf9Poq4nOPxGm2S+Io4iqVFGT05Sdk=;
        b=dUDtC6v5RjJEYqLAKrZUvJdgsvtkSt+8hvHatWrvU909wWeyYUjrARoyq3TTvv7ldN
         5PNasiJf3BZGE9ctTClpN9enOnIh7CoPVcGCsIQvQTj6zn10Rjm5DTvK9LztWamrSjJa
         AaqsjTmylhES2sNlbFeyf6poXoU7X4PpqBT3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=jGdjcaObJA+LOjf9Poq4nOPxGm2S+Io4iqVFGT05Sdk=;
        b=FNNfsTNabq+RTKP9sfYkp3b9mUO4oau8RG6h1idLNREdP+LEDoOQGF73EFnWoUidlN
         K7Em1B2xVlsR5HpkF7H5XdiRZIIV9n3FuPQadYHOtL1p3/Ql6NadZ9z0ITWsB9VzA7dx
         IuUeE+TQIDhHN+zN2T1m4VL3/aaLzzWYdfSo0CJb28cwSJq/HnttoZLvJWlkLVdPtbWb
         F5z7QEY/cdt4zZ+IKq3WxZF0VcJ6eBejOi++0LUIwn57/jrqkfcuPTyruQa7+wE9/LI0
         t7/QVvWlWPvCTyvaMiidO4aeuwifRS+lx8CSM+i26rEx5JbomLbgXkFUt/ebF4SJ1/qI
         6mkg==
X-Gm-Message-State: APjAAAXdpzIAMkylgE7gHeIbyaXYYsOPEftnYP+Pn2lnTxokOvXqpW4b
        apdQZQZRhHiI3E1QaNTv+oI14A==
X-Google-Smtp-Source: APXvYqzirrx5EnthEZOuvQwfJUjLhmigujMSE/NNOATdgV+CS7t5Zzx8CRnjXpUTmxdUv9iGYk9Fiw==
X-Received: by 2002:ac8:50b:: with SMTP id u11mr6104045qtg.308.1567021150789;
        Wed, 28 Aug 2019 12:39:10 -0700 (PDT)
Received: from chatter.i7.local (192-0-228-88.cpe.teksavvy.com. [192.0.228.88])
        by smtp.gmail.com with ESMTPSA id v24sm120458qth.33.2019.08.28.12.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 12:39:10 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:39:08 -0400
From:   Konstantin Ryabitsev <mricon@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        StableKernel <stable@vger.kernel.org>,
        LinuxKernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel version no NOT reflecting on kernel.org
Message-ID: <20190828193908.GC26001@chatter.i7.local>
References: <20190828135750.GA5841@Gentoo>
 <20190828151353.GA9673@kroah.com>
 <20190828160156.GB26001@chatter.i7.local>
 <20190828170547.GA11688@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828170547.GA11688@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 07:05:47PM +0200, Greg KH wrote:
>> > I think there's a way to see which cdn mirror you are hitting when 
>> > you
>> > ask for "www.kernel.org".  Konstantin, any hints as to see if maybe one
>> > of the mirrors is out of sync?
>>
>> Looks like the Singapore mirror was feeling out-of-sorts. It'll start
>> feeling better shortly.
>
>Great, thanks for looking into this!

BTW, the easiest way to figure out which frontend you're hitting is to 
look at the output of "host www.kernel.org", e.g.:

$ host www.kernel.org
www.kernel.org is an alias for git.kernel.org.
git.kernel.org is an alias for ord.git.kernel.org.
ord.git.kernel.org has address 147.75.58.133
ord.git.kernel.org has IPv6 address 2604:1380:4020:600::1

The three-letter airport code should indicate where the frontend is 
located (in my case, ORD = Chicago). There are total of 6:

sea.git.kernel.org - Seattle
lax.git.kernel.org - Los Angeles
ord.git.kernel.org - Chicago
fra.git.kernel.org - Frankfurt
sin.git.kernel.org - Singapore
syd.git.kernel.org - Sydney

Geodns magic should send you to the nearest one, and if the monitoring 
recognizes that one of them is down, it will be automatically removed 
from the pool until it recovers.

Best,
-K
