Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAFDA06DC
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfH1QCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 12:02:00 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36412 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfH1QB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 12:01:59 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so114170qtc.3
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=18vFUXwCCyqrHJ/cXDKe740sqCaN0Wzc0p2txngC8Ek=;
        b=P7SsQclItQ7TwVhV0y5ycfjFwdQA0FmKtll48jZxDnHxDPlabGC92g7nP40H8IkSi+
         MMF3E9f16tNAhesicaRbghW6Smmv/5aIoPs4Rz68aaMXUS5332CcDu19gZhvVqy7M0rc
         4g19xczqRq6l2PDdHOOsQSgewSZGLBDBy5X7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=18vFUXwCCyqrHJ/cXDKe740sqCaN0Wzc0p2txngC8Ek=;
        b=O56RiLKwNhJNchLRvbHr0OL9af9lrB3kyzWPnDMTuyZC9HMoa3MCnwhW+/HbAE4EnV
         CPClzxvlRyEiwKOK1QWowXRi8BHybrbOgwxQzmJVpYjwGKo3YmZ1S9PHdMBoBkCAqO7c
         HUvYbZd/lpxqONcSy0aeeQjzMx3Ld/W+JE2KKrojrVA/h/DfPE5EUpu67OwJVmivVGBJ
         xZqR6pz4T6bLlmBG4DO3p+tcuwmuX2oraTpIhD5Tr0VahFu6BT1ZCvV2iRKh4tqFKdn9
         Hi3cVyvV1LL5VCzEB0EuFRjqtwlEVU/66BQkgVqZ1szEkzBmEc50moOnXZdT+KB1j90q
         MegA==
X-Gm-Message-State: APjAAAXfiIBEW2QTZjNKJX1RL8L8puUjOR5JopnlPIdzKh9v6lOh4gR/
        aZIIqZkm3Z/bbnlBNamos8CuRg==
X-Google-Smtp-Source: APXvYqx4jGyz1MuhN9X9a/bicikxi0tdkyCPTLusG+cCbuet+03E0QpqUxM5Jstq4dpXPnj2AYgdgg==
X-Received: by 2002:a05:6214:104f:: with SMTP id l15mr3259215qvr.189.1567008118708;
        Wed, 28 Aug 2019 09:01:58 -0700 (PDT)
Received: from chatter.i7.local (192-0-228-88.cpe.teksavvy.com. [192.0.228.88])
        by smtp.gmail.com with ESMTPSA id l206sm1411936qke.33.2019.08.28.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 09:01:58 -0700 (PDT)
Date:   Wed, 28 Aug 2019 12:01:56 -0400
From:   Konstantin Ryabitsev <mricon@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        StableKernel <stable@vger.kernel.org>,
        LinuxKernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel version no NOT reflecting on kernel.org
Message-ID: <20190828160156.GB26001@chatter.i7.local>
References: <20190828135750.GA5841@Gentoo>
 <20190828151353.GA9673@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20190828151353.GA9673@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 05:13:53PM +0200, Greg KH wrote:
>On Wed, Aug 28, 2019 at 07:27:53PM +0530, Bhaskar Chowdhury wrote:
>> Am I the only one, who is not seeing it getting reflected on
>> kernel.org???
>>
>> Well, I have tried it 2 different browsers.....cleared caches several
>> times(heck) .....3 different devices .....and importantly 3 different
>> networks.
>>
>> Wondering!
>
>Adding Konstantin.
>
>I think there's a way to see which cdn mirror you are hitting when you
>ask for "www.kernel.org".  Konstantin, any hints as to see if maybe one
>of the mirrors is out of sync?

Looks like the Singapore mirror was feeling out-of-sorts. It'll start 
feeling better shortly.

-K
