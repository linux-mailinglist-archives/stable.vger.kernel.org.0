Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268EC102D9D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKSUeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:34:23 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47061 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKSUeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 15:34:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id l4so12437607plt.13;
        Tue, 19 Nov 2019 12:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GWdsDe609JfH6F8JM5VqQJA7+6YKO8z41wZipDZV2gM=;
        b=dHGSA/ruWvQPmNa+aOB7uzyesp54cu2+yNOelOBJCohHyMCHv/G56OJs+QL4C7tTOj
         SOUUj4eVCHY3SszGl0D17l7gfhnou83ci4MRtcibZ+x4ULguxEZqePE4g9fGwiS5dbkV
         j1TWKQNgL4YTo3PoYbltmh5p68Ks3V3RuaWX0sleIbBg+8Qxy9elshOWpGlamLCaVwvH
         EHEuSEAZ0o0ip4uZho99qxfuZEkqCMtgFvMapP72hlHDxSCWezbDJIyOSDtW10hrAYUi
         Vol/Aj0YPI21YxGmPD8/grfgxCjhSjeCCLb7qfiJ7tfggZ/cMV2RvXKnjrYomkTYYpxc
         Xw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GWdsDe609JfH6F8JM5VqQJA7+6YKO8z41wZipDZV2gM=;
        b=ptGNXlNkv6SHT/76Ol+AttmhUh+CqcwTJhZ2kqwC3T2fxX9EJ7RGE2pgm2pyMkSB2V
         6xTnvkMuF60ievy5rpCIMKv2EE7ueaFuQsfUs300EtIafIxBVVUngxN8FsJzjt6OwimY
         dEAPVvUavQqhoFba9sJxx0iAoQRlsDRTgnqUxSwXkWoGso7AYim/+OrBql1KZ+JQqbXb
         RqrYodF2R5MFI4ZCO7g9/yUqrtBoFzSJzVpoEhciiWUr4nGcuStxasDDImq0hhwnehNM
         +5/IHTMA4kh7gqwFw05i1gLfWOQX1VAB/benaHaBBBMknPkSoUImCn9o5y3Tq4GNiZO7
         9hrg==
X-Gm-Message-State: APjAAAUEf1WlilQU/eBToi3RBx1P6PhY+2h55FAX0fNYp8g70jMbEQRf
        6sSoQvJLdrRv4JV+yV6jV9sVh+9r
X-Google-Smtp-Source: APXvYqxmK8jR4YTFNkyhPIcmP98dh1TXiVtJYfjJIP/xVA8BgoK3VCX2w1xbYbYquZf8Fk+x7AW0sQ==
X-Received: by 2002:a17:902:261:: with SMTP id 88mr37486245plc.322.1574195662365;
        Tue, 19 Nov 2019 12:34:22 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z23sm23779542pgj.43.2019.11.19.12.34.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 12:34:21 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:34:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
Message-ID: <20191119203419.GA14938@roeck-us.net>
References: <20191119050946.745015350@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 06:19:20AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
