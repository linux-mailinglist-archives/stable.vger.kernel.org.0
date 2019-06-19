Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2E84C361
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfFSV6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 17:58:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40517 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSV6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 17:58:39 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so428651pla.7;
        Wed, 19 Jun 2019 14:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I6gqBD2/XW+8NP4mZX0Dd/oS4kA8uH11DjSxrIn/eNM=;
        b=LeKU0DeGzD0RIc4tuIfAr6Qvp0mwfZASU7scgBAGTtlpPbmTaAgcxwdmlQp5mHMyyw
         Ezdg2loVfPVLH6BdcUBZ9l5w4W3PPpsTg++JERT0MinSngr+Fn8Ekqh89Q4ud/UO46EV
         N9/JXaI/acIjd2HajtDdCu+Eh8eFCPXat/58/j3xDvmtK1l7VHnhPQyBOZf6MSgP5Obt
         FKJ70BIArMF3D0SONbgcN5Y2TwckMTuFfyG+HoKdk3dtHnPm4H3b3+oC8epBxEfIdMff
         9NT0mV9Bshj2ZRjnCrk0lNnSj5kyracF8zb6xFMN6VXL7oBUbuFVlMQHf6TEhFxfl2PH
         C/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=I6gqBD2/XW+8NP4mZX0Dd/oS4kA8uH11DjSxrIn/eNM=;
        b=l+CV4sIVP1LSyPqD5jhOFRfXb8IDfpqfbOcp7bUExgtL19bNFhUZWAxHIvFMlFzDZQ
         mL3nNN7jwHQ7a/4C8QRpxnxkP31IQwG4GW9fZuu9Jp/GX5BsJbC/2c9LwuBU4hzZ8nUo
         ZOVrRdb++DqTCwIw8162y/UOg4SPczuXLS/318T3tSEaDaTFPvQiY0KHey0lECocRvjY
         UId1f/07hJdFRlDgfbVSZjCp4kQXWzyKooGzBvMOfAotqeVcEWfMd811An14t/bJRgad
         BUQMiMnYS+ay4k6hCBS4LOUgn/+OpNThbXUIeXSjdv5MNr9iYLrmQIw8dhTflpsvo0v6
         6XNg==
X-Gm-Message-State: APjAAAWHkLmBclL9ehIQjcRl67F3uBB+Yr+0Eo5AFT4Q8lGkO0YE7sxF
        Yfn9UQo9JCQJ92F25iolrsktfo1z
X-Google-Smtp-Source: APXvYqz88Zejf8xFLMYATsBrHyzKXT4f2Yl2zEqRlKc3Lzl0eyzc47OxVBoyXoCWqKGJYU6zGiDZDA==
X-Received: by 2002:a17:902:4623:: with SMTP id o32mr4204005pld.112.1560981518966;
        Wed, 19 Jun 2019 14:58:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f14sm25735414pfn.53.2019.06.19.14.58.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 14:58:37 -0700 (PDT)
Date:   Wed, 19 Jun 2019 14:58:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 00/10] 3.16.69-rc1 review
Message-ID: <20190619215836.GA2387@roeck-us.net>
References: <lsq.1560868079.359853905@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1560868079.359853905@decadent.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 03:27:59PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.69 release.
> There are 10 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Jun 20 14:27:59 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 231 pass: 231 fail: 0

Guenter
