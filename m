Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC65D382D3
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 04:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFGCl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 22:41:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41082 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfFGCl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 22:41:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so542605wrm.8
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 19:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3y90Ukjv3HkSLlwdB9mTxMf2WIS7n8QBszCNotv9kcA=;
        b=YiQFS7UQjLQBcKZ0kAs1hp4VnkoLCwPuCt/Rp0DKjzzFwreXj+oEgzOLzZijee7OyG
         r8w5cRReoqvi6nvTfTavikJV1KICj1+hd0QsvLQ5TTmn/u1eZn8S47Jqq4Id5bc1jJLv
         +IK2Wt9QopziDInH5Pm69qf8Q03xV43Crr8z8l1ofIm/2YJc9i1IFql4TVkb+yfgab7w
         IApsvVZWYCGyV7RbMFLveitfX7LF4qERTaVq6GvzgvUyrQl9xar+eP8o2BOMPR44Qoh0
         p+trGzSxJIqq7bHhkDuhJjKSLaFPOSL4RLnkmhin6VC635zwa6EpcAeXlIUCSgaCEoHj
         wtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3y90Ukjv3HkSLlwdB9mTxMf2WIS7n8QBszCNotv9kcA=;
        b=peMkyBpzRhJOIXTouomrGvY3G5xOk5Ulf7qaRC+QuQWZwuOItCEo6V27+3uNlb2/aK
         1Ckpuqc/EHgJmMqRSE6Vt5TLxb2T6rH0fqDvlz1MpKlZAa/7IyFg4px0ECauC5EbMdQj
         bikdK8JYie7YkpkyoZq0GKiI01wlXWkOA7UbuidGTu3toB0Ru6ruz7zTA8714iDpkSmr
         NScnFnnfBMYTC3uk+wzhaGcJU366JKi+Yw2Tt3TXhM4KncF+8q1QCrRHPxJOVodH1Byv
         fy2L3f1nlhsl+6PiFeA1PZpfINOE5MVBJRdHNohMwI4G3PBhkIFi0MsOx495NGlVLz2P
         5FdA==
X-Gm-Message-State: APjAAAV5KLuV8qLDKTDrI865WuYVd1eCyEplTW+Hc6YkWqhWqMiKVS9b
        N9AWo6uDeDmknSbIjefLP9A=
X-Google-Smtp-Source: APXvYqyekeuPaKkFZVF8Q4/M2hWwWQ7tc08V4SDjcoOp+lIPJIaGrvIrVAli67cEpptxvAj6nBO0Cg==
X-Received: by 2002:adf:dc0c:: with SMTP id t12mr31723858wri.101.1559875285367;
        Thu, 06 Jun 2019 19:41:25 -0700 (PDT)
Received: from zhanggen-UX430UQ ([108.61.173.19])
        by smtp.gmail.com with ESMTPSA id h84sm632080wmf.43.2019.06.06.19.41.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 19:41:24 -0700 (PDT)
Date:   Fri, 7 Jun 2019 10:41:15 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, groeck@chromium.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
Message-ID: <20190607024115.GA4196@zhanggen-UX430UQ>
References: <20190603230239.GA168284@google.com>
 <69e47f52ec342b6c70c1cae6cd0140a51a713752.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e47f52ec342b6c70c1cae6cd0140a51a713752.camel@decadent.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 07:58:35PM +0100, Ben Hutchings wrote:
> On Mon, 2019-06-03 at 16:02 -0700, Zubin Mithra wrote:
> > Hello,
> > 
> > CVE-2019-12381 was fixed in the upstream linux kernel with the commit :-
> > * 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in ip_ra_control()")
> > 
> > Could the patch be applied in order to v4.19.y, v4.14.y, v4.9.y and v4.4.y ?
> > 
> > Tests run:
> > * Chrome OS tryjobs
> 
> This doesn't fix a security vulnerability.  There already was a check
> for allocation failure before dereferencing the returned pointer; it
> just wasn't in the most obvious place.
> 
> I've requested rejection of this CVE, and several other invalid reports
> from the same person.
And where did this 'invalid' come from? Did any maintainers claimed the 
patch 'invalid' or something? I am confused...

Thanks
Gen
> 
> Ben.
> 
> -- 
> Ben Hutchings
> Experience is what causes a person to make new mistakes
> instead of old ones.
> 
> 


