Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED863827A
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 03:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfFGB7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 21:59:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54284 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfFGB7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 21:59:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so355196wme.4
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 18:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hK9GU0jkCkm6KZAYYTXBNfSvMMz0OHH83FIe91e/jKM=;
        b=sJf1unCTNCuKUPBU15E0uVxyXRqFbb+o8OkrlqKdUSGbBoM+61mW4XrQa7YpOmXtCY
         W+3PJVqYg4UztV3Jyi4bOQAPhWlPrvXZf66f2cjqIFIKQnjaaUDBZwm+iCumdUnLKWBi
         pD6fNK+95ge9Pvtfe2m6PgjZCQVu5GlKSifnkkI7erjJacLb3BEilMN9uzDjq7xcjhsa
         BCeJEwhvSOfZ0I8GJ7YtAm77DZCP7xluSAjydSvtA+Jo6uq0ynUWwLYHq58j84hRl41U
         zWo19QnXs5Kkp4i46EquqJ0UPR117/X98nBdlhAID5JrUG2T0vSWENZWFOwJLzKFHGYP
         af1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hK9GU0jkCkm6KZAYYTXBNfSvMMz0OHH83FIe91e/jKM=;
        b=jXbjg5m7ArpPIO2WGadec9hiSH/GNMYK7r681m/t5+Xn3C5OL3kiR38NDwjFh1i/sU
         fHvub5iW6P2y3B2qBc5E6Vs27PaN3cr4OaOfFfENVQW9sMG1KeXvTWmyDLxQaH9M3u81
         tR/RNwUZa/HqlWt2l/hex9sXhBwShLHTVxfuSvV15Fq3BxR3ODP5xbaQv/q1MmaUok28
         bkI06NRmY5em+9b3LzE+36SIosXXM7d4PkdZSqfU1KiepIPbonPLUxCice4/Qi4C6bN+
         cktDmaLgZXNN90SP7qlsUC4xQJAMBCrVpEJza27BWqpMuTbLQSy4+j8gr7lgNWDj2r/U
         8dCQ==
X-Gm-Message-State: APjAAAXuFpmPaVio6qXsx8OW34q/ORjaTy24ZJP8KJ/1ST5DUHSRyNQG
        gBUrADuJi4bSNHE3j7ChfFA=
X-Google-Smtp-Source: APXvYqyEfTXscCZnLxdUVd9QlZvE3TKfI589oCo6NdaKEwrDXQGf7wVWbMGDRInjL79hvLhr22uefA==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr1897380wma.100.1559872771272;
        Thu, 06 Jun 2019 18:59:31 -0700 (PDT)
Received: from zhanggen-UX430UQ ([108.61.173.19])
        by smtp.gmail.com with ESMTPSA id e13sm1327401wra.16.2019.06.06.18.59.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 18:59:30 -0700 (PDT)
Date:   Fri, 7 Jun 2019 09:59:23 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, groeck@chromium.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
Message-ID: <20190607015923.GA2806@zhanggen-UX430UQ>
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
I've discussing this with others these days. You mean the check 
if (!new_ra)? I don't think this check is for allocation failure. 
Because 'new_ra' is NULL when 'on' is zero. The check should be 
if (on && !new_ra) if it is for memory allocation failure.
> 
> I've requested rejection of this CVE, and several other invalid reports
> from the same person.
I think I should be in the CC list. Should I?

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


